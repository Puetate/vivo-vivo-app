import 'package:flutter/material.dart';
import 'package:vivo_vivo_app/src/domain/models/drop_down_item.dart';
import 'package:vivo_vivo_app/src/utils/app_styles.dart';

class DropDownBtn<T> extends StatefulWidget {
  const DropDownBtn(
      {super.key,
      required this.future,
      required this.label,
      required this.selectedValue});
  // final Function(String value) onSelectedValue;
  final TextEditingController selectedValue;
  final Future<List<DropDownItem>> future;
  final String label;

  @override
  State<DropDownBtn> createState() => _DropDownBtnState();
}

class _DropDownBtnState<T> extends State<DropDownBtn> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DropDownItem>>(
      future: widget.future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return DropdownButtonFormField(
            isExpanded: true,
            decoration: InputDecoration(
              label: Text(
                widget.label,
                style: Styles.textLabel,
              ),
            ),
            value: widget.selectedValue.text.isNotEmpty
                ? widget.selectedValue.text
                : null,
            items: snapshot.data!
                .map(
                  (e) => DropdownMenuItem(
                      value: e.id.toString(), child: Text(e.name)),
                )
                .toList(),
            validator: (value) =>
                value == null ? 'Ingrese su ${widget.label}' : null,
            onChanged: (value) {
              setState(() {
                widget.selectedValue.text = value.toString();
              });
            },
          );
        } else if (snapshot.hasError) {
          return const Text('Error');
        } else {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: SizedBox(
                height: 15,
                width: 15,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
