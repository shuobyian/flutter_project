class Board {
  int? id;
  String username;
  String title;
  String content;
  String newsLink;
  String dateTime;
  String company;
  String category;
  String imageUrl;
  int? subscribeCount;

  Board(
      {this.id,
      required this.username,
      required this.title,
      required this.content,
      required this.newsLink,
      required this.dateTime,
      required this.company,
      required this.category,
      required this.imageUrl,
      this.subscribeCount});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'title': title,
      'content': content,
      'newsLink': newsLink,
      'dateTime': dateTime,
      'company': company,
      'category': category,
      'imageUrl': imageUrl,
      'subscribeCount': subscribeCount,
    };
  }

  factory Board.fromJson(Map<String, dynamic> json) {
    return Board(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      newsLink: json['newsLink'] ?? '',
      dateTime: json['dateTime'] ?? '',
      company: json['company'] ?? '',
      category: json['category'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      subscribeCount: json['subscribeCount'] ?? 0,
    );
  }
}
