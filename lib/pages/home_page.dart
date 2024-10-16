import 'package:flutter/material.dart';
import 'package:individual_asessment/pages/member_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFAB886D),
        elevation: 0,
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(
              Icons.menu,
              color: Color.fromARGB(255, 255, 255, 255), // Warna icon menu
            ),
          );
        }),
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFFAB886D),
        child: Column(
          children: [
            // logo
            DrawerHeader(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQj16j2eZUjOKm39fT83fGQ0NsN0ercmEXcZA&s'),
              ),
            ),
            const SizedBox(height: 15),
            const Padding(
              padding: const EdgeInsets.only(left: 15),
              child: ListTile(
                leading: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                title: const Text(
                  'Anggota',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      body: const MemberPage(),
    );
  }
}
