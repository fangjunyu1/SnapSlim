//
//  WindowManager.swift
//  SnapSlim
//
//  Created by 方君宇 on 2025/7/19.
//

import AppKit
import SwiftUI

class WindowManager {
    static let shared = WindowManager()
    var mainWindow: NSWindow? = nil
    
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
}
