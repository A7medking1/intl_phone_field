import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';

class PickerDialogStyle {
  final Color? backgroundColor;

  final TextStyle? countryCodeStyle;

  final TextStyle? countryNameStyle;

  final Widget? listTileDivider;

  final EdgeInsets? listTilePadding;

  final EdgeInsets? padding;

  final Color? searchFieldCursorColor;

  final InputDecoration? searchFieldInputDecoration;

  final EdgeInsets? searchFieldPadding;

  final double? width;

  PickerDialogStyle({
    this.backgroundColor,
    this.countryCodeStyle,
    this.countryNameStyle,
    this.listTileDivider,
    this.listTilePadding,
    this.padding,
    this.searchFieldCursorColor,
    this.searchFieldInputDecoration,
    this.searchFieldPadding,
    this.width,
  });
}

class CountryPickerDialog extends StatefulWidget {
  final List<Country> countryList;
  final Country selectedCountry;
  final ValueChanged<Country> onCountryChanged;
  final String searchText;
  final List<Country> filteredCountries;
  final PickerDialogStyle? style;
  final String languageCode;

  const CountryPickerDialog({
    Key? key,
    required this.searchText,
    required this.languageCode,
    required this.countryList,
    required this.onCountryChanged,
    required this.selectedCountry,
    required this.filteredCountries,
    this.style,
  }) : super(key: key);

  @override
  _CountryPickerDialogState createState() => _CountryPickerDialogState();
}

class _CountryPickerDialogState extends State<CountryPickerDialog> {
  late List<Country> _filteredCountries;
  late Country _selectedCountry;

  @override
  void initState() {
    _selectedCountry = widget.selectedCountry;
    _filteredCountries = widget.filteredCountries.toList();
    // ..sort(
    //       (a, b) =>
    //       a.localizedName(widget.languageCode).compareTo(
    //           b.localizedName(widget.languageCode)),
    // );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery
        .of(context)
        .size
        .width;
    final mediaHeight = MediaQuery
        .of(context)
        .size
        .height;
    final width = widget.style?.width ?? mediaWidth;
    const defaultHorizontalPadding = 40.0;
    const defaultVerticalPadding = 24.0;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
          vertical: defaultVerticalPadding,
          horizontal: mediaWidth > (width + defaultHorizontalPadding * 2)
              ? (mediaWidth - width) / 2
              : defaultHorizontalPadding),
      backgroundColor: widget.style?.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero
      ),
      child: Container(
        height: mediaHeight / 2,
        padding: widget.style?.padding ?? const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            /*   Padding(
              padding: widget.style?.searchFieldPadding ??
                  const EdgeInsets.all(0),
              child: TextField(
                cursorColor: widget.style?.searchFieldCursorColor,
                decoration: widget.style?.searchFieldInputDecoration ??
                    InputDecoration(
                      suffixIcon: const Icon(Icons.search),
                      labelText: widget.searchText,
                    ),
                onChanged: (value) {
                  _filteredCountries = widget.countryList.stringSearch(value)
                    ..sort(
                          (a, b) =>
                          a.localizedName(widget.languageCode).compareTo(
                              b.localizedName(widget.languageCode)),
                    );
                  if (mounted) setState(() {});
                },
              ),
            ),
            const SizedBox(height: 15),*/
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filteredCountries.length,
                itemBuilder: (ctx, index) =>
                    Column(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            _selectedCountry = _filteredCountries[index];
                            widget.onCountryChanged(_selectedCountry);
                            Navigator.of(context).pop();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    kIsWeb
                                        ? Image.asset(
                                      'assets/flags/${_filteredCountries[index]
                                          .code.toLowerCase()}.png',
                                      package: 'intl_phone_field',
                                      width: 32,
                                    )
                                        : Text(
                                      _filteredCountries[index].flag,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    SizedBox(width: 20),
                                    Text(
                                      _filteredCountries[index].localizedName(
                                          widget.languageCode),
                                      style: widget.style?.countryNameStyle ??
                                          const TextStyle(
                                              fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                Text(
                                  '+${_filteredCountries[index].dialCode}',
                                  style: widget.style?.countryCodeStyle ??
                                      const TextStyle(
                                          fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ),
                        widget.style?.listTileDivider ??
                            const Divider(thickness: 1),
                      ],
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
