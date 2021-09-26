//
//  Module.swift
//  Combination Counter
//
//  Created by Paul Brierley on 25/02/2021.
//

import Foundation



struct Module: Identifiable, Hashable, Codable
{
  
  var id: UUID
  var name: String
  var code: String
  var hours: Int
  var credits: Int
  
}
