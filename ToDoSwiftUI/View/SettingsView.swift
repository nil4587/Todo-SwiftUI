//
//  SettingsView.swift
//  ToDoSwiftUI
//
//  Created by Nileshkumar M. Prajapati on 2023/04/21.
//

import SwiftUI

struct SettingsView: View {
    
    //MARK: - Properties
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var iconSettings: IconNames
    
    let themes: [Theme] = themeData
    @ObservedObject var theme = ThemeSettings()
    
    //MARK: - Body
    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 0) {
                //1. Form
                Form {
                    Section(header: Text("Choose the app icon").font(.headline)) {
                        Picker(selection: $iconSettings.currentIndex) {
                            ForEach(0..<iconSettings.iconNames.count) { index in
                                let iconName = self.iconSettings.iconNames[index]
                                AppIconPickerView(iconName: iconName)
                            }
                        } label: {
                            Label {
                                Text("App Icons")
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                            } icon: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 9, style: .continuous)
                                        .strokeBorder(.primary, lineWidth: 2)
                                    
                                    Image(systemName: "paintbrush")
                                        .font(.system(size: 22, weight: .regular, design: .default))
                                    .foregroundColor(.primary)
                                }
                                .frame(width: 44, height: 44)
                            }
                        } //: Picker
                        .onReceive([self.iconSettings.currentIndex].publisher.first()) { value in
                            let index = self.iconSettings.iconNames.firstIndex(of: UIApplication.shared.alternateIconName ?? "") ?? 0
                            if index != value {
                                UIApplication.shared.setAlternateIconName(self.iconSettings.iconNames[value]) { error in
                                    guard let error else {
                                        return
                                    }
                                    print(error.localizedDescription)
                                }
                            }
                        }
                    } //: Section 1
                    .padding(.vertical, 3)
                    
                    Section(header:
                        HStack {
                            Text("Choose the app theme").font(.headline)
                        Image(systemName: "circle.fill")
                            .resizable()
                            .frame(width: 10, height: 10)
                            .foregroundColor(themes[self.theme.themeSettings].themeColor)
                        }
                    ) {
                        List(themes, id: \.id) { theme in
                            Button {
                                self.theme.themeSettings = theme.id
                                UserDefaults.standard.setValue(self.theme.themeSettings, forKey: "Theme")
                            } label: {
                                HStack {
                                    Image(systemName: "circle.fill")
                                        .foregroundColor(theme.themeColor)
                                    
                                    Text(theme.themeName)
                                        .foregroundColor(.primary)
                                }
                            } //: Button Theme
                        }
                    } //: Section 2
                    .padding(.vertical, 3)
                    
                    Section(header: Text("Apple").font(.headline)) {
                        FormRowLinkView(icon: "globe", color: .pink, keyTitle: "Developer", keyLinkValue: "https://developer.apple.com")
                        FormRowLinkView(icon: "link", color: .blue, keyTitle: "Human Interface Guideline", keyLinkValue: "https://developer.apple.com/design/human-interface-guidelines/guidelines/overview/")
                        FormRowLinkView(icon: "play.rectangle", color: .green, keyTitle: "Videos", keyLinkValue: "https://developer.apple.com/videos/")
                    } //: Section 3
                    
                    Section(header: Text("About the application").font(.headline)) {
                        FormRowStaticView(icon: "gear", keyTitle: "Application", keyValue: "Todo")
                        FormRowStaticView(icon: "checkmark.seal", keyTitle: "Compatibility", keyValue: "iPhone, iPad")
                        FormRowStaticView(icon: "keyboard", keyTitle: "Developer", keyValue: "iOS Developer")
                        FormRowStaticView(icon: "flag", keyTitle: "Version", keyValue: "1..0.0")
                    } //: Section 4
                } //: Form
                .listStyle(.grouped)
                .environment(\.horizontalSizeClass, .regular)
                
                //2. Footer
                Text("Copyright © All rights reserved.")
                    .font(.footnote)
                    .padding(.top, 6)
                    .padding(.bottom, 8)
                    .foregroundColor(.secondary)
            }//: VStack
            .toolbar(content: {
                ToolbarItem {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            })
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .background(
                Color("ColorBackground")
                    .edgesIgnoringSafeArea(.all)
            )
        }//: NavigationView
        .accentColor(themes[self.theme.themeSettings].themeColor)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(IconNames())
    }
}
