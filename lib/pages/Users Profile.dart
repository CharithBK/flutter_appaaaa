import 'package:example/component/Services.dart';
import 'package:example/component/Users.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'Login.dart';
import 'Users Details.dart';

class UserProfile extends StatefulWidget {
  final email, jwt;

  UserProfile(this.email, this.jwt);

  @override
  _UserProfileState createState() => _UserProfileState(email, jwt);
}

class _UserProfileState extends State<UserProfile> {
  List<User> _users;

  @override
  void initState() {
    super.initState();
    _users = [];
    //load logged user details when page load
    _loadUserDetails(_user);
  }

  _loadUserDetails(User users) {
    Services.getUserDetails(jwt).then((users) {
      //get the logged user details and put to the textBox
      User loggedUser;
      for (User user in users) {
        //print(email);
        if (user.email == email) {
          loggedUser = user;
        }
      }
      setState(() {
        _users = users;
        idController.text = loggedUser.id;
        nameController.text = loggedUser.name;
        emailController.text = loggedUser.email;
      });
    });
  }

  final email, jwt;

  _UserProfileState(this.email, this.jwt);

  bool _isEnabled = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  User _user;
  bool _isUpdating;

  _updateUser(User user) {
    setState(() {
      _isUpdating = true;
    });
    //updated user details will pass to the Services class
    Services.updateUser(
            idController.text, nameController.text, emailController.text)
        .then((result) {
      final msg = json.decode(result)["message"];
      if ('User was successfully update.' == msg) {
        setState(() {
          _isUpdating = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //textBox and Buttons
    final username = TextFormField(
      enabled: false,
      controller: idController,
      decoration: InputDecoration(labelText: 'Id ', hintText: 'id'),
      // ignore: missing_return
      validator: (value) {
        if (value.isEmpty) {
          return 'ID Is Empty *';
        }
      },
    );
    final name = TextFormField(
      controller: nameController,
      enabled: _isEnabled,
      decoration: InputDecoration(labelText: 'Name ', hintText: 'name'),
      // ignore: missing_return
      validator: (value) {
        if (value.isEmpty) {
          return 'Name Is Empty *';
        }
      },
    );

    final Email = TextFormField(
      enabled: _isEnabled,
      controller: emailController,
      decoration: InputDecoration(labelText: 'Email ', hintText: 'email'),
      // ignore: missing_return
      validator: (value) {
        if (value.isEmpty) {
          return 'Email Is Empty *';
        }
      },
    );

    final updateButton = MaterialButton(
      onPressed: () {
        if (_formKey.currentState.validate()) {
          if (nameController.text != null && emailController.text != null) {
            Fluttertoast.showToast(msg: 'Update Successfully');
            _updateUser(_user);
          } else {
            Fluttertoast.showToast(msg: 'Fields cannot be Empty');
          }
        }
      },
      child: new Text(
        "Update User",
        style: TextStyle(color: Colors.white),
      ),
      color: Colors.green,
    );
    //When edit on , text fields are editable
    //id in cannot edit
    final editMode = MaterialButton(
      onPressed: () {
        setState(() {
          _isEnabled = !_isEnabled;
          if (_isEnabled == true) {
            Fluttertoast.showToast(msg: 'Edit On');
          } else {
            Fluttertoast.showToast(msg: 'Edit Off');
          }
        });
      },
      child: new Text(
        "Edit Mode",
        style: TextStyle(color: Colors.white),
      ),
      color: Colors.red,
    );

    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.green,
        title: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new UserProfile(email, jwt)));
            },
            child: Text('B E N E F I T B L O G ')),
        actions: <Widget>[
          new IconButton(
              icon: Icon(
                Icons.people,
                color: Colors.white,
              ),
              onPressed: () {
                Fluttertoast.showToast(msg: 'All User Details');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new UserDetails(email, jwt)));
              }),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Fluttertoast.showToast(msg: 'Logout');
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => new Login()));
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: new Text(
                    "U S E R      P R O F I L E",
                  ),
                ),
                SizedBox(height: 45.0),
                username,
                SizedBox(height: 5.0),
                name,
                SizedBox(height: 5.0),
                Email,
                SizedBox(height: 35.0),
                new Row(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: updateButton),
                    SizedBox(width: 35.0),
                    Padding(
                        padding: const EdgeInsets.all(8.0), child: editMode),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
