import 'dart:io';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class AttendanceSheetPage extends StatefulWidget {
  const AttendanceSheetPage({Key? key}) : super(key: key);

  @override
  _AttendanceSheetPageState createState() => _AttendanceSheetPageState();
}

class _AttendanceSheetPageState extends State<AttendanceSheetPage> {
  List<String> attendanceData = [];
  late String currentDate;

  @override
  void initState() {
    super.initState();
    currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    openAttendanceSheet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 24, 56, 82),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 14, 56, 90),
        title: Text("Attendance Sheet"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Student Name",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 50),
                Text(
                  "Date",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.white,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: attendanceData.length,
              itemBuilder: (context, index) {
                final attendanceEntry = attendanceData[index].split(',');
                if (attendanceEntry.length >= 2 && index > 0) {
                  final name = attendanceEntry[0];
                  return Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(
                          255, 0, 34, 61), // Set the background color
                      borderRadius:
                          BorderRadius.circular(10), // Set the border radius
                    ),
                    margin: EdgeInsets.all(8),
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                name,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 50),
                            Text(
                              currentDate,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: downloadAttendanceFile,
              child: Text('Download Attendance File'),
            ),
          ),
        ],
      ),
    );
  }

  void openAttendanceSheet() async {
    Directory? appDocumentsDirectory;
    if (Platform.isAndroid || Platform.isIOS) {
      appDocumentsDirectory = await getApplicationDocumentsDirectory();
    } else {
      // Handle other platforms as needed
    }

    if (appDocumentsDirectory != null) {
      final currentDate = _getFormattedDate(DateTime.now());
      final file =
          File('${appDocumentsDirectory.path}/attendance_$currentDate.csv');
      if (await file.exists()) {
        final contents = await file.readAsString();
        setState(() {
          attendanceData = contents.split('\n');
        });
      } else {
        // File does not exist
        print('Attendance file does not exist.');
      }
    }
  }

  String _getFormattedDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void downloadAttendanceFile() async {
    try {
      Directory? appDocumentsDirectory;
      if (Platform.isAndroid || Platform.isIOS) {
        appDocumentsDirectory = await getApplicationDocumentsDirectory();
      } else {
        // Handle other platforms as needed
      }

      if (appDocumentsDirectory != null) {
        final currentDate = _getFormattedDate(DateTime.now());
        final file =
            File('${appDocumentsDirectory.path}/attendance_$currentDate.csv');
        if (await file.exists()) {
          final filePath = file.path;
          print('Opening attendance file at: $filePath');
          openFile(filePath);
        } else {
          // Write the attendance data to the file
          await file.writeAsString(attendanceData.join('\n'));
          print('Attendance file downloaded successfully.');
          print('File path: ${file.path}');
        }
      }
    } catch (e) {
      print('Error downloading attendance file: $e');
    }
  }
}

void openFile(String filePath) {
  // Open the file using the platform's default file opener
  OpenFile.open(filePath);
}
