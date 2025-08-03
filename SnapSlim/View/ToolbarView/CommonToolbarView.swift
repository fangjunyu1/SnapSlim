//
//  CommonToolbarView.swift
//  SnapSlim
//
//  Created by 方君宇 on 2025/8/3.
//

import SwiftUI

struct CommonToolbarView: View {
    @State private var hoverIndex:Int?
    @State private var currentToolIndex:Int?
    // 工具名称
    var tools = ["square","circle","line.diagonal","line.diagonal.arrow","pencil.tip","eraser","character","mosaic","1.circle","pin","translate","text.viewfinder"]
    var body: some View {
        HStack(spacing:10) {
            ForEach(Array(tools.enumerated()),id: \.offset) { index,tool in
                Button(action: {
                    currentToolIndex = currentToolIndex != index ? index : nil
                }, label: {
                    Image(systemName: "\(tool)")
                        .foregroundColor(currentToolIndex == index ? .teal : hoverIndex == index ? .cyan : .white)
                })
                .buttonStyle(.plain)
                .onHover { hover in
                    hoverIndex = hover ? index : nil
                    hover ? NSCursor.pointingHand.set() : NSCursor.arrow.set()
                }
            }
        }
        .padding(.vertical,10)
        .padding(.horizontal,14)
        .background(.black.opacity(0.5))
        .cornerRadius(8)
    }
}

#Preview {
    CommonToolbarView()
}
