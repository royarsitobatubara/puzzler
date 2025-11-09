import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';

import 'package:image/image.dart' as image;
import 'package:puzzlers/helpers/app_images.dart';

// Make stateful widget for testing
class PuzzleScreen extends StatefulWidget {
  final String level;
  final int size;
  const PuzzleScreen({super.key, required this.level, required this.size});

  @override
  State<PuzzleScreen> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  int? valueSlider;
  final GlobalKey<_SlidePuzzleWidgetState> globalKey = GlobalKey();
  final imgPuzzle = AppImages.puzzleList[Random().nextInt(AppImages.puzzleList.length)];
  @override
  Widget build(BuildContext context) {
    String level = widget.level;
    valueSlider = widget.size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
            onTap: () {
              if (Navigator.of(context).canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .2),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: Colors.white.withValues(alpha: .3),
              width: 2,
            ),
          ),
          child: Image.asset(
            AppImages.arrowLeft,
            width: 34,
            height: 34,
          ),
        ),),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .9),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            "Puzzle ${valueSlider}x$valueSlider",
            style: const TextStyle(
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .9),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.deepPurple),
              onPressed: () => globalKey.currentState?.generatePuzzle(),
            ),
          )
        ],
      ),
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AppImages.background),
                fit: BoxFit.cover
            )
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          double maxWidth = MediaQuery.of(context).size.width - 40;
                          double size = maxWidth > 400 ? 400 : maxWidth;

                          return SizedBox(
                            width: size,
                            child: SlidePuzzleWidget(
                              key: globalKey,
                              size: Size(size, size),
                              sizePuzzle: valueSlider!,
                              imageBckGround: Image(
                                image: AssetImage(imgPuzzle),
                              ),
                              level: level,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Stateful widget
class SlidePuzzleWidget extends StatefulWidget {
  final Size size;
  final double innerPadding;
  final Image? imageBckGround;
  final int sizePuzzle;
  final String level;

  const SlidePuzzleWidget({
    super.key,
    required this.size,
    this.innerPadding = 5,
    required this.sizePuzzle,
    required this.imageBckGround,
    required this.level
  });

  @override
  State<SlidePuzzleWidget> createState() => _SlidePuzzleWidgetState();
}

class _SlidePuzzleWidgetState extends State<SlidePuzzleWidget> with SingleTickerProviderStateMixin {
  final GlobalKey _globalKey = GlobalKey();
  late Size size;

  List<SlideObject>? slideObjects;
  image.Image? fullImage;
  bool success = false;
  bool startSlide = false;
  List<int> process = [];
  bool finishSwap = false;
  bool isShuffling = false;

  // Timer variables
  Timer? _timer;
  int _remainingSeconds = 120;
  bool _isGameActive = false;
  int _moveCount = 0;

  // Animation controller
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    // Auto-generate puzzle on init
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _remainingSeconds = 120;
    _isGameActive = true;
    _moveCount = 0;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          } else {
            _stopTimer();
            _showTimeUpDialog();
          }
        });
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _isGameActive = false;
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _showTimeUpDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.timer_off, color: Colors.red[700], size: 30),
              const SizedBox(width: 10),
              const Text('Waktu Habis!', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.sentiment_dissatisfied, size: 60, color: Colors.orange[300]),
              const SizedBox(height: 15),
              const Text(
                'Maaf, waktu Anda telah habis.\nSilakan coba lagi!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Gerakan: $_moveCount',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                generatePuzzle();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.green[400],
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Main Lagi', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/home');
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog() {
    _stopTimer();
    int timeUsed = 120 - _remainingSeconds;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.emoji_events, color: Colors.amber, size: 30),
              SizedBox(width: 10),
              Text('🎉 Selamat!', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.celebration, size: 60, color: Colors.purple[300]),
              const SizedBox(height: 15),
              const Text(
                'Anda berhasil menyelesaikan puzzle!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.timer, size: 20, color: Colors.deepPurple),
                        const SizedBox(width: 5),
                        Text(
                          'Waktu: ${_formatTime(timeUsed)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.touch_app, size: 20, color: Colors.deepPurple),
                        const SizedBox(width: 5),
                        Text(
                          'Gerakan: $_moveCount',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                generatePuzzle();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.green[400],
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Main Lagi', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    size = Size(
      widget.size.width - widget.innerPadding * 2,
      widget.size.width - widget.innerPadding,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Timer and Moves Display
        Container(
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _remainingSeconds <= 30
                  ? [Colors.red[400]!, Colors.red[600]!]
                  : [Colors.deepPurple[400]!, Colors.deepPurple[600]!],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  const Icon(Icons.timer, color: Colors.white, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    _formatTime(_remainingSeconds),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                width: 2,
                height: 30,
                color: Colors.white.withValues(alpha: .5),
              ),
              Row(
                children: [
                  const Icon(Icons.touch_app, color: Colors.white, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    '$_moveCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Puzzle Board
        Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(AppImages.papan),
                      fit: BoxFit.cover
                  ),

              ),
              width: widget.size.width,
              height: widget.size.width,
              padding: EdgeInsets.all(widget.innerPadding),
              child: Stack(
                children: [
                  if (widget.imageBckGround != null && slideObjects == null) ...[
                    RepaintBoundary(
                      key: _globalKey,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        height: double.maxFinite,
                        child: widget.imageBckGround,
                      ),
                    )
                  ],
                  if (slideObjects != null)
                    ...slideObjects!
                        .where((slideObject) => slideObject.empty)
                        .map((slideObject) {
                      return Positioned(
                        left: slideObject.posCurrent.dx,
                        top: slideObject.posCurrent.dy,
                        child: SizedBox(
                          width: slideObject.size.width,
                          height: slideObject.size.height,
                          child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: success ? Colors.green[100] : Colors.grey[300]?.withValues(alpha: .3),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: success ? Colors.green : Colors.grey[400]!,
                                width: 2,
                              ),
                            ),
                            child: Stack(
                              children: [
                                if (slideObject.image != null)
                                  Opacity(
                                    opacity: success ? 1 : 0.3,
                                    child: slideObject.image,
                                  )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  if (slideObjects != null)
                    ...slideObjects!
                        .where((slideObject) => !slideObject.empty)
                        .map((slideObject) {
                      return AnimatedPositioned(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        left: slideObject.posCurrent.dx,
                        top: slideObject.posCurrent.dy,
                        child: GestureDetector(
                          onTap: _isGameActive && !isShuffling
                              ? () => changePos(slideObject.indexCurrent)
                              : null,
                          child: SizedBox(
                            width: slideObject.size.width,
                            height: slideObject.size.height,
                            child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.blue[400]!,
                                    Colors.blue[600]!,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: .2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  if (slideObject.image != null)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: slideObject.image!,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  // Shuffling overlay
                  if (isShuffling)
                    Container(
                      color: Colors.black.withValues(alpha: .5),
                      child: const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                            SizedBox(height: 15),
                            Text(
                              'Mengacak Puzzle...',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Action Buttons
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: isShuffling ? null : () => generatePuzzle(),
              icon: const Icon(Icons.shuffle),
              label: const Text('Acak Baru'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[400],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: (startSlide || isShuffling) ? null : () => reversePuzzle(),
              icon: const Icon(Icons.replay),
              label: const Text('Kembalikan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[400],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<image.Image?> _getImageFromWidget() async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));
      RenderRepaintBoundary? boundary =
      _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null) return null;

      size = boundary.size;
      var img = await boundary.toImage();
      var byteData = await img.toByteData(format: ImageByteFormat.png);
      var pngBytes = byteData!.buffer.asUint8List();

      return image.decodeImage(pngBytes);
    } catch (e) {
      return null;
    }
  }

  Future<void> generatePuzzle() async {
    _stopTimer();
    finishSwap = false;
    success = false;
    isShuffling = true;
    _moveCount = 0;
    setState(() {});

    if (widget.imageBckGround != null && fullImage == null) {
      fullImage = await _getImageFromWidget();
    }

    Size sizeBox = Size(
      size.width / widget.sizePuzzle,
      size.width / widget.sizePuzzle,
    );

    slideObjects = List.generate(
      widget.sizePuzzle * widget.sizePuzzle,
          (index) {
        Offset offsetTemp = Offset(
          (index % widget.sizePuzzle) * sizeBox.width,
          (index ~/ widget.sizePuzzle) * sizeBox.height,
        );

        image.Image? tempCrop;
        if (widget.imageBckGround != null && fullImage != null) {
          tempCrop = image.copyCrop(
            fullImage!,
            x: offsetTemp.dx.round(),
            y: offsetTemp.dy.round(),
            width: sizeBox.width.round(),
            height: sizeBox.height.round(),
          );
        }

        return SlideObject(
          posCurrent: offsetTemp,
          posDefault: offsetTemp,
          indexCurrent: index,
          indexDefault: index + 1,
          size: sizeBox,
          image: tempCrop == null
              ? null
              : Image.memory(
            image.encodePng(tempCrop),
            fit: BoxFit.contain,
          ),
        );
      },
    );

    slideObjects!.last.empty = true;

    process = [];

    int totalMoves = widget.sizePuzzle * 30; // Lebih banyak gerakan untuk shuffle lebih baik
    for (var i = 0; i < totalMoves; i++) {
      SlideObject slideObjectEmpty = getEmptyObject();
      int emptyIndex = slideObjectEmpty.indexCurrent;
      process.add(emptyIndex);

      List<int> possibleMoves = [];
      int row = emptyIndex ~/ widget.sizePuzzle;
      int col = emptyIndex % widget.sizePuzzle;

      // Ambil semua gerakan yang valid
      if (col > 0) possibleMoves.add(emptyIndex - 1); // Kiri
      if (col < widget.sizePuzzle - 1) possibleMoves.add(emptyIndex + 1); // Kanan
      if (row > 0) possibleMoves.add(emptyIndex - widget.sizePuzzle); // Atas
      if (row < widget.sizePuzzle - 1) possibleMoves.add(emptyIndex + widget.sizePuzzle); // Bawah

      if (possibleMoves.isNotEmpty) {
        int randKey = possibleMoves[Random().nextInt(possibleMoves.length)];
        changePosWithoutCheck(randKey);
      }

      // Update UI setiap beberapa gerakan
      if (i % 10 == 0) {
        setState(() {});
        await Future.delayed(const Duration(milliseconds: 10));
      }
    }

    startSlide = false;
    finishSwap = true;
    isShuffling = false;
    setState(() {});

    _startTimer();
  }

  SlideObject getEmptyObject() {
    return slideObjects!.firstWhere((element) => element.empty);
  }

  // Change pos tanpa validasi untuk shuffle
  void changePosWithoutCheck(int indexCurrent) {
    if (slideObjects == null) return;

    SlideObject slideObjectEmpty = getEmptyObject();
    int emptyIndex = slideObjectEmpty.indexCurrent;

    int minIndex = min(indexCurrent, emptyIndex);
    int maxIndex = max(indexCurrent, emptyIndex);

    List<SlideObject> rangeMoves = [];

    if (indexCurrent % widget.sizePuzzle == emptyIndex % widget.sizePuzzle) {
      rangeMoves = slideObjects!
          .where((element) =>
      element.indexCurrent % widget.sizePuzzle ==
          indexCurrent % widget.sizePuzzle)
          .toList();
    } else if (indexCurrent ~/ widget.sizePuzzle ==
        emptyIndex ~/ widget.sizePuzzle) {
      rangeMoves = slideObjects!;
    }

    rangeMoves = rangeMoves
        .where((puzzle) =>
    puzzle.indexCurrent >= minIndex &&
        puzzle.indexCurrent <= maxIndex &&
        puzzle.indexCurrent != emptyIndex)
        .toList();

    if (emptyIndex < indexCurrent) {
      rangeMoves.sort((a, b) => a.indexCurrent < b.indexCurrent ? 1 : -1);
    } else {
      rangeMoves.sort((a, b) => a.indexCurrent < b.indexCurrent ? -1 : 1);
    }

    if (rangeMoves.isNotEmpty) {
      int tempIndex = rangeMoves[0].indexCurrent;
      Offset tempPos = rangeMoves[0].posCurrent;

      for (var i = 0; i < rangeMoves.length - 1; i++) {
        rangeMoves[i].indexCurrent = rangeMoves[i + 1].indexCurrent;
        rangeMoves[i].posCurrent = rangeMoves[i + 1].posCurrent;
      }

      rangeMoves.last.indexCurrent = slideObjectEmpty.indexCurrent;
      rangeMoves.last.posCurrent = slideObjectEmpty.posCurrent;

      slideObjectEmpty.indexCurrent = tempIndex;
      slideObjectEmpty.posCurrent = tempPos;
    }
  }

  void changePos(int indexCurrent) {
    if (slideObjects == null || !_isGameActive || isShuffling) return;

    SlideObject slideObjectEmpty = getEmptyObject();
    int emptyIndex = slideObjectEmpty.indexCurrent;

    int minIndex = min(indexCurrent, emptyIndex);
    int maxIndex = max(indexCurrent, emptyIndex);

    List<SlideObject> rangeMoves = [];

    if (indexCurrent % widget.sizePuzzle == emptyIndex % widget.sizePuzzle) {
      rangeMoves = slideObjects!
          .where((element) =>
      element.indexCurrent % widget.sizePuzzle ==
          indexCurrent % widget.sizePuzzle)
          .toList();
    } else if (indexCurrent ~/ widget.sizePuzzle ==
        emptyIndex ~/ widget.sizePuzzle) {
      rangeMoves = slideObjects!;
    }

    rangeMoves = rangeMoves
        .where((puzzle) =>
    puzzle.indexCurrent >= minIndex &&
        puzzle.indexCurrent <= maxIndex &&
        puzzle.indexCurrent != emptyIndex)
        .toList();

    if (emptyIndex < indexCurrent) {
      rangeMoves.sort((a, b) => a.indexCurrent < b.indexCurrent ? 1 : -1);
    } else {
      rangeMoves.sort((a, b) => a.indexCurrent < b.indexCurrent ? -1 : 1);
    }

    if (rangeMoves.isNotEmpty) {
      _moveCount++; // Tambah counter gerakan

      int tempIndex = rangeMoves[0].indexCurrent;
      Offset tempPos = rangeMoves[0].posCurrent;

      for (var i = 0; i < rangeMoves.length - 1; i++) {
        rangeMoves[i].indexCurrent = rangeMoves[i + 1].indexCurrent;
        rangeMoves[i].posCurrent = rangeMoves[i + 1].posCurrent;
      }

      rangeMoves.last.indexCurrent = slideObjectEmpty.indexCurrent;
      rangeMoves.last.posCurrent = slideObjectEmpty.posCurrent;

      slideObjectEmpty.indexCurrent = tempIndex;
      slideObjectEmpty.posCurrent = tempPos;
    }

    // <=================================== ini jika berhasil =====================>
    if (slideObjects!
        .where((slideObject) =>
    slideObject.indexCurrent == slideObject.indexDefault - 1)
        .length ==
        slideObjects!.length &&
        finishSwap) {
      success = true;
      _stopTimer();
      if(!mounted)return;
      context.go('/winner', extra: {
        'level': widget.level,
        'move': _moveCount,
        'timer': _formatTime(120 - _remainingSeconds)
      });
    } else {
      success = false;
    }

    startSlide = true;
    setState(() {});
  }

  void clearPuzzle() {
    _stopTimer();
    setState(() {
      startSlide = true;
      slideObjects = null;
      finishSwap = true;
      success = false;
      _moveCount = 0;
    });
  }

  Future<void> reversePuzzle() async {
    startSlide = true;
    finishSwap = true;
    setState(() {});

    await Stream.fromIterable(process.reversed)
        .asyncMap((event) async =>
    await Future.delayed(const Duration(milliseconds: 50))
        .then((value) => changePosWithoutCheck(event)))
        .toList();

    process = [];
    setState(() {});
  }
}

class SlideObject {
  Offset posDefault;
  Offset posCurrent;
  int indexDefault;
  int indexCurrent;
  bool empty;
  Size size;
  Image? image;

  SlideObject({
    this.empty = false,
    this.image,
    required this.indexCurrent,
    required this.indexDefault,
    required this.posCurrent,
    required this.posDefault,
    required this.size,
  });
}