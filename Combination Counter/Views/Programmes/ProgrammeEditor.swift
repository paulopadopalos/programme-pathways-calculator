//
//  ProgrammeEditor.swift
//  Combination Counter
//
//  Created by Paul Brierley on 08/09/2021.
//

import SwiftUI

struct ProgrammeEditor: View
{
  
  @EnvironmentObject var dataManager: DataManager
  @State var isShowingResultsView: Bool = false
  
  var programme: Programme
  
  var indexForProgramme: Int
  {
    dataManager.programmes.firstIndex(where: { $0.id == programme.id })!
  }
  
  
  // MARK: - Body
  
  
  var body: some View
  {
    VStack {
      Form
      {
        Section(header: Text("Programme Details"))
        {
          TextField("Programme Name",
                    text: $dataManager.programmes[indexForProgramme].name)
          Stepper(value: $dataManager.programmes[indexForProgramme].creditRequirement)
          {
            Text("\(dataManager.programmes[indexForProgramme].creditRequirement) credits required")
          }
        }
        Section(header: Text("Programme Choices"))
        {
          List
          {
            ForEach(dataManager.programmes[indexForProgramme].choices)
            {
              choice in
              NavigationLink(destination: ChoiceEditor(programme: programme,
                                                       choice: choice))
              {
                VStack
                {
                  Text("\(choice.description) (\(choice.numberOfCombinations) combinations)")
                    .italic()
                }
              }
            }
            .onDelete(perform: deleteChoice)
          }
        }
      }
      HStack
      {
        Button("New Choice", action: addNewChoice)
        Spacer()
        Button("Pathways", action:showResults)
      }
      .padding()
    }
    .navigationTitle("Edit Programme")
    .sheet(isPresented: $isShowingResultsView,
           content: { PathwaysView(programme: dataManager.programmes[indexForProgramme]) })
  }
  
  
  // MARK: - Functions
  
  
  func increaseCredits()
  {
    dataManager.programmes[indexForProgramme].creditRequirement += 1
  }
  
  
  func decreaseCredits()
  {
    if dataManager.programmes[indexForProgramme].creditRequirement > 0
    {
      dataManager.programmes[indexForProgramme].creditRequirement -= 1
    }
  }
  
  
  func addNewChoice()
  {
    let newChoice = Choice(id: UUID(),
                           low: 10,
                           high: 20,
                           modules: [],
                           rangeOrExact: RangeOrExact.exact.rawValue,
                           modulesOrCredits: ModulesOrCredits.modules.rawValue)
    dataManager.programmes[indexForProgramme].choices.append(newChoice)
  }
  
  
  func deleteChoice(at offsets: IndexSet)
  {
    dataManager.programmes[indexForProgramme].choices.remove(atOffsets: offsets)
  }
  
  
  func showResults()
  {
    // Show modal window.
    self.isShowingResultsView = true
  }
  
}



// MARK: - Previews



struct ProgrammeEditor_Previews: PreviewProvider
{
  static var previews: some View
  {
    ProgrammeEditor(programme: Programme(id: UUID(),
                                         name: "Some New Programme",
                                         creditRequirement: 120,
                                         choices: []))
      .environmentObject(DataManager())
  }
}
