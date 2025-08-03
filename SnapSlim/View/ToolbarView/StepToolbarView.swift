//
//  StepToolView.swift
//  SnapSlim
//
//  Created by 方君宇 on 2025/8/3.
//

import SwiftUI

struct StepToolbarView: View {
    @State private var hoverIndex:Int?
    // 工具名称
    var tools = ["arrowshape.turn.up.left","arrowshape.turn.up.right"]
    var body: some View {
        VStack(spacing:10) {
            ForEach(Array(tools.enumerated()),id: \.offset) { index,tool in
                Button(action: {
                    // 执行代码
                }, label: {
                    Image(systemName: "\(tool)")
                        .foregroundColor (
                            hoverIndex == index ?  hoverIndex == 0 ? .teal :
                                hoverIndex == 1 ? .teal : .white : .white
                        )
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
    StepToolbarView()
}
