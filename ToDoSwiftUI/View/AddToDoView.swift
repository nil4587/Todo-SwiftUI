//
//  AddToDoView.swift
//  ToDoSwiftUI
//
//  Created by Nileshkumar M. Prajapati on 2023/04/21.
//

import SwiftUI

struct AddToDoView: View {
    
    //MARK: - Properties
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var objectContext

    @State private var name: String = ""
    @State private var priority: String = "Normal"
    @State private var isErrorDisplayed: Bool = false
    @State private var errorTitle: String = ""
    @State private var errorMessage: String = ""
    
    let priorities = ["High", "Normal", "Low"]
    @ObservedObject var theme = ThemeSettings()
    var themes: [Theme] = themeData
    
    //MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading, spacing: 20) {
                    //1. Todo Name
                    TextField("Todo", text: $name)
                        .padding()
                        .background(Color(UIColor.tertiarySystemFill))
                        .cornerRadius(9)
                        .font(.system(size: 24, weight: .bold, design: .default))
                    
                    //2. Todo Priority
                    Picker("Priority", selection: $priority) {
                        ForEach(priorities, id:\.self) { item in
                            Text(item)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    //3. Button
                    Button {
                        guard self.name.isEmpty == false else {
                            self.isErrorDisplayed = true
                            self.errorTitle = "Invalid name!"
                            self.errorMessage = "Make sure to enter something for the todo item!"
                            return
                        }
                        self.isErrorDisplayed = false

                        let todo = Todo(context: self.objectContext)
                        todo.name = self.name
                        todo.priority = self.priority
                        todo.timestamp = Date()
                        
                        do {
                            try self.objectContext.save()
                            print("New Todo: \(String(describing: todo.name))")
                            dismiss()
                        } catch {
                            print("Couldn't save managed object due to \(error)")
                        }
                    } label: {
                        Text("Save")
                            .font(.system(size: 24, weight: .bold, design: .default))
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(themes[self.theme.themeSettings].themeColor)
                            .cornerRadius(9)
                            .foregroundColor(.white)
                    }//: Save Button
                    
                }//: VStack
                .padding(.horizontal)
                .padding(.vertical)
                
                Spacer()
                
            }//: VStack
            .navigationTitle("New ToDo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
            .alert(isPresented: $isErrorDisplayed) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("Got it!")))
            }
        }//: NavigationView
        .tint(themes[self.theme.themeSettings].themeColor)
    }
}

//MARK: - Preview

struct AddToDoView_Previews: PreviewProvider {
    static var previews: some View {
        AddToDoView()
    }
}
