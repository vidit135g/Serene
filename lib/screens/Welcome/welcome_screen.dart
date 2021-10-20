import 'package:flutter/material.dart';
import '../../mainhabits/data/provider/ProviderFactory.dart';
import 'components/body.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  var sp = ProviderFactory.settingsProvider;
  var loading = true;

  @override
  void initState() {
    super.initState();

    sp.loadInitData().whenComplete(
          () => setState(() {
            loading = false;
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}
