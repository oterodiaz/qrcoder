//
//  TextGenerator.swift
//  QRCoder
//
//  Created by Otero Díaz on 2023-05-19.
//

import SwiftUI

struct TextGenerator: View {
    @ObservedObject var viewModel: ViewModel
    @FocusState private var isTextFocused: Bool

    var body: some View {
        Generator<_, ViewModel> {
            Form {
                Section {
                    CustomTextEditor(text: $viewModel.qrCode.message)
                        .focused($isTextFocused)
                } header: {
                    Text("Message")
                        .fixedSize()
                }
            }
        }
        .environmentObject(viewModel)
        .onTapGesture {
            isTextFocused = false
        }
    }
}

struct TextGenerator_Previews: PreviewProvider {
    static var previews: some View {
        TextGenerator(viewModel: TextGenerator.ViewModel())
    }
}
