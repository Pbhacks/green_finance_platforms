class EsgCalculator {
  static double calculateEsgScore({
    required Map<String, double> environmentalMetrics,
    required Map<String, double> socialMetrics,
    required Map<String, double> governanceMetrics,
  }) {
    // Environmental factors (40% weight)
    double environmentalScore = _calculateEnvironmentalScore(environmentalMetrics);
    
    // Social factors (30% weight)
    double socialScore = _calculateSocialScore(socialMetrics);
    
    // Governance factors (30% weight)
    double governanceScore = _calculateGovernanceScore(governanceMetrics);
    
    // Calculate weighted average
    return (environmentalScore * 0.4) + (socialScore * 0.3) + (governanceScore * 0.3);
  }

  static double _calculateEnvironmentalScore(Map<String, double> metrics) {
    double score = 0;
    
    // Calculate score based on environmental metrics
    if (metrics.containsKey('carbonEmissions')) {
      score += _normalizeCarbonEmissions(metrics['carbonEmissions']!);
    }
    
    if (metrics.containsKey('renewableEnergy')) {
      score += metrics['renewableEnergy']! * 0.3;
    }
    
    if (metrics.containsKey('wasteManagement')) {
      score += metrics['wasteManagement']! * 0.2;
    }
    
    return score.clamp(0, 10);
  }

  static double _calculateSocialScore(Map<String, double> metrics) {
    double score = 0;
    
    if (metrics.containsKey('communityImpact')) {
      score += metrics['communityImpact']! * 0.4;
    }
    
    if (metrics.containsKey('laborPractices')) {
      score += metrics['laborPractices']! * 0.3;
    }
    
    if (metrics.containsKey('humanRights')) {
      score += metrics['humanRights']! * 0.3;
    }
    
    return score.clamp(0, 10);
  }

  static double _calculateGovernanceScore(Map<String, double> metrics) {
    double score = 0;
    
    if (metrics.containsKey('boardDiversity')) {
      score += metrics['boardDiversity']! * 0.3;
    }
    
    if (metrics.containsKey('transparency')) {
      score += metrics['transparency']! * 0.4;
    }
    
    if (metrics.containsKey('ethicalPractices')) {
      score += metrics['ethicalPractices']! * 0.3;
    }
    
    return score.clamp(0, 10);
  }

  static double _normalizeCarbonEmissions(double emissions) {
    // Convert emissions to a 0-10 score (lower emissions = higher score)
    const double maxEmissions = 1000; // Example threshold
    return ((maxEmissions - emissions) / maxEmissions * 10).clamp(0, 10);
  }
}