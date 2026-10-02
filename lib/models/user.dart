class User {
  final String phone;
  final String firstName;
  final String lastName;
  final int age;
  final String address;
  final String zip;
  final String city;
  final String email;
  final int newsletterFreq;

  User({
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.address,
    required this.zip,
    required this.city,
    required this.email,
    required this.newsletterFreq,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      phone: json["phone"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      age: json["age"],
      address: json["address"],
      zip: json["zip"],
      city: json["city"],
      email: json["email"],
      newsletterFreq: json["newsletterFreq"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "phone": phone,
      "firstName": firstName,
      "lastName": lastName,
      "age": age,
      "address": address,
      "zip": zip,
      "city": city,
      "email": email,
      "newsletterFreq": newsletterFreq,
    };
  }

  User copyWith({
    String? phone,
    String? firstName,
    String? lastName,
    int? age,
    String? address,
    String? zip,
    String? city,
    String? email,
    int? newsletterFreq,
  }) {
    return User(
      phone: phone ?? this.phone,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      age: age ?? this.age,
      address: address ?? this.address,
      zip: zip ?? this.zip,
      city: city ?? this.city,
      email: email ?? this.email,
      newsletterFreq: newsletterFreq ?? this.newsletterFreq,
    );
  }
}
