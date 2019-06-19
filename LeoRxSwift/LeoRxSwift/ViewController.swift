//
//  ViewController.swift
//  LeoRxSwift
//
//  Created by tecH on 24/05/19.
//  Copyright © 2019 vijayvir Singh. All rights reserved.
//

import UIKit
class ParentManager: NSObject, Codable {
    enum CodingKeys: String, CodingKey {
        case parents
    }
    
    var parents = [Parent]()
}

class Parent: Equatable, Codable , NSCopying {
    enum CodingKeys: String, CodingKey {
        case name
        case children
    }
    
    var name: String
    var children = [Child]()
    
    init(name: String) {
        self.name = name
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Parent(name: name)
        //copy.children = children
        return copy
    }
    
    // MARK: - Codable conformance
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try values.decode(String.self, forKey: .name)
        self.children = try values.decode([Child].self, forKey: .children)
    }
    
    // MARK: - Equatable conformance
    static func == (lhs: Parent, rhs: Parent) -> Bool {
        if lhs.name != rhs.name {
            return false
        }
        return true
    }
    
    // MARK: - Codable conformance
    func encode(to encoder: Encoder) throws {
        print("Parent" , name)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(children, forKey: .children)
    }
}

// CHILD

class Child: Equatable, Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case parent
    }
    
    // MARK: - Properties
    var name: String
     var parent: Parent?
    
    init(name: String, parent: Parent? = nil) {
        self.name = name
        self.parent = parent
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try values.decode(String.self, forKey: .name)
        self.parent = try values.decode(Parent.self, forKey: .parent)
        
    }
    
    static func == (lhs: Child, rhs: Child) -> Bool {
        if lhs.name != rhs.name {
            return false
        }
        return true
    }
    
    // MARK: - Codable conformance
    func encode(to encoder: Encoder) throws {
        print("Child", name)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(parent, forKey: .parent)
    }
}

// DATA STORE

class DataStore {
    var fileManager = FileManager()
    var jsonDecoder = JSONDecoder()
    var jsonEncoder = JSONEncoder()
    
    let storeFileName = "StoreFile.json"
    
    func storeData(data: ParentManager) {
        let storeFilePath = fileManager.getDocumentsDirectory().appendingPathComponent(storeFileName)
        
        print(storeFilePath)
        if let encodedData = try? JSONEncoder().encode(data.parents) {
            do {
                try encodedData.write(to: storeFilePath)
            } catch {
                print("Failed to write JSON data: \(error.localizedDescription)")
            }
      
        }
    }
}

extension FileManager {
    func getDocumentsDirectory() -> URL {
        let paths = urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let some : ParentManager = ParentManager()
        
        let parent1 = Parent(name: "Parent A")
        
        let child1 = Child(name: "Child 1")
      
        parent1.children.append(child1)
          child1.parent = parent1.copy() as? Parent
        
        let child2 = Child(name: "Child 2")
     
        parent1.children.append(child2)
           child2.parent =  parent1.copy() as? Parent
        
        some.parents.append(parent1)
        some.parents.append(parent1)
        
        let dataStore = DataStore()
          dataStore.storeData(data: some)
        
        // Do any additional setup after loading the view.
    }


}


