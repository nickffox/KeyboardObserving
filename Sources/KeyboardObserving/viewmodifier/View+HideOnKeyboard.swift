//
//  View+HideOnKeyboard.swift
//  
//
//  Created by Matěj Kašpar Jirásek on 25/03/2020.
//

import SwiftUI

extension View {
  /// Automatically hides the view when keyboard is shown.
  /// - Warning: A Keyboard must be available in the Environment.
  /// - Parameter transition: Transition which will be used to hide or show the view during keyboard presentation. By default it animated opacity.
  /// - Returns: A view which is empty if keyboard is visible.
  public func hideOnKeyboard(transition: AnyTransition = .opacity) -> some View {
    self.modifier(HiddenOnKeyboardViewModifier(transition: transition))
  }
}
