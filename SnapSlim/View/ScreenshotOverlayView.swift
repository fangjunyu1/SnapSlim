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
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        layer?.backgroundColor = NSColor.black.withAlphaComponent(0.2).cgColor
        selectionLayer.fillRule = .evenOdd
        layer?.mask = selectionLayer
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func mouseDown(with event: NSEvent) {
        print("按下鼠标")
        startPoint = event.locationInWindow
    }
    override func mouseDragged(with event: NSEvent) {
        print("移动鼠标")
        currentPoint = event.locationInWindow
        updateSelectionPath()
    }
    override func mouseUp(with event: NSEvent) {
        print("抬起鼠标")
        currentPoint = event.locationInWindow
    }
    
    override func layout() {
        let path = CGMutablePath()
        path.addRect(bounds)
        selectionLayer.path = path
    }
    
    // 根据用户拖动鼠标的区域计算区域矩形
    func selectedRect() -> CGRect? {
        guard let start = startPoint, let end = currentPoint else { return nil }
        return CGRect(
            x: min(start.x, end.x),
            y: min(start.y, end.y),
            width: abs(start.x - end.x),
            height: abs(start.y - end.y)
        )
    }

    func updateSelectionPath() {
        guard let rect = selectedRect() else { return }
        
        let path = CGMutablePath()
        path.addRect(bounds)
        path.addRect(rect)
        selectionLayer.path = path
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
                .frame(width: 400, height:260)
            NSScreenshotOverlayView()
                .frame(width: 400, height:260)
        }
    }
}

#Preview {
    ScreenshotOverlaySwiftUIView()
}
