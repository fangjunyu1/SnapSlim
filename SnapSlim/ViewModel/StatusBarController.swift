//
//  StatusBarController.swift
//  SnapSlim
//
//  Created by 方君宇 on 2025/7/19.
//

import AppKit
import SwiftUI
import UniformTypeIdentifiers

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
            
            // 全屏截图
            let fullScreenTitle = NSLocalizedString("Full Screen Screenshot", comment: "全屏截图（延时）")
            let fullScreenItem = NSMenuItem(title: fullScreenTitle, action: #selector(fullScreenshoot), keyEquivalent: "r")
            fullScreenItem.target = self
            menu.addItem(fullScreenItem)
            
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
    
    //        @objc func openApp() {
    //            if let window = WindowManager.shared.mainWindow {
    //                window.makeKeyAndOrderFront(nil)
    //            } else {
    //                print("没有窗口")
    //            }
    //        }
    
    // 截图方法
    @objc func screenshot() {
        print("调用了screenshot截屏方法")
    }
    
    // 全屏截图（延时）
    @objc func fullScreenshoot() {
        print("进入全屏截图")
        if let cgImage = CGDisplayCreateImage(CGMainDisplayID()) {
            print("获取到当前屏幕")
            let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
            
            // 将数据编码为 PNG 格式的Data
            let imageData = bitmapRep.representation(using: .png, properties: [:])
            
            // 文件名称：截屏+当前时间
            let fullScreenTitle = NSLocalizedString("ScreenShot", comment: "截屏")
            let now = Date()
            let calendar = Calendar.current
            let year = calendar.component(.year, from: now)   // 当前年份
            let month = calendar.component(.month, from: now) // 当前月份
            let day = calendar.component(.day, from: now)     // 当前日期
            let hour = calendar.component(.hour, from: now)   // 当前小时
            let minute = calendar.component(.minute, from: now) // 当前分钟
            let second = calendar.component(.second, from: now) // 当前秒
            // 文件名称
            let fileName = "\(fullScreenTitle)\(year)-\(month)-\(day) \(hour).\(minute).\(second)"
            
            print("文件名称为:\(fileName)")
            
            let savePanel = NSSavePanel()
            savePanel.allowedContentTypes = [.png]  // 保存图片的格式
            savePanel.nameFieldStringValue = fileName   // 保存的文件名称
            savePanel.canCreateDirectories = true   // 允许新建文件夹
            savePanel.directoryURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!   // 默认保存路径为桌面
            print("开始调用NSSavePanel")
            
            savePanel.begin { response in
                print("NSSavePanel返回\(response)")
                if response == .OK {
                    if let url = savePanel.url {
                        // 在这里保存文件内容到 url 路径
                        print("返回成功，保存图片文件")
                        try? imageData?.write(to: url)
                    }
                } else {
                    print("返回失败")
                }
            }
        }
    }
    
    func removeFromStatusBar() {
        if let item = statusItem {
            NSStatusBar.system.removeStatusItem(item)
            statusItem = nil
        }
    }
}
