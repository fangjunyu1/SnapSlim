//
//  ResolutionView.swift
//  SnapSlim
//
//  Created by 方君宇 on 2025/8/7.
//
// 分辨率视图
//

import SwiftUI

struct ResolutionView: View {
    var resolution: CGSize
    var body: some View {
            // 常用工具栏
            HStack(spacing: 5) {
                Text(String(format: "%.f",resolution.width))
                    Text("×")
                Text(String(format: "%.f",resolution.height))
            }
            .foregroundColor(.white)
            .frame(width: 80,height:24)
            .background(.black.opacity(0.5))
            .cornerRadius(3)
    }
}

#Preview {
    ResolutionView(resolution: CGSize(width: 100, height: 100))
}
