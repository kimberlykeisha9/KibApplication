import 'package:flutter/material.dart';

class Await extends StatelessWidget {
  const Await({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text('Confirm Selection', style: Theme.of(context).textTheme.subtitle2),
                    Text('In order to proceed, you need to confirm the following details and make a payment before confirming your request for a worker.', style: Theme.of(context).textTheme.subtitle2),
                  ]
                ),
              ),
            ),
        );
  }
}

class _Searching extends StatelessWidget {
  const _Searching({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(flex: 4),
        Text(
          'Searching for available workers in your area',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle2,
        ),
        const Spacer(flex: 2),
        const Center(child: CircularProgressIndicator()),
        const Spacer(flex: 2),
        Text(
          'This could take some time but please be patient.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        const Spacer(flex: 4),
      ],
    );
  }
}
