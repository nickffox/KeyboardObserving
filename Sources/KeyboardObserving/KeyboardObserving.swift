//
//  KeyboardObserving.swift
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

import SwiftUI

// MARK: - View

/// A View that adjusts its content based on the keyboard.
///
/// Important: A Keyboard must be available in the Environment.
///
struct KeyboardObservingView<Content: View>: View {

  @EnvironmentObject var keyboard: Keyboard

  let content: Content

  public init(@ViewBuilder builder: () -> Content) {
    self.content = builder()
  }

  public var body: some View {
    // Catalyst apps don't show a keyboard, so we can return the unchanged content.
    #if targetEnvironment(macCatalyst)
    return content
    #else
    return content
        .padding([.bottom], keyboard.state.height)
        .edgesIgnoringSafeArea((keyboard.state.height > 0) ? [.bottom] : [])
        .animation(.easeOut(duration: keyboard.state.animationDuration))
    #endif
  }
}

// MARK: - ViewModifier

struct KeyboardObservingViewModifier: ViewModifier {

  var additionalBottomPadding: CGFloat = 0

  func body(content: Content) -> some View {
    KeyboardObservingView {
      content
    }
    .padding(.bottom, additionalBottomPadding)
  }
}

// MARK: - Convenience View Method

extension View {

  /// Foo
  ///
  /// - Parameter additionalBottomPadding: <#additionalBottomPadding description#>
  /// - Returns: A KeyboardObservingView that wraps the given content.
  public func keyboardObserving(additionalBottomPadding: CGFloat = 0.0) -> some View {
    self.modifier(KeyboardObservingViewModifier(additionalBottomPadding: additionalBottomPadding))
  }
}
