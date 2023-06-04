//
//  AppState.swift
//  QRCoder
//
//  Created by Otero Díaz on 2023-05-16.
//

import SwiftUI

class AppState: ObservableObject {
    @Published var sidebarSelection: SidebarItem = .scan

    @MainActor lazy var textViewModel = TextGenerator.ViewModel()
    @MainActor lazy var wifiViewModel = WifiGenerator.ViewModel()
    @MainActor lazy var emailViewModel = EmailGenerator.ViewModel()
    @MainActor lazy var scanViewModel = Scan.ViewModel()

    static let isCorrectionLevelEnabled = UserDefaults.standard.bool(
        forKey: "EnableCorrectionLevel"
    )

    static var context = CIContext()
}
