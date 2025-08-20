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
        print("创建ScreenshotWindowController控制器")
        super.init(window: ScreenshotWindow())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showScreenshot() {
        self.showWindow(nil)
        self.window?.makeKeyAndOrderFront(nil)
    }

    func closeScreenshot() {
        self.close()
    }
    
    override func keyDown(with event: NSEvent) {
        print("WindowController的时间戳：\(event.timestamp)")
        print("event.keyCode:\(event.keyCode)")
        super.keyDown(with: event)
    }
}
