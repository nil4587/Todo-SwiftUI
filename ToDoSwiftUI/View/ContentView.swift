//
//  ContentView.swift
//  ToDoSwiftUI
//
//  Created by Nileshkumar M. Prajapati on 2023/04/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    //MARK: - Properties
    
    @Environment(\.managedObjectContext) private var objectContext
    @EnvironmentObject var iconSettings: IconNames
    
    @FetchRequest(entity: Todo.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Todo.timestamp, ascending: true)],
                  animation: .default)
    
    private var todoItems: FetchedResults<Todo>
    @State private var showingAddTodoView: Bool = false
    @State private var animatingButton: Bool = false
    @State private var showingSettingsView: Bool = false
    
    @ObservedObject var theme = ThemeSettings()
    var themes: [Theme] = themeData
    
    //MARK: - Body
    
    var body: some View {
        NavigationStack {
            ZStack {
                //MARK: - ToDo Items
                List {
                    ForEach(todoItems, id: \.self) { item in
                        HStack {
                            Circle()
                                .frame(width: 12, height: 12, alignment: .center)
                                .foregroundColor(colorize(priority: item.priority ?? ""))
                            
                            Text(item.name ?? "Unknown")
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            Text(item.priority ?? "Unknown")
                                .font(.footnote)
                                .foregroundColor(Color(UIColor.systemGray2))
                                .padding(3)
                                .frame(minWidth: 62)
                                .overlay(
                                    Capsule()
                                        .stroke(Color(UIColor.systemGray2), lineWidth: 0.75)
                                )
                        }//: List HStack
                        .padding(.vertical, 10)
                    }//: ForEach
                    .onDelete(perform: deleteTodo(at:))
                } //: List
                .navigationTitle("Todo")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem {
                        Button {
                            self.showingSettingsView.toggle()
                        } label: {
                            Image(systemName: "paintbrush")
                        }//: Add Button
                        .tint(themes[self.theme.themeSettings].themeColor)
                        .sheet(isPresented: $showingSettingsView) {
                            SettingsView()
                                .environmentObject(iconSettings)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                            .tint(themes[self.theme.themeSettings].themeColor)
                    }
                }//: NavigationToolBar
                
                //MARK: - No ToDo Items
                if todoItems.isEmpty {
                    EmptyListView()
                }

            }//: ZStack
            .sheet(isPresented: $showingAddTodoView) {
                AddToDoView()
            }
            .overlay (
                ZStack {
                    Group {
                        Circle()
                            .fill(themes[self.theme.themeSettings].themeColor)
                            .opacity(self.animatingButton ? 0.2 : 0)
                            .scaleEffect(self.animatingButton ? 1 : 0)
                            .frame(width: 68, height: 68, alignment: .center)
                        
                        Circle()
                            .fill(themes[self.theme.themeSettings].themeColor)
                            .opacity(self.animatingButton ? 0.15 : 0)
                            .scaleEffect(self.animatingButton ? 1 : 0)
                            .frame(width: 88, height: 88, alignment: .center)
                    }
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: self.animatingButton)
                    
                    Button(action: {
                        self.showingAddTodoView.toggle()
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .background(
                                Circle()
                                    .fill(Color("ColorBase"))
                            )
                            .frame(width: 48, height: 48, alignment: .center)
                    })//: Button Button Plus
                    .tint(themes[self.theme.themeSettings].themeColor)
                    .onAppear {
                        self.animatingButton.toggle()
                    }
                }//: ZStack
                    .padding(.bottom, 15)
                    .padding(.trailing, 15)
                ,alignment: .bottomTrailing
            )
        } //: Navigation
    }
}

//MARK: - Private Functions

private extension ContentView {
    func deleteTodo(at offsets: IndexSet) {
        for index in offsets {
            let todo = todoItems[index]
            objectContext.delete(todo)
            
            do {
                try objectContext.save()
            } catch {
                print("Couldn't delete object due to \(error)")
            }
        }
    }
    
    func colorize(priority: String) -> Color {
        switch priority {
        case "High":
            return .pink
        case "Normal":
            return .green
        case "Low":
            return .blue
        default:
            return .gray
        }
    }
}

//MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.shared.container.viewContext
        ContentView()
            .environment(\.managedObjectContext, viewContext)
    }
}
