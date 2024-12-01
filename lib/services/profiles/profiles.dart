import 'dart:convert';

const String ipfsPrefix = 'ipfs://';

class Profile {
  String account;
  String username;
  String name;
  String description;
  String image;
  String imageMedium;
  String imageSmall;

  Profile({
    this.account = '',
    this.username = '@anonymous',
    this.name = 'Anonymous',
    this.description = '',
    this.image = 'assets/icons/profile.svg',
    this.imageMedium = 'assets/icons/profile.svg',
    this.imageSmall = 'assets/icons/profile.svg',
  });

  // from json
  factory Profile.fromJson(String json) {
    final Map<String, dynamic> map = jsonDecode(json);
    return Profile.fromMap(map);
  }

  // to json
  String toJson() => jsonEncode(toMap());

  // from map
  Profile.fromMap(Map<String, dynamic> json)
      : account = json['account'],
        username = json['username'],
        name = json['name'],
        description = json['description'] ?? '',
        image = json['image'],
        imageMedium = json['imageMedium'],
        imageSmall = json['imageSmall'];

  // to map
  Map<String, dynamic> toMap() => {
        'account': account,
        'username': username,
        'name': name,
        'description': description,
        'image': image,
        'image_medium': imageMedium,
        'image_small': imageSmall,
      };

  // with copy
  Profile copyWith({
    String? account,
    String? username,
    String? name,
    String? description,
    String? image,
    String? imageMedium,
    String? imageSmall,
  }) {
    return Profile(
      account: account ?? this.account,
      username: username ?? this.username,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      imageMedium: imageMedium ?? this.imageMedium,
      imageSmall: imageSmall ?? this.imageSmall,
    );
  }

  void parseIPFSImageURLs(String url) {
    image = image.replaceFirst(ipfsPrefix, '$url/');
    imageMedium = imageMedium.replaceFirst(ipfsPrefix, '$url/');
    imageSmall = imageSmall.replaceFirst(ipfsPrefix, '$url/');
  }

  // check equality
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Profile &&
          runtimeType == other.runtimeType &&
          account == other.account &&
          username == other.username &&
          name == other.name &&
          description == other.description &&
          image == other.image &&
          imageMedium == other.imageMedium &&
          imageSmall == other.imageSmall;

  @override
  int get hashCode => super.hashCode;
}
