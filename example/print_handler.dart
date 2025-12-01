import 'dart:convert';

/// ANSI color codes for terminal output
class PrintHandler {
  // Reset
  static const String reset = '\x1B[0m';

  // Regular colors
  static const String black = '\x1B[30m';
  static const String red = '\x1B[31m';
  static const String green = '\x1B[32m';
  static const String yellow = '\x1B[33m';
  static const String blue = '\x1B[34m';
  static const String magenta = '\x1B[35m';
  static const String cyan = '\x1B[36m';
  static const String white = '\x1B[37m';

  // Bright colors
  static const String brightBlack = '\x1B[90m';
  static const String brightRed = '\x1B[91m';
  static const String brightGreen = '\x1B[92m';
  static const String brightYellow = '\x1B[93m';
  static const String brightBlue = '\x1B[94m';
  static const String brightMagenta = '\x1B[95m';
  static const String brightCyan = '\x1B[96m';
  static const String brightWhite = '\x1B[97m';

  // Styles
  static const String bold = '\x1B[1m';
  static const String dim = '\x1B[2m';
  static const String italic = '\x1B[3m';
  static const String underline = '\x1B[4m';

  /// Print a header with decorative borders
  static void header(String text, {String color = cyan}) {
    final border = '─' * (text.length + 4);
    print('$color$bold┌$border┐$reset');
    print('$color$bold│  $text  │$reset');
    print('$color$bold└$border┘$reset');
  }

  /// Print a sub-header
  static void subHeader(String text, {String color = magenta}) {
    print('\n$color$bold══════ $text ══════$reset');
  }

  /// Print an info message
  static void info(String label, dynamic value, {int indent = 0}) {
    final tabs = '  ' * indent;
    print('$tabs$brightCyan$label:$reset $white$value$reset');
  }

  /// Print a success message
  static void success(String message) {
    print('$brightGreen✓ $message$reset');
  }

  /// Print an error message
  static void error(String message) {
    print('$brightRed✗ $message$reset');
  }

  /// Print a warning message
  static void warning(String message) {
    print('$brightYellow⚠ $message$reset');
  }

  /// Print a label with a value
  static void label(String label, {String color = yellow}) {
    print('$color$bold$label$reset');
  }

  /// Print formatted JSON with colors and indentation
  static void json(dynamic data, {int indent = 0, String? label}) {
    if (label != null) {
      print('$brightCyan$label:$reset');
    }

    String jsonStr;
    if (data is String) {
      try {
        final parsed = jsonDecode(data);
        jsonStr = _formatJson(parsed, indent);
      } catch (_) {
        jsonStr = data;
      }
    } else if (data is Map || data is List) {
      jsonStr = _formatJson(data, indent);
    } else {
      jsonStr = data.toString();
    }

    print(jsonStr);
  }

  /// Format JSON with colors and proper indentation
  static String _formatJson(dynamic data, int baseIndent) {
    final buffer = StringBuffer();
    _writeJson(data, buffer, baseIndent, 0);
    return buffer.toString();
  }

  static void _writeJson(
      dynamic data, StringBuffer buffer, int baseIndent, int currentIndent) {
    final baseTab = '  ' * baseIndent;
    final tab = '  ' * currentIndent;
    final nextTab = '  ' * (currentIndent + 1);

    if (data is Map) {
      if (data.isEmpty) {
        buffer.write('$baseTab$brightBlack{}$reset');
        return;
      }
      buffer.writeln('$baseTab$brightWhite{$reset');
      final entries = data.entries.toList();
      for (var i = 0; i < entries.length; i++) {
        final entry = entries[i];
        buffer
            .write('$baseTab$nextTab$green"${entry.key}"$reset$white: $reset');
        _writeJson(entry.value, buffer, baseIndent, currentIndent + 1);
        if (i < entries.length - 1) {
          buffer.writeln('$brightBlack,$reset');
        } else {
          buffer.writeln();
        }
      }
      buffer.write('$baseTab$tab$brightWhite}$reset');
    } else if (data is List) {
      if (data.isEmpty) {
        buffer.write('$brightBlack[]$reset');
        return;
      }
      buffer.writeln('$brightWhite[$reset');
      for (var i = 0; i < data.length; i++) {
        buffer.write('$baseTab$nextTab');
        _writeJson(data[i], buffer, baseIndent, currentIndent + 1);
        if (i < data.length - 1) {
          buffer.writeln('$brightBlack,$reset');
        } else {
          buffer.writeln();
        }
      }
      buffer.write('$baseTab$tab$brightWhite]$reset');
    } else if (data is String) {
      buffer.write('$yellow"$data"$reset');
    } else if (data is num) {
      buffer.write('$brightMagenta$data$reset');
    } else if (data is bool) {
      buffer.write('$brightBlue$data$reset');
    } else if (data == null) {
      buffer.write('$brightBlack$italic null$reset');
    } else {
      buffer.write('$white$data$reset');
    }
  }

  /// Print a divider line
  static void divider({String color = brightBlack, int length = 50}) {
    print('$color${'─' * length}$reset');
  }

  /// Print a blank line
  static void newLine() => print('');

  /// Print a key-value pair for configuration display
  static void configItem(
    String key,
    dynamic value, {
    int indent = 1,
    bool cancelIfNull = false,
  }) {
    if (cancelIfNull && value == null) return;
    final tabs = '  ' * indent;
    if (value == null) {
      print('$tabs$cyan$key:$reset $brightBlack$italic null$reset');
    } else if (value is Map || value is List) {
      print('$tabs$cyan$key:$reset');
      json(value, indent: indent + 1);
    } else {
      print('$tabs$cyan$key:$reset $white$value$reset');
    }
  }
}
