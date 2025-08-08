//
//  ScreenshotWindowController.swift
//  SnapSlim
//
//  Created by 方君宇 on 2025/8/8.
//

import AppKit
import SwiftUI

class ScreenshotWindowController: NSWindowController {
    
    init() {
        super.init(window: ScreenshotWindow())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showScreenshotOverlay() {
        self.showWindow(nil)
        self.window?.makeKeyAndOrderFront(nil)
    }

    func closeScreenshotOverlay() {
        self.close()
    }
}
