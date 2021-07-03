import 'package:flutter/material.dart';
import 'package:stripe_payment/stripe_payment.dart';

class Payment extends StatefulWidget {
  @override
  PaymentState createState() => PaymentState();
}

class PaymentState extends State<Payment> {
  Source card;
  var cardPayment;
  Token paymentToken;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StripePayment.setOptions(
      StripeOptions(
          publishableKey:
              'pk_test_51J5pgUSCwJ2aVJIWd3B5gzbqgZ7c2UXzen9dos81TGM2dhTvoKE36Kms6T47nG1BNVEaXM9x00XBul0PuH5toIpA00S06Dm3VO'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stripe Payment')),
      body: Column(
        children: [
          Row(
            children: [
              Text('Normal Payout : '),
              IconButton(icon: Icon(Icons.payment), onPressed: paymentMode),
            ],
          ),
          Row(
            children: [
              Text('Payout with card : '),
              IconButton(icon: Icon(Icons.payment), onPressed: paymentWithCard),
            ],
          ),
          Row(
            children: [
              Text(
                'Create Token with card : ',
                style: TextStyle(color: Colors.red),
              ),
              IconButton(
                icon: Icon(Icons.payment),
                onPressed: paymentWithCreatedTokenCard,
              ),
            ],
          ),
          Row(
            children: [
              Text('Payment method with card : '),
              IconButton(
                icon: Icon(Icons.payment),
                onPressed: paymentMethodWithCard,
              ),
            ],
          ),
        ],
      ),
    );
  }

  paymentMode() {
    print('--><><Normal Payment><><-');
    try {
      StripePayment.createSourceWithParams(
        SourceParams(
          amount: 1,
          currency: 'INR',
          returnURL: 'example://stripe-redirect',
          type: 'ideal',
          name: 'Test',
          statementDescriptor: 'Testing for Stripe Payment',
          email: 'test@gmail.com',
          country: 'India',
        ),
      ).then((value) {
        print('Card value --> ${value.status}');
        card = value;
      });
    } catch (e) {
      print('Error --> $e');
    }
  }

  paymentWithCard() {
    print('--><><Payment With card><><-');
    try {
      StripePayment.paymentRequestWithCardForm(
        CardFormPaymentRequest(
          prefilledInformation: PrefilledInformation(
            billingAddress: BillingAddress(
              city: 'Surat',
              country: 'India',
              line1: 'Address Line no : 1',
              line2: 'Address Line no : 2',
              name: 'Test by Sagar',
              postalCode: '395006',
              state: 'Gujarat',
            ),
          ),
          requiredBillingAddressFields: 'state',
        ),
      ).then((value) {
        print('paymentWithCard --> ${value.toJson()}');
      });
    } catch (e) {
      print('Error --> $e');
    }
  }

  paymentWithCreatedTokenCard() {
    print('--><><Payment With created token card><><-');
    try {
      StripePayment.createTokenWithCard(
        CreditCard(
          number: '4111111111111111',
          expMonth: 10,
          expYear: 25,
        ),
      ).then((value) {
        print('Payment token --> ${value.toJson()}');
        paymentToken = value;
        print('Payment token --> $paymentToken');
      });
    } catch (e) {
      print('Error --> $e');
    }
  }

  paymentMethodWithCard() {
    print('--><><Payment method With card><><-');
    try {
      StripePayment.createPaymentMethod(
        PaymentMethodRequest(
          billingAddress: BillingAddress(
            city: 'Surat',
            country: 'India',
            line1: 'Address Line no : 1',
            line2: 'Address Line no : 2',
            name: 'Test by Sagar',
            postalCode: '395006',
            state: 'Gujarat',
          ),
          card: CreditCard(
              number: '4111111111111111',
              expMonth: 10,
              expYear: 25,
              country: 'India'),
        ),
      ).then((value) {
        print('Payment token --> ${value.toJson()}');
      });
    } catch (e) {
      print('Error --> $e');
    }
  }
}
