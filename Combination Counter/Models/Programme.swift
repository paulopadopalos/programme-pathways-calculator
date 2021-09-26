//
//  Programme.swift
//  Combination Counter
//
//  Created by Paul Brierley on 07/09/2021.
//

import Foundation



struct Programme: Identifiable, Codable
{
  
  var id: UUID
  var name: String
  var creditRequirement: Int
  var choices: [Choice]
  
  
  var programmePathways: [[Module]]
  {
    // We start by getting together all the possible combinations of modules
    // which could be created from the various possible choices xfor this programme.
    var pathwaysWithCorrectCredits: [[Module]] = []
    var allPossibleCombinations: [[Module]] = []
    if self.choices.count > 0
    {
      // We start with the first Choice, and put all the module combinations
      // for that choice into our array of possible pathways. If the programme
      // only had one Choice, this would be our final result.
      allPossibleCombinations = self.choices[0].combinations
      // If there is more than one Choice available, we iterate over Choices.
      // Each time, we get a longer list of possible pathways since we're
      // duplicating what we already have but appending options from the latest
      // Choice we're looking at.
      if self.choices.count > 1
      {
        for i in 1..<self.choices.count
        {
          allPossibleCombinations = combineChoiceLists(originalArray: allPossibleCombinations,
                                                       arrayToAdd: self.choices[i].combinations)
        }
      }
      // Now we need to remove any combinations which contain the same module
      // more than once. To do this we convert the Array to a Set; a set can
      // only contain one instance of a given item. If the number of items in
      // the Set matches the number of items in the original Array then we don't
      // have any duplicates in the Set.
      // Note: this requires Module to conform to the Hashable protocol.
      var programmePathways: [[Module]] = []
      for combo in allPossibleCombinations
      {
        if combo.count == Set(combo).count
        {
          programmePathways.append(combo)
        }
      }
      // For some programmes, it may be possible to pick the same set of
      // Modules, but through a different series of decisions (e.g. if the same
      // Modules are available in different Choices). So we need to do some more
      // de-duplication. Firstly, we will ensure that the lists of Modules are
      // all sorted in the same order. We sort them by UUID since this is unique
      // for each Module, even if they have the same names.
      // Once sorted, we then use our Array -> Set conversion trick to get rid of
      // duplicates, and then convert the set back into an Array.
      for i in 0..<programmePathways.count
      {
        programmePathways[i].sort(by: {$0.id.uuidString < $1.id.uuidString } )
      }
      programmePathways = Array(Set(programmePathways))
      // We now have a set of pathways... but do they provide the correct
      // total number of credits for the programme? We need to get rid of any
      // pathways which do not.
      for pathway in programmePathways
      {
        var creditTotal: Int = 0
        for module in pathway
        {
          creditTotal += module.credits
        }
        if creditTotal == self.creditRequirement
        {
          pathwaysWithCorrectCredits.append(pathway)
        }
      }
    }
    return pathwaysWithCorrectCredits
  }
  
  
  
  func combineChoiceLists(originalArray: [[Module]], arrayToAdd: [[Module]]) -> [[Module]]
  {
    // This is a helper function for combining the lists of module choices someone
    // might make into a single array of pathways. It takes an existing array of module lists
    // and a new set of module lists.
    // For example, if our original list contains [[A,B], [C,D]]
    // and our new list contains [[E,F], [G,H]]
    // then the result will be [[A,B,E,F], [A,B,G,H], [C,D,E,F], [C,D,G,H]].
    var combinedArray: [[Module]] = []
    for entry in originalArray
    {
      for addition in arrayToAdd
      {
        let combinedEntries = entry + addition
        combinedArray.append(combinedEntries)
      }
    }
    return combinedArray
  }
  
  
  
  // MARK: - Preparing data for export via Share Sheet
  
  
  
  func combinationsForExport() -> String
  {
    var formattedText = ""
    for combo in self.programmePathways
    {
      var credits = 0
      var hours = 0
      for module in combo
      {
        formattedText = formattedText + module.code + ","
        credits = credits + module.credits
        hours = hours + module.hours
      }
      formattedText = formattedText + "\(credits) credits,\(hours) hours\n"
    }
    return formattedText
  }
  
  
  
}




