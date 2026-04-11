//
//  Parsistance.swift
//  file_Musician_for_Mac
//
//  Created by 岸　優樹 on 2026/02/16.
//

import Foundation
import SwiftData

class Persistance {
    static var sharedModelContainer: ModelContainer = {
        let schema = Schema([EqualizerParameter.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("error create sharedModelContainer: \(error)")
        }
    }()
    
}

actor PersistanceActor: ModelActor {
    let modelContainer: ModelContainer
    let modelExecutor: any ModelExecutor
    
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
        let context = ModelContext(modelContainer)
        modelExecutor = DefaultSerialModelExecutor(modelContext: context)
    }
    
    func save() {
        do {
            try modelContext.save()
        } catch {
            print("error save")
        }
    }
    
    func get<T:PersistentModel>(_ descriptor:FetchDescriptor<T>)->[T]? {
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("error get")
            return []
        }
    }
    
    func insert<T:PersistentModel>(_ value:T) {
        modelContext.insert(value)
    }
    
    func delete<T:PersistentModel>(_ value:T) {
        modelContext.delete(value)
    }
}
