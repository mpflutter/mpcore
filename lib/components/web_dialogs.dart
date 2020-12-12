part of '../mpcore.dart';

class MPWebDialogs {
  static Future alert({String message}) {
    return MPAction(
      type: 'web_dialogs',
      params: {'dialogType': 'alert', 'message': message},
    ).send();
  }

  static Future confirm({String message}) {
    return MPAction(
      type: 'web_dialogs',
      params: {'dialogType': 'confirm', 'message': message},
    ).send();
  }

  static Future prompt({String message, String defaultValue}) {
    return MPAction(
      type: 'web_dialogs',
      params: {
        'dialogType': 'prompt',
        'message': message,
        'defaultValue': defaultValue
      },
    ).send();
  }
}
