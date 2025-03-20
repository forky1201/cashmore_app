import 'package:flutter/services.dart';

// 휴대폰 번호에 '-' 자동으로 삽입하는 포매터
class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    
    // '-' 추가 규칙 설정
    if (text.length == 3 || text.length == 8) {
      if (oldValue.text.length < newValue.text.length) {
        return TextEditingValue(
          text: '${newValue.text}-',
          selection: TextSelection.collapsed(offset: newValue.selection.end + 1),
        );
      }
    }
    return newValue;
  }
}
