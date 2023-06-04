//
//  GeneratorViewModel-Protocol.swift
//  QRCoder
//
//  Created by Otero Díaz on 2023-05-26.
//

import SwiftUI

@MainActor
protocol GeneratorViewModel: ObservableObject {
    var qrCode: QRCode { get set }
    var nsImage: NSImage? { get set }
    var isShowingStyle: Bool { get set }
    var isCorrectionLevelEnabled: Bool { get }
    var isShowingCorrectionLevel: Bool { get set }

    func generateQRCode()
}
