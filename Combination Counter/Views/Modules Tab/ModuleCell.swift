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
                        .font(.headline)
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .padding(.bottom, 5)
                    Spacer()
                }
                HStack {
                    Text(module.name)
                        .padding(.bottom, 5)
                    Spacer()
                }
            }
            VStack {
                Text("\(module.credits) credits")
                    .font(.system(size: 12.0, weight: .regular))
                    .lineLimit(1)
                    .foregroundColor(.white)
                    .padding(5)
                    .background(Color.green)
                    .cornerRadius(5)
                Text("\(module.hours) hours")
                    .font(.system(size: 12.0, weight: .regular))
                    .lineLimit(1)
                    .foregroundColor(.white)
                    .padding(5)
                    .background(Color.green)
                    .cornerRadius(5)
            }
        }
        .padding(15)
        .background(Color.gray)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
    
    
    
}



// MARK: - Previews



struct ModuleCell_Previews: PreviewProvider {
    static var previews: some View {
        ModuleCell(module: Module())
    }
}
