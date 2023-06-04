//
//  Wifi.swift
//  QRCoder
//
//  Created by Otero Díaz on 2023-05-24.
//

import SwiftUI

struct Wifi: Equatable {
    var ssid = ""
    var password = ""
    var isHiddenNetwork = false
    var security: Security = .wpa

    var isPasswordInvalid: Bool {
        (security != .none) && (password.count < security.minPassCount)
    }

    var isSSIDInvalid: Bool {
        ssid.count < 2
    }

    var stringValue: String {
        guard !isSSIDInvalid && !isPasswordInvalid else {
            return ""
        }

        return """
               WIFI:S:\(ssid);T:\(security.stringValue);P:\(security == .none ? "" : password);\
               \(isHiddenNetwork ? "H:true" : "");
               """
    }

    enum Security: String {
        case wpa  = "WPA"
        case wep  = "WEP"
        case none = "nopass"

        var stringValue: String {
            self.rawValue
        }

        var minPassCount: Int {
            switch self {
            case .wpa:
                return 8
            case .wep:
                return 10
            case .none:
                return 0
            }
        }
    }
}
