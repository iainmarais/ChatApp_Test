// ignore_for_file: file_names, class_names, non_constant_identifier_names

//This should handle the login state and if the user logging in is registered or not

//Views are full screen widgets, so here we do use the scaffold.
//In C# MVC these are called views.

import "package:app02/Utils/AuthManager.dart";
import "package:flutter/material.dart";
//App namespaces
class LoginView extends StatefulWidget 
{
  final AuthManager authManager;
  const LoginView({required this.authManager,super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> 
{
  //Create two props that can be set to the values returned from the inputs:
  String _email_address = "";
  String _password = "";
  String action = "";
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
    _formKey.currentState!.save();
    _HandleSubmit("register");
  }
  bool SetLoginAfterRegistration(bool state)
  {
    return state;
  }
  void _HandleLogin()
  {
    _formKey.currentState!.save();
    _HandleSubmit("login");
  }
  void _HandleSubmit(String action) async
  {
    try
    {
      if (action == "register")
      {
          await widget.authManager.client!.auth.signUp(
          email: _email_address,
          password: _password,
        );
          if (!context.mounted)
          {
            return;
          }
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login successful."))
          );
      }
      else if(action == "login")
      {
          await widget.authManager.client!.auth.signInWithPassword(
          email: _email_address,
          password: _password,
        );
          if (!context.mounted)
          {
            return;
          }
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login successful."))
          );
      }
      //Should not get here, but for in case:
      else
      {
        return;
      }
    }
    //It's like shooting fish in a barrel.
    catch(ex)
    {
      if (ex.toString().contains("Invalid login credentials"))
      {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid username or password."))
        );
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
                                  return "Please enter a username or email address";
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
    Widget FormContent = LoginFormContent;
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
                              child: IsRegistration ? const Text("Register") : const Text("Log in"),
                            ),
                            const SizedBox(width: 20),
                          ],
                        ),
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