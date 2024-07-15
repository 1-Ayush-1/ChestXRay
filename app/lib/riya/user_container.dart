import 'package:flutter/material.dart';

class UserContainer extends StatelessWidget {
  const UserContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 10),
          Padding(padding: EdgeInsets.all(8)),
          Row(
            children: [
              Padding(padding: EdgeInsets.all(12)),
              Positioned(
                top: 93,
                left: 21,
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/user.jpg',
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(12)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Riya Mittal',
                    style: const TextStyle(
                      // const primary = Color(0xff4268b0);
                      color: Color(0xff4268b0),
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '@20B413',
                    style: const TextStyle(
                      color: Color(0xff4268b0),
                      fontSize: 16,
                    ),
                  ),
                  // const primary = Color(0xff4268b0);
                  Text(
                    'riyamittal2102@gmail.com',
                    style: const TextStyle(
                      color: Color(0xff4268b0),
                      fontSize: 14,
                    ),
                  ),
                ], // children
              ),
            ],
          ),
          SizedBox(height: 10),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.all(8)),
                  Container(
                    padding: EdgeInsets.all(3),
                    alignment: Alignment.center,
                    width: 290.0,
                    height: 34,
                    decoration: BoxDecoration(
                        color: Color(0xffcde2f5),
                        // const primary = Color(0xff4268b0);
                        borderRadius: BorderRadius.circular(8)),
                    child: TextField(
                      scrollPadding: EdgeInsets.all(5),
                      decoration: InputDecoration(
                        hintText: 'Enter Mobile number',
                        border: InputBorder.none,
                        // const primary = Color(0xff4268b0);
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(6)),
                  Container(
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xff4268b0)),
                    width: 60,
                    height: 32,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Verify',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Padding(padding: EdgeInsets.all(13)),
                  Container(
                    padding: EdgeInsets.all(3),
                    alignment: Alignment.center,
                    width: 290.0,
                    height: 34,
                    decoration: BoxDecoration(
                        color: Color(0xffcde2f5),
                        borderRadius: BorderRadius.circular(8)),
                    child: TextField(
                      scrollPadding: EdgeInsets.all(5),
                      decoration: InputDecoration(
                        hintText: 'Date of Birth',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Padding(padding: EdgeInsets.all(13)),
                  Container(
                    padding: EdgeInsets.all(3),
                    alignment: Alignment.center,
                    width: 290.0,
                    height: 114,
                    decoration: BoxDecoration(
                        color: Color(0xffcde2f5),
                        borderRadius: BorderRadius.circular(8)),
                    child: TextField(
                      scrollPadding: EdgeInsets.all(5),
                      decoration: InputDecoration(
                        hintText: 'Medication',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Padding(padding: EdgeInsets.all(13)),
                  Container(
                    padding: EdgeInsets.all(3),
                    alignment: Alignment.center,
                    width: 290.0,
                    height: 34,
                    decoration: BoxDecoration(
                        color: Color(0xffcde2f5),
                        borderRadius: BorderRadius.circular(8)),
                    child: TextField(
                      scrollPadding: EdgeInsets.all(5),
                      decoration: InputDecoration(
                        hintText: 'Age',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Padding(padding: EdgeInsets.all(13)),
                  Container(
                    padding: EdgeInsets.all(3),
                    alignment: Alignment.center,
                    width: 290.0,
                    height: 34,
                    decoration: BoxDecoration(
                        color: Color(0xffcde2f5),
                        borderRadius: BorderRadius.circular(8)),
                    child: TextField(
                      scrollPadding: EdgeInsets.all(5),
                      decoration: InputDecoration(
                        hintText: 'Weight',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Padding(padding: EdgeInsets.all(13)),
                  Container(
                    padding: EdgeInsets.all(3),
                    alignment: Alignment.center,
                    width: 290.0,
                    height: 34,
                    decoration: BoxDecoration(
                        color: Color(0xffcde2f5),
                        borderRadius: BorderRadius.circular(8)),
                    child: TextField(
                      scrollPadding: EdgeInsets.all(5),
                      decoration: InputDecoration(
                        hintText: 'Height',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Padding(padding: EdgeInsets.all(13)),
                  Container(
                    padding: EdgeInsets.all(3),
                    alignment: Alignment.center,
                    width: 290.0,
                    height: 34,
                    decoration: BoxDecoration(
                        color: Color(0xffcde2f5),
                        borderRadius: BorderRadius.circular(8)),
                    child: TextField(
                      scrollPadding: EdgeInsets.all(5),
                      decoration: InputDecoration(
                        hintText: 'Address',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Padding(padding: EdgeInsets.all(13)),
                  Container(
                    padding: EdgeInsets.all(3),
                    alignment: Alignment.center,
                    width: 290.0,
                    height: 34,
                    decoration: BoxDecoration(
                        color: Color(0xffcde2f5),
                        borderRadius: BorderRadius.circular(8)),
                    child: TextField(
                      scrollPadding: EdgeInsets.all(5),
                      decoration: InputDecoration(
                        hintText: 'Pincode',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 15),
          Padding(padding: EdgeInsets.all(14)),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.all(10)),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0xff4268b0)),
                width: 150,
                height: 32,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Save',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(10)),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0xff4268b0)),
                width: 150,
                height: 32,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'patient_menu/');
                  },
                  child: Text(
                    'Back',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ], // children
      ),
    );
  } // build context
} // stateless widget
