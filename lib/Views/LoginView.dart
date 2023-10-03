// ignore_for_file: file_names, class_names, non_constant_identifier_names

//This should handle the login state and if the user logging in is registered or not

//Views are full screen widgets, so here we do use the scaffold.
//In C# MVC these are called views.

import "dart:convert";

import "package:flutter/material.dart";
import "package:http/http.dart" as http;

class LoginView extends StatefulWidget 
{
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> 
{
  //Create two props that can be set to the values returned from the inputs:
  String _username = "";
  String _email_address = "";
  String _password = "";
  String action ="";
  bool IsRegistration = true;
  //For this to work we need a form key:
  final _formKey = GlobalKey<FormState>();
  void SwitchForm()
  {
    //Switch the form based on the state of the IsRegistration boolean prop:
    IsRegistration = !IsRegistration;
    setState(() 
    {
      //Update the state of the form:
      _formKey.currentState!.reset();
    });
  }
  void _HandleRegister()
  {
    _HandleSubmit("register");
  }
  void _HandleLogin()
  {
    _HandleSubmit("login");
  }
  void _HandleSubmit(String action) async
  {
    final bool IsValid = _formKey.currentState!.validate();
    //Note to self: validation needs to be improved so as to check for an existing username or email address, and likewise notify the user of this.
    if(!IsValid)
    {
      //Use the snackbar class to show an error message to the user:
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid username and password"),
        )
      );
      return;
    }
    else
    {
      _formKey.currentState!.save();
      final apiUrl = Uri.parse("http://localhost/flutterchat-backend/api/main/post.php?action=$action");
      //Check if a new user is registering or an existing user is logging in:
      if(IsRegistration==true)
      {
        action = "register";
        final data = {"username": _username, "email_address": _email_address, "password": _password};
        try
        {
          final response = await http.post(apiUrl, body: data);
          if(response.statusCode == 200)
          {
            //use the snackbar widget to tell the user of a successful registration
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
              content: Text("User $_username successfully registered."),
              )
            );
          }
          else
          {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Please enter a valid username and password"),
              )
            );
            print(response.body);
          }
        }
        catch(ex)
        {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Something went wrong, please try again."),
            )
          );
          return;
        }
      }
      //End of registration code.

      //Handle the login process:
      else
      {
        action = "login";
        //Create a new dictionary to hold these mappings so that they can be sent as a body to the server
        Map<String, String> data = {};
        if (_username.isNotEmpty)
        {
          data["identifier"] = _username;
        }
        else if (_email_address.isNotEmpty)
        {
          data["identifier"] = _email_address;
        }
        else
        {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please enter a valid username or email address")),
          );
          //If this validation fails, the process should be stopped for security reasons.
          return;
        }
        if (_password.isNotEmpty)
        {
          data["password"] = _password;
        }
        else 
        {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please enter a valid password")),
          );
          //If this validation fails, the process should be stopped for security reasons.
          return;
        }
        try
        {
          final response = await http.post(apiUrl, body: data);
          if(response.statusCode == 200)
          {
            final responseData=response.body;
            final token = jsonDecode(responseData)["token"];
            //Use the snackbar widget to tell the user of a successful login:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
              content: Text("User $_username successfully logged in."), 
              )
            );
            //At this stage, one can proceed to the chat or forum screen.
            //This token must be passed to ensure the validity of the user's session, and cleared when the user ends their session.
            print("Token: $token");
          }
          else
          {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Login failed. Username, email address or password is not valid."),
              )
            );
            print(response.body);
          }
        }
        catch(ex)
        {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Something went wrong, please try again."),
            )
          );
        }
      }
    }
  }
 
  @override
  Widget build(BuildContext context)
  {
    Widget LoginFormContent = SingleChildScrollView(
                  //Use Padding: 16 all dirs:
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child:Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Username or email address",
                              ),
                              //Disable autocorrect and autocapitalise:
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) 
                              {
                                if(value==null || value.trim().isEmpty)
                                {
                                  return "Please enter a username or email address";
                                }
                                //If all is good:
                                return null;
                              },
                              onSaved: (value)
                              {
                                _username = value!;
                              }
                            ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Password"
                              ),
                              //Disable autocorrect and autocapitalise:
                            obscureText: true,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            keyboardType: TextInputType.text,
                            validator: (value)
                              {
                                if(value==null || value.trim().length < 6)
                                {
                                  return "Please enter a valid password of at least 6 characters.";
                                }
                                //If all is good:
                                return null;
                              },
                            onSaved: (value)
                              {
                                _password = value!;
                              }
                            ),
                        const SizedBox(height: 20),
                      ]
                    )
                  )
                );
    Widget RegistrationFormContent = SingleChildScrollView(
                  //Use Padding: 16 all dirs:
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child:Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Username",
                              ),
                              //Disable autocorrect and autocapitalise:
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) 
                              {
                                if(value==null || value.trim().isEmpty)
                                {
                                  return "Please enter a username";
                                }
                                //If all is good:
                                return null;
                              },
                              onSaved: (value)
                              {
                                _username = value!;
                              }
                            ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Email address",
                              ),
                              //Disable autocorrect and autocapitalise:
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) 
                              {
                                if(value==null || value.trim().isEmpty)
                                {
                                  return "Please enter a valid email address";
                                }
                                //If all is good:
                                return null;
                              },
                              onSaved: (value)
                              {
                                _email_address = value!;
                              }
                            ),    
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Password"
                              ),
                              //Disable autocorrect and autocapitalise:
                            obscureText: true,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            keyboardType: TextInputType.text,
                            validator: (value)
                              {
                                if(value==null || value.trim().length < 6)
                                {
                                  return "Please enter a valid password of at least 6 characters.";
                                }
                                //If all is good:
                                return null;
                              },
                            onSaved: (value)
                              {
                                _password = value!;
                              }
                            ),
                        const SizedBox(height: 20),
                      ]
                    )
                  )
                );
    //Switch the form based on the state of the IsRegistration boolean prop:
    Widget FormContent = IsRegistration ? RegistrationFormContent : LoginFormContent;
    //Construct a form widget beneath a scaffold:
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title:const Text("Login")
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            //Cols for username and pw:
            children: [
              Container(
                //Use a margin around the image:
                margin: const EdgeInsets.only(
                  //Use these for TBLR: 30,20,20,20:
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20
                ),
                //Use width = 200 and height = 200:
                width: 200,
                height: 200,
                child: Image.asset(
                  "images/chat-speechbubbles.png",
                )
              ),
              //Create a new card widget and a scrollable view inside it:
              Card(
                  margin: const EdgeInsets.all(20),
                  child:Column(
                    children: [
                      FormContent,
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [                      
                            TextButton(
                              //Toggle the state of the IsRegistration boolean prop:
                              onPressed: SwitchForm,
                              child: IsRegistration ? const Text("New user: "):const Text("Existing user")
                            ),
                            const SizedBox(width: 20),
                            ElevatedButton(
                              onPressed: IsRegistration ? _HandleRegister:_HandleLogin,
                              child: IsRegistration ? const Text("Register") : const Text("Login"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                    ],
                  )
              )
            ]
          )
        )
      ),
    );
  }
}