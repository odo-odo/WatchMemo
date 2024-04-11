//
//  WatchMemoWidget.swift
//  WatchMemoWidget
//
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), memo: ContainerGroupManager().memo)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        var manager = ContainerGroupManager()
        manager.setMemoData()
        let entryDate = Date()
        let entry = SimpleEntry(date: entryDate, memo: manager.memo)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        var manager = ContainerGroupManager()
        manager.setMemoData()
        let entryDate = Date()
        let entry = SimpleEntry(date: entryDate, memo: manager.memo)
        entries.append(entry)
    
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let memo: String
}

// コンプリケーションに応じたView
struct InlineComplication : View {
    @State var memo: String

    var body: some View {
        HStack {
            Image(systemName:"note.text")
            Text(": \(memo)")
                .lineLimit(1)
        }
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct CircularComplication : View {
    @Environment(\.showsWidgetLabel) var showsWidgetLabel
    @State var memo: String

    var body: some View {
        if showsWidgetLabel {
            Image(systemName:"note.text")
                .widgetLabel {
                    Text(memo)
                }
                .containerBackground(.fill.tertiary, for: .widget)
        } else {
            Text(memo)
                .lineLimit(1)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

struct CornerComplication : View {
    @State var memo: String

    var body: some View {
        Image(systemName:"note.text")
            .widgetLabel {
                Text(memo)
                    .lineLimit(1)
                    .containerBackground(.fill.tertiary, for: .widget)
            }
    }
}

struct RectangularComplication : View {
    @State var memo: String

    var body: some View {
        VStack {
            HStack {
                Image(systemName:"note.text")
                    .font(.system(size: 10.0))
                Spacer()
            }
            Text(memo)
                .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                .widgetAccentable()
        }
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct WatchMemoWidgetEntryView : View {
    // コンプリケーションに応じてViewを切り替える準備
    @Environment(\.widgetFamily) var widgetFamily
    @State var entry: Provider.Entry

    var body: some View {
        switch widgetFamily {
            case .accessoryCorner:
                CornerComplication(memo: entry.memo)
            case .accessoryCircular:
                CircularComplication(memo: entry.memo)
            case .accessoryInline:
                InlineComplication(memo: entry.memo)
            case .accessoryRectangular:
                RectangularComplication(memo: entry.memo)
            @unknown default:
                Text("No　Complication")
        }
    }
}

@main
struct WatchMemoWidget: Widget {
    let kind: String = "WatchMemoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WatchMemoWidgetEntryView(entry: entry)
            .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Watch MemoPad")
        .description("short text memo for WatchOS.")
    }
}

struct WidgetAppExtension_Previews: PreviewProvider {
    static var previews: some View {
        WatchMemoWidgetEntryView(entry: SimpleEntry(date: Date(), memo: ContainerGroupManager().memo))
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
    }
}

struct  ContainerGroupManager {
    var memo: String = "memo text"

    mutating func setMemoData(){
        guard let memoData = UserDefaults(suiteName: "group.com.watch.memo")?.object(forKey: "memo")
        else{return}
        self.memo = memoData as! String
    }
}

