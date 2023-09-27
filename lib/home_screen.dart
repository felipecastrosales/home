import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

import 'article_screen.dart';
import 'news_data.dart';

const String appGroupId = 'group.felipecastrosaleshome';
const String iOSWidgetName = 'NewsWidgets';
const String androidWidgetName = 'NewsWidget';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

void updateHeadline(NewsArticle newHeadline) {
  HomeWidget.saveWidgetData<String>(
    'headline_title',
    newHeadline.title,
  );
  HomeWidget.saveWidgetData<String>(
    'headline_description',
    newHeadline.description,
  );
  HomeWidget.updateWidget(
    iOSName: iOSWidgetName,
    androidName: androidWidgetName,
  );
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    HomeWidget.setAppGroupId(appGroupId);
    final newHeadline = NewsHelpers.newsStoriesData[0];
    updateHeadline(newHeadline);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Stories'),
        centerTitle: false,
        titleTextStyle: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      
      body: ListView.separated(
        separatorBuilder: (context, index) => const Divider(),
        itemCount: NewsHelpers.newsStoriesData.length,
        itemBuilder: (context, index) {
          final article = NewsHelpers.newsStoriesData[index];
          return ListTile(
            key: Key('$index ${article.hashCode}'),
            title: Text(article.title),
            subtitle: Text(article.description),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return ArticleScreen(article: article);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
