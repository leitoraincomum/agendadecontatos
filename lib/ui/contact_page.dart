//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter_agendacontatos/helpers/contact_helper.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
//import 'package:flutter_agendacontatos/ui/contact_page.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;
  //contrutor para agregar os contatos
  ContactPage({this.contact});
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  bool _userEdited = false;
  Contact _editedContact;
  //indicar se a página foi editada ou não

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());

      _nameController.text = _editedContact.name;
      _phoneController.text = _editedContact.phone;
      _emailController.text = _editedContact.email;
    }
  }

  @override // serve para sobreescrever a função da classe mãe
  Widget build(BuildContext context) {
    return WillPopScope(
     onWillPop: _requestPop,
     child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple.shade400,
          title: Text(_editedContact.name ?? "Novo Contato"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (_editedContact.name != null && _editedContact.name.isNotEmpty) {
              Navigator.pop(context, _editedContact);
            }
            },
            child: Icon(Icons.save),
            backgroundColor: Colors.red.shade300),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                GestureDetector(
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: _editedContact.img != null
                              ? FileImage(File(_editedContact.img))
                              : AssetImage("images/person.png"),
                          fit: BoxFit.cover),
                    ),
                  ),
                  onTap: (){
                    ImagePicker.pickImage(source: ImageSource.gallery)
                    .then((file){
                      if (file == null) return;
                      setState(() {
                        _editedContact.img = file.path;
                      });
                    });
                  }
                ),
                TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: "Nome"),
                    onChanged: (text) {
                      _userEdited = true;
                      setState(() {
                        _editedContact.name = text;
                      });
                    }),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: "e-mail"),
                  onChanged: (text) {
                    _userEdited = true;
                    _editedContact.email = text;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: "Phone"),
                  onChanged: (text) {
                    _userEdited = true;
                    _editedContact.phone = text;
                  },
                  keyboardType: TextInputType.phone,
                )
              ],
            )))
    //return Container();
     );
  }
  Future <bool> _requestPop(){
    if (_userEdited){
      showDialog(context: context,
       builder: (context){
         return AlertDialog(
           title: Text("Descartar alterações"),
           content: Text("Se sair as alterações serão perdidas"),
           actions: [
             TextButton(child: Text("Cancelar"),
             onPressed: () {
               Navigator.pop(context);
             },
         ),
         FlatButton(
          child: Text("Sim"),
          onPressed: () {
            //pesquisar razões de ter a repetição do navigator.
           Navigator.pop(context);
           Navigator.pop(context);
         },
         ),
         ]);
       });

       return Future.value(false);
      } else {
        return Future.value(true);
      }
  }
}
