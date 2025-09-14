import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  final String _username = dotenv.env['SMTP_USERNAME']!;
  final String _password = dotenv.env['SMTP_PASSWORD']!;
  final String _host = dotenv.env['SMTP_HOST']!;
  final int _port = int.parse(dotenv.env['SMTP_PORT']!);

  Future<Map<String, dynamic>> sendEmail(String recipient, String subject, String body) async {
    final smtpServer = SmtpServer(
      _host,
      port: _port,
      username: _username,
      password: _password,
    );

    final message = Message()
      ..from = Address(_username, 'Laptop Harbour')
      ..recipients.add(recipient)
      ..subject = subject
      ..html = body;

    try {
      final sendReport = await send(message, smtpServer);
      debugPrint('Message sent: $sendReport');
      return {'success': true};
    } on MailerException catch (e) {
      debugPrint('Message not sent.');
      for (var p in e.problems) {
        debugPrint('Problem: ${p.code}: ${p.msg}');
      }
      return {'success': false, 'error': 'Failed to send email: ${e.message}'};
    } on SocketException catch (e) {
      debugPrint('Socket exception: ${e.message}');
      return {'success': false, 'error': 'Please check your internet connection.'};
    } catch (e) {
      debugPrint('An unexpected error occurred: $e');
      return {'success': false, 'error': 'An unexpected error occurred.'};
    }
  }
}
