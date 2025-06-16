import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {
  StripeService._();
  static final StripeService instance = StripeService._();

  Future<void> makePaymentInPKR(int pkrAmount) async {
    try {
      double exchangeRate = 0.0035; 
      int usdAmountInCents = (pkrAmount * exchangeRate * 100).toInt();

      if (usdAmountInCents < 50) {
        print(' Amount too small. ₨$pkrAmount converts to less than 50 cents.');
        return;
      }

      print(' Converted ₨$pkrAmount to \$$usdAmountInCents cents');

      String? clientSecret = await createPaymentIntent(usdAmountInCents, 'usd');

      if (clientSecret == null) {
        print(' Failed to create PaymentIntent');
        return;
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Ayan Riaz',
        ),
      );

      await Stripe.instance.presentPaymentSheet();
      print(' Payment completed successfully');
    } catch (e) {
      print(' Error making payment: $e');
    }
  }

Future<String?> createPaymentIntent(int amount, String currency) async {
  final secretKey = dotenv.env['STRIPE_SECRET_KEY'];
  if (secretKey == null || secretKey.isEmpty) {
    throw Exception('Stripe secret key not configured');
  }

  try {
    final response = await Dio().post(
      'https://api.stripe.com/v1/payment_intents',
      options: Options(
        headers: {
          'Authorization': 'Bearer $secretKey', // Use the verified key
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      ),
      data: {
        'amount': amount.toString(),
        'currency': currency,
      },
    );
    return response.data['client_secret'];
  } catch (e) {
    print('❌ Stripe Error: $e');
    return null;
  }
}

  Future<void> processpayment(int amount) async {
    try {
      await makePaymentInPKR(amount);
    } catch (e) {
      print('❌ Error processing payment: $e');
    }
  }
}
