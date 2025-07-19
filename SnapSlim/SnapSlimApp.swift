//
//  SnapSlimApp.swift
//  SnapSlim
//
//  Created by 方君宇 on 2025/7/19.
//

import SwiftUI

@main
struct SnapSlimApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        Settings {
            ContentView()
        }
    }
}
