//
//  WindowManager.swift
//  SnapSlim
//
//  Created by 方君宇 on 2025/7/19.
//

import AppKit
import SwiftUI

class WindowManager:NSWindowController,NSWindowDelegate {
    static let shared = WindowManager()
    
    var mainWindow: NSWindow? = nil
    var TipsAccessibilityWindow: NSWindow? = nil
    
    // 创建窗口
    func createWindow() {
        // 如果当前没有窗口，则创建窗口
        if mainWindow == nil {
            let contentVC = NSHostingController(rootView: ContentView())
            let workspaceVC = NSHostingController(rootView: ContentView())
            
            // 创建 NSSplitViewController 并添加子项
            let splitVC = NSSplitViewController()
            
            // 创建 NSSplitViewItem
            let sidebarItem = NSSplitViewItem(sidebarWithViewController: contentVC)
            sidebarItem.canCollapse = false
            let viewItem = NSSplitViewItem(viewController: workspaceVC)
            
            // 添加到控制器
            splitVC.addSplitViewItem(sidebarItem)
            splitVC.addSplitViewItem(viewItem)
            
            let window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 900, height: 550),
                styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView], // 可以调大小
                backing: .buffered,
                defer: false)
            window.center()
            window.isReleasedWhenClosed = false
            window.contentViewController = splitVC
            window.minSize = NSSize(width: 600, height: 400)
            window.maxSize = NSSize(width: 1200, height: 800)
            window.makeKeyAndOrderFront(nil)
            
            WindowManager.shared.mainWindow = window
            print("window完成初始化")
        }
    }
    
    // 创建引导“辅助功能”窗口
    func createTipsAccessibilityWindow() {
        if TipsAccessibilityWindow == nil {
            let window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 400, height: 200),
                styleMask: [.closable],
                backing: .buffered,
                defer: false
            )
            window.center()
            window.level = .floating
            window.isMovable = true
            window.delegate = self
            
            let hostingController = NSHostingController(rootView: TipsAccessibilityView())
            window.contentViewController = hostingController
            
            window.makeKeyAndOrderFront(nil)
            
            self.TipsAccessibilityWindow = window
            print("window完成初始化")
        }
    }
    
    func windowWillClose(_ notification: Notification) {
        if let window = notification.object as? NSWindow,window == TipsAccessibilityWindow {
            print("当前 TipsAccessibilityWindow 窗口被关闭，清理辅助窗口")
        }
    }
}
