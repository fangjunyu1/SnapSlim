//
//  WindowsModifier.swift
//  SnapSlim
//
//  Created by 方君宇 on 2025/7/19.
//

import SwiftUI

struct WindowsModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(20)
            .frame(minWidth: 400, minHeight: 400)
            .frame(maxWidth: 900,maxHeight: 750)
    }
}
