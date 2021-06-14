import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

class Contacts {
  static List<String> _contacts;
  static bool hasRequestedThisSession = false;

  static Future<void> _getContacts() async {
    try {
      Iterable<Contact> contacts =
          await ContactsService.getContacts(withThumbnails: false);
      _contacts = contacts
          .map((contact) => contact.displayName != null
              ? contact.displayName
              : contact.givenName)
          .toList();
    } catch (e) {
      _contacts = null;
    }
  }

  static Future<List<String>> queryContacts(pattern) async {
    if (_contacts == null && await Permission.contacts.request().isGranted)
      await _getContacts();

    if (_contacts != null && _contacts.length > 0 && pattern.length > 0) {
      return _contacts
          .where((contact) =>
              contact.toLowerCase().contains(pattern.toLowerCase()))
          .toList();
    }
    return null;
  }
}
