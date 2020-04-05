//
//  KeyboardObservingView.swift
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
  
  // for some reason, this can cause stuttering
  // in mac catalyst applications
  // and we don't need to observe the keyboard
  // in mac catalist anyway
  // so only return the content in mac catalyst
  // (I think it's the animation, but I'm not sure)
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
