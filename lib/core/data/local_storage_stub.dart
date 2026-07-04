/// تطبيق احتياطي للتخزين يُستخدم على الويب (حيث لا يتوفر dart:io).
///
/// يحفظ البيانات داخل الذاكرة فقط (Map) ضمن الجلسة الحالية، الهدف منه أن
/// يبقى المشروع يترجم ويعمل على كل المنصات بنفس الواجهة. على الموبايل
/// والديسكتوب يُستخدم تلقائياً التطبيق الحقيقي (local_storage_io.dart) الذي
/// يكتب ملفات نصية فعلية.
class LocalStorage {
  static final Map<String, List<String>> _store = {};

  static Future<List<String>> readLines(String fileName) async {
    return List<String>.from(_store[fileName] ?? const <String>[]);
  }

  static Future<void> appendLine(String fileName, String line) async {
    _store.putIfAbsent(fileName, () => <String>[]);
    _store[fileName]!.add(line);
  }

  static Future<void> writeLines(String fileName, List<String> lines) async {
    _store[fileName] = List<String>.from(lines);
  }

  static Future<bool> exists(String fileName) async {
    return _store.containsKey(fileName);
  }

  static Future<String> pathFor(String fileName) async {
    return '(in-memory) $fileName';
  }
}
