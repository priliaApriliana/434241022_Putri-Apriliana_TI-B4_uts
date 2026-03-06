import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // 🔑 penting
          children: [

            // =========================
            // CONTAINER 1 (HEADER)
            // =========================
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.blueAccent,
              child: const Text(
                "Welcome to Dashboard",
                style: TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 15),

            // =========================
            // CONTAINER 2 (INFO BOX)
            // =========================
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "Informasi Hari Ini",
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 20),

            // =========================
            // ROW
            // =========================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(Icons.home, size: 40),
                Icon(Icons.person, size: 40),
                Icon(Icons.settings, size: 40),
              ],
            ),

            const SizedBox(height: 20),

            // =========================
            // STACK
            // =========================
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 200,
                  height: 100,
                  color: Colors.green,
                ),
                const Text(
                  "Stack Example",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // =========================
            // GRIDVIEW
            // =========================
            SizedBox(
              height: 200,
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                padding: const EdgeInsets.all(10),
                children: List.generate(4, (index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        "Menu ${index + 1}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 20),

            // =========================
            // LISTVIEW
            // =========================
            SizedBox(
              height: 200,
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text("User 1"),
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text("User 2"),
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text("User 3"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
