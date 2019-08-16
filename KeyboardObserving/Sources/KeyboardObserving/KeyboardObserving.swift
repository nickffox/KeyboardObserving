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
struct KeyboardObserving<Content: View>: View {

  @EnvironmentObject var keyboard: Keyboard

  let content: Content

  init(@ViewBuilder builder: () -> Content) {
    self.content = builder()
  }

  var body: some View {
    VStack {
      content
      Spacer()
        .frame(height: keyboard.state.height)
    }
    .animation(.easeInOut(duration: keyboard.state.animationDuration))
  }
}
