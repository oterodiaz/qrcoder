//
//  WifiGenerator.swift
//  QRCoder
//
//  Created by Otero Díaz on 2023-05-16.
//

import SwiftUI

typealias Security = Wifi.Security

struct WifiGenerator: View {
    @ObservedObject var viewModel: ViewModel
    @FocusState private var focusedField: Field?

    var body: some View {
        Generator<_, ViewModel> {
            Form {
                Section {
                    TextField("Network Name",
                              text: $viewModel.wifi.ssid,
                              prompt: Text(verbatim: "SSID")
                    )
                    .focused($focusedField, equals: .ssid)
                    .labelsHidden()
                } header: {
                    Group {
                        Text("Network Name")

                        if viewModel.wifi.isSSIDInvalid {
                            Text("Must be at least 2 characters long")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                    .fixedSize()
                }

                Section {
                    TextField("Password",
                              text: $viewModel.wifi.password,
                              prompt: Text("Password")
                    )
                    .disabled(viewModel.wifi.security == .none)
                    .labelsHidden()
                    .focused($focusedField, equals: .password)
                } header: {
                    Group {
                        Text("Password")

                        if viewModel.wifi.isPasswordInvalid {
                            Text("Must be at least \(viewModel.wifi.security.minPassCount) characters long")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                    .fixedSize()
                }

                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Picker("Encryption", selection: $viewModel.wifi.security) {
                                Text(verbatim: "WPA")
                                    .tag(Security.wpa)

                                Text(verbatim: "WEP")
                                    .tag(Security.wep)

                                Text("Passwordless")
                                    .tag(Security.none)

                            }
                            .labelsHidden()
                            .pickerStyle(.segmented)

                            Button {
                                viewModel.isShowingSecurityInfo.toggle()
                            } label: {
                                Label("Info", systemImage: "info.circle")
                                    .labelStyle(.iconOnly)
                                    .help("Info")
                            }
                            .buttonStyle(.plain)
                            .foregroundColor(.primary)
                            .contentShape(Rectangle())
                            .popover(isPresented: $viewModel.isShowingSecurityInfo, arrowEdge: .bottom) {
                                Text("""
                                     If unsure, select WPA, as it is the default in most routers
                                     """)
                                .frame(width: 256)
                                .padding(12)
                            }
                        }

                        Toggle("Hidden Network", isOn: $viewModel.wifi.isHiddenNetwork)
                            .fixedSize()
                    }
                } header: {
                    Text("Security")
                        .fixedSize()
                }
            }
            .textFieldStyle(.roundedBorder)
            .animation(.default, value: viewModel.wifi.isSSIDInvalid)
            .animation(.default, value: viewModel.wifi.isPasswordInvalid)
            .onSubmit {
                if focusedField == .ssid {
                    focusedField = .password
                } else {
                    focusedField = nil
                }
            }
        }
        .environmentObject(viewModel)
        .onTapGesture {
            focusedField = nil
        }
    }

    enum Field: String {
        case ssid, password
    }
}


struct WifiGenerator_Previews: PreviewProvider {
    static var previews: some View {
        WifiGenerator(viewModel: WifiGenerator.ViewModel())
    }
}
