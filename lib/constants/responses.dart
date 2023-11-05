import 'dart:math';

import 'package:sms/helpers/time_getter.dart';

String generateResponse(String text) {
  final numbers =
      text.split('').where((char) => RegExp(r'\d').hasMatch(char)).join();
  final time = getCurrentTime1hAhead();
  final isTrolleybus = text.contains('SAB');
  final isTramvay = text.contains('SAC');
  final isAutobus = text.contains('SAA');

  int generateEightDigitNumber() {
    // Generate a random number between 1000000 (inclusive) and 9999999 (inclusive)
    var randomNumber = Random().nextInt(9000000) + 1000000;
    return int.parse('8$randomNumber');
  }

  final int ticketNumber = generateEightDigitNumber();

  if (isTrolleybus) {
    return "Оплата проїзду успішна! \nКод перевірки: №$ticketNumber \nМаршрут №$numbers \nТранспорт: Тролейбус \nМісто: Вінниця \nСумма: 8грн \nДійсній до $time \nКвитанція:https://money.vodafone.ua/get-receipt?i=$ticketNumber&p=380999891843";
  } else if (isTramvay) {
    return "Оплата проїзду успішна! \nКод перевірки: №$ticketNumber \nМаршрут №$numbers \nТранспорт: Трамвай \nМісто: Вінниця \nСумма: 8грн \nДійсній до $time \nКвитанція:https://money.vodafone.ua/get-receipt?i=$ticketNumber&p=380999891843";
  } else if (isAutobus) {
    return "Оплата проїзду успішна! \nКод перевірки: №$ticketNumber \nМаршрут №$numbers \nТранспорт: Автобус \nМісто: Вінниця \nСумма: 12грн \nДійсній до $time \nКвитанція:https://money.vodafone.ua/get-receipt?i=$ticketNumber&p=380999891843";
  }

  return 'Error';
}
