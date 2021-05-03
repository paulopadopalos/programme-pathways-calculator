//
//  ChoicesManager.swift
//  Combination Counter
//
//  Created by Paul Brierley on 25/02/2021.
//

import Foundation



class ChoicesManager: ObservableObject {
   
    
    
    @Published var moduleList: [Module]
    @Published var choiceList: [Choice]
    @Published var programmeCombinations: [[String]]
    

    
    // MARK: - Managing module list.
    
    
    
    func add(module: Module) {
        self.moduleList.append(module)
    }
    
    
    
    func deleteModule(at offsets: IndexSet) -> Bool {
        // We can only delete a module if it's not currently being
        // used by any of the choices.
        var moduleIsInUse = false
        for choice in self.choiceList {
            for combo in choice.combinations {
                for name in combo {
                    for idx in offsets {
                        if name == self.moduleList[idx].name {
                            moduleIsInUse = true
                        }
                    }
                }
            }
        }
        if moduleIsInUse == true {
            return false
        } else {
            self.moduleList.remove(atOffsets: offsets)
            return true
        }
    }
    
    
    
    // MARK: - Managing choice list.
    
    
    
    func add(choice: Choice) {
        self.choiceList.append(choice)
    }
    
    
    
    func deleteChoice(at offsets:IndexSet) {
        self.choiceList.remove(atOffsets: offsets)
    }
    
    
    
    // MARK: - Saving and loading.
    
    
    
    init() {
        self.moduleList = []
        self.choiceList = []
        self.programmeCombinations = []
        let decoder = JSONDecoder()
        let documentsFolderURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let moduleFileURL = documentsFolderURL.appendingPathComponent("moduleList.json")
        if let decodedModuleData = try? Data.init(contentsOf: moduleFileURL) {
            if let loadedModuleData = try? decoder.decode([Module].self, from: decodedModuleData) {
                self.moduleList = loadedModuleData
            }
        }
        let choiceFileURL = documentsFolderURL.appendingPathComponent("choiceList.json")
        if let decodedChoiceData = try? Data.init(contentsOf: choiceFileURL) {
            if let loadedChoiceData = try? decoder.decode([Choice].self, from: decodedChoiceData) {
                self.choiceList = loadedChoiceData
            }
        }
        self.programmeCombinations = []
    }
    
    
    
    func save() {
        let encoder = JSONEncoder()
        let documentsFolderURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let moduleFileURL = documentsFolderURL.appendingPathComponent("moduleList.json")
        if let encodedModuleData = try? encoder.encode(self.moduleList) {
            do {
                try encodedModuleData.write(to: moduleFileURL, options: .atomic)
            }
            catch {
                print(error.localizedDescription)
            }
        } else {
            print("Encoding  of modules failed")
        }
        let choiceFileURL = documentsFolderURL.appendingPathComponent("choiceList.json")
        if let encodedChoiceData = try? encoder.encode(self.choiceList) {
            do {
                try encodedChoiceData.write(to: choiceFileURL, options: .atomic)
            }
            catch {
                print(error.localizedDescription)
            }
        } else {
            print ("Encoding of choices failed")
        }
        
    }
    
    
    
}



// MARK: -
private typealias CombinationHelpers = ChoicesManager
extension CombinationHelpers  {
    
    
    
    func calculateProgrammeChoices() {
        self.programmeCombinations = []
        var allPossibleCombinations: [[String]] = []
        if self.choiceList.count > 0 {
            allPossibleCombinations = self.choiceList[0].combinations
            if self.choiceList.count > 1 {
                for i in 1..<choiceList.count {
                    allPossibleCombinations = combine(originalArray: allPossibleCombinations,
                                               arrayToAdd: self.choiceList[i].combinations)
                }
            }
        }
        // We now need to remove any combinations which contain duplicate modules.
        for combo in allPossibleCombinations {
            if combo.count == Set(combo).count {
                self.programmeCombinations.append(combo)
            }
        }
        
    }
    
    
    
    func combine(originalArray: [[String]], arrayToAdd: [[String]]) -> [[String]] {
        
        var combinedArray: [[String]] = []
        
        for entry in originalArray {
            for addition in arrayToAdd {
                let combinedEntries = entry + addition
                combinedArray.append(combinedEntries)
            }
        }
        
        return combinedArray
    }
    
    
    
}
