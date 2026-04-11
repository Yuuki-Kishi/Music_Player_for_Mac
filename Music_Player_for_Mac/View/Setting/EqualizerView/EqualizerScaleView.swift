//
//  EqualizerScaleView.swift
//  file_Musician_for_Mac
//
//  Created by 岸　優樹 on 2026/02/14.
//

import SwiftUI

struct EqualizerScaleView: View {
    var body: some View {
        VStack {
            Text("+12dB")
            Spacer()
            Text("0dB")
            Spacer()
            Text("-12dB")
                .padding(.bottom, 40)
        }
        .padding()
    }
}

#Preview {
    EqualizerScaleView()
}
