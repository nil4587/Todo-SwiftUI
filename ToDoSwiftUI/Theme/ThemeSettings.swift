//
//  ThemeSettings.swift
//  ToDoSwiftUI
//
//  Created by Nileshkumar M. Prajapati on 2023/04/22.
//

import SwiftUI

//MARK: - Theme Class

class ThemeSettings: ObservableObject {
    @Published var themeSettings: Int = UserDefaults.standard.integer(forKey: "Theme") {
        didSet {
            UserDefaults.standard.set(self.themeSettings, forKey: "Theme")
        }
    }
}
