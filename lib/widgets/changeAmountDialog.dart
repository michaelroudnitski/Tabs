import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tabs/controllers/tabsController.dart';

class ChangeAmountDialog extends StatefulWidget {
  final DocumentSnapshot tab;
  ChangeAmountDialog({@required this.tab});

  @override
  _ChangeAmountDialogState createState() => _ChangeAmountDialogState();
}

class _ChangeAmountDialogState extends State<ChangeAmountDialog> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _amountController = TextEditingController();
    _amountController.text = widget.tab["amount"].toString();
    _amountController.selection =
        TextSelection.collapsed(offset: _amountController.text.length);
    return SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(20.0),
      ),
      title: Text('Change Amount'),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: TextField(
            autofocus: true,
            decoration: InputDecoration(contentPadding: EdgeInsets.all(12)),
            inputFormatters: [
              WhitelistingTextInputFormatter(RegExp("[0-9.]")),
            ],
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            controller: _amountController,
            keyboardType: TextInputType.numberWithOptions(
              decimal: true,
            ),
          ),
        ),
        ButtonBar(
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            SimpleDialogOption(
              onPressed: () {
                if (_amountController.text.length > 0) {
                  try {
                    double newAmount = double.parse(_amountController.text);
                    TabsController.updateAmount(
                        widget.tab.documentID, newAmount);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  } catch (e) {}
                }
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ],
    );
  }
}
