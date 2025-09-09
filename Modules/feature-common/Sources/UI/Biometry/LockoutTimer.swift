//
//  CountdownTimer.swift
//  feature-common
//
//  Created by Bharat Jagtap on 04/09/25.
//
import Foundation

final class LockoutTimer {
  private var timer: DispatchSourceTimer?
  private let queue = DispatchQueue(label: "lockoutCountdown.timer.queue")

  private(set) var endTimestamp: TimeInterval?

  private var onTick: (@Sendable (String) -> Void)?
  private var onCompletion: (@Sendable () -> Void)?

  /// Start countdown until the given Unix timestamp
  func start(until endTimestamp: TimeInterval,
             onTick: @escaping @Sendable (String) -> Void,
             onCompletion: @escaping @Sendable () -> Void) {
    stop() // clean any existing timer

    self.endTimestamp = endTimestamp
    self.onTick = onTick
    self.onCompletion = onCompletion

    let timer = DispatchSource.makeTimerSource(queue: queue)
    timer.schedule(deadline: .now(), repeating: 1.0)

    timer.setEventHandler { [weak self] in
      guard let self, let end = self.endTimestamp else { return }

      let now = Date().timeIntervalSince1970
      let remaining = Int(end - now)

      if remaining > 0 {
        if let tick = self.onTick {
          let message = formattedTimeString(seconds: remaining)
          DispatchQueue.main.async {
            tick(message)
          }
        }
      } else {
        self.stop()
        if let completion = self.onCompletion {
          DispatchQueue.main.async {
            completion()
          }
        }
      }
    }

    self.timer = timer
    timer.resume()
  }

  /// Stop the timer
  func stop() {
    timer?.cancel()
    timer = nil
    endTimestamp = nil
  }

  func formattedTimeString(seconds: Int) -> String {
    let totalSeconds = Int(seconds)
    if totalSeconds < 60 {
      return LocalizableStringKey.quickPinLockoutCountdownSeconds(totalSeconds).toString
    } else {
      let minutes = totalSeconds / 60
      let seconds = totalSeconds % 60
      return LocalizableStringKey.quickPinLockoutCountdownMinutes([minutes, seconds]).toString
    }
  }
}
