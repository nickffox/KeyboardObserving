//
//  Keyboard.swift
//
//  Created by Nicholas Fox on 8/16/19.
//

import SwiftUI

/// A View that adjusts its content based on the keyboard.
///
/// Important: A Keyboard must be available in the Environment.
///
public struct KeyboardObservingView<Content: View>: View {

  @EnvironmentObject var keyboard: Keyboard

  let content: Content

  public init(@ViewBuilder builder: () -> Content) {
    self.content = builder()
  }

  public var body: some View {
      content
        .padding([.bottom], keyboard.state.height)
        .animation(.easeOut(duration: keyboard.state.animationDuration))
  }
}
