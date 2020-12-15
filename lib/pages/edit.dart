import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noteup/models/note.dart';
import 'package:noteup/service/db.dart';
import 'package:noteup/widgets/loading.dart';

class Edit extends StatefulWidget {
  final Note note;
  Edit({this.note});

  @override
  EditState createState() => EditState();
}

class EditState extends State<Edit> {
  TextEditingController title, content;
  bool loading = false, editmode = false;

  @override
  void initState() {
    super.initState();
    title = new TextEditingController();
    content = new TextEditingController();
    if (widget.note.id != null) {
      editmode = true;
      title.text = widget.note.title;
      content.text = widget.note.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(editmode ? 'EDIT' : 'NEW'),
      //   actions: <Widget>[
      //     IconButton(
      //       icon: Icon(Icons.save),
      //       onPressed: () {
      //         setState(() => loading = true);
      //         save();
      //         Navigator.of(context).pop();
      //       },
      //     ),
      //     if (editmode)
      //       IconButton(
      //         icon: Icon(Icons.delete),
      //         onPressed: () {
      //           setState(() => loading = true);
      //           delete();
      //         },
      //       ),
      //   ],
      //   backgroundColor: Color(0xFF21BFBD),
      // ),
      body: loading
          ? Loading()
          : ListView(
              padding: EdgeInsets.all(50.0),
              children: <Widget>[
                SizedBox(
                  height: 100,
                ),
                Text(
                  !editmode ? 'New Note' : 'Edit mode',
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w500, fontSize: 30),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                    controller: title,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF21BFBD)),
                      ),
                      hintText: 'Title',
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF21BFBD)),
                      ),
                    )),
                SizedBox(height: 10.0),
                TextField(
                    controller: content,
                    maxLines: 6,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF21BFBD)),
                      ),
                      hintText: 'Description',
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF21BFBD)),
                      ),
                    )),
                SizedBox(
                  height: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Colors.white,
                          )),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Color(0xFF21BFBD),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.save_alt_rounded,
                            color: Colors.white,
                          )),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Color(0xFF21BFBD),
                      ),
                    )
                  ],
                )
              ],
            ),
    );
  }

  Future<void> save() async {
    if (title.text != '') {
      widget.note.title = title.text;
      widget.note.content = content.text;
      if (editmode)
        await DB().update(widget.note);
      else
        await DB().add(widget.note);
    }
    setState(() => loading = false);
  }

  Future<void> delete() async {
    await DB().delete(widget.note);
    Navigator.pop(context);
  }
}
