class Rating {
  String ratingId;
  String ratingSenderId;
  int starsNumber;

  Rating({required this.ratingSenderId, required this.starsNumber, required this.ratingId});

  Map<String, dynamic> toMap() {
    return {
      'ratingSenderId': ratingSenderId,
      'starsNumber': starsNumber,
      'ratingId': ratingId,
    };
  }

  factory Rating.fromMap(Map<String, dynamic> map, String id) {
    return Rating(
      ratingSenderId: map['ratingSenderId'],
      starsNumber: map['starsNumber'],
      ratingId: id,
    );
  }

}
