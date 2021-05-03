//
//  ModuleListView.swift
//  Combination Counter
//
//  Created by Paul Brierley on 25/02/2021.
//

import SwiftUI



struct ModuleListView: View {

    
    
    @EnvironmentObject var choicesManager: ChoicesManager
    
    @State private var isShowingModuleEditor: Bool = false
    @State private var isShowingDeleteFail: Bool = false
        

    
    var body: some View {
        VStack {
            
            // Header to aid user navigation.
            Text("Modules")
                .font(.headline)
            
            // List of modules.
            List {
                ForEach (choicesManager.moduleList) { myModule in
                    ModuleCell(module: myModule)
                }
                .onDelete(perform: deleteModule)
                .alert(isPresented: $isShowingDeleteFail) { () -> Alert in
                    Alert(title: Text("Unable to delete module"),
                          message: Text("This module is currently part of a choice group. Delete the choice group, then try deleting the module again."))
                }
            }
            
            // Button at bottom for creating new modules.
            HStack {
                Button (action: addNewModule) {
                    Text("Add New Module")
                        .padding()
                }
                .sheet(isPresented: $isShowingModuleEditor,
                       content: { self.newModuleSheet })
            }
            
        }
    }
    
    
    
    // MARK: - Functions
    
    
    
    func addNewModule(){
        self.isShowingModuleEditor.toggle()
    }
    
    
    
    func deleteModule(at offsets: IndexSet){
        let deleteSuccess = self.choicesManager.deleteModule(at: offsets)
        if deleteSuccess == false {
            isShowingDeleteFail = true
        }
    }
    
    
    
    // MARK: - Helper views

    
    
    var newModuleSheet : some View {
        ModuleEditor(completionHandler: { newModule in
            self.choicesManager.add(module: newModule)
            self.isShowingModuleEditor = false
        })
    }
    
    
    
}



// MARK: - Previews



struct ModuleListView_Previews: PreviewProvider {
    static var previews: some View {
        ModuleListView()
            .environmentObject(ChoicesManager())
    }
}
