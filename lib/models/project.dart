class Project {
  final String id;
  final String name;
  final double esgScore;
  final double roi;
  final double budget;
  final Map<String, double> sustainabilityMetrics;
  final List<String> risks;

  Project({
    required this.id,
    required this.name,
    required this.esgScore,
    required this.roi,
    required this.budget,
    required this.sustainabilityMetrics,
    required this.risks,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
      esgScore: json['esgScore'].toDouble(),
      roi: json['roi'].toDouble(),
      budget: json['budget'].toDouble(),
      sustainabilityMetrics: Map<String, double>.from(json['sustainabilityMetrics']),
      risks: List<String>.from(json['risks']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'esgScore': esgScore,
      'roi': roi,
      'budget': budget,
      'sustainabilityMetrics': sustainabilityMetrics,
      'risks': risks,
    };
  }
}