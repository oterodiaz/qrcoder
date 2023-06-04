//
//  Generator.swift
//  QRCoder
//
//  Created by Otero Díaz on 2023-05-19.
//

import SwiftUI

struct Generator<Content: View, ViewModel: GeneratorViewModel>: View {
    @EnvironmentObject var viewModel: ViewModel
    private let content: Content

    init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 0) {
            Preview(viewModel: Preview.ViewModel(nsImage: viewModel.nsImage))
                .padding(.bottom)

            content
                .frame(maxWidth: 512)
                .padding(.top)

            Spacer(minLength: 0)
        }
        .contentShape(Rectangle()) // Required for onTapGesture to work
        .padding()
        .toolbar {
            ToolbarItemGroup {
                if viewModel.isCorrectionLevelEnabled {
                    Button {
                        viewModel.isShowingCorrectionLevel.toggle()
                    } label: {
                        Label("Correction Level", systemImage: "chart.bar")
                    }
                    .help("Correction Level")
                    .popover(isPresented: $viewModel.isShowingCorrectionLevel, arrowEdge: .bottom) {
                        CorrectionLevelView(correctionLevel: $viewModel.qrCode.correctionLevel)
                    }
                }

                Button {
                    viewModel.isShowingStyle.toggle()
                } label: {
                    Label("Customize", systemImage: "paintpalette")
                }
                .help("Customize")
                .popover(isPresented: $viewModel.isShowingStyle, arrowEdge: .bottom) {
                    StyleOptions(style: $viewModel.qrCode.style)
                }

                Button {
                    saveToFile(viewModel.nsImage!)
                } label: {
                    Label("Export", systemImage: "arrow.down.doc")
                }
                .help("Export")
                .disabled(viewModel.nsImage == nil)

                if let nsImage = viewModel.nsImage,
                   let url = createTempFile(from: nsImage) {
                        ShareLink(item: url)
                            .help("Share")
                } else {
                    Button {
                    } label: {
                        Label("Share", systemImage: "square.and.arrow.up")
                            .help("Share")
                    }
                    .disabled(true)
                }
            }
        }
    }
}

struct Generator_Previews: PreviewProvider {
    static var previews: some View {
        Generator<_, WifiGenerator.ViewModel> {
            Color.accentColor
        }
        .environmentObject(WifiGenerator.ViewModel())
    }
}
