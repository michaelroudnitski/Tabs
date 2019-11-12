import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import './home.dart';
import './register.dart';

class Welcome extends StatelessWidget {
  static const String id = "welcome";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    "Tabs",
                    style: Theme.of(context)
                        .textTheme
                        .display2
                        .copyWith(color: Theme.of(context).primaryColor),
                  ),
                  Text(
                    "The expense sharing app.",
                    style: Theme.of(context)
                        .textTheme
                        .body2
                        .copyWith(color: Theme.of(context).primaryColor),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        RaisedButton(
                          padding: EdgeInsets.all(14),
                          child: Text("Get Started"),
                          onPressed: () {
                            Navigator.pushNamed(context, Register.id);
                          },
                        ),
                        FlatButton(
                          child: Text("Sign In"),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, Home.id);
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: WaveWidget(
              config: CustomConfig(
                colors: [Colors.teal, Theme.of(context).primaryColor],
                durations: [30000, 50000],
                heightPercentages: [0.5, 0.35],
              ),
              waveAmplitude: 5,
              wavePhase: 45,
              waveFrequency: 80,
              size: Size(
                MediaQuery.of(context).size.width * 100,
                20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
