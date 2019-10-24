//
//  File.swift
//  
//
//  Created by Joseph A. Wardell on 10/24/19.
//

import SwiftUI

public struct HiddenWhenKeyboardVisibleView<Content: View>: View {

  @EnvironmentObject var keyboard: Keyboard

  let content: Content

  public init(@ViewBuilder builder: () -> Content) {
    self.content = builder()
  }

  public var body: some View {
  
  #if targetEnvironment(macCatalyst)
  return content
  #else

    return content
        .opacity(keyboard.state.height == 0 ? 1.0 : 0.0)
        .animation(.easeOut(duration: keyboard.state.animationDuration))
  #endif
  }
}
