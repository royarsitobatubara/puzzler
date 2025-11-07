import 'package:flutter/material.dart';

class PuzzleScreen extends StatefulWidget {
  const PuzzleScreen({super.key});

  @override
  State<PuzzleScreen> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  final int grid = 3; // 3x3 puzzle
  late List<int> tiles;

  @override
  void initState() {
    super.initState();
    resetPuzzle();
  }

  void resetPuzzle() {
    tiles = List.generate(grid * grid, (index) => index);
    tiles.shuffle();
    setState(() {});
  }

  bool isCompleted() {
    for (int i = 0; i < tiles.length; i++) {
      if (tiles[i] != i) return false;
    }
    return true;
  }

  void onTileTap(int index) {
    int emptyIndex = tiles.indexOf(0);
    if (canMove(index, emptyIndex)) {
      setState(() {
        int temp = tiles[index];
        tiles[index] = tiles[emptyIndex];
        tiles[emptyIndex] = temp;
      });

      if (isCompleted()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Selamat, puzzle beres!")),
        );
      }
    }
  }

  bool canMove(int index, int emptyIndex) {
    int row = index ~/ grid;
    int col = index % grid;
    int emptyRow = emptyIndex ~/ grid;
    int emptyCol = emptyIndex % grid;

    return (row == emptyRow && (col - emptyCol).abs() == 1) ||
        (col == emptyCol && (row - emptyRow).abs() == 1);
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width * 0.9;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sliding Image Puzzle"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            SizedBox(
              width: size,
              height: size,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tiles.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: grid,
                ),
                itemBuilder: (context, index) {
                  int tile = tiles[index];
                  if (tile == 0) return Container(color: Colors.grey.shade800);

                  return GestureDetector(
                    onTap: () => onTileTap(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: const AssetImage("assets/images/logo.webp"),
                          alignment: Alignment(
                            (tile % grid) / (grid - 1) * 2 - 1,
                            (tile ~/ grid) / (grid - 1) * 2 - 1,
                          ),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: resetPuzzle,
              child: const Text("Shuffle"),
            )
          ],
        ),
      ),
    );
  }
}
