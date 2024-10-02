import 'package:flutter/material.dart';
import 'AddDevice.dart';



class Devices extends StatelessWidget {
  const Devices({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              'الأجهزة المساعدة لزراعة',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 16),
          const Text(
            'عفواً لايوجد لديك أجهزة اذا كان لديك أحد الاجهزة الخاصة بنا مثل (جهاز ري النخيل الذكي - جهاز مستشعر تربة النخيل - مستكشف أفة السوسة الحمراء - وغيرها) يمكنك ربط الجهاز من خلال الزر التالي أو طلب جهاز جديد',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () {
                  // الانتقال إلى صفحة إضافة جهاز جديد
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage()),
                  );
                },
                child: Text('ربط جهاز جديد'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // فتح الفورم لطلب جهاز جديد
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('طلب جهاز جديد'),
                        content: SingleChildScrollView(
                          child: Column(
                            children: [
                              TextField(
                                decoration: InputDecoration(labelText: 'الاسم'),
                              ),
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(labelText: 'اختر جهاز'),
                                items: <String>[
                                  'جهاز ري النخيل الذكي',
                                  'جهاز مستشعر تربة النخيل',
                                  'جهاز حصاد التمور وفرزها',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {},
                              ),
                              TextField(
                                decoration: InputDecoration(labelText: 'رقم الجوال'),
                                keyboardType: TextInputType.phone,
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              // إرسال الطلب
                              Navigator.of(context).pop();
                            },
                            child: Text('إرسال'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('طلب جهاز جديد'),
              ),
              SizedBox(height: 16),
            ],
          ),
        ],
      ),
    );
  }
}

