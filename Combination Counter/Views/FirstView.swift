//
//  FirstView.swift
//  Combination Counter
//
//  Created by Paul Brierley on 25/02/2021.
//

import SwiftUI



struct FirstView: View
{
  var body: some View
  {
    NavigationView
    {
      VStack
      {
        HStack
        {
          NavigationLink(destination: ProgrammeListView())
          {
            Image(systemName: "graduationcap")
            Text("Programmes")
              .font(.title)
            Spacer()
            Image(systemName:"chevron.right.circle.fill")
          }
        }
        .foregroundColor(.white)
        .padding()
        .background(Color.blue)
        .cornerRadius(8)
        
        HStack
        {
          NavigationLink(destination: ModuleListView())
          {
            Image(systemName: "books.vertical")
            Text("Modules")
              .font(.title)
            Spacer()
            Image(systemName:"chevron.right.circle.fill")
          }
        }
        .foregroundColor(.white)
        .padding()
        .background(Color.green)
        .cornerRadius(8)
        Spacer()
        
      }
      .padding()
      .navigationTitle("Combo Counter")
    }
  }
  
}



// MARK: - Previews



struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        FirstView()
            .environmentObject(DataManager())
    }
}
