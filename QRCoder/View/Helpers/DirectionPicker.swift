//
//  DirectionPicker.swift
//  QRCoder
//
//  Created by Otero Díaz on 2023-05-23.
//

import SwiftUI

struct DirectionPicker: View {
    @Binding var direction: QRCode.Style.Fill.Direction

    var body: some View {
        Picker("Direction", selection: $direction) {
            ForEach(QRCode.Style.Fill.Direction.allCases, id: \.self) { direction in
                Label(direction.rawValue, systemImage: direction.rawValue)
                    .labelsHidden()
            }
        }
        .labelStyle(.iconOnly)
        .pickerStyle(.segmented)
        .labelsHidden()
        .fixedSize()
    }
}

struct DirectionPicker_Previews: PreviewProvider {
    static var previews: some View {
        DirectionPicker(direction: .constant(QRCode().style.bg.gradientDirection))
    }
}
