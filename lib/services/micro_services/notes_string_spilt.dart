String insertLineBreaks(String text, int breakAfter) {
  List<String> words = text.split(' ');
  StringBuffer sb = StringBuffer();
  int currentLineLength = 0;

  for (var word in words) {
    if (currentLineLength + word.length >= breakAfter) {
      sb.write('\n'); // Start a new line
      currentLineLength = 0;
    }
    sb.write(word + ' ');
    currentLineLength += word.length + 1;
  }

  return sb.toString();
}
