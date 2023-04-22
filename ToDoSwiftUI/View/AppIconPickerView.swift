//
//  AppIconPickerView.swift
//  ToDoSwiftUI
//
//  Created by Nileshkumar M. Prajapati on 2023/04/22.
//

import SwiftUI

struct AppIconPickerView: View {
    
    var iconName: String
    
    var body: some View {
        HStack {
            Text(iconName)
                .padding(.trailing, 5)
            
            Image("\(iconName) 1")
                .resizable()
                .scaledToFit()
                .frame(width: 36, height: 36, alignment: .center)
        }
    }
}

struct AppIconPickerView_Previews: PreviewProvider {
    static var previews: some View {
        AppIconPickerView(iconName: "Blue")
            .previewLayout(.sizeThatFits)
    }
}
