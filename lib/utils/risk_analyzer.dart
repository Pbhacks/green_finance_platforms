class RiskAnalyzer {
  static List<String> analyzeProjectRisks({
    required Map<String, double> financialMetrics,
    required Map<String, double> environmentalMetrics,
    required Map<String, double> marketConditions,
  }) {
    List<String> risks = [];
    
    // Analyze financial risks
    risks.addAll(_analyzeFinancialRisks(financialMetrics));
    
    // Analyze environmental risks
    risks.addAll(_analyzeEnvironmentalRisks(environmentalMetrics));
    
    // Analyze market risks
    risks.addAll(_analyzeMarketRisks(marketConditions));
    
    return risks;
  }

  static List<String> _analyzeFinancialRisks(Map<String, double> metrics) {
    List<String> risks = [];
    
    if (metrics['debtRatio'] != null && metrics['debtRatio']! > 0.7) {
      risks.add('High Debt Exposure');
    }
    
    if (metrics['liquidityRatio'] != null && metrics['liquidityRatio']! < 1.2) {
      risks.add('Low Liquidity');
    }
    
    if (metrics['roi'] != null && metrics['roi']! < 0.1) {
      risks.add('Low ROI');
    }
    
    return risks;
  }

  static List<String> _analyzeEnvironmentalRisks(Map<String, double> metrics) {
    List<String> risks = [];
    
    if (metrics['carbonEmissions'] != null && metrics['carbonEmissions']! > 500) {
      risks.add('High Carbon Emissions');
    }
    
    if (metrics['resourceDepletion'] != null && metrics['resourceDepletion']! > 0.6) {
      risks.add('Resource Depletion Risk');
    }
    
    if (metrics['climateRisk'] != null && metrics['climateRisk']! > 0.7) {
      risks.add('High Climate Risk');
    }
    
    return risks;
  }

  static List<String> _analyzeMarketRisks(Map<String, double> conditions) {
    List<String> risks = [];
    
    if (conditions['marketVolatility'] != null && conditions['marketVolatility']! > 0.5) {
      risks.add('High Market Volatility');
    }
    
    if (conditions['competitionLevel'] != null && conditions['competitionLevel']! > 0.8) {
      risks.add('High Competition');
    }
    
    if (conditions['regulatoryRisk'] != null && conditions['regulatoryRisk']! > 0.6) {
      risks.add('Regulatory Risk');
    }
    
    return risks;
  }
}