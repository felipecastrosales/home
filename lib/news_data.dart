class NewsArticle {
  NewsArticle({
    required this.title,
    required this.description,
    this.articleText = NewsHelpers.loremIpsum,
  });

  final String title, description;
  final String? articleText;
}

sealed class NewsHelpers {
  static const String loremIpsum =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.';

  static List<NewsArticle> get newsStoriesData => [
        NewsArticle(
          title: 'Real Madrid is the biggest club',
          description: 'Real Madrid have 14 Champions League titles',
        ),
        NewsArticle(
          title: 'Real Madrid in Spain',
          description: 'Real Madrid have 35 league titles',
        ),
        NewsArticle(
          title: 'Cristiano Ronaldo is the GOAT',
          description: 'Best striker from history',
        ),
        NewsArticle(
          title: 'Toni Kroos and Luka Modric',
          description: 'Sensational pair, two top midfield',
        )
      ];
}
