import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms of Service"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          children: const [
            Text(
              "- Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque bibendum ac sapien nec lacinia. Integer placerat sollicitudin lectus ac fringilla. Maecenas vestibulum nunc ultrices eleifend scelerisque. Quisque faucibus ex magna, a porta sapien rutrum tincidunt. Suspendisse facilisis nulla ac neque vehicula faucibus ut condimentum nibh. Mauris in arcu nisi. Nam sed viverra orci, quis sodales metus. Vivamus tincidunt lectus nisl, accumsan maximus lorem cursus id. Duis a bibendum ante. Ut accumsan vulputate nibh. Phasellus aliquet molestie odio, ut mollis libero cursus in. Cras eget mi vitae nunc aliquet pellentesque quis id enim.",
            ),
            SizedBox(height: 5),
            Text(
              "- Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque bibendum ac sapien nec lacinia. Integer placerat sollicitudin lectus ac fringilla. Maecenas vestibulum nunc ultrices eleifend scelerisque. Quisque faucibus ex magna, a porta sapien rutrum tincidunt. Suspendisse facilisis nulla ac neque vehicula faucibus ut condimentum nibh. Mauris in arcu nisi. Nam sed viverra orci, quis sodales metus. Vivamus tincidunt lectus nisl, accumsan maximus lorem cursus id. Duis a bibendum ante. Ut accumsan vulputate nibh. Phasellus aliquet molestie odio, ut mollis libero cursus in. Cras eget mi vitae nunc aliquet pellentesque quis id enim.",
            ),
            SizedBox(height: 5),
            Text(
              "- Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque bibendum ac sapien nec lacinia. Integer placerat sollicitudin lectus ac fringilla. Maecenas vestibulum nunc ultrices eleifend scelerisque. Quisque faucibus ex magna, a porta sapien rutrum tincidunt. Suspendisse facilisis nulla ac neque vehicula faucibus ut condimentum nibh. Mauris in arcu nisi. Nam sed viverra orci, quis sodales metus. Vivamus tincidunt lectus nisl, accumsan maximus lorem cursus id. Duis a bibendum ante. Ut accumsan vulputate nibh. Phasellus aliquet molestie odio, ut mollis libero cursus in. Cras eget mi vitae nunc aliquet pellentesque quis id enim.",
            ),
          ],
        ),
      ),
    );
  }
}
