//
//  EqualizerViewSlider.swift
//  file_Musician_for_Mac
//
//  Created by 岸　優樹 on 2026/02/14.
//

import SwiftUI

struct EqualizerViewSlider: View {
    @Binding var gain: Float
    @State var frequency: Float
    let onChanged: () -> Void
    
    var body: some View {
        VStack {
            VerticalSlider(value: $gain, range: -12.0...12.0, step: 1.0) {
                onChanged()
            }
            .padding(10)
            Text(frequencyString())
                .lineLimit(1)
                .padding(.bottom)
                .frame(width: 50)
        }
    }
    func frequencyString() -> String {
        if frequency >= 1000 {
            return String(Int(frequency) / 1000) + "kHz"
        } else {
            return String(Int(frequency)) + "Hz"
        }
    }
}

#Preview {
    EqualizerViewSlider(gain: Binding(get: { 0.0 }, set: { _ in }), frequency: 1000) {}
}
