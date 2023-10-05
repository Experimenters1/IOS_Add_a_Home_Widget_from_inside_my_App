//
//  WidgetExtension.swift
//  WidgetExtension
//
//  Created by Huy Vu on 10/3/23.
//

import WidgetKit
import SwiftUI
import URLImage

struct Provider: AppIntentTimelineProvider {
    typealias Entry = SimpleEntry
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), text: "")
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration, text: "")
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        
        let userDefaults = UserDefaults(suiteName: "group.huy.test1")
        
        // Initialize text with an empty string
        var text = userDefaults?.value(forKey: "text") as? String ?? ""
        
        print("huy \(text)")
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            
            // Create a Timer to periodically update "text"
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
                if let newImageUrlString = userDefaults?.value(forKey: "text") as? String, text != newImageUrlString {
                    DispatchQueue.main.async {
                        // Update the "text" property
                        text = newImageUrlString
                        
                        // Create a new entry with updated values
                        let entry = SimpleEntry(date: entryDate, configuration: configuration, text: newImageUrlString)
                        
                        // Replace the old entry with the updated entry
                        if let index = entries.firstIndex(where: { $0.date == entryDate }) {
                            entries[index] = entry
                        } else {
                            entries.append(entry)
                        }
                    }
                }
            }
            
            let entry = SimpleEntry(date: entryDate, configuration: configuration, text: text)
            entries.append(entry)
        }
        
        return Timeline(entries: entries, policy: .atEnd)
    }
}


struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let text: String

}

struct WidgetExtensionEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            if let imageUrl = URL(string: entry.text) {
                if let imageData = try? Data(contentsOf: imageUrl),
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Text("Invalid Image URL")
                }
            } else {
                Text("Invalid URL")
            }
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
    SimpleEntry(date: .now, configuration: .smiley ,text: "" )
    SimpleEntry(date: .now, configuration: .starEyes,text: "")
}
