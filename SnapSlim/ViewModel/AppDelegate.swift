//
//  AppDelegate.swift
//  SnapSlim
//
//  Created by 方君宇 on 2025/7/19.
//

import AppKit
import SwiftUI
import Combine

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarController: StatusBarController?
    var cancellables = Set<AnyCancellable>()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
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
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        print("点击Dock栏，显示window")
        if !flag {
            WindowManager.shared.mainWindow?.makeKeyAndOrderFront(nil)
        }
        return true
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        print("应用即将退出，清除状态栏图标")
        statusBarController?.removeFromStatusBar()
        statusBarController = nil
    }
}
