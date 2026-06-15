## 0.5.1

- Fixed [#9](https://github.com/tao-zhi-1992/flutter_confetti/issues/9)

## 0.5.0

- add the `enableCustomScheduler` argument to `Confetti`. If true, the confetti will use a timer to schedule the confetti, it is useful when you want to keep the speed of the confetti constant on every device with different refresh rates.

## 0.4.0

- Fix y position for particles.
- Add the `insertInOverlay` argument to the `Confetti.launch` function. This will be useful when you need to add the confetti OverlayEntry to a custom overlay.

Thanks to [@cosminpahomi](https://github.com/cosminpahomi)

## 0.3.4

- Add the `controller.kill()` method to kill the showing confetti

## 0.3.3

- Improve the render quality of the emoji

## 0.3.2

- Add the emoji shape

## 0.3.1

- Add the triangle shape by [@Imad Eddine](https://github.com/DidoHZ)

## 0.3.0

- the `controller` argument of `Confetti` is required now
- add the `instant` argument to `Confetti`
- `Confetti.launch` will return the controller created from the inner, and has added an argument called `onFinished` that will be invoked as the animation has finished
- Refactor the code, make the render faster a little again

## 0.2.0

- Refactor the code, make the render faster a little again
- Options is not required

## 0.1.1

- Make the render faster a little

## 0.1.0

- Add the square shape
- Fix some spelling issues

## 0.0.1

- 🎉 confetti animation in Flutter
