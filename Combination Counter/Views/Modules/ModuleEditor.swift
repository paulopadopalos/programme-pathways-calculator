//
//  ModuleEditor.swift
//  Combination Counter
//
//  Created by Paul Brierley on 26/02/2021.
//

import SwiftUI

struct ModuleEditor: View {
    
    
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var moduleName: String = ""
    @State var moduleCode: String = ""
    @State var moduleCredits: String = ""
    @State var moduleHours: String = ""
    
    private let completionHandler: (Module) -> Void
    
    
    
    init(completionHandler: @escaping ((Module) -> Void )) {
        self.completionHandler = completionHandler
    }
    
    
    
    var body: some View {
        VStack {
            Text("Add New Module")
                .font(.headline)
                .padding()
            Form {
                Section (header: Text("Module Code")) {
                    TextField("Module Code", text: $moduleCode)
                        .autocapitalization(.allCharacters)
                }
                Section (header: Text("Module Name")) {
                    TextField("Module Name (optional)", text: $moduleName)
                        .autocapitalization(.words)
                }
                Section (header: Text("Module Credits")) {
                    TextField("Module Credits", text: $moduleCredits)
                        .keyboardType(.numberPad)
                }
                Section (header: Text("Contact Hours")) {
                    TextField("Hours per week (optional)", text: $moduleHours)
                        .keyboardType(.numberPad)
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
    
    
    
    func didPressOK() {
      if (moduleCode != "")
      {
        let newModule = Module(id: UUID(),
                               name: moduleName,
                               code: moduleCode,
                               hours: Int(moduleHours) ?? 0,
                               credits: Int(moduleCredits) ?? 0)
        self.presentationMode.wrappedValue.dismiss()
        self.completionHandler(newModule)
      }
    }
    
    
    
    func didPressCancel() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    
    
}



// MARK: - Previews



struct ModuleEditor_Previews: PreviewProvider {
    static var previews: some View {
        ModuleEditor(completionHandler: {_ in })
    }
}
