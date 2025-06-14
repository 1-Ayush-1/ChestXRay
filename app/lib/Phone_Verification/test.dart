import 'package:flutter/material.dart';

class Mytest extends StatefulWidget {
  const Mytest({super.key});

  @override
  State<Mytest> createState() => _MytestState();
}

class _MytestState extends State<Mytest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      appBar: AppBar(
        title: Text(''),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Color.fromARGB(223, 24, 5, 235),
      ),
      
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
           
              children:[    
                Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'image/');
                          // Handle button press
                        },
                        child: Text('Select from Gallery'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          textStyle: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                  ]
                )
              ]
          )
         )
      
    );
  }
}