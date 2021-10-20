import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/colors.dart';
import '../../../utils/const.dart';

class BaseSelection2LineTile extends StatelessWidget {
  //
  final String value;
  final VoidCallback onTap;
  final VoidCallback onClear;
  final Icon icon;
  final String title;
  final String subtitle;
  final String emptyText;

  BaseSelection2LineTile({
    this.value,
    this.onTap,
    this.onClear,
    this.icon,
    this.title,
    this.subtitle,
    this.emptyText,
  });

  Widget _tile(
    Icon _icon,
    String title,
    String subtitle,
    BuildContext context,
  ) {
    var _theme = Theme.of(context);
    var _darkMode = _theme.brightness == Brightness.dark;

    return Container(
      child: ListTile(
        leading: _icon,
        title: Text(
          title,
          style: GoogleFonts.nunito(
            color: CustomColors.darkhabit,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        subtitle: Text(
          subtitle == null || subtitle == '' ? this.emptyText : subtitle,
          style: GoogleFonts.nunito(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        trailing: subtitle == null || subtitle == ''
            ? Text('')
            : IconButton(
                color: Theme.of(context).accentColor,
                icon: Icon(Icons.cancel),
                onPressed: () => this.onClear(),
              ),
        onTap: () => this.onTap(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _tile(
      this.icon,
      this.title,
      this.value,
      context,
    );
  }
}
