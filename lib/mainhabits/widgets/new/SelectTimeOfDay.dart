import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/provider/ProviderFactory.dart';
import '../basic/BaseSelection2LineTile.dart';

class SelectTimeOfDay extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChange;

  final sp = ProviderFactory.settingsProvider;

  SelectTimeOfDay({this.value, this.onChange});

  void _showDialog(context) {
    final List<String> options = sp.timeArea.map((ta) => ta.area).toList();
    options.add('All Day');

    showDialog(
      context: context,
      builder: (ctxt) => SimpleDialog(
        title: Text(
          'Select Time Of Day',
          style: GoogleFonts.nunito(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        children: options
            .map((e) => ListTile(
                  dense: true,
                  title: Text(
                    e,
                    style: GoogleFonts.nunito(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  onTap: () => {
                    this.onChange(e),
                    Navigator.of(context).pop(),
                  },
                ))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseSelection2LineTile(
      value: this.value,
      icon: Icon(Icons.brightness_low),
      title: 'Time Of Day',
      emptyText: 'All Day',
      onTap: () => _showDialog(context),
      onClear: () => this.onChange(null),
    );
  }
}
