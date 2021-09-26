//
//  ProgrammeCell.swift
//  Combination Counter
//
//  Created by Paul Brierley on 08/09/2021.
//

import SwiftUI

struct ProgrammeCell: View {
  
  var programme: Programme
  
    var body: some View {
        HStack
        {
          VStack
          {
            Text(programme.name)
              .fontWeight(.heavy)
          }
          Spacer()
          VStack
          {
            Text("\(programme.creditRequirement) credits")
              .font(.system(size: 11.0, weight: .bold))
              .lineLimit(1)
              .foregroundColor(.white)
              .padding(5)
              .background(Color.blue)
              .cornerRadius(5)
              .overlay(RoundedRectangle(cornerRadius: 5)
                          .stroke(Color.black, lineWidth: 1))
            Text("\(programme.choices.count) choices")
              .font(.system(size: 12.0, weight: .bold))
              .lineLimit(1)
              .foregroundColor(.white)
              .padding(5)
              .background(Color.blue)
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



// MARK: - Previews



struct ProgrammeCell_Previews: PreviewProvider
{
  static var previews: some View
  {
    ProgrammeCell(programme: Programme(id: UUID(),
                                       name: "BSc Physics Y1",
                                       creditRequirement: 120,
                                       choices: []))
  }
}
