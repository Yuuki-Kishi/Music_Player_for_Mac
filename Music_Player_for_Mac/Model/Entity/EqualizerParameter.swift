//
//  EqualizerParameter.swift
//  Music_Player_for_Mac
//
//  Created by 岸　優樹 on 2026/04/11.
//

import Foundation
import SwiftData

@Model
final class EqualizerParameter {
    @Attribute(.unique) var id = UUID()
    var type: UInt32
    var bandWidth: Float
    var frequency: Float
    var gain: Float
    
    init(type: UInt32, bandWidth: Float, frequency: Float, gain: Float) {
        self.type = type
        self.bandWidth = bandWidth
        self.frequency = frequency
        self.gain = gain
    }
}
