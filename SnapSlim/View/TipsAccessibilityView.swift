//
//  TipsAccessibilityView.swift
//  SnapSlim
//
//  Created by 方君宇 on 2025/7/27.
//

import SwiftUI

struct TipsAccessibilityView: View {
    var body: some View {
        VStack{
            HStack {
                
                Rectangle()
                    .frame(width: 45, height:45)
                    .cornerRadius(15)
                    .foregroundColor(Color(hex: "3478f6"))
                    .overlay {
                        Image(systemName: "accessibility")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                    }
                Image(systemName: "chevron.right.dotted.chevron.right")
                Image("icon")
                    .resizable()
                    .scaledToFit()
                    .imageScale(.large)
                    .frame(width: 50, height:50)
                    .cornerRadius(15)
            }
            
            Spacer().frame(height: 10)
            // 启用辅助功能提示
            Text("Implement shortcut key function")
                .foregroundColor(Color(hex: "2f2f2f"))
                .fontWeight(.light)
                .padding(.vertical,5)
                .padding(.horizontal,10)
                .background(Color(hex: "dddddd"))
                .cornerRadius(10)
            
            Spacer().frame(height: 15)
            Divider()
            Spacer().frame(height: 15)
            Text("Enable Accessibility tips")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "3b3b3b"))
            Spacer().frame(height:8)
            Text("Please enable the \"Accessibility\" permission for this app in the system settings to implement shortcut functions such as screenshots and screen recording.")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .frame(width:260)
                .fixedSize()
            Spacer().frame(height:20)
            Button(action: {
                if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") {
                        NSWorkspace.shared.open(url)
                    }
                // 隐藏窗口
                print("隐藏窗口")
                WindowManager.shared.TipsAccessibilityWindow?.close()
            },label:  {
                Text("Open Settings")
                    .font(.headline)
                    .frame(minWidth: 200,minHeight: 40)
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(10)
            })
            .buttonStyle(.plain)
            .onHover { isHovering in
                               isHovering ? NSCursor.pointingHand.set() : NSCursor.arrow.set()
                           }
            Spacer().frame(height:10)
            Button(action: {
                // 隐藏窗口
                print("隐藏窗口")
                WindowManager.shared.TipsAccessibilityWindow?.close()
            },label:  {
                Text("Cancel")
                    .font(.headline)
                    .frame(minWidth: 200,minHeight: 40)
                    .foregroundColor(.white)
                    .background(.gray)
                    .cornerRadius(10)
            })
            .buttonStyle(.plain)
            .onHover { isHovering in
                               isHovering ? NSCursor.pointingHand.set() : NSCursor.arrow.set()
                           }
            
            Spacer().frame(height: 20)
        }
        .frame(width: 280)
        .padding(20)
    }
}

#Preview {
    TipsAccessibilityView()
}
