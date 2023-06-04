//
//  ContentView.swift
//  QRCoder
//
//  Created by Otero Díaz on 2023-05-16.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState

    private let scan: SidebarItem = .scan
    private let generators: [SidebarItem] = SidebarItem.allCases.filter { $0 != .scan }

    var body: some View {
        NavigationSplitView {
            List(selection: $appState.sidebarSelection) {
                Label(scan.localizedName, systemImage: scan.systemImage)
                    .tag(scan)

                Section("Generate") {
                    ForEach(generators, id: \.self) { generator in
                        Label(generator.localizedName, systemImage: generator.systemImage)
                    }
                }
            }
        } detail: {
            switch appState.sidebarSelection {
            case .scan:
                Scan(viewModel: appState.scanViewModel)
            case .text:
                TextGenerator(viewModel: appState.textViewModel)
            case .wifi:
                WifiGenerator(viewModel: appState.wifiViewModel)
            case .email:
                EmailGenerator(viewModel: appState.emailViewModel)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
