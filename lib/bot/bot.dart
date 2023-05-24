import 'package:derevo_sad_bot/bot/logic.dart';
import 'package:derevo_sad_bot/bot/view.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';

late TeleDart _tdInit;
const _botToken = "6204436052:AAFjc_rfFmi5R8ieIXhfV_8VMH-NbEm0iKA";

final class Bot with Commands, Views {
  final TeleDart _td;
  Bot._(this._td) {
    initCommand(_td);
    initView(_td);
  }

  @override
  void registerCommand() {
    start(startMarkup());
    super.registerCommand();
  }

  static Future init() async {
    Telegram tm = Telegram(_botToken);
    var me = await tm.getMe();
    var td = TeleDart(_botToken, Event(me.username!));
    _tdInit = td;
    td.start();
  }

  static Bot getInstanse() {
    return Bot._(_tdInit);
  }
}
