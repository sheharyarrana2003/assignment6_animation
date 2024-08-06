import 'package:flutter/material.dart';
import 'contacts.dart';

Widget buildTexts(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    ),
  );
}

class ContactDetailPage extends StatelessWidget {
  final Contact contact;

  const ContactDetailPage({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contact.name,style: const TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: Center(
        child: Hero(
          tag: contact.name,
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTexts("Name: ", contact.name),
                    buildTexts("Phone: ", contact.phoneNumber),
                    buildTexts("Email: ", contact.email),
                    buildTexts("Address: ", contact.address),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
