class User {
  final String name;
  final String album;
  final String picture;

  User(
    this.name,
    this.album,
    this.picture,
  );

  factory User.fromJson(dynamic json) {
    return User(
      json['name'] as String,
      json['album'] as String,
      json['picture'] as String,
    );
  }

  Map<String, dynamic> toJson() =>
      {'name': name, 'album': album, 'picture': picture};
}
