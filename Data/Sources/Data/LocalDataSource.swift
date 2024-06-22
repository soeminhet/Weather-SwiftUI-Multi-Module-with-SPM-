//
//  File.swift
//
//
//  Created by Soe Min Htet on 20/06/2024.
//

import Foundation
import CoreData
import Combine

public protocol LocalDataSource {
    
    var savedCitied: Published<[CityEntity]>.Publisher { get }
    
    func addCity(
        name: String,
        lat: Double,
        lon: Double,
        state: String
    )
    
    func delete(entity: CityEntity)
}

public class LocalDataSourceImpl: LocalDataSource {
    
    public init() {
        getAllCities()
    }
    
    @Published var savedCitiesPubliser: [CityEntity] = []
    public var savedCitied: Published<[CityEntity]>.Publisher { $savedCitiesPubliser }
    
    lazy private var container: NSPersistentContainer? = {
        guard let modelURL = Bundle.module.url(forResource:"Model", withExtension: "momd") else { return  nil}
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else { return nil }
        let container = NSPersistentContainer(name:"Data",managedObjectModel:model)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    public func addCity(
        name: String,
        lat: Double,
        lon: Double,
        state: String
    ) {
        if let containter = container {
            let entity = CityEntity(context: containter.viewContext)
            entity.id = UUID()
            entity.name = name
            entity.lat = lat
            entity.lon = lon
            entity.state = state
            save()
        } else {
            print("Container is empty")
        }
    }
    
    public func delete(entity: CityEntity) {
        if let container = container {
            container.viewContext.delete(entity)
            save()
        } else {
            print("Container is empty")
        }
    }
    
    private func getAllCities() {
        if let container = container {
            let request = NSFetchRequest<CityEntity>(entityName: "CityEntity")
            
            do {
                savedCitiesPubliser = try container.viewContext.fetch(request)
            } catch let error {
                print("Cannot fetch entity \(error.localizedDescription)")
            }
        } else {
            print("Container is empty")
        }
    }
    
    private func save() {
        do {
            try container?.viewContext.save()
            getAllCities()
            print("Save success")
        } catch let error {
            print("Save error \(error)")
        }
    }
    
}
