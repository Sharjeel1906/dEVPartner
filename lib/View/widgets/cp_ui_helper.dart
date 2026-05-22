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
      const SizedBox(height: 5),
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

Widget buildDropdown({
  required String value,
  required List<String> options,
  required Function(String) onChanged,
  bool forceOpenDownward = false,
}) {
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
        dropdownColor: C.bg,
        isDense: forceOpenDownward,
        menuMaxHeight: forceOpenDownward ? 200 : null,
        alignment: forceOpenDownward
            ? AlignmentDirectional.bottomStart
            : AlignmentDirectional.centerStart,
        icon: Icon(Icons.arrow_drop_down, color: C.textPrimary),
        items: options.map((option) {
          return DropdownMenuItem(
            value: option,
            child: Text(option,style: TextStyle(color: C.textPrimary.withOpacity(0.8)),maxLines: 1,overflow: TextOverflow.visible,),
          );
        }).toList(),
        onChanged: (val) {
          if (val != null) onChanged(val);
        },
      ),
    ),
  );
}
Widget buildLabeledDropdownRow({
  required String label1,
  required String value1,
  required List<String> options1,
  required Function(String) onChanged1,

  required String label2,
  required String value2,
  required List<String> options2,
  required Function(String) onChanged2,

  required double spacing,
}) {
  return Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label1, style: TextStyle(color: C.textLabel)),
            const SizedBox(height: 6),
            buildDropdown(
              value: value1,
              options: options1,
              onChanged: onChanged1,
            ),
          ],
        ),
      ),
      SizedBox(width: spacing),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label2, style: TextStyle(color: C.textLabel)),
            const SizedBox(height: 6),
            buildDropdown(
              value: value2,
              options: options2,
              onChanged: onChanged2,
            ),
          ],
        ),
      ),
    ],
  );
}
Widget buildDropdownRow3({
  required String value1,
  required List<String> options1,
  required Function(String) onChanged1,

  required String value2,
  required List<String> options2,
  required Function(String) onChanged2,

  required String value3,
  required List<String> options3,
  required Function(String) onChanged3,

  required double spacing,
  bool forceOpenDownward = false,
}) {
  return Row(
    children: [
      Expanded(
        child: buildDropdown(
          value: value1,
          options: options1,
          onChanged: onChanged1,
          forceOpenDownward: forceOpenDownward,
        ),
      ),

      SizedBox(width: spacing),

      Expanded(
        child: buildDropdown(
          value: value2,
          options: options2,
          onChanged: onChanged2,
          forceOpenDownward: forceOpenDownward,
        ),
      ),

      SizedBox(width: spacing),

      Expanded(
        child: buildDropdown(
          value: value3,
          options: options3,
          onChanged: onChanged3,
          forceOpenDownward: forceOpenDownward,
        ),
      ),
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

Future<void> customColoredBox(
    BuildContext context,
    String text,
    ) {
  return showDialog(
    context: context,
    barrierColor: Colors.black54,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: C.bg, // ✅ same as screen background
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: C.green,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: C.green.withOpacity(0.15),
              blurRadius: 20,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
                border: Border.all(
                  color: C.green,
                ),
              ),
              child: const Icon(
                Icons.info_outline_rounded,
                color: C.green,
                size: 38,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Information",
              style: GoogleFonts.spaceMono(
                color: C.green, // ✅ green title
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              text,
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                color: C.cyan, // ✅ green text
                fontSize: 15,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: C.green,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "OK",
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Future<bool> showConfirmDeleteDialog(
  BuildContext context, {
  String title = "Confirm Delete",
  String message = "Are you sure you want to delete?",
  String confirmLabel = "Delete",
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierColor: Colors.black54,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: C.bg,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: C.green, width: 1.2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: GoogleFonts.spaceMono(
                color: C.green,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                color: C.cyan,
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: C.cyan,
                      side: const BorderSide(color: C.cyan),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.dmSans(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: C.green,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(
                      confirmLabel,
                      style: GoogleFonts.dmSans(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
  return result == true;
}