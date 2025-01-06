class RiskAnalyzer {
  static Map<String, dynamic> analyzeProjectRisk({
    required double esgScore,
    required double investment,
    required Map<String, double> sustainabilityMetrics,
  }) {
    List<String> risks = [];
    String riskLevel;
    double roi;

    // ESG Score based risk
    if (esgScore < 50) {
      risks.add('Low ESG Performance');
      riskLevel = 'High';
    } else {
      riskLevel = 'Low';
    }

    // Calculate ROI based on sustainability metrics and ESG score
    roi = _calculateROI(sustainabilityMetrics, esgScore, investment);

    // Additional risk factors
    if (sustainabilityMetrics['co2Reduction']! < 100) {
      risks.add('Low Carbon Reduction Impact');
    }

    if (sustainabilityMetrics['energySavings']! < 1000) {
      risks.add('Minimal Energy Savings');
    }

    if (sustainabilityMetrics['jobCreation']! < 50) {
      risks.add('Limited Social Impact');
    }

    if (sustainabilityMetrics['governanceScore']! < 5) {
      risks.add('Poor Governance Standards');
    }

    return {
      'riskLevel': riskLevel,
      'risks': risks,
      'roi': roi,
    };
  }

  static double _calculateROI(
    Map<String, double> metrics,
    double esgScore,
    double investment,
  ) {
    // Base ROI calculation
    double baseRoi = 15.0; // 15% base ROI

    // Adjust ROI based on ESG score
    double esgMultiplier = esgScore / 50.0; // 1.0 is neutral point

    // Adjust ROI based on sustainability metrics
    double sustainabilityBonus = 0.0;
    sustainabilityBonus += (metrics['co2Reduction']! / 1000) * 2; // Up to 2%
    sustainabilityBonus += (metrics['energySavings']! / 10000) * 3; // Up to 3%
    sustainabilityBonus += (metrics['socialImpact']! / 10) * 2; // Up to 2%
    sustainabilityBonus += (metrics['governanceScore']! / 10) * 3; // Up to 3%

    // Calculate final ROI
    double finalRoi = (baseRoi * esgMultiplier) + sustainabilityBonus;

    // Cap ROI between 5% and 30%
    return finalRoi.clamp(5.0, 30.0);
  }
}