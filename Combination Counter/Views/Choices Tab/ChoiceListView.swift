//
//  ChoiceListView.swift
//  Combination Counter
//
//  Created by Paul Brierley on 25/02/2021.
//

import SwiftUI



struct ChoiceListView: View {
    
    
    
    @EnvironmentObject var choicesManager: ChoicesManager
    
    @State var isShowingNewChoiceEditor: Bool = false
    
    
    
    var body: some View {
        VStack {
            
            // Header to aid user navigation.
            Text("Choices")
                .font(.headline)
            
            // List of modules.
            List {
                ForEach(choicesManager.choiceList) { myChoice in
                    ChoiceCell(choice: myChoice)
                }
                .onDelete(perform: deleteChoice)
            }
            
            // Button at bottom for creating new modules.
            HStack {
                Button (action: addNewEntry) {
                    Text("Add New Choice")
                        .padding()
                }
                .sheet(isPresented: $isShowingNewChoiceEditor,
                       content: { self.newChoiceSheet })
            }
            
        }
    }
    
    
    
    // MARK: - Actions
    
    
    func addNewEntry() {
        isShowingNewChoiceEditor.toggle()
    }
    
    
    
    func deleteChoice(at offsets: IndexSet) {
        self.choicesManager.deleteChoice(at: offsets)
    }
    
    
    
    // MARK: - Helper views

    
    
    var newChoiceSheet : some View {
        ChoiceEditor(completionHandler: { newChoice in
            newChoice.calculateCombinations()
            self.choicesManager.add(choice: newChoice)
            self.isShowingNewChoiceEditor = false
        })
    }
    
    
    
    
    
    
}



// MARK: - Previews



struct ChoiceListView_Previews: PreviewProvider {
    static var previews: some View {
        ChoiceListView()
    }
}
