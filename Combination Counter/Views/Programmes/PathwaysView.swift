//
//  PathwaysView.swift
//  Combination Counter
//
//  Created by Paul Brierley on 13/09/2021.
//

import SwiftUI

struct PathwaysView: View
{
  
  @State var isPresentingShareSheet: Bool = false
  @Environment(\.presentationMode) var presentationMode
  
  var programme: Programme
  
  var body: some View
  {
    VStack
    {
      HStack
      {
        Spacer()
        Button(action:dismiss)
        {
          Image(systemName:"xmark.circle")
        }
        .padding()
      }
      Text("There are \(programme.programmePathways.count) unique pathways possible for \(programme.creditRequirement) credits on \(programme.name)")
        .padding(.leading, 10)
        .padding(.trailing,10)
      List
      {
        // programmePathways is [[Module]]
        ForEach (0..<programme.programmePathways.count)
        { pathwayIndex in
          HStack
          {
            Text(wordingForCombination(pathway: programme.programmePathways[pathwayIndex]))
              .bold()
            Spacer()
            VStack
            {
              let credits = creditsForCombination(pathway: programme.programmePathways[pathwayIndex])
              let hours = hoursForCombination(pathway: programme.programmePathways[pathwayIndex])
              Text("\(credits) credits")
                .font(.system(size: 12.0, weight: .bold))
                .lineLimit(1)
                .foregroundColor(.white)
                .padding(5)
                .background(Color.blue)
                .cornerRadius(5)
                .overlay(RoundedRectangle(cornerRadius: 5)
                .stroke(Color.black, lineWidth: 1))
              Text("\(hours) hours")
                .font(.system(size: 12.0, weight: .bold))
                .lineLimit(1)
                .foregroundColor(.white)
                .padding(5)
                .background(Color.blue)
                .cornerRadius(5)
                .overlay(RoundedRectangle(cornerRadius: 5)
                .stroke(Color.black, lineWidth: 1))
            }

          }
        }
      }
      Spacer()
      Button(action:exportCombinations)
      {
        Image(systemName:"square.and.arrow.up")
        Text("Export Combinations")
      }
      .sheet(isPresented: $isPresentingShareSheet,
             content:
              {
                ShareSheet (activityItems: [self.programme.combinationsForExport()])
              })
      .padding()
    }
  }
  
  
  
  func exportCombinations()
  {
    self.isPresentingShareSheet = true
  }
  
  
  
  func wordingForCombination(pathway: [Module]) -> String
  {
    var wording = ""
    wording = pathway[0].code
    for index in 1..<pathway.count
    {
      wording = wording + ", " + pathway[index].code
    }
    return wording
  }
  
  
  
  func creditsForCombination(pathway: [Module]) -> Int
  {
    var totalCredits = 0
    for module in pathway
    {
      totalCredits += module.credits
    }
    return totalCredits
  }
  
  
  
  func hoursForCombination(pathway: [Module]) -> Int
  {
    var totalHours = 0
    for module in pathway
    {
      totalHours += module.hours
    }
    return totalHours
  }
  
  
  
  func dismiss()
  {
    self.presentationMode.wrappedValue.dismiss()
  }
  
  
  
}



// MARK: - Previews



struct PathwaysView_Previews: PreviewProvider {
    static var previews: some View {
      PathwaysView(programme: Programme(id: UUID(),
                                        name: "A Sample Programme",
                                        creditRequirement: 120,
                                        choices: []))
    }
}
