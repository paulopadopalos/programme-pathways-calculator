//
//  ModuleListView.swift
//  Combination Counter
//
//  Created by Paul Brierley on 25/02/2021.
//

import SwiftUI



struct ModuleListView: View
{

  @EnvironmentObject var dataManager: DataManager
  @State private var isShowingModuleEditor: Bool = false
  @State private var isShowingDeleteFail: Bool = false
    
  var body: some View
  {
    VStack
    {
      List
      {
        ForEach (dataManager.allModules)
        {
          myModule in
          ModuleCell(module: myModule)
        }
        .onDelete(perform: deleteModule)
        .alert(isPresented: $isShowingDeleteFail)
        {
          () -> Alert in
          Alert(title: Text("Unable to delete module"),
              message: Text("This module is currently part of a choice group. Delete the choice group, then try deleting the module again."))
        }
      }
      HStack
      {
        Button (action: addNewModule)
        {
          Text("Add New Module").padding()
        }
        .sheet(isPresented: $isShowingModuleEditor,
               content: { self.newModuleSheet })
        Spacer()
        Button (action: sortModules)
        {
          Text("Sort by Code").padding()
        }
      }
    }.navigationTitle("Modules")
  }
  
  // MARK: - Functions for managing module list.
    
  func addNewModule()
  {
    self.isShowingModuleEditor.toggle()
  }
  
  func sortModules()
  {
    self.dataManager.sortModules()
  }
    
  func deleteModule(at offsets: IndexSet)
  {
    let deleteSuccess = self.dataManager.deleteModule(at: offsets)
    if deleteSuccess == false
    {
      isShowingDeleteFail = true
    }
  }
    
    
    
    // MARK: - Helper views

    
    
    var newModuleSheet : some View
    {
        ModuleEditor(completionHandler:
                      { newModule in
                        self.dataManager.add(module: newModule)
                        self.isShowingModuleEditor = false
                      })
    }
    
}



// MARK: - Previews



struct ModuleListView_Previews: PreviewProvider
{
  static var previews: some View
  {
    ModuleListView().environmentObject(DataManager())
  }
}
