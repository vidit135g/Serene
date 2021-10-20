import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/colors.dart';

class BaseSelectionRadioTile extends StatelessWidget {
  //
  final bool value;
  final VoidCallback onTap;
  final ValueChanged<bool> onChange;
  final VoidCallback onClear;
  final Icon icon;
  final String title;
  final String subtitle;

  BaseSelectionRadioTile({
    this.value,
    this.onTap,
    this.onChange,
    this.onClear,
    this.icon,
    this.title,
    this.subtitle,
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
      decoration: BoxDecoration(
        color: _darkMode
            ? Colors.grey.withOpacity(0.25)
            : Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: Colors.grey.withOpacity(0.5), width: 0.5),
          bottom: BorderSide(color: Colors.grey.withOpacity(0.5), width: 0.5),
        ),
      ),
      child: ListTile(
        leading: _icon,
        title: Text(
          '$title',
          style: GoogleFonts.nunito(
            color: CustomColors.darkhabit,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        subtitle: subtitle == null
            ? null
            : Text(
                subtitle,
                style: GoogleFonts.nunito(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
        trailing: title == null || title == ''
            ? Text('')
            : IconButton(
                color: Theme.of(context).accentColor,
                icon: Icon(value ? Icons.add_circle_outline : Icons.cancel),
                onPressed: () => this.onChange(!this.value),
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
      this.subtitle,
      context,
    );
  }
}
