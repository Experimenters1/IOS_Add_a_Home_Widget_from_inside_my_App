//
//  WidgetExtension.swift
//  WidgetExtension
//
//  Created by Huy Vu on 9/28/23.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(),text: "", configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(),text: "", configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        
        let userDefaults = UserDefaults(suiteName: "group.huy.test1")
        
        let text = userDefaults?.value(forKey:"text") as? String ?? "No text"

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate ,text: text , configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let text: String
    let configuration: ConfigurationAppIntent
}

struct WidgetExtensionEntryView : View {
    var entry: Provider.Entry
 
    var body: some View {
        ZStack {
            GeometryReader { geo in
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geo.size.width,height: geo.size.height,alignment: .center)
                    .clipped()
            }
            
            Text(entry.text)
                .font(Font.system(size: 24,weight: .semibold,design: .default))
                .foregroundColor(Color.white)
        }

    }
}

struct WidgetExtension: Widget {
    let kind: String = "WidgetExtension"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            WidgetExtensionEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    WidgetExtension()
} timeline: {
    SimpleEntry(date: .now,text: "Hello Widget", configuration: .smiley)
    SimpleEntry(date: .now,text: "Hello Widget", configuration: .starEyes)
}
