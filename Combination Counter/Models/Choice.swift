//
//  Choice.swift
//  Combination Counter
//
//  Created by Paul Brierley on 27/02/2021.
//

import Foundation
import SwiftUI



// MARK: - Class for representing choices.



class Choice: Identifiable, ObservableObject, Codable {
    
    
    
    @Published var modules: [Module]
    @Published var choiceType: ChoiceType
    @Published var choiceNumber: Int
    @Published var combinationCount: Int
    @Published var combinations: [[String]]
    var id: UUID
    
    
    
    // MARK: - Saving and Loading
    
    
    
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
    
    
    
    // MARK: - Functions for calculation of combinations
    
    
    
    func calculateCombinations() {
        
        var validCombinations: [[String]] = []
        
        // What we do depends upon whether this choice is for
        // a number of credits, or a number of units.
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
                // This case is complicated. It's choose m from n, for all value of m
                // from 1 to n. We then have to validate each choice for whether it gives us sufficient credits.
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
        print(validCombinations)
        self.combinations = validCombinations
        self.combinationCount = validCombinations.count
    }
    
    
    
    /// Code taken from Rosetta Code: https://rosettacode.org/wiki/Combinations#Swift
    func addCombo(prevCombo: [Int], pivotList: [Int]) -> [([Int], [Int])] {
        var thisList = pivotList
        return (0..<thisList.count).map { _ -> ([Int], [Int]) in
            (prevCombo + [thisList.remove(at:0)], thisList)
        }
    }
    
    /// Code taken from Rosetta Code. This function is called for choosing m items from a list of n.
    func combosOfLength(n: Int, m: Int) -> [[Int]] {
        return [Int](1...m).reduce([([Int](), [Int](0..<n))]) { (accum, _) in
          accum.flatMap(addCombo)
        }.map {
          $0.0
        }
    }

  
    
}



// MARK: - enum for types of choice



enum ChoiceType: Int, CaseIterable, Codable {
    
    case module
    case credit
    
    func niceName() -> String {
        switch(self) {
            case .module:
                return "Modules"
            case .credit:
                return "Credits"
        }
    }
    
    var name: String {
        get { return niceName() }
    }

}



///
/// This code was found on StackOverflow, answering a question about finding combinations
/// with repetition using Swift 5. We can make use of this if we look for all combinations
/// and include "nothing" as an option. We can then exclude any combination which doesn't
/// provide the correct number of credits, and any combination which includes the same
/// module more than once.
/// https://stackoverflow.com/questions/57232327/finding-all-combinations-in-an-array-swift-5-with-enumeration
///
struct CombinationsWithRepetition<C: Collection> : Sequence {

    let base: C
    let length: Int

    init(of base: C, length: Int) {
        self.base = base
        self.length = length
    }

    struct Iterator : IteratorProtocol {
        let base: C

        var firstIteration = true
        var finished: Bool
        var positions: [C.Index]

        init(of base: C, length: Int) {
            self.base = base
            finished = base.isEmpty
            positions = Array(repeating: base.startIndex, count: length)
        }

        mutating func next() -> [C.Element]? {
            if firstIteration {
                firstIteration = false
            } else {
                // Update indices for next combination.
                finished = true
                for i in positions.indices.reversed() {
                    base.formIndex(after: &positions[i])
                    if positions[i] != base.endIndex {
                        finished = false
                        break
                    } else {
                        positions[i] = base.startIndex
                    }
                }

            }
            return finished ? nil : positions.map { base[$0] }
        }
    }

    func makeIterator() -> Iterator {
        return Iterator(of: base, length: length)
    }
}
