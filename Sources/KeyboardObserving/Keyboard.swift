//
//  Keyboard.swift
//
//  Copyright (c) 2020 Nick Fox
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//


import Combine
import Foundation
import UIKit

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

  /// Object representing the current state of the keyboard.
  public struct State {

    // MARK: - Properties

    /// The duration of time taken to adjust the keyboard.
    public let animationDuration: TimeInterval
    /// The current height of the keyboard.
    public let height: CGFloat
    /// True if the keyboard is currently being shown.
    public var isVisible: Bool { height > 0 }

    // MARK: - Initializers

    private init(
      animationDuration: TimeInterval,
      height: CGFloat
    ) {
      self.animationDuration = animationDuration
      self.height = height
    }

    // MARK: - Static Properties

    fileprivate static let `default` = Keyboard.State(animationDuration: 0.25, height: 0)

    // MARK: - Static Methods

    fileprivate static func from(notification: Notification) -> Keyboard.State? {
      guard let userInfo = notification.userInfo else { return nil }
      // NOTE: We could eventually get the aniamtion curve here too.
      // Get the duration of the keyboard animation
      let rawAnimationDurationValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey]
      let animationDuration = (rawAnimationDurationValue as? NSNumber)?.doubleValue ?? 0.25

      // Get keyboard height
      var height: CGFloat = 0
      if let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
        // If the rectangle is at the bottom of the screen, set the height to 0.
        height = keyboardFrame.origin.y == UIScreen.main.bounds.height ? 0 : keyboardFrame.height
      }

      return Keyboard.State(
        animationDuration: animationDuration,
        height: height)
    }
  }
}
