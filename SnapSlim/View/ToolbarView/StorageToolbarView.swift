//
//  StorageView.swift
//  SnapSlim
//
//  Created by 方君宇 on 2025/8/3.
//

import SwiftUI

struct StorageToolbarView: View {
    @State private var hoverIndex:Int?
    // 工具名称
    var tools = ["xmark","square.and.arrow.down","checkmark"]
    var body: some View {
        HStack(spacing:10) {
            ForEach(Array(tools.enumerated()),id: \.offset) { index,tool in
                Button(action: {
                    // 执行命令代码
                }, label: {
                    Image(systemName: "\(tool)")
                        .foregroundColor(
                            hoverIndex == index ?  hoverIndex == 0 ? .red :
                                hoverIndex == 1 ? .teal :
                                hoverIndex == 2 ? .green : .white : .white
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
    StorageToolbarView()
}
