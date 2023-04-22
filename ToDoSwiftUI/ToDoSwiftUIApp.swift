//
//  ToDoSwiftUIApp.swift
//  ToDoSwiftUI
//
//  Created by Nileshkumar M. Prajapati on 2023/04/21.
//

import SwiftUI

@main
struct ToDoSwiftUIApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(IconNames())
        }
    }
}


class IconNames: ObservableObject {
    var iconNames: [String] = []
    @Published var currentIndex = 0

    init() {
        getAlternateIconNames()
        
        if let currentIcon = UIApplication.shared.alternateIconName {
            self.currentIndex = iconNames.firstIndex(of: currentIcon) ?? 0
        }
    }
    
    func getAlternateIconNames() {
        guard let icons = Bundle.main.object(forInfoDictionaryKey: "CFBundleIcons") as? [String: Any] else { return }
        guard let alternateIcons = icons["CFBundleAlternateIcons"] as? [String: Any] else { return }
        
        for (_, value) in alternateIcons {
            guard let iconList = value as?  [String: Any] else { return }
            guard let iconFiles = iconList["CFBundleIconFiles"] as? [String] else { return }
            guard let icon = iconFiles.first else { return }
            
            iconNames.append(icon)
        }
    }
}
