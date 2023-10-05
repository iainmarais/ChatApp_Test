// ignore_for_file: file_names, class_names, non_constant_identifier_names
import "package:flutter/material.dart";

class MainView extends StatelessWidget 
{
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    //Construct a scaffold with the title "Chat - Main"
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title:const Text("Main"),
      ),
      //This should be scrollable.
      body:const Row(
        //Two columns:
        children: [
          Card(
            child:SingleChildScrollView(
              child: Column(
                children:[
                  Row(
                    children: [
                      Text("Forum"),
                    ],
                  )
                ]
              ),
            )
          ),
          Card(
            child:SingleChildScrollView(
              child: Column(
                children:[
                  Row(
                    children: [
                      Text("Conversations"),
                    ],
                  )
                ]
              ),
            )
          ),
        ]
      )
    );
  }
}