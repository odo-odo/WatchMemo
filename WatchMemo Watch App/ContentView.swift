//
//  ContentView.swift
//  watch-memo Watch App
//
//


import SwiftUI
import WidgetKit

struct ContentView: View {
    @ObservedObject var memoData = MemoData()
    @State var value: String = " "

    var body: some View {
        VStack {
            NavigationStack {
                List {
                    NavigationLink(destination: EditView(value: "\(value)")) {
                        Text(value)
                            .font(.headline)
                            .lineLimit(5 ... 100)
                            .multilineTextAlignment(.leading)
                            .padding()
                            .onAppear() {
                                guard let defaultMemo = UserDefaults(suiteName: "group.com.watch.memo")?.object(forKey: "memo")
                                else{return}
                                // memoがNullの場合、値に空文字を挿入する
                                value = defaultMemo as! String
                                if value == "" {
                                    value = " "
                                }
                            }
                    }
                    .padding()
                    // Textエリアが見えにくいので枠を作る
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 8))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .listRowBackground(Color.clear)
                    Button(action: {erase()}) {
                        Label("erase", systemImage: "trash")
                            .font(.headline)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.clear)
                    }
                    // 背景色を透明にする
                    .listRowBackground(Color.clear)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
        }
    }
    // データの削除
    private func erase() {
        let eraseMemo = " "
        self.memoData.memo = eraseMemo
        self.value = eraseMemo
        // Widgetを更新
        WidgetCenter.shared.reloadAllTimelines()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
