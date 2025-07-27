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
    var monitor: Any?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        // 如果启动 mac 应用后，检测到没有启用辅助功能，弹出提示框
        let isAccessibility = checkAccessibilityPermission()
        if !isAccessibility {
            print("当前没有启用辅助功能，弹出提示框")
            WindowManager.shared.createTipsAccessibilityWindow()
        } else {
            print("当前已启用辅助功能")
        }
        
        // 添加全局监听
        monitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            self?.handleGlobalKeyEvent(event)
        }
        
        // 创建状态栏
        _ = StatusBarController.shared
        
        // 设置为辅助App，无 Dock 图标、无菜单栏（菜单栏可自建）。
        NSApp.setActivationPolicy(.accessory)
        
    }
    
    // 当点击 Dock 栏时触发
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        print("点击Dock栏，显示window")
        if !flag {
            WindowManager.shared.mainWindow?.makeKeyAndOrderFront(nil)
        }
        return true
    }
    
    // 应用即将退出
    func applicationWillTerminate(_ notification: Notification) {
        // 清除监听器
        if let monitor = monitor {
            NSEvent.removeMonitor(monitor)
        }
    }
    
    // 监听NSEvent并进行回调
    func handleGlobalKeyEvent(_ event: NSEvent) {
        let commandPressed = event.modifierFlags.contains(.command)
        let shiftPressed = event.modifierFlags.contains(.shift)
        
        if commandPressed && shiftPressed {
            switch event.keyCode {
            case 0:     // Command + Shift + A
                print("Command + Shift + A 被触发！普通截图")
                StatusBarController.shared.screenshot()
            case 1:
                print("Command + Shift + S 被触发！全屏截图")
                StatusBarController.shared.fullScreenshoot()
            default:
                print("event:\(event.keyCode)")
            }
        }
        if commandPressed && shiftPressed && event.keyCode == 0 {
            print("1、event:\(event.keyCode)")
        }
    }
    
    // 检查“辅助功能”是否开启
    func checkAccessibilityPermission() -> Bool {
        let options = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as String: true] as CFDictionary
        return AXIsProcessTrustedWithOptions(options)
    }
}
