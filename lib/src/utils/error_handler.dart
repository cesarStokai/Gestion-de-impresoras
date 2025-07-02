import 'package:flutter/material.dart';

class ErrorHandler {
  
  static void showError(BuildContext context, String message) {
    print('Error: $message');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }


  static void showSuccess(BuildContext context, String message) {
    print('Éxito: $message');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  static void handleException(BuildContext context, Object e) {
    showError(context, 'Ocurrió un error: ${e.toString()}');
  }


  static void logError(String error) {
    print('Error: $error');
  }


  static void showErrorGlobal(String error) {
    print('Error global: $error');
    // Aquí podrías agregar lógica para logs remotos o archivos si lo deseas.
  }


  static void showSuccessGlobal(String message) {
    print('Éxito: $message');
    // Aquí podrías agregar lógica para logs remotos o archivos si lo deseas.
  }
}
