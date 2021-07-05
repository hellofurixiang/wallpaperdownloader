import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallpaperdownloader/common/config/ConstantConfig.dart';

class TelAndSmsService {
  static void call(String number) => launch("tel:$number");

  static void sendSms(String number) => launch("sms:$number");

  static void sendEmail(String email) => launch("mailto:$email");

  static void launchMailto() async {
    final mailtoLink = Mailto(
      to: [ConstantConfig.emailUrl],
      subject: 'Feedback Version - ${ConstantConfig.versionName}',
      body: '',
    );
    await launch('$mailtoLink');
  }
}
