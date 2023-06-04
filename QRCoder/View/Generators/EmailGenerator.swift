//
//  EmailGenerator.swift
//  QRCoder
//
//  Created by Otero Díaz on 2023-05-21.
//

import SwiftUI

struct EmailGenerator: View {
    @ObservedObject var viewModel: ViewModel
    @FocusState private var focusedField: Field?

    var body: some View {
        Generator<_, ViewModel> {
            Form {
                Section {
                    TextField("Address", text: $viewModel.email.address)
                        .focused($focusedField, equals: .address)
                        .labelsHidden()
                } header: {
                    Text("Address")
                        .fixedSize()

                    if viewModel.email.address.isEmpty {
                        Text("Required field")
                            .fixedSize()
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }

                Section {
                    TextField("Subject", text: $viewModel.email.subject)
                        .focused($focusedField, equals: .subject)
                        .labelsHidden()
                } header: {
                    Text("Subject")
                        .fixedSize()

                    if viewModel.email.subject.isEmpty {
                        Text("Required field")
                            .fixedSize()
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }

                Section {
                    CustomTextEditor(text: $viewModel.email.message)
                        .focused($focusedField, equals: .message)
                } header: {
                    Text("Message")
                        .fixedSize()

                    if viewModel.email.message.isEmpty {
                        Text("Required field")
                            .fixedSize()
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .textFieldStyle(.roundedBorder)
            .animation(.default, value: viewModel.email)
            .onSubmit {
                if focusedField == .address {
                    focusedField = .subject
                } else {
                    focusedField = .message
                }
            }
        }
        .environmentObject(viewModel)
        .onTapGesture {
            focusedField = nil
        }
    }

    private enum Field {
        case address, subject, message
    }
}

struct EmailGenerator_Previews: PreviewProvider {
    static var previews: some View {
        EmailGenerator(viewModel: EmailGenerator.ViewModel())
    }
}
