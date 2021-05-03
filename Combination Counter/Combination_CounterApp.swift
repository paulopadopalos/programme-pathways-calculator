//
//  Combination_CounterApp.swift
//  Combination Counter
//
//  Created by Paul Brierley on 25/02/2021.
//

import SwiftUI

@main
struct Combination_CounterApp: App {
    
    
    
    @StateObject var choicesManager = ChoicesManager()
    
    @Environment(\.scenePhase) var scenePhase
    
    
    
    var body: some Scene {
        WindowGroup {
            FirstView()
                .environmentObject(choicesManager)
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
                case .background:
                    choicesManager.save()
                default:
                    break
            }
        }
    }
    
    
    
}
