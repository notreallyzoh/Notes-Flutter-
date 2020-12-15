import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noteup/models/note.dart';
import 'package:noteup/pages/edit.dart';
import 'package:noteup/service/db.dart';
import 'package:noteup/widgets/loading.dart';
import 'package:flutter/services.dart';


class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  List<Note> notes;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF21BFBD),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            setState(() => loading = true);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Edit(note: new Note()))).then((v) {
              refresh();
            });
          },
          backgroundColor: Color(0xFF21BFBD),
        ),
        body: loading
            ? Loading()
            : Column(
                children: [
                  SizedBox(
                    height: 200.0,
                    child: Container(
                      child: Text('Notes',style: GoogleFonts.montserrat(fontSize: 60,color: Colors.white,fontWeight: FontWeight.w300)),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 40),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10, top: 20),
                    height: MediaQuery.of(context).size.height - 228,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(75.0)),
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.all(20.0),
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        Note note = notes[index];
                        return Card(
                          color: Colors.white,
                          shadowColor: Color(0xFF21BFBD),
                          child: ListTile(
                            title: Text(note.title),
                            subtitle: Text(
                              note.content,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              setState(() => loading = true);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Edit(note: note))).then((v) {
                                refresh();
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> refresh() async {
    notes = await DB().getNotes();
    setState(() => loading = false);
  }
}
