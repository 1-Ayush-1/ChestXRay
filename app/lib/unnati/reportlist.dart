import 'package:flutter/material.dart';
import 'api_service.dart';
import 'user_profile.dart';
import 'reports.dart';
import 'ReportDetailPage.dart';
import 'ReportDetailDocPage.dart';

class ReportDetailsPage extends StatefulWidget {
  final String token;

  const ReportDetailsPage({super.key, required this.token});

  @override
  _ReportDetailsPageState createState() => _ReportDetailsPageState();
}

class _ReportDetailsPageState extends State<ReportDetailsPage> {
  late Future<UserProfile> _futureUserProfile;
  late Future<List<UserReport>> _futureUserReports;

  @override
  void initState() {
    super.initState();
    _futureUserProfile = ApiService().fetchUserProfile(widget.token);
    _futureUserReports = ApiService().fetchUserReports(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: FutureBuilder<UserProfile>(
        future: _futureUserProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching data: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  color: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: snapshot.data!.profilePhoto!.isNotEmpty
                            ? NetworkImage(snapshot.data!.profilePhoto!)
                            : const AssetImage('assets/screen.png')
                                as ImageProvider,
                      ),
                      const SizedBox(width: 16.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, ${snapshot.data!.name}!',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '@${snapshot.data!.staticId}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Please find your previous reports here -',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 8.0),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Until: Yesterday',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: FutureBuilder<List<UserReport>>(
                    future: _futureUserReports,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error fetching data: ${snapshot.error}'),
                        );
                      } else if (snapshot.hasData) {
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final report = snapshot.data![index];
                            return GestureDetector(
                              onTap: () {
                                if (report.doctorComments! == "No comments") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ReportDetailPage(
                                        token: widget.token,
                                        reportStaticId: report.staticId,
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ReportDetailDocPage(
                                        token: widget.token,
                                        reportStaticId: report.staticId,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Card(
                                margin: const EdgeInsets.only(bottom: 16.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      ClipOval(
                                        child: Image.network(
                                          report.aiImage!,
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                            return Image.asset('assets/screen.png', width: 80, height: 80, fit: BoxFit.cover);
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 16.0),
                                      Expanded(
                                        child: Text(
                                          report.aiText ?? 'no_text',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(
                          child: Text('No reports available'),
                        );
                      }
                    },
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: Text('Unexpected error'),
            );
          }
        },
      ),
    );
  }
}
