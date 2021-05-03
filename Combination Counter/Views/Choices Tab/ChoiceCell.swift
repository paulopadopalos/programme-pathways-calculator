//
//  ChoiceCell.swift
//  Combination Counter
//
//  Created by Paul Brierley on 27/02/2021.
//

import SwiftUI

struct ChoiceCell: View {
    
    
    
    var choice: Choice
    
    
    
    var body: some View {
        VStack {
            HStack {
                Text(choiceLabel())
                    .italic()
                Spacer()
            }
            Text(textFor(choice: choice))
                .fontWeight(.bold)
                .fixedSize(horizontal: false, vertical: true)
            HStack {
                Spacer()
                Text("\(choice.combinationCount) possible combinations.")
                    .font(.caption)
                    .padding(2)
            }
        }
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
        label = label + " from the following"
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
    
    
    
}



// MARK: - Previews



struct ChoiceCell_Previews: PreviewProvider {
    static var previews: some View {
        ChoiceCell(choice: Choice())
    }
}
