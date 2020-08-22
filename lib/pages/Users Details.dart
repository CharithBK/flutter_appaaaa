import 'dart:convert';
import 'dart:async';
import 'package:example/component/Services.dart';
import 'package:example/component/Users.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Users Profile.dart';

class UserDetails extends StatefulWidget {
  final String title = "USER DETAILS";
  final email,jwt;

  UserDetails(this.email,this.jwt);

  @override
  _UserDetailsState createState() => _UserDetailsState(email,jwt);
}

class _UserDetailsState extends State<UserDetails> {
  final email,jwt;

  _UserDetailsState(this.email,this.jwt);

  //variable initialization
  List<User> _users;
  List<User> _filterUsers;
  GlobalKey<ScaffoldState> _scaffoldKey;
  TextEditingController _id;
  TextEditingController _name;
  TextEditingController _email;
  TextEditingController _password;
  User _selectedUser;
  bool _isUpdating;
  String _titleProgress;

  @override
  void initState() {
    super.initState();
    _users = [];
    _filterUsers = [];
    _isUpdating = false;
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey();
    _id = TextEditingController();
    _name = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    //When page load all user details will load to the table
    _getUsers();
  }

  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  //get all user details
  _getUsers() {
    _showProgress('Loading Users...');
    Services.getUsers().then((users) {
      setState(() {
        _users = users;
        _filterUsers = users;
      });
      _showProgress(widget.title); // Reset the title...
    });
  }

//delete a selected user from the table
  _deleteUser(User users) {
    _showProgress('Deleting Member...');
    Services.deleteUser(users.id).then((result) {
      final msg = json.decode(result)["message"];
      print(msg);
      if ('User was deleted successfully!' == msg) {
        _getUsers();
      }
    });
  }

//add data to the variables
  _showValues(User user) {
    _id.text = user.id;
    _name.text = user.name;
    _email.text = user.email;
    _password.text = user.email;
  }

  SingleChildScrollView _dataBody() {
    // Both Vertical and Horozontal Scrollview for the DataTable to
    // scroll both Vertical and Horizontal...
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('ID',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  )),
            ),
            DataColumn(
              label: Text('Name',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  )),
            ),
            DataColumn(
              label: Text('Email',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  )),
            ),
            // Lets add one more column to show a delete button
            DataColumn(
              label: Text('Password',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  )),
            ),
            DataColumn(
              label: Text('Delete',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  )),
            ),
          ],
          //load data in to the table one by one
          rows: _filterUsers
              .map(
                (user) => DataRow(cells: [
                  DataCell(
                    Text(user.id),
                    onTap: () {
                      _showValues(user);
                      _selectedUser = user;
                      setState(() {
                        _isUpdating = true;
                      });
                    },
                  ),
                  DataCell(
                    Text(
                      user.name.toUpperCase(),
                    ),
                    onTap: () {
                      _showValues(user);

                      _selectedUser = user;

                      setState(() {
                        _isUpdating = true;
                      });
                    },
                  ),
                  DataCell(
                    Text(
                      user.email.toUpperCase(),
                    ),
                    onTap: () {
                      _showValues(user);

                      _selectedUser = user;
                      setState(() {
                        _isUpdating = true;
                      });
                    },
                  ),
                  DataCell(
                    Text(
                      user.password.toUpperCase(),
                    ),
                    onTap: () {
                      _showValues(user);

                      _selectedUser = user;
                      setState(() {
                        _isUpdating = true;
                      });
                    },
                  ),
                  DataCell(IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    //Delete the selected user and refresh the table
                    onPressed: () {
                      _deleteUser(user);
                      Fluttertoast.showToast(msg: 'User Deleted');
                      _getUsers();
                    },
                  ))
                ]),
              )
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(_titleProgress), // we show the progress in the title...
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Fluttertoast.showToast(msg: 'User Profile');

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new UserProfile(email,jwt)));
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _getUsers();
            },
          )
        ],
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(child: _dataBody()),
            ],
          ),
        ),
      ),
    );
  }
}
