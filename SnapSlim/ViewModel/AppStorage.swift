//
//  AppStorage.swift
//  SnapSlim
//
//  Created by 方君宇 on 2025/7/19.
//

import Foundation

class AppStorage:ObservableObject {
    
    static var shared = AppStorage()
    
    private init() {
        loadUserDefault()   // 加载 UserDefaults 中的数据
    }
    
    // 是否内购赞助
    @Published var inAppPurchaseMembership = false {
        willSet {
            // 修改 USerDefault 中的值
            UserDefaults.standard.set(newValue, forKey: "inAppPurchaseMembership")
            // 修改 iCloud 中的值
            let store = NSUbiquitousKeyValueStore.default
            store.set(newValue, forKey: "inAppPurchaseMembership")
            store.synchronize() // 强制触发数据同步
        }
    }
    
    // 从UserDefaults加载数据
    private func loadUserDefault() {
        
        // 1、应用赞助标识
        // 如果 UserDefaults 中没有 inAppPurchaseMembership 键，设置默认为 false
        if UserDefaults.standard.object(forKey: "inAppPurchaseMembership") == nil {
            // 设置默认值为 true
            print("应用赞助，默认值为nil，设置为 false")
            UserDefaults.standard.set(false, forKey: "inAppPurchaseMembership")
            inAppPurchaseMembership = false  // 菜单栏图标
        } else {
            // 如果 UserDefaults 有 inAppPurchaseMembership 键，则设置为对应 Bool 值
            inAppPurchaseMembership = UserDefaults.standard.bool(forKey: "inAppPurchaseMembership")
            print("应用赞助，默认值为 \(inAppPurchaseMembership)")
        }
    }
}
