import 'package:flutter/material.dart';
import 'contact_details.dart';
import 'contacts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final GlobalKey<AnimatedListState> _animateKey = GlobalKey<AnimatedListState>();
  final List<Contact> contacts = [
    Contact(name: "Ambulance", phoneNumber: "1122", email: "pakAmbulance@gmail.com", address: "Lahore"),
    Contact(name: "Fire Brigade", phoneNumber: "1122", email: "pakFireBrigade@gmail.com", address: "Karachi"),
    Contact(name: "Police", phoneNumber: "15", email: "punjuabPolice@gmail.com", address: "Lahore"),
  ];
  int selectedContactIndex = -1;

  void addContact(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _buildAddContactDialog(context),
    );
  }

  Widget _buildAddContactDialog(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Contact"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(_nameController, TextInputType.name, "Name"),
            _buildTextField(_numberController, TextInputType.number, "Number"),
            _buildTextField(_emailController, TextInputType.emailAddress, "Email"),
            _buildTextField(_addressController, TextInputType.streetAddress, "Address"),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () => _handleAddContact(context),
          child: const Text("Add"),
        ),
      ],
    );
  }

  TextField _buildTextField(TextEditingController controller, TextInputType keyboardType, String labelText) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: labelText),
    );
  }

  void _handleAddContact(BuildContext context) {
    String name = _nameController.text;
    String number = _numberController.text;
    String email = _emailController.text;
    String address = _addressController.text;

    if (name.isNotEmpty && number.isNotEmpty && email.isNotEmpty && address.isNotEmpty) {
      final Contact newContact = Contact(name: name, phoneNumber: number, email: email, address: address);
      addItem(newContact);
      Navigator.of(context).pop();
      _clearTextFields();
    }
  }

  void _clearTextFields() {
    _nameController.clear();
    _numberController.clear();
    _emailController.clear();
    _addressController.clear();
  }

  void addItem(Contact contact) {
    contacts.insert(0, contact);
    _animateKey.currentState!.insertItem(0, duration: const Duration(seconds: 1));
  }

  void removeItem(int index, BuildContext context) {
    final removedContact = contacts.removeAt(index);
    _animateKey.currentState!.removeItem(index, (context, animation) {
      return _buildRemovedItem(removedContact, animation);
    }, duration: const Duration(seconds: 1));
  }

  Widget _buildRemovedItem(Contact contact, Animation<double> animation) {
    return SlideTransition(
      position: animation.drive(Tween<Offset>(
        begin: const Offset(1, 0),
        end: const Offset(0, 0),
      ).chain(CurveTween(curve: Curves.ease))),
      child: _buildContactCard(contact, true),
    );
  }

  Widget _buildContactCard(Contact contact, [bool isRemoved = false]) {
    return Card(
      elevation: 0,
      color: isRemoved ? Colors.grey[200] : (selectedContactIndex == contacts.indexOf(contact) ? Colors.grey[300] : Colors.grey[200]),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(11),
      ),
      child: ListTile(
        title: Text(contact.name, style: const TextStyle(fontSize: 18)),
        subtitle: Text(contact.phoneNumber, style: const TextStyle(fontSize: 16)),
        trailing: IconButton(
          onPressed: () => removeItem(contacts.indexOf(contact), context),
          icon: const Icon(Icons.delete, size: 28),
        ),
        onTap: () => _handleContactTap(context, contacts.indexOf(contact)),
      ),
    );
  }

  void _handleContactTap(BuildContext context, int index) {
    setState(() {
      selectedContactIndex = index;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ContactDetailPage(contact: contacts[index])));
      setState(() {
        selectedContactIndex = -1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Contacts", style: TextStyle(fontWeight: FontWeight.bold))),
        elevation: 1,
        backgroundColor: Colors.blue,
      ),
      body: AnimatedList(
        key: _animateKey,
        initialItemCount: contacts.length,
        itemBuilder: (context, index, animation) {
          return Hero(
            tag: contacts[index].name,
            child: FadeTransition(
              opacity: animation,
              child: SizeTransition(
                key: UniqueKey(),
                sizeFactor: animation,
                child: _buildContactCard(contacts[index]),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addContact(context),
        backgroundColor: Colors.blue,
        child:  const Icon(Icons.add),
      ),
    );
  }
}
