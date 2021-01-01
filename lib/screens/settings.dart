import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabs/providers/settingsState.dart';

class Settings extends StatelessWidget {
  static const String id = "/settings";
  final currencies = SettingsState.currencies;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Settings"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Currency",
                style: Theme.of(context).textTheme.headline6,
              ),
              Wrap(
                spacing: 8,
                children: List<Widget>.generate(
                  currencies.length,
                  (int index) {
                    return ChoiceChip(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      label: Text(currencies[index]),
                      selected: currencies[index] ==
                          Provider.of<SettingsState>(context).selectedCurrency,
                      onSelected: (bool selected) {
                        if (selected)
                          Provider.of<SettingsState>(context, listen: false)
                              .selectCurrency(currencies[index]);
                      },
                    );
                  },
                ).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
