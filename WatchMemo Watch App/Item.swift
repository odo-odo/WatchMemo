//
//  Item.swift
//  watch-memo Watch App
//
//

import Foundation

class MemoData: ObservableObject {
    @Published var memo: String {
        willSet {
            print("willset")
            print(UserDefaults(suiteName: "group.com.watch.memo")?.string(forKey: "memo"))
        }
        didSet {
            UserDefaults(suiteName: "group.com.watch.memo")?.set(memo, forKey: "memo")
            print("didset")
            print(UserDefaults(suiteName: "group.com.watch.memo")?.string(forKey: "memo"))
        }
    }

    // 初期化
    init() {
        memo = UserDefaults(suiteName: "group.com.watch.memo")?.string(forKey: "memo") ?? " "
    }
}
