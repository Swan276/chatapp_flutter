class ApiConstants {
  static String get baseUrl {
    const host = String.fromEnvironment("host");
    return "http://$host";
  }

  static String get websocketBaseUrl {
    const host = String.fromEnvironment("host");
    return "ws://$host";
  }

  static const websocketChannel = "websocket-channel";
}
