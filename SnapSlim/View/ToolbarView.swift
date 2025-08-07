//
//  CommonToolbarView.swift
//  SnapSlim
//
//  Created by 方君宇 on 2025/8/3.
//

import SwiftUI

struct ToolbarView: View {
    @State private var currentToolIndex:Int?
    @State private var commandHoverIndex:Int?
    @State private var stepHoverIndex:Int?
    @State private var storageHoverIndex:Int?
    // 工具名称
    var commandTools = ["square","circle","line.diagonal","line.diagonal.arrow","pencil.tip","eraser","character","mosaic","1.circle","pin","translate","text.viewfinder"]
    var storageTools = ["xmark","square.and.arrow.down","checkmark"]
    var stepTools = ["arrowshape.turn.up.left","arrowshape.turn.up.right"]
    
    var body: some View {
        HStack {
            // 常用工具栏
            HStack(spacing:15) {
                ForEach(Array(commandTools.enumerated()),id: \.offset) { index,tool in
                    Button(action: {
                        currentToolIndex = currentToolIndex != index ? index : nil
                    }, label: {
                        Image(systemName: "\(tool)")
                            .foregroundColor(currentToolIndex == index ? .teal : commandHoverIndex == index ? .cyan : .white)
                            .font(.title2)
                    })
                    .buttonStyle(.plain)
                    .onHover { hover in
                        commandHoverIndex = hover ? index : nil
                        hover ? NSCursor.pointingHand.set() : NSCursor.arrow.set()
                    }
                }
            }
            .frame(width: 430,height:40)
            .background(.black.opacity(0.5))
            .cornerRadius(8)
            
            // 步骤工具栏
            HStack(spacing:15) {
                ForEach(Array(stepTools.enumerated()),id: \.offset) { index,tool in
                    Button(action: {
                        // 执行代码
                    }, label: {
                        Image(systemName: "\(tool)")
                            .font(.title2)
                            .foregroundColor (
                                stepHoverIndex == index ?  stepHoverIndex == 0 ? .teal :
                                    stepHoverIndex == 1 ? .teal : .white : .white
                            )
                    })
                    .buttonStyle(.plain)
                    .onHover { hover in
                        stepHoverIndex = hover ? index : nil
                        hover ? NSCursor.pointingHand.set() : NSCursor.arrow.set()
                    }
                }
            }
            .frame(width: 80,height:40)
            .background(.black.opacity(0.5))
            .cornerRadius(8)
            
            // 存储工具栏
            HStack(spacing:15) {
                ForEach(Array(storageTools.enumerated()),id: \.offset) { index,tool in
                    Button(action: {
                        // 执行命令代码
                    }, label: {
                        Image(systemName: "\(tool)")
                            .font(.title2)
                            .foregroundColor(
                                storageHoverIndex == index ?  storageHoverIndex == 0 ? .red :
                                    storageHoverIndex == 1 ? .teal :
                                    storageHoverIndex == 2 ? .green : .white : .white
                            )
                    })
                    .buttonStyle(.plain)
                    .onHover { hover in
                        storageHoverIndex = hover ? index : nil
                        hover ? NSCursor.pointingHand.set() : NSCursor.arrow.set()
                    }
                }
            }
            .frame(width: 120,height:40)
            .background(.black.opacity(0.5))
            .cornerRadius(8)
        }
    }
}

#Preview {
    ToolbarView()
}
