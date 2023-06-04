//
//  TextGenerator-ViewModel.swift
//  QRCoder
//
//  Created by Otero Díaz on 2023-05-24.
//

import SwiftUI

extension TextGenerator {
    @MainActor
    class ViewModel: GeneratorViewModel {
        @Published var qrCode = QRCode() { didSet { generateQRCode() } }
        var nsImage: NSImage?
        @Published var isShowingStyle = false
        let isCorrectionLevelEnabled: Bool
        @Published var isShowingCorrectionLevel = false

        func generateQRCode() {
            nsImage = qrCode.nsImage
        }

        init(qrCode: QRCode = QRCode(),
             isShowingStyle: Bool = false,
             isCorrectionLevelEnabled: Bool = AppState.isCorrectionLevelEnabled,
             isShowingCorrectionLevel: Bool = false) {

            self.qrCode = qrCode
            self.nsImage = qrCode.nsImage
            self.isShowingStyle = isShowingStyle
            self.isCorrectionLevelEnabled = isCorrectionLevelEnabled
            self.isShowingCorrectionLevel = isShowingCorrectionLevel
            
            generateQRCode()
        }
    }
}
