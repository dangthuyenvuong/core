import 'dart:math';

String uniqueID({int length = 16}) {
  const String chars =
      "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  Random random = Random();

  String timestamp = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
  String randomStr = List.generate(length - timestamp.length,
      (index) => chars[random.nextInt(chars.length)]).join();

  return timestamp + randomStr;
}



String removeVietnameseDiacritics(String str) {
  const Map<String, String> vietnamese = {
    'à': 'a', 'á': 'a', 'ả': 'a', 'ã': 'a', 'ạ': 'a',
    'ă': 'a', 'ằ': 'a', 'ắ': 'a', 'ẳ': 'a', 'ẵ': 'a', 'ặ': 'a',
    'â': 'a', 'ầ': 'a', 'ấ': 'a', 'ẩ': 'a', 'ẫ': 'a', 'ậ': 'a',
    'è': 'e', 'é': 'e', 'ẻ': 'e', 'ẽ': 'e', 'ẹ': 'e',
    'ê': 'e', 'ề': 'e', 'ế': 'e', 'ể': 'e', 'ễ': 'e', 'ệ': 'e',
    'ì': 'i', 'í': 'i', 'ỉ': 'i', 'ĩ': 'i', 'ị': 'i',
    'ò': 'o', 'ó': 'o', 'ỏ': 'o', 'õ': 'o', 'ọ': 'o',
    'ô': 'o', 'ồ': 'o', 'ố': 'o', 'ổ': 'o', 'ỗ': 'o', 'ộ': 'o',
    'ơ': 'o', 'ờ': 'o', 'ớ': 'o', 'ở': 'o', 'ỡ': 'o', 'ợ': 'o',
    'ù': 'u', 'ú': 'u', 'ủ': 'u', 'ũ': 'u', 'ụ': 'u',
    'ư': 'u', 'ừ': 'u', 'ứ': 'u', 'ử': 'u', 'ữ': 'u', 'ự': 'u',
    'ỳ': 'y', 'ý': 'y', 'ỷ': 'y', 'ỹ': 'y', 'ỵ': 'y',
    'đ': 'd',
    'À': 'A', 'Á': 'A', 'Ả': 'A', 'Ã': 'A', 'Ạ': 'A',
    'Ă': 'A', 'Ằ': 'A', 'Ắ': 'A', 'Ẳ': 'A', 'Ẵ': 'A', 'Ặ': 'A',
    'Â': 'A', 'Ầ': 'A', 'Ấ': 'A', 'Ẩ': 'A', 'Ẫ': 'A', 'Ậ': 'A',
    'È': 'E', 'É': 'E', 'Ẻ': 'E', 'Ẽ': 'E', 'Ẹ': 'E',
    'Ê': 'E', 'Ề': 'E', 'Ế': 'E', 'Ể': 'E', 'Ễ': 'E', 'Ệ': 'E',
    'Ì': 'I', 'Í': 'I', 'Ỉ': 'I', 'Ĩ': 'I', 'Ị': 'I',
    'Ò': 'O', 'Ó': 'O', 'Ỏ': 'O', 'Õ': 'O', 'Ọ': 'O',
    'Ô': 'O', 'Ồ': 'O', 'Ố': 'O', 'Ổ': 'O', 'Ỗ': 'O', 'Ộ': 'O',
    'Ơ': 'O', 'Ờ': 'O', 'Ớ': 'O', 'Ở': 'O', 'Ỡ': 'O', 'Ợ': 'O',
    'Ù': 'U', 'Ú': 'U', 'Ủ': 'U', 'Ũ': 'U', 'Ụ': 'U',
    'Ư': 'U', 'Ừ': 'U', 'Ứ': 'U', 'Ử': 'U', 'Ữ': 'U', 'Ự': 'U',
    'Ỳ': 'Y', 'Ý': 'Y', 'Ỷ': 'Y', 'Ỹ': 'Y', 'Ỵ': 'Y',
    'Đ': 'D',
  };

  return str.split('').map((char) => vietnamese[char] ?? char).join('');
}



// String hightlight(String text, String query) {
//   final keywords = query.split(' ');
//   var newText = text;
//   for (var keyword in keywords) {
//     // Loại bỏ dấu để so sánh
//     String normalizedKeyword = removeVietnameseDiacritics(keyword).toLowerCase();

//     // Tạo regex không phân biệt hoa/thường và có dấu/không dấu
//     RegExp regex = RegExp(
//       r'(?<!\w)(' + keyword + r'|' + normalizedKeyword + r')(?!\w)',
//       caseSensitive: false, // Không phân biệt hoa/thường
//     );

//     // Thay thế bằng phiên bản bọc <b>...</b>
//     newText = newText.replaceAllMapped(regex, (match) => "<b>${match[0]}</b>");
//   }
//   return newText;
// }



String highlight(String text, String query) {
  String normalizedText = removeVietnameseDiacritics(text).toLowerCase();
  String normalizedQuery = removeVietnameseDiacritics(query).toLowerCase();

  List<String> keywords = normalizedQuery.split(' ');

  Map<int, int> highlightPositions = {}; // Lưu vị trí cần bôi đậm

  for (var keyword in keywords) {
    int index = 0;
    while ((index = normalizedText.indexOf(keyword, index)) != -1) {
      highlightPositions[index] = keyword.length;
      index += keyword.length;
    }
  }

  // Highlight từ gốc dựa vào vị trí trong text
  StringBuffer result = StringBuffer();
  int lastIndex = 0;

  highlightPositions.entries.toList()
    ..sort((a, b) => a.key.compareTo(b.key)) // Sắp xếp vị trí theo thứ tự xuất hiện
    ..forEach((entry) {
      int start = entry.key;
      int length = entry.value;

      result.write(text.substring(lastIndex, start)); // Thêm phần trước highlight
      result.write("<b>${text.substring(start, start + length)}</b>"); // Highlight
      lastIndex = start + length;
    });

  result.write(text.substring(lastIndex)); // Thêm phần còn lại

  return result.toString();
}