import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:forex_conversion/forex_conversion.dart';
import 'package:get/get.dart';
import 'package:homelyvendor/components/api.dart';
import 'package:homelyvendor/components/constants.dart';
import 'package:homelyvendor/components/model.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Membership extends StatefulWidget {
  final VendorModel vendorDetails;
  const Membership({Key key, this.vendorDetails}) : super(key: key);

  @override
  _MembershipState createState() => _MembershipState();
}

class _MembershipState extends State<Membership> {
  Razorpay _razorpay;
  final _allApi = AllApi();

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _openCheckout() async {

    final fx = Forex();
    print("2.99USD in PKR: ${widget.vendorDetails.country}");

    double myPriceInPKR = await fx.getCurrencyConverted("USD",'INR', 2.99);

    print("2.99USD in PKR: ${myPriceInPKR*100}");

    var options = {
      'key': 'rzp_test_ihkYabNRZci5vW',
      'amount': (myPriceInPKR*100).round(),
      'name': 'Homelyy Vendor',
      'description': 'Membership Renewal',
      'prefill': {
        'contact': '',
        'email': widget.vendorDetails.email,
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }

    // launch("https://portal.myfatoorah.com/KWT/le/05068804425629858");


  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    await _allApi.putLastPaymentDate(
      vendorId: widget.vendorDetails.vendorId,
      paymentDate: DateFormat('dd-MM-yyyy').format(
        DateTime.now(),
      ),
    );
    Get.snackbar('Payment Successfull', 'Please Restart your App',backgroundColor: kgreen,colorText: Colors.white,snackPosition: SnackPosition.BOTTOM);
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId, toastLength: Toast.LENGTH_SHORT);

  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName,
        toastLength: Toast.LENGTH_SHORT);
  }

  @override
  Widget build(BuildContext context) {
    var lastPaymentDate =
        DateFormat('dd-MM-yyy').parse(widget.vendorDetails.lastPaymentDate);
    var difference = DateTime.now().difference(lastPaymentDate).inDays;
    print(difference);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Membership')
        ,backgroundColor: kgreen,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
            elevation: 5,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.2,
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: Text(
                  difference < 33
                      ? 'You have paid the membership fee on ${widget.vendorDetails.lastPaymentDate}'
                      : 'Your membership is expired',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          difference > 33 ?
            ElevatedButton(
              onPressed: _openCheckout,
              child: const Text(
                'Renew',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(kgreen),
                shape: MaterialStateProperty.all(
                  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12.0),
                    ),
                  ),
                ),
              ),
            ) : SizedBox()
        ],
      ),
    );
  }
}
