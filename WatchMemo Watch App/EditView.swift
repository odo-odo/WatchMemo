//
//  EditView.swift
//  watch-memo Watch App
//
//


import SwiftUI
import WidgetKit

struct EditView: View {
    @ObservedObject var memoData = MemoData()
    @State var value: String

    func setMemoData(){
        guard let memoData = UserDefaults(suiteName: "group.com.watch.memo")?.object(forKey: "memo")
        else{return}
        self.value = memoData as! String
    }

    var body: some View {
        TextField("Input Text", text: $value)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .overlay(RoundedRectangle(cornerRadius: 10)
            .stroke(Color.gray, lineWidth: 8))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .onAppear {
                if $value.wrappedValue == " " {
                    value.self = ""
                }
            }
            .onSubmit {
                update(memo: value)
            }
    }

    private func update(memo: String) {
        self.memoData.memo = memo
        setMemoData()
        // Widgetを更新
        WidgetCenter.shared.reloadAllTimelines()
    }
}
