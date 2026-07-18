/// AUTO-GENERATED FILE, DO NOT MODIFY
var titleList = ['Basic Cannon','Random Direction','Fireworks','Stars','Emoji','Snow','School Pride','Launch','Not Full Screen'];
var codeList = ['''
Confetti.launch(
  context,
  options: const ConfettiOptions(
      particleCount: 100, spread: 70, y: 0.6),
);

''','''
double randomInRange(double min, double max) {
  return min + Random().nextDouble() * (max - min);
}

Confetti.launch(
  context,
  options: ConfettiOptions(
      angle: randomInRange(55, 125),
      spread: randomInRange(50, 70),
      particleCount: randomInRange(50, 100).toInt(),
      y: 0.6),
);

''','''
double randomInRange(double min, double max) {
  return min + Random().nextDouble() * (max - min);
}

int total = 60;
int progress = 0;

Timer.periodic(const Duration(milliseconds: 250), (timer) {
  progress++;

  if (progress >= total) {
    timer.cancel();
    return;
  }

  int count = ((1 - progress / total) * 50).toInt();

  Confetti.launch(
    context,
    options: ConfettiOptions(
        particleCount: count,
        startVelocity: 30,
        spread: 360,
        ticks: 60,
        x: randomInRange(0.1, 0.3),
        y: Random().nextDouble() - 0.2),
  );
  Confetti.launch(
    context,
    options: ConfettiOptions(
        particleCount: count,
        startVelocity: 30,
        spread: 360,
        ticks: 60,
        x: randomInRange(0.7, 0.9),
        y: Random().nextDouble() - 0.2),
  );
});

''','''

const options = ConfettiOptions(
    spread: 360,
    ticks: 50,
    gravity: 0,
    decay: 0.94,
    startVelocity: 30,
    colors: [
      Color(0xffFFE400),
      Color(0xffFFBD00),
      Color(0xffE89400),
      Color(0xffFFCA6C),
      Color(0xffFDFFB8)
    ]);

shoot() {
  Confetti.launch(context,
      options:
          options.copyWith(particleCount: 40, scalar: 1.2),
      particleBuilder: (index) => Star());
  Confetti.launch(context,
      options: options.copyWith(
        particleCount: 10,
        scalar: 0.75,
      ),
      particleBuilder: (index) => Star());
}

Timer(Duration.zero, shoot);
Timer(const Duration(milliseconds: 100), shoot);
Timer(const Duration(milliseconds: 200), shoot);

''','''

const options = ConfettiOptions(
  spread: 360,
  ticks: 50,
  gravity: 0,
  decay: 0.94,
  startVelocity: 30,
);

shoot() {
  Confetti.launch(context,
      options: options.copyWith(
        particleCount: 40,
      ),
      particleBuilder: (index) => Emoji(
          emoji: '🍄',
          textStyle: GoogleFonts.notoColorEmoji()));
  Confetti.launch(context,
      options: options.copyWith(
        particleCount: 10,
      ),
      particleBuilder: (index) => Emoji(
            emoji: '️⚽',
            textStyle: GoogleFonts.notoColorEmoji(),
          ));
}

Timer(Duration.zero, shoot);
Timer(const Duration(milliseconds: 200), shoot);
Timer(const Duration(milliseconds: 400), shoot);

''','''

const colors = [
  Color(0xFFFFFFFF),
  Color(0xFFE8F1FF),
  Color(0xFFBFD7FF),
];

// ~12 seconds of snowfall.
int total = 120;
int progress = 0;

ConfettiController? controller;
bool isDone = false;

Timer.periodic(const Duration(milliseconds: 100), (timer) {
  progress++;

  if (progress >= total) {
    timer.cancel();
    isDone = true;
    return;
  }

  if (controller == null) {
    controller = Confetti.launch(
      context,
      options: const ConfettiOptions(
        particleCount: 2,
        // No launch speed — gravity alone pulls them down.
        startVelocity: 0,
        spread: 360,
        ticks: 1000,
        gravity: 0.4,
        driftVariance: 0.6,
        scalar: 0.7,
        y: -0.05,
        randomX: true,
        colors: colors,
      ),
      particleBuilder: (index) => Snowflake(),
      onFinished: (overlayEntry) {
        if (isDone) {
          overlayEntry.remove();
        }
      },
    );
  } else {
    controller!.launch();
  }
});

''','''

const colors = [
  Color(0xffbb0000),
  Color(0xffffffff),
];

int frameTime = 1000 ~/ 24;
int total = 15 * 1000 ~/ frameTime;
int progress = 0;

ConfettiController? controller1;
ConfettiController? controller2;
bool isDone = false;

Timer.periodic(Duration(milliseconds: frameTime), (timer) {
  progress++;

  if (progress >= total) {
    timer.cancel();
    isDone = true;
    return;
  }
  if (controller1 == null) {
    controller1 = Confetti.launch(
      context,
      options: const ConfettiOptions(
          particleCount: 2,
          angle: 60,
          spread: 55,
          x: 0,
          colors: colors),
      onFinished: (overlayEntry) {
        if (isDone) {
          overlayEntry.remove();
        }
      },
    );
  } else {
    controller1!.launch();
  }

  if (controller2 == null) {
    controller2 = Confetti.launch(
      context,
      options: const ConfettiOptions(
          particleCount: 2,
          angle: 120,
          spread: 55,
          x: 1,
          colors: colors),
      onFinished: (overlayEntry) {
        if (isDone) {
          overlayEntry.remove();
        }
      },
    );
  } else {
    controller2!.launch();
  }
});

''','''

final controller = Confetti.launch(
  context,
  options: const ConfettiOptions(
      particleCount: 100, spread: 70, y: 0.6),
);

/// call the kill method to kill the confetti
/// controller.kill();

''','''
controller.launch();

// Wrap the Confetti widget in a Container.
// Container(
//   child: ClipPath(
//     child: Confetti(
//       controller: controller,
//       options: const ConfettiOptions(
//           particleCount: 100, spread: 70, y: 1),
//     ),
//   ),
// );

'''];

getCodeByTitle(title) {
final index = titleList.indexOf(title);
if (index == -1) {
  return null;
}
  return codeList[index];
}
