import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Membership extends StatefulWidget {
  const Membership({Key key}) : super(key: key);

  @override
  _MembershipState createState() => _MembershipState();
}

class _MembershipState extends State<Membership> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Membership'),
        centerTitle: true,
      ),
      body: DateTime.now().day > 2
          ? Column(
              children: [
                Card(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(12.0),
                    child: const Text('Your membership has expired'),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Renew'),
                ),
              ],
            )
          : Center(
              child: Container(
                padding: const EdgeInsets.all(12.0),
                child: const Text(
                  'Your membership will expire on 2nd of the month',
                ),
              ),
            ),
    );
  }
}
