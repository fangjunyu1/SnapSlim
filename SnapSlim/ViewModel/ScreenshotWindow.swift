//
//  ScreenshotWindow.swift
//  SnapSlim
//
//  Created by 方君宇 on 2025/8/8.
//

import AppKit
import SwiftUI

class ScreenshotWindow: NSWindow {
    init() {
        let hostingView = ScreenshotOverlayView()   // 创建视图
        hostingView.frame = NSScreen.main?.frame ?? .zero
        super.init(
            contentRect: NSScreen.main?.frame ?? .zero,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false)
        self.isOpaque = false
        self.backgroundColor = .clear
        self.level = .screenSaver // 保证在最上层
        self.hasShadow = false
        self.ignoresMouseEvents = false
        self.makeFirstResponder(nil)    // 设置为第一响应者
        self.contentView = hostingView
    }
    
    override var canBecomeKey: Bool {
        return true
    }
    
    override func keyDown(with event: NSEvent) {
        print("keyDown:\(event.keyCode)")
        if event.keyCode == 53 { // ESC
            print("检测到 ESC 键，窗口被关闭")
            if let screenshotWC = self.windowController as? ScreenshotWindowController {
                screenshotWC.closeScreenshotOverlay()
            }
        } else {
            super.keyDown(with: event)
        }
    }
    
    override func rightMouseDown(with event: NSEvent) {
        print("检测到 右 键，窗口被关闭")
        if let screenshotWC = self.windowController as? ScreenshotWindowController {
            screenshotWC.closeScreenshotOverlay()
        }
    }
}
