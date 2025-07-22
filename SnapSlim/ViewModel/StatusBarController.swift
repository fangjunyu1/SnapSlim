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
    
    func getFileURL(folderURL: URL) -> URL {
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
        
        let fileURL = folderURL.appendingPathComponent(fileName).appendingPathExtension("png")
        return fileURL
    }
    // 全屏截图（延时）
    @objc func fullScreenshoot() {
        print("进入全屏截图")
        // 1. 获取主屏幕 ID 和截图
        let mainDisplayID = CGMainDisplayID()
        guard let cgImage = CGDisplayCreateImage(mainDisplayID) else { return }
        
        // 2. 获取屏幕尺寸
        guard let screen = NSScreen.main else { return }
        let screenSize = screen.frame.size
        
        // 3. 创建 NSImage
        let screenImage = NSImage(cgImage: cgImage, size: screenSize)
        
        // 4. 获取鼠标图像和 hotspot（点击热点）
        let cursorImage = NSCursor.current.image
        let cursorImageSize = NSCursor.current.image.size
        let hotSpot = NSCursor.current.hotSpot
        
        // 5. 获取鼠标位置（全局坐标，原点在左下）
        let mouseLocation = NSEvent.mouseLocation
        
        // 6. 合成图像：绘制屏幕 + 鼠标图像
        let finalImage = NSImage(size: screenSize)
        finalImage.lockFocus()
        
        // 绘制屏幕截图
        screenImage.draw(at: .zero, from: .zero, operation: .sourceOver, fraction: 1.0)
        
        // 绘制鼠标图像（考虑 hotspot 偏移）
        let cursorOrigin = NSPoint(x: mouseLocation.x - hotSpot.x,
                                   y: mouseLocation.y - cursorImageSize.height  + hotSpot.x)
        cursorImage.draw(at: cursorOrigin, from: .zero, operation: .sourceOver, fraction: 1.0)
        
        finalImage.unlockFocus()
        
        guard let tiffData = finalImage.tiffRepresentation,
              let bitmapRep = NSBitmapImageRep(data: tiffData) else {return }
        
        // 将数据编码为 PNG 格式的Data
        guard let imageData = bitmapRep.representation(using: .png, properties: [:]) else { return }
        
        if let bookmark = UserDefaults.standard.data(forKey: "SaveFolderBookmark") {
            var isStale = false
            do {
                let url = try URL(resolvingBookmarkData: bookmark, options: [.withSecurityScope], relativeTo: nil, bookmarkDataIsStale: &isStale)
                
                if url.startAccessingSecurityScopedResource() {
                    defer { url.stopAccessingSecurityScopedResource() }
                    
                    let fileURL = getFileURL(folderURL: url)

                    try? imageData.write(to: fileURL)
                } else {
                    print("无法访问资源")
                }
            } catch {
                print("解析书签失败: \(error)")
            }
        } else {
            let panel = NSOpenPanel()
            panel.canChooseDirectories = true
            panel.canChooseFiles = false
            panel.allowsMultipleSelection = false
            let saveDir = NSLocalizedString("Select the save folder", comment: "选择保存文件夹")
            panel.prompt = saveDir
            
            panel.begin { [self] response in
                if response == .OK, let folderURL = panel.url {
                    // 创建安全书签
                    do {
                        let bookmark = try folderURL.bookmarkData(options: [.withSecurityScope], includingResourceValuesForKeys: nil, relativeTo: nil)
                        UserDefaults.standard.set(bookmark, forKey: "SaveFolderBookmark")
                        print("保存文件夹书签成功:\(folderURL)")
                    } catch {
                        print("书签创建失败: \(error)")
                    }
                    
                    let fileURL = getFileURL(folderURL: folderURL)
                    do {
                        try imageData.write(to: fileURL)
                    } catch {
                        print("保存失败")
                    }
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
