//
//  SidebarItem.swift
//  QRCoder
//
//  Created by Otero Díaz on 2023-05-16.
//

import SwiftUI

enum SidebarItem: CaseIterable {
    case scan, text, wifi, email

    var localizedName: LocalizedStringKey {
        return self.info.localizedName
    }

    var systemImage: String {
        return self.info.systemImage
    }

    private var info: (localizedName: LocalizedStringKey, systemImage: String) {
        switch self {
        case .scan:
            return ("Scan", "qrcode.viewfinder")
        case .text:
            return ("Text", "pencil.line")
        case .wifi:
            return ("Wifi", "wifi")
        case .email:
            return ("Email", "envelope")
        }
    }
}
