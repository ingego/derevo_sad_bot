import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';

mixin Commands {
  late TeleDart _td;

  void initCommand(TeleDart td) {
    _td = td;
  }

  void registerCommand() {}

  start(ReplyMarkup? markup) {
    return _td.onCommand('start').listen((event) {
      event.reply(
          '''Добро пожаловать в партнерскую систему Derevosad! Мы ценим вашу роль в продвижении нашего проекта - продажи плодовых саженцев. Мы предлагаем широкий выбор качественных саженцев и готовы поддержать вас инструментами и аналитикой. Вместе мы создадим успешное партнерство, привлечем клиентов и достигнем максимальной прибыли. Спасибо за ваше участие и удачи в работе! Команда Derevosad.''',
          replyMarkup: markup);
    });
  }
}
