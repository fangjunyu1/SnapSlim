//
//  ScreenshotOverlayView.swift
//  SnapSlim
//
//  Created by 方君宇 on 2025/7/30.
//

import AppKit
import SwiftUI

class ScreenshotOverlayView: NSView {
    var startPoint: NSPoint?
    var currentPoint: NSPoint?
    var selectionLayer = CAShapeLayer()
    private var toolbarWindow: ToolbarWindow?
    private var resolutionWindow: ResolutionWindow?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        layer?.backgroundColor = NSColor.black.withAlphaComponent(0.2).cgColor
        layer?.mask = selectionLayer
        selectionLayer.fillRule = .evenOdd
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        print("按下鼠标")
        startPoint = event.locationInWindow
        hideToolbar()   // 隐藏工具栏
        hideResolution()    // 隐藏分辨率
    }
    override func mouseDragged(with event: NSEvent) {
        super.mouseDragged(with: event)
        print("移动鼠标")
        currentPoint = event.locationInWindow
        updateSelectionPath()
        hideToolbar()   // 隐藏工具栏
        hideResolution()    // 隐藏分辨率
    }
    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        print("抬起鼠标")
        currentPoint = event.locationInWindow
        showToolbar() // 显示常用工具栏
        showResolution()    // 显示分辨率
    }
    
    override func layout() {
        let path = CGMutablePath()
        path.addRect(bounds)
        selectionLayer.path = path
    }
    
    // 根据用户拖动鼠标的区域计算区域矩形
    func selectedRect() -> CGRect? {
        print("进入selectedRect方法")
        guard let start = startPoint, let end = currentPoint else { return nil }
        let rect = CGRect(
            x: min(start.x, end.x),
            y: min(start.y, end.y),
            width: abs(start.x - end.x),
            height: abs(start.y - end.y))
        return rect
    }
    
    // 更新用户选取的路径
    func updateSelectionPath() {
        guard let rect = selectedRect() else {
            print("无法计算鼠标区域")
            return
        }
        
        let path = CGMutablePath()
        path.addRect(bounds)
        path.addRect(rect)
        selectionLayer.path = path
    }
    
    // 显示常用、存储和步骤工具栏
    func showToolbar() {
        guard let rect = selectedRect(),let window = window else { return }
        // 设置工具栏尺寸
        let toolbarSize = NSSize(width: 650, height: 40)
        // 将视图尺寸转换为窗口尺寸
        let windowOrigin = window.convertToScreen(rect).origin
        // 默认放在区域的底部
        var toolbarOrigin = NSPoint(
            x: windowOrigin.x + rect.width / 2 - toolbarSize.width / 2,
            y: windowOrigin.y - 50
        )
        // 调整菜单栏的上下显示区域
        // 调整菜单栏Y轴位置
        // 如果当前矩形底部区域小于 50，调整菜单栏显示在截图区域的上方
        if rect.minY < 50 {
            toolbarOrigin.y = windowOrigin.y + rect.height
            // 如果菜单栏顶部的留白区域也小于 50，调整菜单栏显示在截图区域的下方，并留出空白位置
            if rect.maxY < 50 {
                toolbarOrigin.y = windowOrigin.y + 100
            }
        }
        let xLeftSpacing = rect.minX
        let xRightSpacing = bounds.width - rect.maxX
        if xLeftSpacing < toolbarSize.width / 2 - rect.width / 2 {
            toolbarOrigin.x = windowOrigin.x - xLeftSpacing
        }
        if xRightSpacing < 300 - rect.width / 2 {
            toolbarOrigin.x = windowOrigin.x + rect.width +  xRightSpacing - toolbarSize.width
        }
        
        print("xLeftSpacing:\(xLeftSpacing),xRightSpacing:\(xRightSpacing),toolbarSize:\(toolbarSize),toolbarOrigin:\(toolbarOrigin),windowOrigin:\(windowOrigin)")
        
        // 如果已经显示则不再重复创建
        guard toolbarWindow == nil else {
            toolbarWindow?.makeKeyAndOrderFront(nil)
            print("当前已经有toolbar不再重复创建")
            return
        }
        
        // 创建工具栏窗口
        let toolbar = ToolbarWindow(rectOrigin: toolbarOrigin, rectSize: toolbarSize) {
            ToolbarView()
        }
        window.addChildWindow(toolbar, ordered: .above)
        toolbarWindow = toolbar
    }
    
    // 显示分辨率窗口
    func showResolution() {
        guard let rect = selectedRect(),let window = window else { return }
        // 设置工具栏尺寸
        let toolbarSize = NSSize(width: 80, height: 24)
        // 将视图尺寸转换为窗口尺寸
        let windowOrigin = window.convertToScreen(rect).origin
        // 默认放在区域的底部
        var toolbarOrigin = NSPoint(
            x: windowOrigin.x,
            y: windowOrigin.y + rect.height + 5
        )
        // 调整菜单栏的上下显示区域
        // 调整菜单栏Y轴位置
        // 如果当前矩形顶部部区域小于 24，调整分辨率栏显示在截图区域的左侧
        if bounds.height - rect.maxY <  24 {
            print("当前顶部间隙小于24")
            toolbarOrigin.x = windowOrigin.x - 80
            toolbarOrigin.y = windowOrigin.y + rect.height - 24
            // 如果调整为左侧显示，但左侧区域不足80，设置为内部显示。
            let xLeftSpacing = rect.minX
            if xLeftSpacing < 80 {
                toolbarOrigin.x = windowOrigin.x
            }
        }
        
        // 如果已经显示则不再重复创建
        guard resolutionWindow == nil else {
            resolutionWindow?.makeKeyAndOrderFront(nil)
            print("当前已经有分辨率窗口，不再重复创建")
            return
        }
        
        // 创建工具栏窗口
        let resolution = ResolutionWindow(rectOrigin: toolbarOrigin, rectSize: toolbarSize) {
            ResolutionView(resolution: rect.size)
        }
        window.addChildWindow(resolution, ordered: .above)
        resolutionWindow = resolution
    }
    
    // 隐藏常用、存储和步骤工具栏
    func hideToolbar() {
        if let toolbar = toolbarWindow {
            toolbar.orderOut(nil)
            toolbar.close() // 可选，释放窗口资源
            toolbarWindow = nil
        }
    }
    
    // 隐藏截图区域分辨率
    func hideResolution() {
        if let resolution = resolutionWindow {
            resolution.orderOut(nil)
            resolution.close()
            resolutionWindow = nil
        }
    }
}

struct NSScreenshotOverlayView: NSViewRepresentable {
    func makeNSView(context: Context) -> ScreenshotOverlayView {
        return ScreenshotOverlayView()
    }
    func updateNSView(_ nsView: ScreenshotOverlayView, context: Context) {
    }
}

struct ScreenshotOverlaySwiftUIView: View {
    var body: some View {
        ZStack {
            Image("testBackground")
                .resizable()
                .scaledToFill()
                .frame(width: 1200, height:800)
            TimelineView(.periodic(from: Date(), by: 1)) { context in
                Text("\(Date())")
            }
            NSScreenshotOverlayView()
                .frame(width: 1200, height:800)
        }
    }
}

#Preview {
    ScreenshotOverlaySwiftUIView()
}
