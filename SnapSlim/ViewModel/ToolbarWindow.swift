//
//  CommonToolbarWindow.swift
//  SnapSlim
//
//  Created by 方君宇 on 2025/8/3.
//

import AppKit
import SwiftUI

class ToolbarWindow: NSWindow {
    init(rectOrigin rect: CGPoint,rectSize size: CGSize, ViewBuilder: () -> any View) {
        // 先创建内容视图
        let swiftUIView = ViewBuilder()
        let hostingControllerView = NSHostingController(rootView: AnyView(swiftUIView))
        super.init(contentRect: CGRect(origin: rect, size: size), styleMask: .borderless, backing: .buffered, defer: false)
        isOpaque = false    // 是否完全不透明
        backgroundColor = NSColor.clear // 窗口颜色
        level = .floating   // 窗口层级
        contentViewController = hostingControllerView
        isReleasedWhenClosed = false    // 关闭窗口时不释放窗口
        isMovable = true    // 支持用户拖动窗口
        isMovableByWindowBackground = true  // 支持用户拖动背景窗口
        acceptsMouseMovedEvents = true  // 接收鼠标移动
    }
    
    override var canBecomeKey: Bool {
        return true
    }

    override var canBecomeMain: Bool {
        return true
    }
}
