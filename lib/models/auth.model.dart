class TokenModel {
  final String? accessToken;
  final String? refreshToken;
  const TokenModel({this.accessToken, this.refreshToken});
  TokenModel copyWith({String? accessToken, String? refreshToken}) {
    return TokenModel(
        accessToken: accessToken ?? this.accessToken,
        refreshToken: refreshToken ?? this.refreshToken);
  }

  Map<String, Object?> toJson() {
    return {'access_token': accessToken, 'refresh_token': refreshToken};
  }

  static TokenModel fromJson(Map<String, Object?> json) {
    return TokenModel(
        accessToken: json['access_token'] == null
            ? null
            : json['access_token'] as String,
        refreshToken: json['refresh_token'] == null
            ? null
            : json['refresh_token'] as String);
  }

  @override
  String toString() {
    return '''TokenModel(
                accessToken:$accessToken,
refreshToken:$refreshToken
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is TokenModel &&
        other.runtimeType == runtimeType &&
        other.accessToken == accessToken &&
        other.refreshToken == refreshToken;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, accessToken, refreshToken);
  }
}
