# IOS_Add_a_Home_Widget_from_inside_my_App

## [IOS: Add a Home Widget from inside my App](https://stackoverflow.com/questions/72560997/ios-add-a-home-widget-from-inside-my-app) <br><br>
## [How To Add Widget In Storyboard Type In XCode, Swift5 project](https://stackoverflow.com/questions/75819852/how-to-add-widget-in-storyboard-type-in-xcode-swift5-project) <br><br>
#

### Cách sử dụng biểu tượng cảm xúc (emoji) trên MacBook siêu đơn giản (emoji text agin)
hãy nhấn đồng thời tổ hợp phím **Command + Control + Space**.
![image](https://github.com/Experimenters1/IOS_Add_a_Home_Widget_from_inside_my_App/assets/64000769/d4af2f49-f373-4515-a1d1-4d078cc60dd0)

# 
![Screenshot 2023-09-22 at 5 18 40 PM](https://github.com/Experimenters1/IOS_Add_a_Home_Widget_from_inside_my_App/assets/64000769/a75e36e2-8fc8-4d30-b372-019db82745a7)
```swift
//
//  MonthlyWidget.swift
//  MonthlyWidget
//
//  Created by Huy Vu on 9/21/23.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

//    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//        var entries: [SimpleEntry] = []
//
//        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()
//        for hourOffset in 0 ..< 5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            let entry = SimpleEntry(date: entryDate, configuration: configuration)
//            entries.append(entry)
//        }
//
//        let timeline = Timeline(entries: entries, policy: .atEnd)
//        completion(timeline)
//    }
    
//    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//            var entries: [SimpleEntry] = []
//
//            // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//            let currentDate = Date()
//            for hourOffset in 0 ..< 5 {
//                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//                let entry = SimpleEntry(date: entryDate, configuration: configuration)
//                entries.append(entry)
//            }
//
//            let timeline = Timeline(entries: entries, policy: .atEnd)
//            completion(timeline)
//        }
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Tạo một Timer để cập nhật dữ liệu mỗi phút
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            let currentDate = Date()
            let entry = SimpleEntry(date: currentDate, configuration: configuration)
            entries.append(entry)

            // Tạo một Timeline với mục mới nhất
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }

}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct MonthlyWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
    
        
        VStack {
            HStack (spacing: 9){
                Image(systemName: "calendar.circle.fill") // Thay thế "calendar.circle.fill" bằng biểu tượng mong muốn
                    .font(.system(size: 24))
                Text(entry.date, style: .time)
                    .padding(.bottom, 1) // Khoảng cách giữa Top Text và Bottom Text
                Spacer()
            }
            .padding()
            HStack {
                Text(entry.date, formatter: dateFormatter)
            }
            .padding(3)
        }
     
   
    }
    // Định nghĩa một dateFormatter cho ngày tháng
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }
}

struct MonthlyWidget: Widget {
    let kind: String = "MonthlyWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            MonthlyWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall]) //widget chỉ hỗ trợ gia đình nhỏ (small widget)
    }
}

struct MonthlyWidget_Previews: PreviewProvider {
    static var previews: some View {
        MonthlyWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}



```

## Creating a Widget
### The Timeline Entry (Mục nhập dòng thời gian)

Bạn có thể tưởng tượng mục nhập dòng thời gian là đối tượng mô hình của chế độ xem tiện ích. Nó ít nhất phải bao gồm một **date** tham số. Bất kỳ tham số nào khác cũng có thể được thêm vào mục nhập dòng thời gian dựa trên nhu cầu của chúng ta.

```swift
struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let providerInfo: String
}

```
Lưu ý rằng chúng tôi sẽ sử dụng **providerInfo** để giữ thông tin liên quan đến nhà cung cấp dòng thời gian và hiển thị thông tin đó trên tiện ích - sẽ nói thêm về điều đó sau.

