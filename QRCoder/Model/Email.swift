//
//  Email.swift
//  QRCoder
//
//  Created by Otero Díaz on 2023-05-24.
//

import SwiftUI

struct Email: Equatable {
    var address = ""
    var subject = ""
    var message = ""

    var stringValue: String {
        guard !(address.isEmpty || subject.isEmpty || message.isEmpty) else {
            return ""
        }

        return "mailto:\(address)?subject=\(subject)&body=\(message)"
    }
}
