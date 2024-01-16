# IOS_Add_a_Home_Widget_from_inside_my_App

## [IOS: Add a Home Widget from inside my App](https://stackoverflow.com/questions/72560997/ios-add-a-home-widget-from-inside-my-app) <br><br>
## [How To Add Widget In Storyboard Type In XCode, Swift5 project](https://stackoverflow.com/questions/75819852/how-to-add-widget-in-storyboard-type-in-xcode-swift5-project) <br><br>
## [iOS WidgetKit: remote images fails to load](https://stackoverflow.com/questions/63086029/ios-widgetkit-remote-images-fails-to-load) <br><br>
## [WidgetKit: image widget with AppIntents](https://www.youtube.com/watch?v=JyS66ZMs-Cw) <br><br>
#

### Cách sử dụng biểu tượng cảm xúc (emoji) trên MacBook siêu đơn giản (emoji text agin)
hãy nhấn đồng thời tổ hợp phím **Command + Control + Space**.
![image](https://github.com/Experimenters1/IOS_Add_a_Home_Widget_from_inside_my_App/assets/64000769/d4af2f49-f373-4515-a1d1-4d078cc60dd0)

# 
![Screenshot 2023-09-22 at 5 18 40 PM](https://github.com/Experimenters1/IOS_Add_a_Home_Widget_from_inside_my_App/assets/64000769/a75e36e2-8fc8-4d30-b372-019db82745a7)
```swift
//
//  WidgetExtension.swift
//  WidgetExtension
//
//  Created by Huy Vu on 12/11/23.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct WidgetExtensionEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)

            Text("Favorite Emoji:")
            Text(entry.configuration.favoriteEmoji)
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
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
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
Lưu ý rằng chúng tôi sẽ sử dụng **providerInfo** để giữ thông tin liên quan đến nhà cung cấp dòng thời gian và hiển thị thông tin đó trên tiện ích - sẽ nói thêm về điều đó sau.<br><br>
**SimpleEntry** là một cấu trúc tuân theo giao thức **TimelineEntry**. Nó đại diện cho một mục nhập duy nhất trong dòng thời gian của **widget**, giữ ngày và cấu hình.<br><br>

### The Widget View  (Chế độ xem tiện ích)


Sau khi tạo **Timeline Entry (mục nhập dòng thời gian)**, chúng ta có thể tiến hành triển khai giao diện người dùng của Widget. Về cơ bản nó chỉ là một Chế độ xem SwiftUI.

```swift
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

```
### The Timeline Provider (Nhà cung cấp dòng thời gian)

```swift
struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

```
**Cấu Trúc Provider**<br><br>
   **Provider** là một cấu trúc tuân theo giao thức  **AppIntentTimelineProvider**, được sử dụng để định nghĩa nội dung và hành vi của  **widget**.<br><br>
+)  **placeholder(in:)** cung cấp một bản xem trước của  **widget** khi nó đang được cấu hình.<br><br>
+)  **snapshot(for:in:)** cung cấp một cái nhìn nhanh về **widget**, thường được sử dụng trong bộ sưu tập **widget.** <br><br>
+)  **timeline(for:in:)** định nghĩa nội dung thực tế của **widget** theo thời gian. Trong trường hợp này, nó tạo ra năm mục nhập, mỗi mục cách nhau một giờ.<br><br>

### The Widget Configuration (Cấu hình tiện ích)

![Screenshot 2023-10-09 at 9 16 22 AM](https://github.com/Experimenters1/IOS_Add_a_Home_Widget_from_inside_my_App/assets/64000769/e4b7697d-2691-4fee-9291-c015350c5d35)

```swift
struct WidgetExtension: Widget {
    let kind: String = "WidgetExtension"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            WidgetExtensionEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
            
        }
        
//        .supportedFamilies([.systemSmall])
//        .supportedFamilies([.systemMedium])
//        .supportedFamilies([ .systemLarge])
        .supportedFamilies([
                    .systemSmall,
                    .systemMedium,
                    .systemLarge,
                ])
        .configurationDisplayName("WidgetExtension")
        .description("This is an example widget.")
    }
}
```
## Test3
```swift

//                    optionalString = "https://file.hstatic.net/200000547241/file/1luffy_6c8b23a6cf254b9ab6ab5221f79db57a_grande.png"
//                    optionalString = "https://inkythuatso.com/uploads/thumbnails/800/2022/03/2665651-15-15-34-30.jpg"
//                    optionalString = "https://gamek.mediacdn.vn/133514250583805952/2022/5/18/photo-1-16528608926331302726659.jpg"
                    optionalString = "https://anime.atsit.in/l/wp-content/uploads/2023/06/one-piece-sap-ra-mat-som-cho-gear-5-trong-2-tap.jpg"
```
#####
### Có một số câu lệnh khác có thể hữu ích trong việc quản lý cách widgets của bạn cập nhật và hiển thị dữ liệu:<br><br>
**1.WidgetCenter.shared.reloadTimelines(ofKind:):** Phương thức này tải lại dòng thời gian cho các widget của một loại cụ thể. Điều này hữu ích nếu bạn có nhiều loại widget khác nhau và chỉ muốn cập nhật một loại nhất định.<br><br>
```swift
WidgetCenter.shared.reloadTimelines(ofKind: "MyWidgetKind")
```
Trong đó **"MyWidgetKind"** là loại của widget bạn muốn cập nhật.<br><br>
**2.WidgetCenter.shared.getCurrentConfigurations(completion:):** Phương thức này lấy thông tin cấu hình hiện tại của tất cả các widget được cài đặt. Nó có thể hữu ích để xác định widget nào đang được sử dụng và cách chúng được cấu hình.<br><br>

```swift
WidgetCenter.shared.getCurrentConfigurations { result in
    switch result {
    case .success(let configurations):
        for config in configurations {
            print("Widget of kind: \(config.kind)")
        }
    case .failure(let error):
        print("Error fetching configurations: \(error)")
    }
}
```
**3.NotificationCenter.default.post(name:notificationName, object: nil):**  Đôi khi bạn có thể muốn sử dụng **NotificationCenter** để gửi thông báo từ ứng dụng của mình tới widget, điều này có thể kích hoạt cập nhật trong widget.<br><br>

```swift
let notificationName = Notification.Name("MyAppWidgetUpdate")
NotificationCenter.default.post(name: notificationName, object: nil)
```

Sau đó, trong widget, bạn lắng nghe thông báo này và cập nhật dữ liệu tương ứng.<br><br>

Mỗi phương thức này đều có các ứng dụng và tác dụng cụ thể trong quá trình phát triển widget, giúp bạn quản lý cách widget của mình hiển thị và cập nhật dữ liệu.<br><br>

###
## Swift được sử dụng để cập nhật dữ liệu hiển thị trên các widget, nhưng chúng phục vụ cho mục đích khác nhau:<br><br>
**1.WidgetCenter.shared.reloadAllTimelines():** Phương thức này yêu cầu hệ thống tải lại dòng thời gian cho **tất cả** các **widget** mà ứng dụng cung cấp. Khi sử dụng phương thức này, mọi widget của ứng dụng bạn, không phụ thuộc vào loại widget, sẽ được yêu cầu cập nhật. Điều này hữu ích khi có một thay đổi lớn ảnh hưởng đến toàn bộ widget của ứng dụng.<br><br>

**2.WidgetCenter.shared.reloadTimelines(ofKind: "MyWidgetKind"):** Trong khi đó, phương thức này chỉ yêu cầu tải lại dòng thời gian cho các widget của một loại cụ thể, được xác định bởi tham số truyền vào. Trong trường hợp này, chỉ những widget thuộc loại **"MyWidgetKind"** sẽ được cập nhật. Điều này hữu ích khi bạn chỉ muốn cập nhật một nhóm widget cụ thể mà không ảnh hưởng đến các widget khác của ứng dụng.<br><br>
###




