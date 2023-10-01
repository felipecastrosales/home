import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> NewsArticleEntry {
        NewsArticleEntry(
            date: Date(),
            title: "Placholder Title",
            description: "Placholder description",
            filename: "No screenshot available",
            displaySize: context.displaySize
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (NewsArticleEntry) -> ()) {
        let entry: NewsArticleEntry
        if context.isPreview{
            entry = placeholder(in: context)
        } else {
            /// Get the data from the user defaults to display
            let userDefaults = UserDefaults(suiteName: "group.HW5BGGMK8X.com.felipecastrosales.home")
            print("APP: userDefaults: \(userDefaults) - \(userDefaults?.string(forKey: "headline_title")) - \(userDefaults?.string(forKey: "headline_description"))")
            let title = userDefaults?.string(forKey: "headline_title") ?? "No Title Set"
            let description = userDefaults?.string(forKey: "headline_description") ?? "No Description Set"
            let filename = userDefaults?.string(forKey: "filename") ?? "No screenshot available"
            print(filename)
            entry = NewsArticleEntry(
                date: Date(),
                title: title,
                description: description,
                filename: filename,
                displaySize: context.displaySize
            )
        }
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        print("APP: getTimeline")
        /// This just uses the snapshot function you defined earlier
        getSnapshot(in: context) { (entry) in
            let timeline = Timeline(entries: [entry], policy: .atEnd)
                completion(timeline)
            }
    }
}

struct NewsArticleEntry: TimelineEntry {
    let date: Date
    let title: String
    let description:String
    // New: add the filename and displaySize.
    let filename: String
    let displaySize: CGSize
}

struct NewsWidgetsEntryView : View {
    var entry: Provider.Entry

    init(entry: Provider.Entry){
            self.entry = entry
            CTFontManagerRegisterFontsForURL(
                bundle.appending(path: "/fonts/Chewy-Regular.ttf") as CFURL,
                CTFontManagerScope.process, nil
            )
        }
    
    var bundle: URL {
            let bundle = Bundle.main
            if bundle.bundleURL.pathExtension == "appex" {
                // Peel off two directory levels - MY_APP.app/PlugIns/MY_APP_EXTENSION.appex
                var url = bundle.bundleURL.deletingLastPathComponent().deletingLastPathComponent()
                url.append(component: "Frameworks/App.framework/flutter_assets")
                return url
            }
            return bundle.bundleURL
        }

    var ChartImage: some View {
        if let uiImage = UIImage(contentsOfFile: entry.filename) {
            let image = Image(uiImage: uiImage)
                .resizable()
                .frame(
                    width: entry.displaySize.height * 0.5,
                    height: entry.displaySize.height * 0.5,
                    alignment: .center
                )
            return AnyView(image)
        }
        print("The image file could not be loaded")
        return AnyView(EmptyView())
    }


    var body: some View {
        VStack {
            Text(entry.title).font(Font.custom("Chewy", size: 13))
            Text(entry.description).font(.system(size: 12)).padding(10)
            ChartImage
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
