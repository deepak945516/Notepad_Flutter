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
  var searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    notes = dbManager.getNotes(orderBy: sortTitle);
  }

  @override
  Widget build(BuildContext context) {
    PreferenceData.getStringData("sortTitle").then((value) {
      setState(() {
        sortTitle = value == null ? "By Title" : value;
      });
    });
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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

                    notes = dbManager.getNotes(
                      orderBy: sortTitle,
                      searchKey: searchController.text.trim(),
                    );
                  },
                );
              });
        },
      ),
    );
  }

  Widget getBody() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
          padding: EdgeInsets.only(left: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.grey[300]),
          ),
          child: TextField(
            controller: searchController,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.name,
            autocorrect: false,
            decoration: InputDecoration(
              icon: Icon(Icons.search_outlined),
              hintText: "Search",
              floatingLabelBehavior: FloatingLabelBehavior.never,
              border: InputBorder.none,
            ),
            onChanged: (value) {
              notes = dbManager.getNotes(orderBy: sortTitle, searchKey: value);
            },
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Note>>(
            future: notes,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        searchController.text.trim().isEmpty
                            ? "Please add note by tapping + button"
                            : "No result found!",
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
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Center(
            child: Text(
              "By Deepak",
              style: TextStyle(color: Colors.grey[300]),
            ),
          ),
        )
      ],
    );
  }

  Widget getNoteList(List<Note> noteList) {
    lastNoteId = noteList
        .reduce((value, element) => value.id > element.id ? value : element)
        .id;
    return ListView.builder(
      physics: BouncingScrollPhysics(),
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

                        notes = dbManager.getNotes(
                            orderBy: sortTitle,
                            searchKey: searchController.text.trim());
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

          notes = dbManager.getNotes(
              orderBy: sortTitle, searchKey: searchController.text.trim());
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

                  notes = dbManager.getNotes(
                      orderBy: sortTitle,
                      searchKey: searchController.text.trim());

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
