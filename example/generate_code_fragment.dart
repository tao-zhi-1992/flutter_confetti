import 'dart:io';
import 'dart:math';

void main(List<String> arguments) {
  var sourceFilePath = './lib/main.dart';
  var generateFilePath = './lib/code_block.g.dart';

  run() async {
    final sourceFile = File(sourceFilePath);
    final sourceCode = await sourceFile.readAsString();

    List<String> titleList = [];

    RegExp(r"buttonText:\s+'(.+)',").allMatches(sourceCode).forEach((match) {
      final title = match.group(1);
      titleList.add(title!);
    });

    List<String> codeList = [];
    RegExp(r'///BEGIN(\s+(?:.|\n)*?\s+)///END', multiLine: true)
        .allMatches(sourceCode)
        .forEach((match) {
      final code = match.group(1)!;
      final lines = code.split('\n');
      final indents = lines
          .where((line) => line.trim().isNotEmpty)
          .map((line) => line.length - line.trimLeft().length);
      final minIndent = indents.isEmpty ? 0 : indents.reduce(min);

      final formattedCode = lines.map((line) {
        if (line.trim().isEmpty) return '';
        return line.length >= minIndent ? line.substring(minIndent) : line.trimLeft();
      }).join('\n');
      codeList.add(formattedCode);
    });

    final generateCode = '''
/// AUTO-GENERATED FILE, DO NOT MODIFY
var titleList = [${titleList.map((e) => "'$e'").join(',')}];
var codeList = [${codeList.map((e) => "'''$e'''").join(',')}];

getCodeByTitle(title) {
final index = titleList.indexOf(title);
if (index == -1) {
  return null;
}
  return codeList[index];
}
''';

    final generateFile = File(generateFilePath);
    generateFile.writeAsStringSync(generateCode);
  }

  run();
}
