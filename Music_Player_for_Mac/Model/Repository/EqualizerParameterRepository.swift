//
//  EqualizerParameterRepository.swift
//  file_Musician_for_Mac
//
//  Created by 岸　優樹 on 2026/02/16.
//

import Foundation
import SwiftData

class EqualizerParameterRepository {
    static let actor = {
        return PersistanceActor(modelContainer: Persistance.sharedModelContainer)
    }()
    
    static func create(equalizerParameters: [EqualizerParameter]) async {
        for equalizerParameter in equalizerParameters {
            await actor.insert(equalizerParameter)
        }
        await actor.save()
    }
    
    static func read() async -> [EqualizerParameter] {
        let predicate = #Predicate<EqualizerParameter> { equalizerParameter in
            return true
        }
        let descriptor = FetchDescriptor(predicate: predicate)
        var equalizerParameters = await actor.get(descriptor) ?? []
        equalizerParameters.sort { $0.frequency < $1.frequency }
        return equalizerParameters
    }
    
    static func update(equalizerParameter: EqualizerParameter) async {
        let id = equalizerParameter.id
        let predicate = #Predicate<EqualizerParameter> { $0.id == id }
        let descriptor = FetchDescriptor(predicate: predicate)
        
        if let parameter = await actor.get(descriptor)?.first {
            parameter.type = equalizerParameter.type
            parameter.bandWidth = equalizerParameter.bandWidth
            parameter.frequency = equalizerParameter.frequency
            parameter.gain = equalizerParameter.gain
            await actor.save()
        } else {
            await actor.insert(equalizerParameter)
            await actor.save()
        }
    }
    
    static func delete(equalizerParameter: EqualizerParameter) async {
        await actor.delete(equalizerParameter)
        await actor.save()
    }
}
