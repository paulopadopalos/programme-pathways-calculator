//
//  DataManager.swift
//  Combination Counter
//
//  Created by Paul Brierley on 25/02/2021.
//

import Foundation



class DataManager: ObservableObject
{
  
  
  
  @Published var allModules: [Module]
  @Published var programmes: [Programme]
  
  
  
  // The file version is used to determine which version of loading/saving
  // was used by this app. The current version is 1.0.
  let fileVersion: Float = 1.0
  
  
  
  // MARK: - Functions for managing the list of modules.
  
  
  
  func sortModules()
  {
    self.allModules.sort(by: { $0.code < $1.code })
  }
  
  
  
  func deleteModule(at offsets: IndexSet) -> Bool
  {
    var isBeingUsed = false
    for prog in self.programmes
    {
      for choice in prog.choices
      {
        for module in choice.modules
        {
          for index in offsets
          {
            if (module.id == self.allModules[index].id)
            {
              isBeingUsed = true
            }
          }
        }
      }
    }
    if (isBeingUsed == false)
    {
      self.allModules.remove(atOffsets: offsets)
      return true
    }
    else
    {
      return false
    }
  }
  
  
  
  func add(module: Module)
  {
    self.allModules.append(module)
  }
  
  
  
  // MARK: - Functions for managing the list of programmes.
  
  
  
  func sortProgrammes()
  {
    self.programmes.sort(by: { $0.name < $1.name })
  }
  
  
  
  func deleteProgramme(at offsets: IndexSet)
  {
    self.programmes.remove(atOffsets: offsets)
  }
  
  
  
  func add(programme: Programme)
  {
    self.programmes.append(programme)
  }
  
  
  
  // MARK: - Loading and saving.
  
  
  
  init()
  {
    self.allModules = []
    self.programmes = []
    // We try and load a version file. If we find one, and the version matches, we can
    // got ahead and try loading programmes and files.
    let decoder = JSONDecoder()
    let documentsFolderURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let versionFileURL = documentsFolderURL.appendingPathComponent("version.json")
    let moduleFileURL = documentsFolderURL.appendingPathComponent("moduleList.json")
    let programmeFileURL = documentsFolderURL.appendingPathComponent("programmeList.json")
    if let decodedFileVersion = try? Data.init(contentsOf: versionFileURL)
    {
      if let loadedFileVersion = try? decoder.decode(Float.self, from: decodedFileVersion)
      {
        // If we get this far, we've successfully loaded a file version. We can
        // now proceed to load the data *if* the file versions match.
        if loadedFileVersion == self.fileVersion
        {
          // Load the module data.
          if let decodedModuleData = try? Data.init(contentsOf: moduleFileURL)
          {
            if let loadedModuleData = try? decoder.decode([Module].self, from: decodedModuleData)
            {
              self.allModules = loadedModuleData
            }
          }
          // Load the programmes data.
          if let decodedProgrammeData = try? Data.init(contentsOf: programmeFileURL)
          {
            if let loadedProgrammeData = try? decoder.decode([Programme].self, from: decodedProgrammeData)
            {
              self.programmes = loadedProgrammeData
            }
          }
        }
      }
    }
  }

  
  
  func save()
  {
    let encoder = JSONEncoder()
    let documentsFolderURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let versionFileURL = documentsFolderURL.appendingPathComponent("version.json")
    let moduleFileURL = documentsFolderURL.appendingPathComponent("moduleList.json")
    let programmeFileURL = documentsFolderURL.appendingPathComponent("programmeList.json")
    // Save the file type version we are using.
    if let encodedVersionNumber = try? encoder.encode(self.fileVersion)
    {
      do
      {
        try encodedVersionNumber.write(to: versionFileURL, options: .atomic)
      }
      catch
      {
        print("Encoding of version number failed.")
        print(error.localizedDescription)
      }
    }
    // Save the list of modules.
    if let encodedModuleData = try? encoder.encode(self.allModules)
    {
      do
      {
        try encodedModuleData.write(to: moduleFileURL, options: .atomic)
      }
      catch
      {
        print("Encoding  of modules failed.")
        print(error.localizedDescription)
      }
    }
    // Save the list of programmes.
    if let encodedProgrammeData = try? encoder.encode(self.programmes)
    {
      do
      {
        try encodedProgrammeData.write(to: programmeFileURL, options: .atomic)
      }
      catch
      {
        print("Encoding of programmes data failed.")
        print(error.localizedDescription)
      }
    }
  }
  
  
  
}
