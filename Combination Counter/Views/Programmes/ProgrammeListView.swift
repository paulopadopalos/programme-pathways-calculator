//
//  ProgrammeListView.swift
//  Combination Counter
//
//  Created by Paul Brierley on 07/09/2021.
//

import SwiftUI

struct ProgrammeListView: View
{
  
  
  @EnvironmentObject var dataManager: DataManager
  
  
  // MARK: - Body
  
  
  var body: some View
  {
    VStack
    {
      List
      {
        ForEach (dataManager.programmes)
        {
          programme in
          NavigationLink(destination: ProgrammeEditor(programme: programme))
          {
            ProgrammeCell(programme: programme)
          }
        }
        .onDelete(perform: deleteProgramme)
      }
      HStack
      {
        Button(action: addNewProgramme)
        {
          Text("New Programme").padding()
        }
        Spacer()
        Button(action: sortByName)
        {
          Text("Sort by Name").padding()
        }
      }
    }
    .navigationTitle(Text("Programmes"))
  }
  
  
  // MARK: - Functions
  
  
  func deleteProgramme(at offsets: IndexSet)
  {
    self.dataManager.deleteProgramme(at: offsets)
  }
  
  
  func addNewProgramme()
  {
    let newProgramme = Programme(id: UUID(),
                                 name: "New Programme",
                                 creditRequirement: 120,
                                 choices: [])
    self.dataManager.add(programme: newProgramme)
  }
  
  
  func sortByName()
  {
    self.dataManager.sortProgrammes()
  }
  
  
}



// MARK: - Previews



struct ProgrammeListView_Previews: PreviewProvider
{
  static var previews: some View
  {
    ProgrammeListView()
      .environmentObject(DataManager())
  }
}
