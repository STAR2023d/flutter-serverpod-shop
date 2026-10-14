import 'package:mailer/mailer.dart' as mailer;
import 'package:mailer/smtp_server.dart' as smtp;
import 'package:serverpod/serverpod.dart';

/// Sends an email over SMTP.
/// If SMTP is not configured and we are in development, the email is only
/// logged (so you can read verification codes in the server log).
Future<void> sendEmail(
  Session session, {
  required String to,
  required String subject,
  required String body,
}) async {
  final pod = session.serverpod;

  final host = pod.getPassword('smtpHost');
  final username = pod.getPassword('smtpUsername');
  final password = pod.getPassword('smtpPassword');
  final from = pod.getPassword('smtpFrom');

  final configured =
      host != null && username != null && password != null && from != null;

  if (!configured) {
    if (pod.runMode == 'development') {
      session.log('[Email to $to] $subject: $body');
    } else {
      session.log(
        'SMTP is not configured; email to $to not sent.',
        level: LogLevel.error,
      );
    }
    return;
  }

  final message = mailer.Message()
    ..from = mailer.Address(from, 'Shop')
    ..recipients.add(to)
    ..subject = subject
    ..text = body;

  try {
    await mailer.send(
      message,
      smtp.SmtpServer(host, port: 587, username: username, password: password),
    );
  } catch (e) {
    session.log('Failed to send email to $to: $e', level: LogLevel.error);
  }
}
