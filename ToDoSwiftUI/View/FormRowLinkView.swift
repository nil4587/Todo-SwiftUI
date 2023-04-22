//
//  FormRowLinkView.swift
//  ToDoSwiftUI
//
//  Created by Nileshkumar M. Prajapati on 2023/04/21.
//

import SwiftUI

struct FormRowLinkView: View {
    
    //MARK: - Properties
    
    var icon: String
    var color: Color
    var keyTitle: String
    var keyLinkValue: String
    
    //MARK: - Body

    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(color)
                
                Image(systemName: icon)
                    .imageScale(.large)
                    .foregroundColor(.white)
    
            }//: ZStack
            .frame(width: 36, height: 36, alignment: .center)
            
            Text(keyTitle)
                .foregroundColor(.gray)
                .font(.subheadline)
            
            Spacer()
            
            Button {
                guard let url = URL(string: self.keyLinkValue), UIApplication.shared.canOpenURL(url) else { return }
                
                UIApplication.shared.open(url)
            } label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
            }
            .tint(Color(.systemGray2))
        }
    }
}

//MARK: - Preview

struct FormRowLinkView_Previews: PreviewProvider {
    static var previews: some View {
        FormRowLinkView(icon: "globe", color: Color.pink, keyTitle: "Website", keyLinkValue: "https://www.apple.com")
            .previewLayout(.fixed(width: 375, height: 60))
            .padding()
    }
}
