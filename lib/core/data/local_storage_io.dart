import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// تطبيق التخزين على المنصات الأصلية (Android / iOS / Windows / macOS / Linux).
///
/// يحفظ البيانات في ملفات نصية حقيقية داخل مجلد مستندات التطبيق
/// (Application Documents Directory)، وهو مجلد آمن ومخصّص للتطبيق.
///
/// كل دالة هنا بسيطة عمداً: قراءة أسطر، إضافة سطر، إعادة كتابة كل الأسطر،
/// ومعرفة مسار الملف. أي تطبيق لقاعدة بيانات مستقبلاً يحتاج فقط يقدّم
/// نفس هذه العمليات (انظر الـ repositories).
class LocalStorage {
  /// يرجّع كائن File يشير إلى ملف باسم [fileName] داخل مجلد مستندات التطبيق.
  static Future<File> _fileFor(String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$fileName');
  }

  /// يقرأ كل الأسطر غير الفارغة من الملف. يرجّع قائمة فارغة لو الملف غير موجود.
  static Future<List<String>> readLines(String fileName) async {
    final file = await _fileFor(fileName);
    if (!await file.exists()) return <String>[];
    final content = await file.readAsString();
    return content
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .toList();
  }

  /// يضيف سطراً جديداً في نهاية الملف (ينشئ الملف لو ما كان موجوداً).
  static Future<void> appendLine(String fileName, String line) async {
    final file = await _fileFor(fileName);
    await file.writeAsString('$line\n', mode: FileMode.append);
  }

  /// يعيد كتابة الملف بالكامل بقائمة الأسطر المعطاة (يُستخدم مثلاً عند التحديث).
  static Future<void> writeLines(String fileName, List<String> lines) async {
    final file = await _fileFor(fileName);
    final content = lines.isEmpty ? '' : '${lines.join('\n')}\n';
    await file.writeAsString(content);
  }

  /// هل الملف موجود؟
  static Future<bool> exists(String fileName) async {
    final file = await _fileFor(fileName);
    return file.exists();
  }

  /// المسار الكامل للملف على الجهاز (مفيد لعرضه للمستخدم أو للتنقيح).
  static Future<String> pathFor(String fileName) async {
    final file = await _fileFor(fileName);
    return file.path;
  }
}
