//
//  FormRowStaticView.swift
//  ToDoSwiftUI
//
//  Created by Nileshkumar M. Prajapati on 2023/04/21.
//

import SwiftUI

struct FormRowStaticView: View {
    
    //MARK: - Properties
    
    var icon: String
    var keyTitle: String
    var keyValue: String
    
    //MARK: - Body
    
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(.gray)
                
                Image(systemName: icon)
                    .foregroundColor(.white)
            }//: ZStack
            .frame(width: 36, height: 36, alignment: .center)
            
            Text(keyTitle)
                .foregroundColor(.gray)
                .font(.subheadline)
            
            Spacer()
            
            Text(keyValue)
                .font(.subheadline)
        }
    }
}

//MARK: - Preview

struct FormRowStaticView_Previews: PreviewProvider {
    static var previews: some View {
        FormRowStaticView(icon: "gear", keyTitle: "Application", keyValue: "Todo")
            .previewLayout(.fixed(width: 375, height: 60))
            .padding()
    }
}
