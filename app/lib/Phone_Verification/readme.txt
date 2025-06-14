@override
Widget build(BuildContext context) {
    // Accessing UserProvider instance
    final userProvider = Provider.of<UserProvider>(context);
    
    // Accessing user data from UserProvider
    final user = userProvider.user;
}

EXAMPLE:->
        Text('Welcome ${user!.username}'),
        SizedBox(height: 16),
        Text('Email: ${user!.email}'),
        SizedBox(height: 16),
        Text('Mobile Number: ${user!.mobileNum}'),

#remeber to use null operator after user => user!
#Ensure widget is not constant

also import these two
import 'package:provider/provider.dart';
import 'package:check/saumya/user_provider.dart';


//i have just passed the report id so that unnati screen could be seen wiith report