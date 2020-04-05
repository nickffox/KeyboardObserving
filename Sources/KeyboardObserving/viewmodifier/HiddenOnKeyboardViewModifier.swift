//
//  HiddenOnKeyboardViewModifier.swift
//  
//
//  Created by Matěj Kašpar Jirásek on 25/03/2020.
//

import SwiftUI

struct HiddenOnKeyboardViewModifier: ViewModifier {
  @EnvironmentObject private var keyboard: Keyboard

  let transition: AnyTransition

  func body(content: Content) -> some View {
    Group {
      #if targetEnvironment(macCatalyst)
      content
      #else
      if keyboard.state.height == 0 {
        content
          .transition(transition)
          .animation(.easeOut(duration: keyboard.state.animationDuration))
      } else {
        EmptyView()
      }
      #endif
    }
  }
}
