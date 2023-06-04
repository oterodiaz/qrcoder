//
//  Scan.swift
//  QRCoder
//
//  Created by Otero Díaz on 2023-05-31.
//

import SwiftUI

struct Scan: View {
    @ObservedObject var viewModel: ViewModel
    @State private var dropIconScale = 0.5
    @State private var copyAllImageSystemName = "doc.on.doc"

    var body: some View {
        ZStack(alignment: .top) {
            if viewModel.isContentScanned {
                VStack {
                    Preview(viewModel: Preview.ViewModel(nsImage: viewModel.qrCode.nsImage ?? NSImage(), isDraggingEnabled: false))
                        .padding(.bottom)

                    Form {
                        Section("Decoded Message") {
                            CustomTextEditor(text: .constant(viewModel.qrCode.message), isEditable: false)
                        }
                    }
                    .padding(.top)
                }
                .padding()
            }

            ZStack {
                Color.accentColor
                    .opacity(0.25)
            }
            .background(.ultraThinMaterial)
            .opacity(viewModel.isDraggingFile ? 1 : 0)

            if viewModel.isDraggingFile || !viewModel.isContentScanned {
                VStack {
                    Spacer(minLength: 0)

                    Text("Drop an Image Here")
                        .font(.title)

                    if viewModel.isDraggingFile {
                        Image(systemName: "square.and.arrow.down")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32)
                            .scaleEffect(dropIconScale)
                            .onAppear { dropIconScale = 1 }
                            .onDisappear { dropIconScale = 0.5 }
                    } else {
                        HStack {
                            Button("Open File") {
                                viewModel.openFile()
                            }

                            Button(viewModel.isPressingOption ? "Scan Area" : "Scan Screen") {
                                viewModel.takeScreenshot(of: viewModel.isPressingOption ? .area : .screen)
                            }
                        }
                        .controlSize(.large)
                    }

                    Spacer(minLength: 0)
                }
                .padding()
                .frame(minWidth: 300, minHeight: 300)
            }
        }
        .animation(.default, value: viewModel.isDraggingFile)
        .onAppear(perform: viewModel.observeOptionKeyPresses)
        .onDrop(of: [.image], isTargeted: $viewModel.isDraggingFile, perform: viewModel.handleDrop)
        .alert("Scan Failed", isPresented: $viewModel.isShowingAlert, actions: {}) {
            Text("Could not find any QR Codes in the provided image.")
        }
        .toolbar {
            ToolbarItemGroup {
                Group {
                    Button {
                        viewModel.copyToClipboard()

                        copyAllImageSystemName = "checkmark"
                        Timer.scheduledTimer(withTimeInterval: 0.75, repeats: false) { _ in
                            copyAllImageSystemName = "doc.on.doc"
                        }
                    } label: {
                        Label("Copy", systemImage: copyAllImageSystemName)
                    }
                    .help("Copy")

                    Button {
                        viewModel.reset()
                    } label: {
                        Label("Reset", systemImage: "arrow.counterclockwise")
                    }
                    .help("Reset")
                }
                .disabled(!viewModel.isContentScanned)
            }
        }
    }
}

struct Scan_Previews: PreviewProvider {
    static var previews: some View {
        Scan(viewModel: Scan.ViewModel(
            qrCode: QRCode(message: "Hello"),
            isContentScanned: true)
        )
    }
}
