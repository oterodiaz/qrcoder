//
//  CorrectionLevel.swift
//  QRCoder
//
//  Created by Otero Díaz on 2023-05-23.
//

import SwiftUI

enum CorrectionLevel: String, CaseIterable {
    case low      = "L" //  7%
    case medium   = "M" // 15%
    case quartile = "Q" // 25%
    case high     = "H" // 30%

    var localizedName: LocalizedStringKey {
        switch self {
        case .low:
            return "Low (7%)"
        case .medium:
            return "Medium (15%)"
        case .quartile:
            return "Quartile (25%)"
        case .high:
            return "High (30%)"
        }
    }
}
