//
//  EqualizerView.swift
//  file_Musician_for_Mac
//
//  Created by 岸　優樹 on 2026/02/14.
//

import SwiftUI

struct EqualizerView: View {
    @StateObject var playDataStore: PlayDataStore = .shared
    @State private var equalizerParameters: [EqualizerParameter] = []
    let frequencys: [Float] = [32, 64.0, 128.0, 256.0, 500.0, 1000.0, 2000.0, 4000.0, 8000.0, 16000.0]
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("イコライザ　オン/オフ")
                    .padding(.vertical)
                Toggle("イコライザオン/オフ", isOn: $playDataStore.equalizerToggle)
                    .toggleStyle(.switch)
                    .labelsHidden()
                    .padding()
                    .onChange(of: playDataStore.equalizerToggle) {
                        Task { await setEqualizerParameters() }
                    }
            }
            GeometryReader { geo in
                ZStack(alignment: .center) {
                    HStack {
                        Spacer()
                        EqualizerScaleView()
                            .frame(width: 80)
                        ForEach($equalizerParameters, id: \.self) { $equalizerParameter in
                            EqualizerViewSlider(gain: $equalizerParameter.gain, frequency: equalizerParameter.frequency) {
                                Task { await setEqualizerParameters() }
                            }
                            Spacer()
                        }
                    }
                    .frame(width: geo.size.width / 1.2, height: geo.size.height / 1.25)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationTitle("イコライザ設定")
        .onAppear() {
            Task { await onAppear() }
        }
    }
    func setEqualizerParameters() async {
        for equalizerParameter in equalizerParameters {
            await EqualizerParameterRepository.update(equalizerParameter: equalizerParameter)
        }
        PlayRepository.setEqualizer(equalizerParameters: equalizerParameters)
    }
    func onAppear() async {
        let equalizerParameters = await EqualizerParameterRepository.read()
        if equalizerParameters.isEmpty {
            var equalizerParameters: [EqualizerParameter] = []
            for frequency in frequencys {
                let equalizerParameter = EqualizerParameter(type: 0, bandWidth: 1, frequency: frequency, gain: 0.0)
                equalizerParameters.append(equalizerParameter)
            }
            equalizerParameters.sort { $0.frequency < $1.frequency }
            self.equalizerParameters = equalizerParameters
        } else {
            self.equalizerParameters = equalizerParameters
        }
    }
}

#Preview {
    EqualizerView()
}
