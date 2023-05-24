import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';
import 'package:uuid/uuid.dart';
import 'package:weeek_api/core/weeek.dart';
import 'package:weeek_api/models/deal.dart';

mixin Views {
  late TeleDart _td;

  initView(TeleDart td) {
    _td = td;
    handleEvents();
  }

  handleEvents() {
    _td.onCallbackQuery().listen((event) async {
      var data = event.data!;
      switch (data) {
        case "reg":
          {
            var weeek = Weeek.getInstance();
            var funnel = (await weeek.getAllFunnels()).last;
            var status = (await weeek.getAllFunnelsStatus(funnel.id!)).first;

            var ref = await weeek.getDeals(status.id!);
            bool create = true;
            for (var element in ref) {
              if (element.title == event.teledartMessage!.chat.username) {
                create = false;
                break;
              }
            }
            if (create) {
              var split = Uuid().v4().split("");
              var refferal = [split[0], split[1], split[2], split[3]].join();
              await weeek.createDeal(
                  status.id!,
                  Deal(
                      title: event.teledartMessage!.chat.username,
                      description:
                          '''{"referal": "${event.teledartMessage!.chat.username}$refferal","amount": "0","currency": "RUB"}'''));
              _td.sendMessage(
                  event.teledartMessage!.chat.id, "Добро пожаловать!");
            } else {
              _td.sendMessage(
                  event.teledartMessage!.chat.id, "Вы уже в системе");
            }
          }
        case "cash":
          {
            var weeek = Weeek.getInstance();
            var funnel = (await weeek.getAllFunnels()).last;
            var status = (await weeek.getAllFunnelsStatus(funnel.id!)).first;
            var deals = await weeek.getDeals(status.id!);
            for (var element in deals) {
              var desc = element.description
                  .toString()
                  .replaceAll("&quot;", "")
                  .replaceAll("<p >", "")
                  .replaceAll("</p>", "");
              if (element.title == event.teledartMessage!.chat.username) {
                _td.sendMessage(
                    event.teledartMessage!.chat.id, desc.split(",")[1]);
                break;
              }
            }
          }
        case "refferal":
          {
            var weeek = Weeek.getInstance();
            var funnel = (await weeek.getAllFunnels()).last;
            var status = (await weeek.getAllFunnelsStatus(funnel.id!)).first;
            var deals = await weeek.getDeals(status.id!);
            for (var element in deals) {
              var desc = element.description
                  .toString()
                  .replaceAll("&quot;", "")
                  .replaceAll("<p >", "")
                  .replaceAll("</p>", "");
              if (element.title == event.teledartMessage!.chat.username) {
                _td.sendMessage(event.teledartMessage!.chat.id,
                    desc.split(",")[0].replaceAll("{referal: ", ""));
              }
            }
          }
      }
      event.answer(showAlert: false);
    });
  }

  InlineKeyboardMarkup startMarkup() {
    return InlineKeyboardMarkup(inlineKeyboard: [
      [
        InlineKeyboardButton(text: "Зарегистрироваться", callbackData: "reg"),
        InlineKeyboardButton(text: "Проверить счет", callbackData: "cash"),
      ],
      [
        InlineKeyboardButton(
            text: "Получить реферальный код", callbackData: "refferal"),
        InlineKeyboardButton(
            text: "Материалы для фигмы",
            url:
                "https://www.figma.com/file/MiGkjAL7VPM9YsgIZgkFp0/Untitled?type=design&node-id=0%3A1&t=atfbPoBxPbYfKNj7-1"),
      ]
    ]);
  }
}
