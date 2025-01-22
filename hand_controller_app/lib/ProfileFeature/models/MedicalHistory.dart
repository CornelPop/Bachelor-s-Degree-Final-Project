class Consultation {
  String date;
  String title;
  String notes;
  String treatmentPlan;

  Consultation({
    required this.date,
    required this.title,
    required this.notes,
    required this.treatmentPlan,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'title': title,
      'notes': notes,
      'treatmentPlan': treatmentPlan,
    };
  }

  factory Consultation.fromMap(Map<String, dynamic> map) {
    return Consultation(
      date: map['date'],
      title: map['title'],
      notes: map['notes'],
      treatmentPlan: map['treatmentPlan'] ?? '',
    );
  }
}
