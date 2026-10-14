import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import 'src/generated/serverpod.dart';
import 'src/seed.dart';
import 'src/email_sender.dart';

import 'src/routes/daraja_callback_route.dart';

Future<void> run(List<String> args) async {
  final pod = Serverpod(args);

  pod.initializeAuthServices(
    tokenManagerBuilders: [JwtConfigFromPasswords()],
    identityProviderBuilders: [
      EmailIdpConfigFromPasswords(
        sendRegistrationVerificationCode: _sendRegistrationCode,
        sendPasswordResetVerificationCode: _sendPasswordResetCode,
      ),
    ],
  );

  final callbackToken = pod.getPassword('mpesaCallbackToken');
  if (callbackToken != null && callbackToken.isNotEmpty) {
    pod.webServer.addRoute(
      DarajaCallbackRoute(),
      '/payments/callback/$callbackToken',
    );
  }

  await pod.start();
}

//mailer  to email provider

Future<void> _sendRegistrationCode(
  Session session, {
  required String email,
  required UuidValue accountRequestId,
  required String verificationCode,
  required Transaction? transaction,
}) {
  return sendEmail(
    session,
    to: email,
    subject: 'Your Shop verification code',
    body:
        'Your verification code is $verificationCode. '
        'It expires shortly. If you did not request it, ignore this email.',
  );
}

Future<void> _sendPasswordResetCode(
  Session session, {
  required String email,
  required UuidValue passwordResetRequestId,
  required String verificationCode,
  required Transaction? transaction,
}) {
  return sendEmail(
    session,
    to: email,
    subject: 'Your Shop password reset code',
    body:
        'Your password reset code is $verificationCode. '
        'If you did not request it, ignore this email.',
  );
}
