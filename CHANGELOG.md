## 0.7.1

- Smooth out fixed-timestep rendering with interpolation between physics steps, so motion stays fluid on the web and on high refresh rate displays when frame timing doesn't line up with the 60Hz physics tick.

## 0.7.0

- The confetti speed is now frame-rate independent: the physics simulation runs at a fixed 60 ticks per second on every device, so the animation is no longer faster on high refresh rate (e.g. 120Hz) screens.
- Deprecate the `enableCustomScheduler` argument of `Confetti` and `Confetti.launch`. It is no longer needed and has no effect.
- Performance improvements:
  - Finished particles are removed from the internal list, so repeated launches no longer accumulate work.
  - Reuse a shared `Random` instance and per-particle `Paint`/`Path` objects instead of allocating them on every tick.
  - `Emoji` particles with the same emoji, text style and scale now share one rasterized image, and the image is no longer rasterized multiple times while loading.
  - Wrap the confetti canvas in a `RepaintBoundary` to isolate its repaints from the rest of the widget tree.

## 0.6.0

- Fix package analysis issues reported by pub.dev.
- Update the minimum Flutter version to 3.27.0 and migrate color opacity calls to `Color.withValues`.

## 0.5.2

- Change github url. 

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
