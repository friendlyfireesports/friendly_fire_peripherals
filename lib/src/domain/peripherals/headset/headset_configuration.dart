import 'package:faker/faker.dart';
import 'package:friendly_fire_peripherals/src/domain/peripherals/configuration.dart';

class HeadsetConfiguration extends Configuration {
  HeadsetConfiguration({required this.speaker, required this.mic});

  final HeadsetSpeaker speaker;
  final HeadsetMic mic;

  factory HeadsetConfiguration.fromJson(Map<String, dynamic> json) {
    return HeadsetConfiguration(
      speaker: HeadsetSpeaker.fromJson(json['speaker']),
      mic: HeadsetMic.fromJson(json['mic']),
    );
  }

  int operator [](String key) {
    dynamic value = -1;
    speaker.toJson().forEach((k, v) {
      if (k == key) {
        value = v;
      }
    });
    mic.toJson().forEach((k, v) {
      if (k == key) {
        value = v;
      }
    });
    return value;
  }

  HeadsetConfiguration copyWith({
    HeadsetSpeaker? speaker,
    HeadsetMic? mic,
  }) =>
      HeadsetConfiguration(
        speaker: speaker ?? this.speaker,
        mic: mic ?? this.mic,
      );

  @override
  HeadsetConfiguration rectified(ConfigurationOptions configurationOptions) {
    final options = configurationOptions as HeadsetConfigurationOptions;
    return HeadsetConfiguration(
      speaker: speaker.rectified(options),
      mic: mic.rectified(options),
    );
  }

  @override
  HeadsetConfiguration fromJson(Map<String, dynamic> json) =>
      HeadsetConfiguration.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    return {
      'speaker': speaker.toJson(),
      'mic': mic.toJson(),
    };
  }
}

class HeadsetConfigurationOptions extends ConfigurationOptions {
  HeadsetConfigurationOptions({required this.speaker, required this.mic});

  List<Setting> speaker;
  List<Setting> mic;

  factory HeadsetConfigurationOptions.fromJson(Map<String, dynamic> json) {
    final settings = (json['settings'] as Map)
        .map((key, value) => MapEntry(key, Setting.fromJson(value)))
        .values
        .toList();
    final speakerSettings = List<Setting>.from(settings)
      ..removeWhere((setting) => setting.name.contains('mic'));
    final micSettings = (List<Setting>.from(settings)
          ..removeWhere((setting) => !setting.name.contains('mic')))
        .map((setting) =>
            setting.copyWith(name: setting.name.replaceAll('mic_', '')))
        .toList();
    return HeadsetConfigurationOptions(
      speaker: speakerSettings,
      mic: micSettings,
    );
  }

  Setting? operator [](String key) {
    try {
      return speaker.firstWhere((setting) => setting.name == key);
    } catch (_) {
      try {
        return mic.firstWhere(
            (setting) => setting.name == key.replaceAll('mic_', ''));
      } catch (_) {
        return null;
      }
    }
  }

  @override
  HeadsetConfigurationOptions fromJson(Map<String, dynamic> json) =>
      HeadsetConfigurationOptions.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        'speaker': speaker.map((setting) => setting.toJson()),
        'mic': mic.map((setting) => setting.toJson()),
      };
}

class HeadsetSpeaker {
  HeadsetSpeaker({
    required this.mute,
    required this.volume,
    required this.leftChannelVolume,
    required this.rightChannelVolume,
  });

  factory HeadsetSpeaker.fromJson(Map<String, dynamic> json) => HeadsetSpeaker(
        mute: json['mute'] != 0,
        volume: json['volume'],
        leftChannelVolume: json['left_channel_volume'],
        rightChannelVolume: json['right_channel_volume'],
      );

  static HeadsetSpeaker get random => HeadsetSpeaker(
        mute: faker.randomGenerator.boolean(),
        volume: faker.randomGenerator.integer(101),
        leftChannelVolume: faker.randomGenerator.integer(101),
        rightChannelVolume: faker.randomGenerator.integer(101),
      );

  final bool mute;
  final int volume;
  final int leftChannelVolume;
  final int rightChannelVolume;

  HeadsetSpeaker copyWith({
    bool? mute,
    bool? surround,
    int? volume,
    int? leftChannelVolume,
    int? rightChannelVolume,
  }) =>
      HeadsetSpeaker(
        mute: mute ?? this.mute,
        volume: volume ?? this.volume,
        leftChannelVolume: leftChannelVolume ?? this.leftChannelVolume,
        rightChannelVolume: rightChannelVolume ?? this.rightChannelVolume,
      );

  HeadsetSpeaker rectified(HeadsetConfigurationOptions configurationOptions) {
    return HeadsetSpeaker(
      mute: mute,
      volume: volume.clamp(0, 100),
      leftChannelVolume: leftChannelVolume.clamp(0, 100),
      rightChannelVolume: rightChannelVolume.clamp(0, 100),
    );
  }

  Map<String, dynamic> toJson() => {
        'mute': mute ? 1 : 0,
        'volume': volume,
        'left_channel_volume': leftChannelVolume,
        'right_channel_volume': rightChannelVolume,
      };
}

class HeadsetMic {
  HeadsetMic({
    required this.mute,
    required this.volume,
  });

  factory HeadsetMic.fromJson(Map<String, dynamic> json) => HeadsetMic(
        mute: json['mute'] != 0,
        volume: json['volume'],
      );

  static HeadsetMic get random => HeadsetMic(
        mute: faker.randomGenerator.boolean(),
        volume: faker.randomGenerator.integer(101),
      );

  final bool mute;
  final int volume;

  HeadsetMic copyWith({
    bool? mute,
    int? volume,
  }) =>
      HeadsetMic(
        mute: mute ?? this.mute,
        volume: volume ?? this.volume,
      );

  HeadsetMic rectified(HeadsetConfigurationOptions configurationOptions) {
    return HeadsetMic(
      mute: mute,
      volume: volume.clamp(0, 100),
    );
  }

  Map<String, dynamic> toJson() => {
        'mute': mute ? 1 : 0,
        'volume': volume,
      };
}

class Setting {
  Setting({
    required this.name,
    required this.type,
    required this.min,
    required this.max,
  });

  factory Setting.fromJson(Map<String, dynamic> json) => Setting(
        name: json['key'],
        type: json['type'],
        min: json['min_value'],
        max: json['max_value'],
      );

  final String name;
  final String type;
  final int min;
  final int max;

  Setting copyWith({
    String? name,
    String? type,
    int? min,
    int? max,
  }) =>
      Setting(
        name: name ?? this.name,
        type: type ?? this.type,
        min: min ?? this.min,
        max: max ?? this.max,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'min': min,
        'max': max,
      };
}
