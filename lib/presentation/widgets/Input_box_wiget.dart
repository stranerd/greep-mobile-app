// import 'package:flutter/material.dart';
//
// class InputBoxWidget extends StatelessWidget {
//
//   const InputBoxWidget({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       onChanged: widget.onChanged,
//       controller: editingController,
//       cursorColor: kPrimaryColor,
//       style: Theme.of(context).textTheme.bodyText1,
//       obscureText: widget.isPassword && isObscure,
//       decoration: InputDecoration(
//           suffixIcon: widget.isPassword
//               ? IconButton(
//             icon: Icon(
//                 isObscure ? Icons.visibility : Icons.visibility_off,
//                 color: kBlackColor
//             ),
//             onPressed: toggleObscurity,
//           )
//               : null,
//           filled: true,
//           fillColor: kBorderColor,
//           focusedBorder: InputBorder.none,
//           border: InputBorder.none,
//           enabledBorder: InputBorder.none,
//           errorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(5),
//             borderSide: BorderSide(color: kErrorColor,width: 0.5),
//           )),
//       validator: (val) => widget.validator(val!),
//     )
//     ;
//   }
// }
