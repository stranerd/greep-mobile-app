import 'package:equatable/equatable.dart';

class User extends Equatable{
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String username;
  final String fullName;
  final String photoUrl;
  String? managerName;
  final bool hasManager;
  final num? commission;
  final String? managerId;
  final UserRanking? rankings;
  final bool isVerified;
  final String? type;

   User(
      {required this.id,
      required this.email,
      required this.fullName,
        this.managerId,
        required this.username,
        required this.isVerified,
        this.commission,
         this.rankings,
        this.managerName,
      required this.firstName,
        this.type,
      required this.hasManager,
      required this.lastName,
      required this.photoUrl});

  factory User.fromServer(dynamic data) {
    var user = User(
        id: data["id"],
        email: data["bio"]?["email"] ?? "",
        rankings: data["account"]?["rankings"] == null ? null :UserRanking.fromMap(data["account"]?["rankings"]),
        fullName: data["bio"]?["name"]?["full"] ?? "",
        username: data["bio"]?["username"] ?? "",
        isVerified: false,
        firstName: data["bio"]?["name"]["first"] ?? "",
        lastName: data["bio"]?["name"]?["last"] ?? "",
        hasManager: data["manager"] != null,
        type: data["type"]?["type"],
        managerId: data["manager"] != null ? data["manager"]["managerId"]: null,
        commission: data["manager"] != null ? data["manager"]["commission"]: null,
        photoUrl: data["bio"]?["photo"]?["link"]??"");
    return user;
  }

  factory User.fromServerAuth(dynamic data) {
    print("From server auth ${data}");
    var user = User(
        id: data["id"],
        email: data["email"],
        isVerified: false,
        rankings:data["account"]?["rankings"] == null ? null : UserRanking.fromMap(data["rankings"]),
        username: data["username"] ?? "",
        fullName: data["allNames"]["full"],
        firstName: data["name"]["first"] ?? "",
        lastName: data["name"]["last"] ?? "",
        hasManager: false,
        photoUrl: data["photo"]["link"]);
    return user;
  }


  @override
  String toString() {
    return 'User{id: $id, email: $email, firstName: $firstName, lastName: $lastName, username: $username, fullName: $fullName, photoUrl: $photoUrl, managerName: $managerName, hasManager: $hasManager, commission: $commission, managerId: $managerId, rankings: $rankings, isVerified: $isVerified, type: $type}';
  }

  @override
  List<Object?> get props => [id];
}

class UserRanking {
  final Rank? daily;
  final Rank? weekly;
  final Rank? monthly;

  UserRanking({required this.daily, required this.weekly, required this.monthly});

  Map<String, dynamic> toMap() {
    return {
      'daily': daily,
      'weekly': weekly,
      'monthly': monthly,
    };
  }

  factory UserRanking.fromMap(Map<String, dynamic>? map) {
    return UserRanking(
      daily: map?['daily'] != null ? Rank.fromMap(map!["daily"]) : null,
      weekly: map?['weekly'] != null ? Rank.fromMap(map!["weekly"]) : null,
      monthly: map?['monthly'] != null ? Rank.fromMap(map!["monthly"]) : null,
    );
  }
}

class Rank {
  final num value;
  final DateTime date;

  Rank({required this.value, required this.date});

  Map<String, dynamic> toMap() {
    return {
      'value': value,
      'date': date,
    };
  }

  factory Rank.fromMap(Map<String, dynamic> map) {
    return Rank(
      value: map['value'] ?? 0,
      date: map["lastUpdatedAt"]  != null ? DateTime.fromMillisecondsSinceEpoch(map["lastUpdatedAt"]): DateTime.now(),
    );
  }
}
