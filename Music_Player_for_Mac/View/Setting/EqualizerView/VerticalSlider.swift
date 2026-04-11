//
//  VerticalSlider.swift
//  file_Musician_for_Mac
//
//  Created by 岸　優樹 on 2026/02/15.
//

import SwiftUI

struct VerticalSlider: View {
    @Binding var value: Float
    let range: ClosedRange<Float>
    let step: Float
    @GestureState private var isDragging: Bool = false
    let onChanged: () -> Void
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: geo.size.width / 3)
                    .foregroundStyle(.gray.opacity(0.3))
                    .frame(width: 10)
                    .frame(maxWidth: .infinity)
                RoundedRectangle(cornerRadius: geo.size.width / 3)
                    .foregroundStyle(.purple)
                    .frame(width: 10, height: colorBarHeight(geo: geo))
                    .frame(maxWidth: .infinity)
                ZStack {
                    Circle()
                        .foregroundStyle(.secondary)
                        .frame(width: 25)
                    Circle()
                        .foregroundStyle(.purple)
                        .frame(width: 12)
                }
                .offset(y: thumbOffset(geo: geo))
                .frame(maxWidth: .infinity)
                if isDragging {
                    Text(gainText())
                        .font(.system(size: 9))
                        .background(.background)
                        .offset(y: thumbOffset(geo: geo) - 7)
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .updating($isDragging) { _, state, _ in
                        state = true
                    }
                    .onChanged { gesture in
                        updateValue(from: gesture.location.y, in: geo.size.height)
                    }
                    .onEnded { _ in
                        onChanged()
                    }
            )
        }
        .frame(width: 40)
    }
    func normalizedValue() -> Float {
        (value - range.lowerBound) / (range.upperBound - range.lowerBound)
    }
    func colorBarHeight(geo: GeometryProxy) -> CGFloat {
        geo.size.height * CGFloat(normalizedValue())
    }
    func gainText() -> String {
        String(round((normalizedValue() * 2 - 1) * range.upperBound)) + "dB"
    }
    func thumbOffset(geo: GeometryProxy) -> CGFloat {
        -geo.size.height * Double(normalizedValue()) + 12.5
    }
    func updateValue(from y: CGFloat, in totalHeight: CGFloat) {
        let percent: Float = Float(1 - (y / totalHeight))
        let rawValue = percent * (range.upperBound - range.lowerBound) + range.lowerBound
        let stepped = (rawValue / step).rounded() * step
        value = Float(min(max(stepped, range.lowerBound), range.upperBound))
    }
}

#Preview {
    VerticalSlider(value: Binding(get: { 0.0 }, set: { _ in }), range: -12.0...12.0, step: 1.0) {}
}
