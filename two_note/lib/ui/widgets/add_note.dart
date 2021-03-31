import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:two_note/common/dart_helper.dart';
import 'package:two_note/model/note_model.dart';

class AddNote extends StatelessWidget {
  var note = Note();
  bool isUpdate = false;
  Function addUpdateAction;

  var titleController = TextEditingController();
  var detailsController = TextEditingController();

  AddNote({this.note, this.isUpdate, this.addUpdateAction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: getBody(context),
    );
  }

  Widget getBody(BuildContext context) {
    if (isUpdate) {
      titleController.text = note.title;
      detailsController.text = note.details;
    }
    return Center(
      child: Container(
        height: 400,
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            TextField(
              textCapitalization: TextCapitalization.sentences,
              autocorrect: false,
              maxLength: 25,
              //keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              maxLines: 1,
              controller: titleController,
              decoration: InputDecoration(
                icon: Icon(Icons.title_outlined),
                labelText: "Note title",
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              textCapitalization: TextCapitalization.sentences,
              autocorrect: false,
              textInputAction: TextInputAction.newline,
              maxLines: 6,
              controller: detailsController,
              decoration: InputDecoration(
                icon: Icon(Icons.note_add_outlined),
                labelText: "Note",
              ),
            ),
            SizedBox(
              height: 30,
            ),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                      shape: StadiumBorder(),
                      color: Colors.blue[800],
                      minWidth: 150,
                      height: 45,
                      child: Text(
                        isUpdate ? "Update" : "Add",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                      onPressed: () {
                        if (titleController.text.trim().isEmpty) {
                          DartHelper.showToast(
                              message: "Please enter title");
                          return;
                        }
                        note.title = titleController.text;
                        note.details = detailsController.text;
                        var currentDate = "${DartHelper.getCurrentTimeStamp()}";
                        note.updatedDate = currentDate;
                        if (isUpdate == false) {
                          note.createdDate = currentDate;
                        }
                        addUpdateAction(note, isUpdate);
                        Navigator.pop(context);
                      }),
                  SizedBox(
                    width: 20,
                  ),
                  MaterialButton(
                      shape: StadiumBorder(),
                      color: Colors.red,
                      minWidth: 150,
                      height: 45,
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
