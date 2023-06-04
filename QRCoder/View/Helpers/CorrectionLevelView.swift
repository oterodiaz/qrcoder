//
//  CorrectionLevelView.swift
//  QRCoder
//
//  Created by Otero Díaz on 2023-05-20.
//

import SwiftUI

struct CorrectionLevelView: View {
    @Binding var correctionLevel: CorrectionLevel

    var body: some View {
        Form {
            Section {
                Picker("Correction Level", selection: $correctionLevel) {
                    ForEach(CorrectionLevel.allCases, id: \.self) { correctionLevel in
                        Text(correctionLevel.localizedName)
                    }
                }
                .pickerStyle(.radioGroup)
                .labelsHidden()
            } header: {
                Text("Correction Level")

                Text("Amount of redundant data to preserve scannability if the code is damaged")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
        .frame(width: 256, alignment: .leading)
        .padding(12)
    }
}

struct CorrectionLevelView_Previews: PreviewProvider {
    static var previews: some View {
        CorrectionLevelView(correctionLevel: .constant(QRCode().correctionLevel))
    }
}
