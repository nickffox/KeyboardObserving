//
//  View+KeyboardObserving.swift
//
//  Created by Nicholas Fox on 10/4/19.
//

import SwiftUI


extension View {
  public func keyboardObserving(padding: CGFloat = 8) -> some View {
    self.modifier(KeyboardObserving(padding: padding))
  }
}
