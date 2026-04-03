import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/theme.dart';

Widget customTextField({
  required TextEditingController controller,
  required String hintText,
  required String labelText,
  required Focusnode,
  bool isPassword = false,
}) {
  final obscurePassword = ValueNotifier<bool>(isPassword);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        labelText,
        style: TextStyle(
          color: C.textLabel,
          fontSize: 13,
        ),
      ),
      const SizedBox(height: 6),
      ValueListenableBuilder<bool>(
        valueListenable: obscurePassword,
        builder: (context, value, child) {
          return TextField(
            controller: controller,
            obscureText: value,
            focusNode: Focusnode,
            style: TextStyle(color: C.textPrimary),
            cursorColor: C.green,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: C.textLabel),
              filled: true,
              fillColor: C.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: C.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: C.borderFocus, width: 1.5),
              ),
              suffixIcon: isPassword
                  ? IconButton(
                icon: Icon(
                  value ? Icons.visibility_off : Icons.visibility,
                  color: C.textLabel,
                ),
                onPressed: () {
                  obscurePassword.value = !obscurePassword.value;
                },
              )
                  : null,
            ),
          );
        },
      ),
    ],
  );
}

Widget customizedCapsule({required String text, required String no}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: C.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: C.border),
      boxShadow: [
        BoxShadow(
          color: C.green.withOpacity(0.3),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Circle with number inside
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: C.green,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            no,
            style: GoogleFonts.spaceMono(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Text next to circle
        Text(
          text,
          style: GoogleFonts.spaceMono(
            color: C.cyan,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

Widget buildDropdown(ValueNotifier<String> notifier, List<String> options) {
  return ValueListenableBuilder<String>(
    valueListenable: notifier,
    builder: (context, value, _) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: C.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: C.border),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            dropdownColor: C.bg, // dropdown background
            icon: Icon(Icons.arrow_drop_down, color: C.textPrimary),
            style: TextStyle(
              color: C.textPrimary,
              fontSize: 14,
            ),
            items: options.map((option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(option, style: GoogleFonts.spaceMono(color: C.textPrimary),maxLines: 1,overflow: TextOverflow.visible,)
                  ),
                ),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) notifier.value = val;
            },
          ),
        ),
      );
    },
  );
}

// Function to build a row of two labeled dropdowns
Widget buildLabeledDropdownRow({
  required String label1,
  required ValueNotifier<String> notifier1,
  required List<String> options1,
  required String label2,
  required ValueNotifier<String> notifier2,
  required List<String> options2,
  required double spacing,
}) {
  return Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label1, style: TextStyle(color: C.textLabel)),
            SizedBox(height: 6),
            buildDropdown(notifier1, options1),
          ],
        ),
      ),
      SizedBox(width: spacing),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label2, style: TextStyle(color: C.textLabel)),
            SizedBox(height: 6),
            buildDropdown(notifier2, options2),
          ],
        ),
      ),
    ],
  );
}
Widget buildDropdownRow3({
  required ValueNotifier<String> notifier1,
  required List<String> options1,

  required ValueNotifier<String> notifier2,
  required List<String> options2,

  required ValueNotifier<String> notifier3,
  required List<String> options3,

  required double spacing,
}) {
  return Row(
    children: [
      Expanded(child: buildDropdown(notifier1, options1)),
      SizedBox(width: spacing),

      Expanded(child: buildDropdown(notifier2, options2)),
      SizedBox(width: spacing),

      Expanded(child: buildDropdown(notifier3, options3)),
    ],
  );
}
Widget sectionHeading({
  required BuildContext context,
  required String text,
}) {
  final width = MediaQuery.of(context).size.width;
  return Text(
    text,
    style: GoogleFonts.spaceMono(
      fontSize: width * 0.05,
      color: C.textPrimary,
      fontWeight: FontWeight.w600,
    ),
  );
}
Widget sectionSubHeading({
  required BuildContext context,
  required String text,
}) {
  final width = MediaQuery.of(context).size.width;
  return Text(
    text,
    style: GoogleFonts.spaceMono(
      fontSize: width * 0.028,
      color: C.textPrimary,
    ),
  );
}
Widget spacer(){
  return Container(
    height: 1,
    margin: EdgeInsets.symmetric(vertical: 20),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.transparent, C.green, Colors.transparent],
      ),
    ),
  );
}
