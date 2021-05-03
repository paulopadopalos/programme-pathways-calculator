//
//  FirstView.swift
//  Combination Counter
//
//  Created by Paul Brierley on 25/02/2021.
//

import SwiftUI



struct FirstView: View {
    var body: some View {
        TabView {
            
            // First Tab
            ModuleListView()
                .tabItem {
                    Image(systemName:"cube")
                    Text("Modules")
                }
            
            // Second Tab
            ChoiceListView()
                .tabItem {
                    Image(systemName:"hand.point.up.left")
                    Text("Choices")
                }
            
            // Third Tab
            ResultsView()
                .tabItem {
                    Image(systemName:"binoculars")
                    Text("Results")
                }
            
        }
    }
}



// MARK: - Previews



struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        FirstView()
            .environmentObject(ChoicesManager())
    }
}
