//
//  ChoiceEditor.swift
//  Combination Counter
//
//  Created by Paul Brierley on 08/09/2021.
//

import SwiftUI

struct ChoiceEditor: View
{
  
  @EnvironmentObject var dataManager: DataManager
  var rangeOrExactLabels = ["Between", "Exactly"]
  var modulesOrCreditsLabels = ["Modules", "Credits"]
  var programme: Programme
  var choice: Choice
  
  
  
  // MARK: - Body
  
  
  var body: some View
  {
    Form
    {
      Section(header:Text("Type of Choice"))
      {
        Picker("", selection: $dataManager.programmes[indexForProgramme].choices[indexForChoice].rangeOrExact)
        {
          ForEach(0..<self.rangeOrExactLabels.count)
          {
            Text(self.rangeOrExactLabels[$0])
          }
        }
        .pickerStyle(SegmentedPickerStyle())
        HStack
        {
          Spacer()
          Stepper("\(dataManager.programmes[indexForProgramme].choices[indexForChoice].low)", value:$dataManager.programmes[indexForProgramme].choices[indexForChoice].low)
          Spacer()
        }
        if (dataManager.programmes[indexForProgramme].choices[indexForChoice].rangeOrExact == RangeOrExact.range.rawValue)
        {
        
            HStack
            {
              Spacer()
              Text ("and").italic()
              Spacer()
            }.animation(.easeInOut)
            HStack
            {
              Spacer()
              Stepper("\(dataManager.programmes[indexForProgramme].choices[indexForChoice].high)", value:$dataManager.programmes[indexForProgramme].choices[indexForChoice].high)
              Spacer()
            }.animation(.easeInOut)
        }
        Picker("Choose", selection: $dataManager.programmes[indexForProgramme].choices[indexForChoice].modulesOrCredits)
        {
          ForEach(0..<self.modulesOrCreditsLabels.count)
          {
            Text(self.modulesOrCreditsLabels[$0])
          }
        }
        .pickerStyle(SegmentedPickerStyle())
      }
      Section(header:Text("Course Units"))
      {
        ForEach(dataManager.allModules)
        {
          module in
          HStack
          {
            Text(module.name)
            Spacer()
            if (isModuleSelected(module:module) == true)
            {
              Image(systemName:"checkmark")
            }
          }
          .onTapGesture { didTapModule(module: module) }
        }
      }
    }
    .navigationTitle("Edit Choice")
  }
  
  
  // MARK: - Functions
  
  
  var indexForProgramme: Int
  {
    dataManager.programmes.firstIndex(where: { $0.id == programme.id })!
  }
  
  var indexForChoice: Int
  {
    dataManager.programmes[indexForProgramme].choices.firstIndex(where: { $0.id == choice.id })!
  }
  
  func isModuleSelected(module:Module) -> Bool
  {
    if dataManager.programmes[indexForProgramme].choices[indexForChoice].modules.firstIndex(where: {$0.id == module.id}) != nil
    {
      return true
    }
    return false
  }
  
  func didTapModule(module:Module) {
    if let indexForModule =  dataManager.programmes[indexForProgramme].choices[indexForChoice].modules.firstIndex(where: {$0.id == module.id})
    {
      // Remove the module from this choice.
      dataManager.programmes[indexForProgramme].choices[indexForChoice].modules.remove(at: indexForModule)
    }
    else
    {
      // Add the module to this choice.
      dataManager.programmes[indexForProgramme].choices[indexForChoice].modules.append(module)
    }
  }
  
}



// MARK: - Previews



struct ChoiceEditor_Previews: PreviewProvider
{
  static var previews: some View
  {
    ChoiceEditor(programme: Programme(id: UUID(),
                                      name: "Some Programme",
                                      creditRequirement: 120,
                                      choices: []),
                 choice: Choice(id: UUID(),
                                low: 10,
                                high: 50,
                                modules: [],
                                rangeOrExact: RangeOrExact.exact.rawValue,
                                modulesOrCredits: ModulesOrCredits.modules.rawValue))
      .environmentObject(DataManager())
  }
}
