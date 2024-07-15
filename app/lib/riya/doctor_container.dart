import 'package:flutter/material.dart';

class DoctorContainer extends StatefulWidget {
  const DoctorContainer({Key? key}) : super(key: key);

  @override
  State<DoctorContainer> createState() => _DoctorContainerState();
}

class _DoctorContainerState extends State<DoctorContainer> {
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
                    'assets/images/doctor.jpeg',
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
                    'Dr. John',
                    style: const TextStyle(
                      color: Color(0xff4268b0),
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '@20B218',
                    style: const TextStyle(
                      color: Color(0xff4268b0),
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'johndoe@gmail.com',
                    style: const TextStyle(
                      color: Color(0xff4268b0),
                      fontSize: 14,
                    ),
                  ),
                ], // children
              ),
            ],
          ),
          SizedBox(height: 15),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.all(8)),
                  Container(
                    padding: EdgeInsets.all(4),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Color(0xffcde2f5),
                        borderRadius: BorderRadius.circular(8)),
                    child: SizedBox(
                      width: 290.0,
                      height: 34,
                      child: TextField(
                        scrollPadding: EdgeInsets.all(3),
                        decoration: InputDecoration(
                          labelText: 'Enter Mobile number',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          labelStyle:
                              TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(7)),
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
              SizedBox(height: 15),
              Row(
                children: [
                  Padding(padding: EdgeInsets.all(12)),
                  Container(
                    padding: EdgeInsets.all(3),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Color(0xffcde2f5),
                        borderRadius: BorderRadius.circular(8)),
                    child: SizedBox(
                      width: 290.0,
                      height: 34,
                      child: TextField(
                        scrollPadding: EdgeInsets.all(5),
                        decoration: InputDecoration(
                          labelText: 'Date of Birth',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          labelStyle:
                              TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Padding(padding: EdgeInsets.all(13)),
                  Container(
                    padding: EdgeInsets.all(3),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Color(0xffcde2f5),
                        borderRadius: BorderRadius.circular(8)),
                    child: SizedBox(
                      width: 290.0,
                      height: 34,
                      child: TextField(
                        scrollPadding: EdgeInsets.all(5),
                        decoration: InputDecoration(
                          labelText: 'Age',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          labelStyle:
                              TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Padding(padding: EdgeInsets.all(12)),
                  Container(
                    padding: EdgeInsets.all(3),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Color(0xffcde2f5),
                        borderRadius: BorderRadius.circular(8)),
                    child: SizedBox(
                      width: 290.0,
                      height: 34,
                      child: TextField(
                        scrollPadding: EdgeInsets.all(5),
                        decoration: InputDecoration(
                          hintText: 'Location',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Padding(padding: EdgeInsets.all(12)),
                  Container(
                    padding: EdgeInsets.all(3),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Color(0xffcde2f5),
                        borderRadius: BorderRadius.circular(8)),
                    child: SizedBox(
                      width: 290.0,
                      height: 34,
                      child: TextField(
                        scrollPadding: EdgeInsets.all(5),
                        decoration: InputDecoration(
                          hintText: 'Tell about yourself',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Padding(padding: EdgeInsets.all(12)),
                  Container(
                    padding: EdgeInsets.all(3),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Color(0xffcde2f5),
                        borderRadius: BorderRadius.circular(8)),
                    child: SizedBox(
                      width: 290.0,
                      height: 34,
                      child: TextField(
                        scrollPadding: EdgeInsets.all(5),
                        decoration: InputDecoration(
                          hintText: 'Enter your qualifications',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
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
                  onPressed: () {},
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
  }
}

// stateless widget

// enum ganderGroup {
//   male,
//   female,
//   other,
// }

// class DoctorContainerbox extends StatefulWidget {
//   const DoctorContainerbox({Key? key}) : super(key: key);

//   @override
//   _DoctorContainerboxState createState() => _DoctorContainerboxState();
// }

// class _DoctorContainerboxState extends State<DoctorContainerbox> {
//   ganderGroup? _value = ganderGroup.male;
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Text('Gender'),
//         RadioListTile(
//             value: ganderGroup.male,
//             title: Text('Male'),
//             groupValue: _value,
//             onChanged: (ganderGroup? val) {
//               (() {
//                 _value = val;
//               });
//               print(val);
//             }),
//         RadioListTile(
//             value: ganderGroup.female,
//             title: Text('Female'),
//             groupValue: _value,
//             onChanged: (ganderGroup? val) {
//               print(val);
//             }),
//         RadioListTile(
//             value: ganderGroup.other,
//             title: Text('Other'),
//             groupValue: _value,
//             onChanged: (ganderGroup? val) {
//               print(val);
//             }),
//       ],
//     );
//   } // build Context
// } // DoctorContainerBox
// enum GenderGroup {
//   male,
//   female,
//   other,
// }

// class DoctorContainerbox extends StatefulWidget {
//   const DoctorContainerbox({Key? key}) : super(key: key);

//   @override
//   _DoctorContainerboxState createState() => _DoctorContainerboxState();
// }

// class _DoctorContainerboxState extends State<DoctorContainerbox> {
//   Set<GenderGroup> _selectedValues = {};

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text('Gender'),
//         CheckboxListTile(
//           value: _selectedValues.contains(GenderGroup.male),
//           title: Text('Male'),
//           onChanged: (bool? val) {
//             setState(() {
//               if (val == true) {
//                 _selectedValues.add(GenderGroup.male);
//               } else {
//                 _selectedValues.remove(GenderGroup.male);
//               }
//             });
//             print(_selectedValues);
//           },
//         ),
//         CheckboxListTile(
//           value: _selectedValues.contains(GenderGroup.female),
//           title: Text('Female'),
//           onChanged: (bool? val) {
//             setState(() {
//               if (val == true) {
//                 _selectedValues.add(GenderGroup.female);
//               } else {
//                 _selectedValues.remove(GenderGroup.female);
//               }
//             });
//             print(_selectedValues);
//           },
//         ),
//         CheckboxListTile(
//           value: _selectedValues.contains(GenderGroup.other),
//           title: Text('Other'),
//           onChanged: (bool? val) {
//             setState(() {
//               if (val == true) {
//                 _selectedValues.add(GenderGroup.other);
//               } else {
//                 _selectedValues.remove(GenderGroup.other);
//               }
//             });
//             print(_selectedValues);
//           },
//         ),
//       ],
//     );
//   } // build Context
// } // DoctorContainerBox
