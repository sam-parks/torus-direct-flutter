class LoginWindowResponse {
  String accessToken;
  String idToken;

  String getAccessToken() {
    return accessToken;
  }

  void setAccessToken(String accessToken) {
    this.accessToken = accessToken;
  }

  String getIdToken() {
    return idToken;
  }

  void setIdToken(String idToken) {
    this.idToken = idToken;
  }

  void parseResponse(String response) {
    List<String> params =
        response.substring(response.indexOf("#") + 1).split("&");
    for (String param in params) {
      List<String> keyValuePair = param.split("=");
      if (keyValuePair.length > 0) {
        if (keyValuePair[0] == "access_token") {
          setAccessToken(keyValuePair[1]);
        } else if (keyValuePair[0] == "id_token") {
          setIdToken(keyValuePair[1]);
        }
      }
    }
  }

  String toString() {
    return "LoginWindowResponse{" +
        "accessToken='" +
        accessToken +
        '\'' +
        ", idToken='" +
        idToken +
        '\'' +
        '}';
  }
}
