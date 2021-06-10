import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_agendacontatos/helpers/contact_helper.dart';
import 'package:flutter_agendacontatos/ui/contact_page.dart';
import 'package:url_launcher/url_launcher.dart';
//caminho do arquivo contact_helper

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();
  List<Contact> contacts = [];
  //List() substuído por [] pois deixa de reclamar que está depreciado

  @override
  void initState() {
    super.initState();
    //chamada do método que exibe os contatos
    _getAllContacts();

/*
    Contact c = Contact();

    c.name = "Fernanda Souza";
    c.email = "fernanda@leitoraincomum.com.br";
    c.phone = " 991 234 567";
    c.img = "imgTeste";
    helper.saveContact(c);

    @override
    helper.getAllContact().then((list){
      print(list);
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.blue.shade300,
        centerTitle: true,
      ),
      backgroundColor: Colors.lightBlue.shade50,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red.shade300,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return _contactCard(context, index);
        },
      ),
    );
  }

  //_contactCard é um método para chamar os contatos salvos e por isso tanto o nome
  //quanto a chamada, precisa ser prcedido pelo underline _
  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
          child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: contacts[index].img != null
                      ? FileImage(File(contacts[index].img))
                      : AssetImage("images/person.png"),
                  fit: BoxFit.cover),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contacts[index].name ?? "",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(contacts[index].email ?? "",
                      style: TextStyle(fontSize: 18)),
                  Text(contacts[index].phone ?? "",
                      style: TextStyle(fontSize: 18))
                ],
              ))
        ]),
      )),
      onTap: () {
        // _showContactPage(contact: contacts[index]);
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
              onClosing: () {},
              builder: (context) {
                return Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: FlatButton(
                              //child indica que flatButton é um elemento interno da padding
                              onPressed: () {
                                // puxar o número de telefone dentro do vetor.
                                launch("tel: ${contacts[index].phone}");
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Ligar",
                                style:
                                    TextStyle(color: Colors.green.shade300, fontSize: 20),
                              ))),
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: FlatButton(
                              onPressed: () {
                                //fechar as opções
                                Navigator.pop(context);
                                _showContactPage(contact: contacts[index]);
                              },
                              child: Text(
                                "Editar",
                                style:
                                    TextStyle(color: Colors.orange.shade400, fontSize: 20),
                              ))),
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: FlatButton(
                              onPressed: () {
                                helper.deleteContact(contacts[index].id);
                                setState(() {
                                  contacts.removeAt(index);
                                  Navigator.pop(context);
                                });
                              },
                              child: Text(
                                "Excluir",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 20),
                              ))),
                    ],
                  ),
                );
              });
        });
  }

  void _showContactPage({Contact contact}) async {
    final recContact = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContactPage(
                  contact: contact,
                )));
    if (recContact != null) {
      if (contact != null) {
        await helper.updateContact(recContact);
      } else {
        await helper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }
//método que busca, lista e exibe todos os contatos.
  void _getAllContacts() {
    helper.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }
  /*
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ContactPage(
        contact: contact,
      );
    }));*/
}

/*     helper.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
   });*/
