//
//  ChoiceCell.swift
//  Combination Counter
//
//  Created by Paul Brierley on 27/02/2021.
//

import SwiftUI

struct ChoiceCell: View {
    
    
    
    @EnvironmentObject var choicesManager: ChoicesManager
    
    
    
    @ObservedObject var choice: Choice
    
    
    
    @State var isShowingChoiceEditor: Bool = false
    
    
    
    var body: some View {
        VStack {
            HStack {
                Text(choiceLabel())
                    .font(.body)
                Spacer()
                Text("\(choice.combinationCount) combinations.")
                    .font(.system(size: 12.0, weight: .bold))
                    .foregroundColor(.white)
                    .padding(5)
                    .background(Color.green)
                    .cornerRadius(5)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.black, lineWidth: 1))
                
            }
            Text(textFor(choice: choice))
                .fontWeight(.bold)
                .fixedSize(horizontal: false, vertical: true)

        }
        .padding(10)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .overlay(RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.black, lineWidth:2))
        .onTapGesture(perform: didPressToEdit)
        .sheet(isPresented: $isShowingChoiceEditor,
               content: { self.editChoiceSheet } )
    }
    
    
    
    // MARK: - Helper functions
    
    
    
    func choiceLabel() -> String {
        var label = "Choose \(choice.choiceNumber) "
        switch choice.choiceType {
            case .credit:
                label = label + "credit"
            case .module:
                label = label + "unit"
        }
        if (choice.choiceNumber > 1) {
            label = label + "s"
        }
        label = label + " from:"
        return label
    }
    
    
    
    func textFor(choice: Choice) -> String {
        var stringToDisplay = ""
        switch (choice.modules.count) {
            case 0:
                stringToDisplay = "No modules selected."
            case 1:
                stringToDisplay = choice.modules[0].code
            default:
                for i in 0 ..< (choice.modules.count - 1) {
                    stringToDisplay += choice.modules[i].code
                    stringToDisplay += ", "
                }
                stringToDisplay += choice.modules[choice.modules.count - 1].code
        }
        return stringToDisplay
    }
    
    
    
    func didPressToEdit(){
        self.isShowingChoiceEditor = true
    }
    
    
    
    // MARK: - Helper views

    
    
    var editChoiceSheet : some View {
        ChoiceEditor(choice: self.choice,
                     completionHandler: { newChoice in
                        newChoice.calculateCombinations()
                        self.isShowingChoiceEditor = false
        })
    }
    
    
    
}



// MARK: - Previews



struct ChoiceCell_Previews: PreviewProvider {
    static var previews: some View {
        ChoiceCell(choice: Choice())
    }
}
