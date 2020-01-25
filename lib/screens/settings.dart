import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabs/providers/settingsState.dart';

class Settings extends StatelessWidget {
  static const String id = "/register";
  final currencies = SettingsState.currencies;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Settings",
                style: Theme.of(context).textTheme.display1,
              ),
              Divider(),
              Text(
                "Currency",
                style: Theme.of(context).textTheme.title,
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
                          Provider.of<SettingsState>(context)
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
