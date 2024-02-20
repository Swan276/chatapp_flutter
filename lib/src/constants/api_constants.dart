class ApiConstants {
  static String get baseUrl {
    const host = String.fromEnvironment("host");
    return "http://$host:8088";
  }

  static String get websocketBaseUrl {
    const host = String.fromEnvironment("host");
    return "ws://$host:8088";
  }

  static const websocketChannel = "websocket-channel";
}
