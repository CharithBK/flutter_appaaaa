class User {
  String _id;
  String _name;
  String _email;
  String _password;

  // ignore: non_constant_identifier_names
  User(id, name, email, password) {
    this._id = id.toString();
    this._name = name.toString();
    this._email = email.toString();
    this._password = password.toString();
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(json['id'], json['name'], json['email'], json['password']);
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }
}
