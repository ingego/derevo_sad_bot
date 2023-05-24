import 'package:derevo_sad_bot/bot/bot.dart';
import 'package:weeek_api/core/weeek.dart';

void main(List<String> arguments) async {
  Weeek.init("0b5b510d-4d32-471c-9bec-65c812f45b1c");
  await Bot.init();
  var bot = Bot.getInstanse();
  bot.registerCommand();
}
