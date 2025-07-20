//
//  StatusBarController.swift
//  SnapSlim
//
//  Created by 方君宇 on 2025/7/19.
//

import AppKit
import SwiftUI

class StatusBarController:ObservableObject {
    static let shared = StatusBarController()
    private var statusItem: NSStatusItem?
    
    init() {
        print("进入 StatusBarController 方法")
        // 创建系统菜单栏图标
        statusItem = NSStatusBar.system.statusItem(withLength: 18)
        // 添加菜单栏菜单
        if let status = statusItem {
            if let button = status.button {
                button.image = NSImage(named: "templateIcon")
                button.toolTip = Bundle.main.appName
            }
            
            // 创建菜单
            let menu = NSMenu()
            
            // 截图
            let screenShotTitle = NSLocalizedString("ScreenShot", comment: "截图")
            let screenShotItem = NSMenuItem(title: screenShotTitle, action: #selector(screenshot), keyEquivalent: "o")
            screenShotItem.target = self
            menu.addItem(screenShotItem)
            
            // 插入分割线
            menu.addItem(NSMenuItem.separator())
            
            // 应用信息
            let appInfoTitle = NSLocalizedString("SnapSlim", comment: "应用名称")
            let appInfoItem = NSMenuItem(title: "\(appInfoTitle)",action: nil,keyEquivalent: "")
            menu.addItem(appInfoItem)
            
            // 插入分割线
            menu.addItem(NSMenuItem.separator())
            
            let quitTitle = NSLocalizedString("Quit", comment: "退出应用程序的菜单项标题")
            let quitItem = NSMenuItem(title: quitTitle, action: #selector(NSApp.terminate(_:)), keyEquivalent: "q")
            menu.addItem(quitItem)
            
            status.menu = menu
        } else {
            print("没有 statusItem 状态栏")
        }
        
    }
    
//    @objc func openApp() {
//        if let window = WindowManager.shared.mainWindow {
//            window.makeKeyAndOrderFront(nil)
//        } else {
//            print("没有窗口")
//        }
//    }
    
    // 截图方法
    @objc func screenshot() {
        
    }
    
    func removeFromStatusBar() {
        if let item = statusItem {
            NSStatusBar.system.removeStatusItem(item)
            statusItem = nil
        }
    }
}
