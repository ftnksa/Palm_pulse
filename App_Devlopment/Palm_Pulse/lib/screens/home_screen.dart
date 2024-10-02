import 'dart:io';

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:palm_pulse/screens/devices.dart';


//import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';

import 'dart:developer' as devtools;

import 'Setting.dart';
import 'info.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const MyHomePage(),
    const Devices(),
    const InfoPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text('نبض النخيل'),
        ),
        toolbarHeight: 60,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Color(0xff156E5C), // #156E5C
        items: const [
          Icon(Icons.eco),
          Icon(Icons.devices_other),
          Icon(Icons.info),
          Icon(Icons.settings),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}


//tflite


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? filePath;
  String label = '';
  double confidence = 0.0;

  final Map<String, String> diseaseNames = {
    'Palm__Black_Scorch': 'Black Scorch',
    'Palm__Fusarium_Wilt': 'Fusarium Wilt',
    'Palm__Leaf_Spots': 'Leaf Spots',
    'Palm__Magnesium_Deficiency': 'Magnesium Deficiency',
    'Palm__Manganese_Deficiency': 'Manganese Deficiency',
    'Palm__Parlatoria_Blanchardi': 'Parlatoria Blanchardi',
    'Palm__Potassium_Deficiency': 'Potassium Deficiency',
    'Palm__Rachis_Blight': 'Rachis Blight',
  };

  Future<void> _tfLteInit() async {
    String? res = await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
      numThreads: 1,
      isAsset: true,
      useGpuDelegate: false,
    );
  }

  pickImageGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    var imageMap = File(image.path);

    setState(() {
      filePath = imageMap;
    });

    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 2,
      threshold: 0.2,
      asynch: true,
    );

    if (recognitions == null) {
      return;
    }

    setState(() {
      confidence = (recognitions[0]['confidence'] * 100);
      label = recognitions[0]['label'].toString();
    });
  }

  pickImageCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image == null) return;

    var imageMap = File(image.path);

    setState(() {
      filePath = imageMap;
    });

    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 2,
      threshold: 0.2,
      asynch: true,
    );

    if (recognitions == null) {
      return;
    }

    setState(() {
      confidence = (recognitions[0]['confidence'] * 100);
      label = recognitions[0]['label'].toString();
    });
  }

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }

  @override
  void initState() {
    super.initState();
    _tfLteInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center,
          child: const Text("قم بتصوير اوراق النخلة لمعرفة حالتها"),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 12),
              Card(
                elevation: 20,
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                  width: 300,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 18),
                        Container(
                          height: 280,
                          width: 280,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            image: const DecorationImage(
                              image: AssetImage('assets/upload.jpg'),
                            ),
                          ),
                          child: filePath == null
                              ? const Text('')
                              : Image.file(
                            filePath!,
                            fit: BoxFit.fill,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                             // if (label.isNotEmpty)
                               // Text(
                                 // label,
                                 // style: const TextStyle(
                                   // fontSize: 18,
                                   // fontWeight: FontWeight.bold,
                                 // ),
                               // ),
                              const SizedBox(height: 12),
                              if (confidence > 0)
                                Text(
                                  "%الدقة هي ${confidence.toStringAsFixed(0)}",
                                  style: const TextStyle(fontSize: 18),
                                ),
                              const SizedBox(height: 12),
                              if (label != 'Palm__healthy' && label.isNotEmpty)
                                Column(
                                  children: [
                                    Text(
                                      diseaseNames[label]!,
                                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 12),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => TreatmentPage(disease: diseaseNames[label]!),
                                          ),
                                        );
                                      },
                                      child: const Text('معلومات العلاج'),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: pickImageCamera,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  foregroundColor: Colors.black,
                  backgroundColor: Color(0xff156E5C),
                  minimumSize: Size(160, 40),
                ),
                child: const Text("أخذ لقطة"),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: pickImageGallery,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  foregroundColor: Colors.black,
                  backgroundColor: Color(0xff156E5C),
                  minimumSize: Size(160, 40),
                ),
                child: const Text("تصفح الصور"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TreatmentPage extends StatelessWidget {
  final String disease;

  const TreatmentPage({super.key, required this.disease});

  @override
  Widget build(BuildContext context) {
    // تفاصيل العلاج لكل مرض
    final Map<String, String> treatmentDetails = {
      'Black Scorch':
      'Black Scorch – اللفحة السوداء\n'
      'مكافحة المرض والوقاية منه:\n'
          'أهم وسائل الوقاية هو استخدام فسائل سليمة خالية من المرض وتطهير أدوات التقليم '
          'باستمرار أثناء عملية التقليم، وعند ظهور إصابات مبكرة تزال الأوراق المصابة وتحرق '
          'ويرش البستان دوريا للوقاية بفطر نحاسي وآخر جهازي مع إزالة الأشجار المصابة بشدة '
          'وحرقها.',

      'Fusarium Wilt':
      'Fusarium wilt - مرض الذبول الفيوزارمي\n'
      'المكافحة المتكاملة للمرض:\n'
          'هذا المرض من الأمراض الخطيرة التي يصعب مكافحتها في حالة توطنها في منطقة ما، '
          'ولذلك تبذل الجهود لتحديد طبيعة ومسبب الحالات المرضية المشتبه فيها والتي تظهر في '
          'بعض المناطق بالمملكة حتى يمكن اتخاذ الإجراءات المناسبة لمنع انتشاره ومن تلك '
          'الإجراءات ما يلي: حجر زراعي صارم على المزارع التي يظهر بها، إزالة الأشجار '
          'المصابة وحرقها مع عدم زراعة نخيل في مكانها ويمكن زراعة حمضيات، تطهير أدوات '
          'التقليم دوريا، والرش وقائيا بمبيد جهازي متخصص للفيوزاريوم والعناية التامة بصحة '
          'النبات والتسميد والري المتوازن.',

      'Leaf Spots':
      'Leaf Spots - تبقعات الأوراق\n'
      'الوقاية والعلاج لأمراض التبقع:\n'
          'للحد من انتشار أمراض التبقع:\n'
          '1. الاهتمام والرعاية الجيدة بالبستان من حيث الري والتسميد المتوازن وتقليم وإزالة '
          'الأوراق المصابة والمسنة وحرقها بعد جمع المحصول.\n'
          '2. الرش مرتين بينهما 4-3 أسابيع بعد جمع المحصول ومع بداية الربيع بأحد المبيدات '
          'التالية ويفضل تغيير المبيد بين الرشتين: تراي ملتوكس فورت، ريدور.',

      'Magnesium Deficiency':
      'Magnesium Deficiency - نقص المغنسيوم\n'
      'المكافحة العضوية:\n'
          'استخدم المواد التي تحتوي على عنصر الماغنيسيوم مثل الحجر الجيري الطحلبي، الدولوميت أو '
          'الحجر الجيري الماغنيسيومى. استخدام السماد العضوي أو الروث المتحلل أو السماد لتحقيق '
          'التوازن في محتوى عناصر التربة. فهي تحتوي على المواد العضوية والعديد من العناصر '
          'الغذائية التي يتم إطلاقها ببطء في التربة.\n'
          'المكافحة الكيميائية:\n'
          'استخدم أسمدة تحتوي على عنصر الماغنيسيوم.\n'
          'أمثلة: أكسيد الماغنيسيوم، كبريتات الماغنيسيوم. '
          'استشر مستشارك الزراعة لمعرفة أفضل المنتجات والجرعات المناسبة لتربتك ومحصولك.',

      'Manganese Deficiency':
      'Manganese Deficiency - نقص المنجنيز \n'
      'المكافحة العضوية:\n'
          'قم باستخدام السماد العضوي أو المهاد العضوي أو الكومبوست العضوي لتحقيق التوازن بين '
          'محتوى المغذيات ودرجة حموضة التربة. تحتوي هذه الأسمدة على المواد العضوية والتي '
          'تعمل بدورها على زيادة محتوى الدبال للتربة وقدرتها على الاحتفاظ بالماء وتقليل الرقم '
          'الهيدروجيني قليلاً.\n'
          'المكافحة الكيميائية:\n'
          'من المستحسن استخدام برنامج متوازن للأسمدة يتناسب مع درجة حموضة التربة والمحصول '
          'المستهدف. تمتص النباتات المنغنيز كأيون من خلال أوراقها النباتية وكذلك جذورها. '
          'أما الأسمدة الأكثر شيوعا فهي كبريتات المنغنيز. ويمكنك رشها بالبخاخات أو إضافتها '
          'إلى التربة. إذا لم يشكل الرقم الهيدروجيني للتربة مشكلة ولا يوجد منغنيز في التربة، '
          'يمكن استخدام الرش الورقي كعلاج للحصول على المنغنيز في النبات. وتذكر اتباع '
          'الكميات المحددة بعناية واستخدامه بشكل صحيح.',

      'Parlatoria Blanchardi':
      'Parlatoria Blanchardi - حشرة النخيل القشرية البيضاء\n'
      'المكافحة:\n'
          'تكافح بمبيد حشري غير جهازي ديزانيون 1 مل + 1 لتر ماء وترش كل 15 يوم مرة.',

      'Potassium Deficiency':
      'Potassium Deficiency - نقص البوتاسيوم\n'
      'المكافحة العضوية:\n'
          'يمكنك إضافة المواد العضوية على شكل رماد أو نشارة النبات للتربة على الأقل مرة واحدة '
          'في السنة. يحتوي رماد الأخشاب أيضاً على نسبة عالية من البوتاسيوم. إن تجيير التربة '
          'الحمضية يمكن أن يزيد من احتباس البوتاسيوم في بعض أنواع التربة عن طريق تقليل '
          'الترشيح.\n'
          'المكافحة الكيميائية:\n'
          'استخدم أسمدة تحتوي على عنصر البوتاسيوم.\n'
          'أمثلة: نترات البوتاسيوم (KNO3)، كلوريد البوتاسيوم (MOP). '
          'استشر مستشارك الزراعة لمعرفة أفضل المنتجات والجرعات المناسبة لتربتك ومحصولك. '
          'توصيات أخرى:\n'
          'يوصى بعمل اختبار للتربة قبل بداية موسم الزراعة للحصول على أقصى إنتاجية لمحصولك. '
          'من الأفضل تطبيق الأسمدة أثناء إعداد الحقل وعند مرحلة الإزهار. '
          'تمتص المحاصيل البوتاسيوم بكفاءة أعلى عند تسميد التربة مقارنة برش الأوراق.',

      'Rachis Blight':
      'Rachis Blight - لفحة السعفة\n'
      'المكافحة:\n'
          'يجب إزالة السعف المصاب وحرقه خارج المزرعة والرش الوقائي بأحد المبيدات الفعالة '
          'مثل الكربندازيم.'
    };


    return Scaffold(
      appBar: AppBar(
        title: const Text('معلومات العلاج'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            treatmentDetails[disease] ?? 'لا توجد معلومات متاحة.',
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
