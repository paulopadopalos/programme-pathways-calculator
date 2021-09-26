//
//  Choice.swift
//  Combination Counter
//
//  Created by Paul Brierley on 27/02/2021.
//

import Foundation
import Algorithms


struct Choice: Identifiable, Codable
{
  
  var id: UUID
  var low: Int
  var high: Int
  var modules: [Module]
  var rangeOrExact: Int
  var modulesOrCredits: Int
  
  var description: String
  {
    var text = ""
    switch(rangeOrExact)
    {
      case RangeOrExact.range.rawValue:
        text = "Choose \(low) to \(high) "
      default:
        text = "Choose \(low) "
    }
    switch(modulesOrCredits)
    {
      case ModulesOrCredits.modules.rawValue:
        text = text + "modules "
      default:
        text = text + "credits "
    }
    text = text + "from \(modules.count) modules."
    return text
  }
  
  var numberOfCombinations: Int
  {
    return self.combinations.count
  }
  
  
  var combinations: [[Module]]
  {
    // Four possible ways we need to calculate combinations
    // 1. Pick X modules.
    // 2. Pick X to Y modules.
    // 3. Pick X credits.
    // 4. Pick X to Y credits.
    var combinations:[[Module]] = []
    // If there are no modules selected for this choice, we can shortcut
    // this whole section of code.
    if self.modules.count == 0
    {
      return combinations
    }
    switch (rangeOrExact, modulesOrCredits)
    {
      case (RangeOrExact.exact.rawValue, ModulesOrCredits.modules.rawValue):
        // Scenario 1. Pick X modules.
        let combos = self.modules.combinations(ofCount: low)
        for combo in combos
        {
          combinations.append(combo)
        }
        break
      case (RangeOrExact.range.rawValue, ModulesOrCredits.modules.rawValue):
        // Scenario 2. Pick X to Y modules.
        let combos = self.modules.combinations(ofCount: low...high)
        for combo in combos
        {
          combinations.append(combo)
        }
        break
      case (RangeOrExact.exact.rawValue, ModulesOrCredits.credits.rawValue):
        // Scenario 3. Pick X credits.
        let combos = self.modules.combinations(ofCount: 1...self.modules.count)
        for combo in combos
        {
          var credits = 0
          for module in combo
          {
            credits += module.credits
          }
          if (credits == self.low)
          {
            combinations.append(combo)
          }
        }
        break
      default:
        // Scenario 4. Pick X to Y credits.
        let combos = self.modules.combinations(ofCount: 1...self.modules.count)
        for combo in combos
        {
          var credits = 0
          for module in combo
          {
            credits += module.credits
          }
          if ((credits >= self.low) && (credits <= self.high))
          {
            combinations.append(combo)
          }
        }
      break
    }
    return combinations
  }
  
  
  
}



enum RangeOrExact: Int
{
  case range = 0
  case exact = 1
}



enum ModulesOrCredits: Int
{
  case modules = 0
  case credits = 1
}





/*class Choice: Identifiable, ObservableObject, Codable {
    
    
    
    @Published var modules: [Module]
    @Published var choiceType: ChoiceType
    @Published var choiceNumber: Int
    @Published var combinationCount: Int
    @Published var combinations: [[String]]
    var id: UUID

    
    
    init() {
        id = UUID()
        choiceType = .module
        choiceNumber = 1
        modules = []
        combinationCount = 0
        combinations = []
    }
    
    
    
    enum CodingKeys: CodingKey {
        case id
        case choiceType
        case choiceNumber
        case modules
        case combinationCount
        case combinations
    }
    
    
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        choiceType = try container.decode(ChoiceType.self, forKey: .choiceType)
        choiceNumber = try container.decode(Int.self, forKey: .choiceNumber)
        modules = try container.decode(Array.self, forKey: .modules)
        combinationCount = try container.decode(Int.self, forKey: .combinationCount)
        combinations = try container.decode(Array.self, forKey: .combinations)
    }
    
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(choiceType, forKey: .choiceType)
        try container.encode(choiceNumber, forKey: .choiceNumber)
        try container.encode(modules, forKey: .modules)
        try container.encode(combinationCount, forKey: .combinationCount)
        try container.encode(combinations, forKey: .combinations)
    }
    
    
	
}



private typealias CombinationCalculations = Choice
extension CombinationCalculations {
    
    func calculateCombinations() {
        
        var validCombinations: [[String]] = []
        
        switch (self.choiceType) {
            
            case .module:
                // This case is simple. It's just choose m from n.
                let comboIndices = combosOfLength(n: self.modules.count, m: self.choiceNumber)
                for indexSet in comboIndices {
                    var newCombination: [String] = []
                    for index in indexSet {
                        newCombination.append(self.modules[index].code)
                    }
                    validCombinations.append(newCombination)
                }
            
            case .credit:
                // This case is complicated. It's choose m from n, for all values of m between 1 and n.
                // We then have to validate each choice for whether it contains sufficient credits.
                for counter in 1...self.modules.count {
                    let comboIndices = combosOfLength(n: self.modules.count, m: counter)
                    for indexSet in comboIndices {
                        var newCombination: [String] = []
                        for index in indexSet {
                            newCombination.append(self.modules[index].code)
                        }
                        var creditsForThisCombo: Int = 0
                        for moduleCode in newCombination {
                            if let thisModule = self.modules.first(where: { $0.code == moduleCode }) {
                                creditsForThisCombo += thisModule.credits
                            }
                        }
                        if creditsForThisCombo == self.choiceNumber {
                            validCombinations.append(newCombination)
                        }
                    }
                }
        }
        self.combinations = validCombinations
        self.combinationCount = validCombinations.count
    }
    
}



private typealias RosettaCode = Choice
extension RosettaCode {
    // The code is this extension is taken from the Rosetta Code website.
    // https://rosettacode.org/wiki/Combinations
    // The two functions allow us to determine the combinations of size m
    // of the integers between 0 and n-1. We can then use these combinations
    // of integers to pick modules from a list.
    
    func combosOfLength(n: Int, m: Int) -> [[Int]] {
        return [Int](1...m).reduce([([Int](), [Int](0..<n))]) { (accum, _) in
          accum.flatMap(addCombo)
        }.map { $0.0 }
    }
    
    func addCombo(prevCombo: [Int], pivotList: [Int]) -> [([Int], [Int])] {
        var thisList = pivotList
        return (0..<thisList.count).map { _ -> ([Int], [Int]) in
            (prevCombo + [thisList.remove(at:0)], thisList)
        }
    }
    
}



*/
