import 'package:intl/intl.dart';

extension ForMatterExtension on double {
  String get currencyPTBR {
    final currencyFormat = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: r'R$', // ou 'R\$'
    );
    return currencyFormat.format(this);
  }
}
