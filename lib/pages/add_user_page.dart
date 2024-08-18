import 'package:flutter/material.dart';

class AddUserPage extends StatelessWidget {
  final Widget buttonWidget;
  final TextEditingController name;
  final TextEditingController password;
  final VoidCallback onSubmit;
  const AddUserPage(
      {super.key,
      required this.buttonWidget,
      required this.name,
      required this.password,
      required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formstate = GlobalKey<FormState>();
    return Form(
      key: formstate,
      child: AlertDialog(
        title: Text('Add User'),
        actions: [
          TextFormField(
            controller: name,
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value!.isEmpty) {
                return 'يجب ادخال كلمة الاسم';
              }
              return null;
            },
            obscureText: false,
            decoration: InputDecoration(
              labelText: 'الأسم',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: password,
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value!.isEmpty) {
                return 'يجب ادخال كلمة السر';
              }
              return null;
            },
            obscureText: false,
            decoration: InputDecoration(
              labelText: 'كلمة السر',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
          ),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  side: const BorderSide(
                      color: Colors.lightGreenAccent, width: 2.5)),
              onPressed: () async {
                if (formstate.currentState!.validate()) {
                  onSubmit();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                    'جميع الحقول مطلوبة، الأسم مطلوب الأسم لا يجب ان يكون فارغ وكلمة المرور مطلوب كلمة المرور لا يجب ان تكون فارغة .',
                    textDirection: TextDirection.rtl,
                  )));
                }
                // final db = await
              },
              child: buttonWidget,
            ),
          ),
        ],
      ),
    );
  }
}
