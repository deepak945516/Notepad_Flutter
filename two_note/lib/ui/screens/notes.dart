import 'package:flutter/material.dart';
import 'package:two_note/common/dart_helper.dart';
import 'package:two_note/common/shared_pref.dart';
import 'package:two_note/db_manager/db_manager.dart';
import 'package:two_note/model/note_model.dart';
import 'package:two_note/ui/widgets/add_note.dart';

class Notes extends StatefulWidget {
  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  final dbManager = DbManager();
  Future<List<Note>> notes;
  int lastNoteId;
  final menuItems = [
    "By Title",
    "By Created Date",
    "By Updated Date",
  ];
  String sortTitle;

  @override
  Widget build(BuildContext context) {
    PreferenceData.getStringData("sortTitle").then((value) {
      setState(() {
        sortTitle = value == null ? "By Title" : value;
      });
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notes",
        ),
        actions: [
          getMenu(context),
        ],
      ),
      body: getBody(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.add,
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) {
                return AddNote(
                  note: Note(),
                  isUpdate: false,
                  addUpdateAction: (Note note, bool isUpdate) async {
                    note.id = lastNoteId == null ? 0 : lastNoteId + 1;
                    await dbManager.createNote(note);
                    setState(() {
                      notes = dbManager.getNotes(orderBy: sortTitle);
                    });
                  },
                );
              });
        },
      ),
    );
  }

  Widget getBody() {
    notes = dbManager.getNotes(orderBy: sortTitle);
    return FutureBuilder<List<Note>>(
      future: notes,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Please add some note by tapping + button",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
              ),
            );
          }
          return getNoteList(snapshot.data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // By default, show a loading spinner.
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget getNoteList(List<Note> noteList) {
    lastNoteId = noteList
        .reduce((value, element) => value.id > element.id ? value : element)
        .id;
    return ListView.builder(
      padding: EdgeInsets.all(12),
      itemCount: noteList.length,
      itemBuilder: (_, index) {
        var note = noteList[index];
        return Card(
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  note.title,
                  maxLines: 2,
                ),
                Text(
                  DartHelper.geDateFrom(int.parse(note.createdDate)),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            subtitle: Text(note.details),
            trailing: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () {
                  showDeleteDialog(note);
                }),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AddNote(
                      note: note,
                      isUpdate: true,
                      addUpdateAction: (Note note, bool isUpdate) async {
                        await dbManager.updateNote(note);
                        setState(() {
                          notes = dbManager.getNotes(orderBy: sortTitle);
                        });
                      },
                    );
                  });
            },
          ),
        );
      },
    );
  }

  Widget getMenu(BuildContext context) {
    return PopupMenuButton(
        //child: Text("Please select your designation"),
        icon: Icon(
          Icons.sort_sharp,
          color: Colors.white,
        ), // only icon or child
        //initialValue: selectedDesignation,
        onSelected: (String menuName) {
          sortTitle = menuName;
          PreferenceData.setStringData("sortTitle", sortTitle);
          setState(() {
            notes = dbManager.getNotes(orderBy: sortTitle);
          });
        },
        itemBuilder: (context) {
          return menuItems.map<PopupMenuItem<String>>((value) {
            return PopupMenuItem(
              value: value,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(value),
                  Icon(
                    value == sortTitle ? Icons.check_box_rounded : null,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            );
          }).toList();
        });
  }

  void showDeleteDialog(Note note) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
            content: Text(
              "Do you want to delete ${note.title}?",
              style: TextStyle(color: Colors.grey[600]),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  dbManager.deleteNote(note.id);
                  setState(() {
                    notes = dbManager.getNotes(orderBy: sortTitle);
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  "Delete",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "No",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          );
        });
  }
}


