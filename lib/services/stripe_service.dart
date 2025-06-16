import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food_app/const.dart'; 
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
    try {
      final Dio dio = Dio();

      final body = {
        'amount': amount.toString(),
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      final response = await dio.post(
        'https://api.stripe.com/v1/payment_intents',
        data: body,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            'Authorization': 'Bearer $stripeSecretKey',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      print('✅ Stripe Response: ${response.data}');
      return response.data['client_secret'];
    } on DioException catch (e) {
      if (e.response != null) {
        print('❌ Stripe Error: ${e.response!.data}');
      } else {
        print('❌ Dio Error: $e');
      }
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
