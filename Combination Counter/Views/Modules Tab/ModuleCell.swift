//
//  ModuleCell.swift
//  Combination Counter
//
//  Created by Paul Brierley on 27/02/2021.
//

import SwiftUI



struct ModuleCell: View {

    
    
    var module: Module
    
    
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text(module.code)
                        .font(.title)
                        .fontWeight(.heavy)
                        .lineLimit(1)
                    Spacer()
                }
                HStack {
                    Text(module.name)
                        .italic()
                    Spacer()
                }
            }
            VStack {
                Text("\(module.credits) credits")
                    .font(.system(size: 12.0, weight: .bold))
                    .lineLimit(1)
                    .foregroundColor(.white)
                    .padding(5)
                    .background(Color.green)
                    .cornerRadius(5)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.black, lineWidth: 1))
                Text("\(module.hours) hours")
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



// MARK: - Previews



struct ModuleCell_Previews: PreviewProvider {
    static var previews: some View {
        ModuleCell(module: Module())
    }
}
