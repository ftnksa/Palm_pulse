import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center( // إضافة Center للنص
            child: Text(
              'معلومات عن التطبيق',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center, //
            ),
          ),
          SizedBox(height: 16),
          const Text(
            'مشروع نبض النخيل هو منصة متكاملة تدعم مزارعين النخيل بتوفير ذكاء صناعي مخصص لمعرفة صحة النخلة',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,

          ),
          SizedBox(height: 16),
          const Text(
            'تم انشاء هذا المشروع بالكامل في هاكثون تمور المدينة المنورة بواسطة فريق فطن المكون من سليمان صالح الحصين كمبرمج وصالح حمود الحلوة كامصمم',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset('assets/logo-c-h.png', width: 100, height: 100),
              Image.asset('assets/pmu.png', width: 100, height: 100),
            ],
          ),
        ],
      ),
    );
  }
}
