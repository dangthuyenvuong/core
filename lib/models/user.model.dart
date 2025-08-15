class UserModel {
  final String? id;
  final String? fullName;
  final String? avatar;
  final String? accountId;
  final String? email;
  final String? phone;
  final List<SocialAccounts>? socialAccounts;
  final String? createdAt;
  final String? updatedAt;
  final String? provider;
  const UserModel(
      {this.id,
      this.fullName,
      this.avatar,
      this.accountId,
      this.email,
      this.phone,
      this.socialAccounts,
      this.createdAt,
      this.updatedAt,
      this.provider});
  UserModel copyWith(
      {String? id,
      String? fullName,
      String? avatar,
      String? accountId,
      String? email,
      String? phone,
      List<SocialAccounts>? socialAccounts,
      String? createdAt,
      String? updatedAt,
      String? provider}) {
    return UserModel(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        avatar: avatar ?? this.avatar,
        accountId: accountId ?? this.accountId,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        socialAccounts: socialAccounts ?? this.socialAccounts,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        provider: provider ?? this.provider);
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'avatar': avatar,
      'account_id': accountId,
      'email': email,
      'phone': phone,
      'social_accounts': socialAccounts
          ?.map<Map<String, dynamic>>((data) => data.toJson())
          .toList(),
      'created_at': createdAt,
      'updated_at': updatedAt,
      'provider': provider
    };
  }

  static UserModel fromJson(Map<String, Object?> json) {
    return UserModel(
        id: json['id'] == null ? null : json['id'] as String,
        fullName:
            json['full_name'] == null ? null : json['full_name'] as String,
        avatar: json['avatar'] == null ? null : json['avatar'] as String,
        accountId:
            json['account_id'] == null ? null : json['account_id'] as String,
        email: json['email'] == null ? null : json['email'] as String,
        phone: json['phone'] == null ? null : json['phone'] as String,
        socialAccounts: json['social_accounts'] == null
            ? null
            : (json['social_accounts'] as List)
                .map<SocialAccounts>((data) => SocialAccounts.fromJson(data))
                .toList(),
        createdAt:
            json['created_at'] == null ? null : json['created_at'] as String,
        updatedAt:
            json['updated_at'] == null ? null : json['updated_at'] as String,
        provider: json['provider'] == null ? null : json['provider'] as String);
  }

  @override
  String toString() {
    return '''User(
                id:$id,
fullName:$fullName,
avatar:$avatar,
accountId:$accountId,
email:$email,
phone:$phone,
socialAccounts:${socialAccounts.toString()},
createdAt:$createdAt,
updatedAt:$updatedAt,
provider:$provider
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is UserModel &&
        other.runtimeType == runtimeType &&
        other.id == id &&
        other.fullName == fullName &&
        other.avatar == avatar &&
        other.accountId == accountId &&
        other.email == email &&
        other.phone == phone &&
        other.socialAccounts == socialAccounts &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.provider == provider;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, id, fullName, avatar, accountId, email,
        phone, socialAccounts, createdAt, updatedAt, provider);
  }
}

class SocialAccounts {
  final String? provider;
  final String? providerId;
  final String? createdAt;
  final String? updatedAt;
  const SocialAccounts(
      {this.provider, this.providerId, this.createdAt, this.updatedAt});
  SocialAccounts copyWith(
      {String? provider,
      String? providerId,
      String? createdAt,
      String? updatedAt}) {
    return SocialAccounts(
        provider: provider ?? this.provider,
        providerId: providerId ?? this.providerId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  Map<String, Object?> toJson() {
    return {
      'provider': provider,
      'providerId': providerId,
      'created_at': createdAt,
      'updated_at': updatedAt
    };
  }

  static SocialAccounts fromJson(Map<String, Object?> json) {
    return SocialAccounts(
        provider: json['provider'] == null ? null : json['provider'] as String,
        providerId:
            json['providerId'] == null ? null : json['providerId'] as String,
        createdAt:
            json['created_at'] == null ? null : json['created_at'] as String,
        updatedAt:
            json['updated_at'] == null ? null : json['updated_at'] as String);
  }

  @override
  String toString() {
    return '''SocialAccounts(
                provider:$provider,
providerId:$providerId,
createdAt:$createdAt,
updatedAt:$updatedAt
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is SocialAccounts &&
        other.runtimeType == runtimeType &&
        other.provider == provider &&
        other.providerId == providerId &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, provider, providerId, createdAt, updatedAt);
  }
}
