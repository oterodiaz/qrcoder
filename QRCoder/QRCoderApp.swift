//
//  QRCoderApp.swift
//  QRCoder
//
//  Created by Otero Díaz on 2023-05-16.
//

import SwiftUI

@main
struct QRCoderApp: App {
    @StateObject private var appState = AppState()
    @AppStorage("NSFullScreenMenuItemEverywhere") var fullScreenEnabled = false
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        fullScreenEnabled = false
    }

    var body: some Scene {
        Window("QRCoder", id: "main") {
            ContentView()
                .environmentObject(appState)
                .onAppear {
                    NSWindow.allowsAutomaticWindowTabbing = false
                }
        }
        .defaultSize(width: 550, height: 500)
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(replacing: .help, addition: {})
        }
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        DispatchQueue.main.async {
            if let menu = NSApplication.shared.mainMenu {
                menu.items.removeAll { $0.title == "View" }
            }
        }
    }
}
