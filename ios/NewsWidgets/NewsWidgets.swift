//
//  NewsWidgets.swift
//  NewsWidgets
//
//  Created by Felipe Sales on 26/09/23.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    /// Placeholder is used as a placeholder when the widget is first displayed
    func placeholder(in context: Context) -> NewsArticleEntry {
        /// Add some placeholder title and description, and get the current date
        NewsArticleEntry(date: Date(), title: "Placeholder Title", description: "Placeholder description")
    }

    /// Snapshot entry represents the current time and state
    func getSnapshot(in context: Context, completion: @escaping (NewsArticleEntry) -> ()) {
        let entry: NewsArticleEntry
        if context.isPreview {
            print("APP: isPreview")
            entry = placeholder(in: context)
        }
        else {
            /// Get the data from the user defaults to display
            let userDefaults = UserDefaults(suiteName: "group.com.felipecastrosales.home")
            print("APP: userDefaults: \(userDefaults) - \(userDefaults?.string(forKey: "headline_title")) - \(userDefaults?.string(forKey: "headline_description"))")
            let title = userDefaults?.string(forKey: "headline_title") ?? "No Title Set"
            let description = userDefaults?.string(forKey: "headline_description") ?? "No Description Set"
            entry = NewsArticleEntry(date: Date(), title: title, description: description)
            print("APP: entry: \(entry)")
        }
        completion(entry)
    }
    /// getTimeline is called for the current and optionally future times to update the widget
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        print("APP: getTimeline")
        /// This just uses the snapshot function you defined earlier
        getSnapshot(in: context) { (entry) in
        print("APP: getTimeline - entry: \(entry)")
        /// atEnd policy tells widgetkit to request a new entry after the date has passed
        let timeline = Timeline(entries: [entry], policy: .atEnd)
            print("APP: getTimeline - timeline: \(timeline)")
            completion(timeline)
        }
    }
}

/// The date and any data you want to pass into your app must conform to TimelineEntry
struct NewsArticleEntry: TimelineEntry {
    let date: Date
    let title: String
    let description: String
}

/// View that holds the contents of the widget
struct NewsWidgetsEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text(entry.title)
            Text(entry.description)
        }
    }
}

struct NewsWidgets: Widget {
    let kind: String = "NewsWidgets"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            NewsWidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

/// Initial preview generation
// struct NewsWidgets_Previews: PreviewProvider {
//     static var previews: some View {
//         NewsWidgetsEntryView(entry: SimpleEntry(date: Date()))
//             .previewContext(WidgetPreviewContext(family: .systemSmall))
//     }
// }

/// Another preview.
//struct NewsWidgets_Previews: PreviewProvider {
//    static var previews: some View {
//        NewsWidgetsEntryView(entry: NewsArticleEntry(date: Date(), title: "Preview Title", description: "Preview description", filename: "No Screenshot available"))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}
