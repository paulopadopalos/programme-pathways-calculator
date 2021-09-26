//
//  Combination_CounterApp.swift
//  Combination Counter
//
//  Created by Paul Brierley on 25/02/2021.
//

import SwiftUI

@main
struct Combination_CounterApp: App
{
    
  @StateObject var dataManager = DataManager()
  @Environment(\.scenePhase) var scenePhase
    
  var body: some Scene
  {
    WindowGroup
    {
      FirstView()
        .environmentObject(dataManager)
    }
    .onChange(of: scenePhase)
    {
      _ in dataManager.save()
    }
  }
    
}
