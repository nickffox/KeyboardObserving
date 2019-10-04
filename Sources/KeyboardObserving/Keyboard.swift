//
//  Keyboard.swift
//
//  Created by Nicholas Fox on 8/16/19.
//

import Foundation
import UIKit
import Combine

/// An object representing the keyboard
public final class Keyboard: ObservableObject {

  // MARK: - Published Properties

  @Published public var state: Keyboard.State = .default

  // MARK: - Private Properties

  private var cancellables: Set<AnyCancellable> = []
  private var notificationCenter: NotificationCenter

  // MARK: - Initializers

  public init(notificationCenter: NotificationCenter = .default) {
    self.notificationCenter = notificationCenter

    // Observe keyboard notifications and transform them into state updates
    notificationCenter.publisher(for: UIResponder.keyboardWillChangeFrameNotification)
      .compactMap(Keyboard.State.from(notification:))
      .assign(to: \.state, on: self)
      .store(in: &cancellables)
  }

  deinit {
    cancellables.forEach { $0.cancel() }
  }
}

// MARK: - Nested Types
extension Keyboard {

  public struct State {

    // MARK: - Properties

    public let animationDuration: TimeInterval
    public let height: CGFloat

    // MARK: - Initializers

    init(animationDuration: TimeInterval, height: CGFloat) {
      self.animationDuration = animationDuration
      self.height = height
    }

    // MARK: - Static Properties

    fileprivate static let `default` = Keyboard.State(animationDuration: 0.25, height: 0)

    // MARK: - Static Methods

    static func from(notification: Notification) -> Keyboard.State? {
      return from(
        notification: notification,
        screen: .main
      )
    }

    // NOTE: A testable version of the transform that injects the dependencies.
    static func from(
      notification: Notification,
      screen: UIScreen
    ) -> Keyboard.State? {
      guard let userInfo = notification.userInfo else { return nil }
      // NOTE: We could eventually get the aniamtion curve here too.
      // Get the duration of the keyboard animation
      let animationDuration =
        (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
        ?? 0.25

      // Get keyboard height
      var height: CGFloat = 0
      if let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
        // If the rectangle is at the bottom of the screen, set the height to 0.
        if keyboardFrame.origin.y == screen.bounds.height {
          height = 0
        } else {
          height = keyboardFrame.height
        }
      }

      return Keyboard.State(
        animationDuration: animationDuration,
        height: height
      )
    }
  }
}

