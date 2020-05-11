class StringUtils {
  static String addEllipsis(String message, [int maxLenght = 20]) {
    if (message != null) {
      if (message.length > maxLenght) {
        return '${message.substring(0, maxLenght)}...';
      }
    }
    return message;
  }
}
