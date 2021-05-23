//
//  ChoiceEditor.swift
//  Combination Counter
//
//  Created by Paul Brierley on 27/02/2021.
//

import SwiftUI

struct ChoiceEditor: View {
    
    
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var choicesManager: ChoicesManager
    
    @ObservedObject var choice: Choice
    
    @State private var choiceType = ChoiceType.allCases[0]
    
    private let completionHandler: (Choice) -> Void
    
    
    
    init(completionHandler: @escaping ((Choice) -> Void )) {
        self.choice = Choice()
        self.completionHandler = completionHandler
    }
    
    
    
    init(choice: Choice, completionHandler: @escaping ((Choice) -> Void )) {
        self.choice = choice
        self.completionHandler = completionHandler
    }
    
    
    
    var body: some View {
        VStack {
            Text("Add New Choice")
                .font(.headline)
                .padding()
            Form {
                Section(header: Text("Choice Type")) {
                    Picker(selection: $choice.choiceType, label: Text("Choice Type")) {
                        ForEach(ChoiceType.allCases, id:\.self) { element in
                            Text(element.name)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Number of credits or units")) {
                    Stepper(onIncrement: increaseChoiceNumber,
                            onDecrement: decreaseChoiceNumber) {
                        Text(stepperLabel())
                    }
                    
                }
                Section(header: Text("Course Units")) {
                    List {
                        ForEach(choicesManager.moduleList) { myModule in
                            HStack {
                                Text(myModule.code)
                                Text(myModule.name)
                                Spacer()
                                if (isModulePartOfChoice(module: myModule)) {
                                    Image(systemName:"checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture(count:1) {
                                didTapRowForModule(module: myModule)
                            }
                        }
                    }
                }
            }
            HStack {
                Spacer()
                Button(action: didPressOK) {
                    Image(systemName: "checkmark")
                    Text("OK")
                }
                .padding()
                Spacer()
                Button(action: didPressCancel) {
                    Image(systemName: "multiply")
                    Text("Cancel")
                }
                .padding()
                .foregroundColor(.red)
                Spacer()
            }
            
        }
    }
    
    
    
    // MARK:- User interaction
    
    
    
    func didTapRowForModule(module: Module) {
        if let index = choice.modules.firstIndex(of: module) {
            choice.modules.remove(at: index)
        } else {
            choice.modules.append(module)
        }
    }
    
    
    
    func didPressOK(){
        self.completionHandler(choice)
        self.presentationMode.wrappedValue.dismiss()
    }
    
    
    
    func didPressCancel(){
        self.presentationMode.wrappedValue.dismiss()
    }
    
    
    
    func increaseChoiceNumber() {
        choice.choiceNumber += 1
    }
    
    
    
    func decreaseChoiceNumber() {
        if choice.choiceNumber > 1 {
            choice.choiceNumber -= 1
        }
    }
    
    
    
    // MARK:- Convenience methods
    
    
    
    func isModulePartOfChoice(module: Module) -> Bool {
        if let _ = choice.modules.firstIndex(of: module) {
            return true
        } else {
            return false
        }
    }
    
    
    
    func stepperLabel() -> String {
        var label = "\(choice.choiceNumber) "
        switch choice.choiceType{
            case .module:
                label = label + "unit"
            case .credit:
                label = label + "credit"
        }
        if (choice.choiceNumber > 1) {
            label = label + "s"
        }
        return label
    }
    
    
    
}



// MARK: - Previews



struct ChoiceEditor_Previews: PreviewProvider {
    static var previews: some View {
        ChoiceEditor(completionHandler: { _ in })
            .environmentObject(ChoicesManager())
    }
}
