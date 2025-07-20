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
    var cancellables = Set<AnyCancellable>()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        // 创建状态栏
        _ = StatusBarController.shared
        
        // 设置为辅助App，无 Dock 图标、无菜单栏（菜单栏可自建）。
        NSApp.setActivationPolicy(.accessory)
        
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        print("点击Dock栏，显示window")
        if !flag {
            WindowManager.shared.mainWindow?.makeKeyAndOrderFront(nil)
        }
        return true
    }
    
    // 应用即将推出
    func applicationWillTerminate(_ notification: Notification) {
    }
}
