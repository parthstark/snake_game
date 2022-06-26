class Score {
  int? id;
  late int score;
  late String date;
  Score(this.score, this.date);

  // Convert Score object to Map object
  Map<String, dynamic> toMap() => {'id': id, 'score': score, 'date': date};

  // Extract a Score object from Map object
  Score.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    score = map['score'];
    date = map['date'];
  }
}
