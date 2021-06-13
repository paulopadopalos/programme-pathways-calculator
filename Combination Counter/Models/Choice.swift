//
//  Choice.swift
//  Combination Counter
//
//  Created by Paul Brierley on 27/02/2021.
//

import Foundation
import SwiftUI



// This class represents a choice, which is part of the a degree programme.
// The choice can take one of two forms - either select a certain number of modules
// from a list, or select modules whose combined credit value meets a specific criterion.



class Choice: Identifiable, ObservableObject, Codable {
    
    
    
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



// MARK:-
// This custom enum just gives us a neat way of distinguishing between whether
// a specific choice is about choosing a certain number of credits or a certain
// number of modules.



enum ChoiceType: Int, CaseIterable, Codable {
    
    case module
    case credit
    
    var name: String {
        get {
            switch(self) {
            case .module:
                return "Modules"
            case .credit:
                return "Credits"
            }
        }
    }

}
