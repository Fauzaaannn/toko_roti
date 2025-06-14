import 'package:flutter/material.dart';
import 'package:toko_roti/ui/widget/buttom_nav.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Started'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Get Started'),
            const SizedBox(height: 20), // spasi antara teks dan tombol
            ElevatedButton(
               onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BottomNavBar()),
                );
              },
              child: const Text('Mulai'),
            ),
          ],
        ),
      ),
    );
  }
}
