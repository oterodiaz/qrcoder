//
//  WifiGenerator-ViewModel.swift
//  QRCoder
//
//  Created by Otero Díaz on 2023-05-24.
//

import SwiftUI

extension WifiGenerator {
    @MainActor
    class ViewModel: GeneratorViewModel {
        @Published var qrCode = QRCode() { didSet { generateQRCode() } }
        @Published var nsImage: NSImage?
        @Published var wifi = Wifi() { didSet { updateMessage() } }
        @Published var isShowingSecurityInfo = false
        @Published var isShowingStyle = false
        let isCorrectionLevelEnabled: Bool
        @Published var isShowingCorrectionLevel = false

        func generateQRCode() {
            nsImage = qrCode.nsImage
        }

        func updateMessage() {
            qrCode.message = wifi.stringValue
        }

        init(qrCode: QRCode = QRCode(),
             wifi: Wifi = Wifi(),
             isShowingSecurityInfo: Bool = false,
             isShowingStyle: Bool = false,
             isCorrectionLevelEnabled: Bool = AppState.isCorrectionLevelEnabled,
             isShowingCorrectionLevel: Bool = false) {

            self.qrCode = qrCode
            self.wifi = wifi
            self.isShowingSecurityInfo = isShowingSecurityInfo
            self.isShowingStyle = isShowingStyle
            self.isCorrectionLevelEnabled = isCorrectionLevelEnabled
            self.isShowingCorrectionLevel = isShowingCorrectionLevel
            
            updateMessage()
            generateQRCode()
        }
    }
}
