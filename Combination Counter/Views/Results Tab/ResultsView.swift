//
//  ResultsView.swift
//  Combination Counter
//
//  Created by Paul Brierley on 25/02/2021.
//

import SwiftUI

struct ResultsView: View {
    
    
    
    @EnvironmentObject var choicesManager: ChoicesManager
    
    @State var numberOfCombinations: Int = 0
    
    @State var isCalculating: Bool = false
    @State var isPresentingShareSheet: Bool = false
    
    
    
    // MARK: - User Interface
    
    
    
    var body: some View {
        
        VStack {
            
            // Header to aid user navigation.
            HStack {
                Text("Pathways")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                Spacer()
            }
            
            // Button for triggering the calculation.
            Button (action: calculateCombinations) {
                Text("Calculate Combinations")
                    .padding()
            }
            .disabled(isCalculating == true)
                        
            if (isCalculating) {
                ProgressView("Calculating...")
            } else {
                Text("There are \(numberOfCombinations) pathways through this programme.")
            }
            
            // List of combinations
            List {
                ForEach(choicesManager.programmeCombinations, id:\.self) { myCombo in
                    HStack {
                        Text(wordingForCombination(combo: myCombo))
                            .fontWeight(.heavy)
                        Spacer()
                        VStack {
                            Text("\(creditsFor(combination: myCombo)) credits")
                                .font(.system(size: 12.0, weight: .bold))
                                .lineLimit(1)
                                .foregroundColor(.white)
                                .padding(5)
                                .background(Color.green)
                                .cornerRadius(5)
                                .overlay(RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.black, lineWidth: 1))
                            Text("\(hoursFor(combination: myCombo)) hours")
                                .font(.system(size: 12.0, weight: .bold))
                                .lineLimit(1)
                                .foregroundColor(.white)
                                .padding(5)
                                .background(Color.green)
                                .cornerRadius(5)
                                .overlay(RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.black, lineWidth: 1))
                        }
                    }
                    .padding(10)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .overlay(RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.black, lineWidth:2))
                }
            }
            Button(action:exportCombinations) {
                Image(systemName:"square.and.arrow.up")
                Text("Export Combinations")
            }
            .padding()
            .sheet(isPresented: $isPresentingShareSheet,
                   content: { ShareSheet (activityItems: [self.choicesManager.combinationsForExport()])})
            
        }
        
    }
    
    
    
    // MARK: - Helper functions.
  
    
    
    func wordingForCombination(combo: [String]) -> String {
        var textToDisplay = ""
        for i in 0..<(combo.count - 1) {
            textToDisplay = textToDisplay + combo[i] + ", "
        }
        textToDisplay = textToDisplay + (combo.last ?? "")
        return textToDisplay
    }
    
    
    
    func creditsFor(combination:[String]) -> Int {
        var credits = 0
        for moduleCode in combination {
            if let thisModule = self.choicesManager.moduleList.first(where: { $0.code == moduleCode }) {
                credits += thisModule.credits
            }
        }
        return credits
    }
    
    
    
    func hoursFor(combination:[String]) -> Int {
        var hours = 0
        for moduleCode in combination {
            if let thisModule = self.choicesManager.moduleList.first(where: { $0.code == moduleCode }) {
                hours += thisModule.hours
            }
        }
        return hours
    }
    
    
    
    func calculateCombinations() {
        self.isCalculating = true
        self.choicesManager.calculateProgrammeChoices()
        self.numberOfCombinations = choicesManager.programmeCombinations.count
        self.isCalculating = false
    }
    
    
    
    func exportCombinations() {
        self.isPresentingShareSheet = true
    }
    
    
    
}



// MARK: - Previews



struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView()
            .environmentObject(ChoicesManager())
    }
}
