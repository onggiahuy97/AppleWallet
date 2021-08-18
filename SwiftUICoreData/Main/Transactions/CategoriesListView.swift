//
//  CategoriesListView.swift
//  CategoriesListView
//
//  Created by Huy Ong on 7/27/21.
//

import SwiftUI

struct CategoriesListView: View {
    @Binding var selectedCategories: Set<TransactionCategory>

    @State private var name = ""
    @State private var color = Color.red    
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TransactionCategory.timestamp, ascending: false)],
        animation: .default
    ) private var categories: FetchedResults<TransactionCategory>
    
    var body: some View {
        Form {
            Section(header: Text("Select a categorye")) {
                ForEach(categories) { category in
                    Button {
                        if selectedCategories.contains(category)  {
                            selectedCategories.remove(category)
                        } else {
                            selectedCategories.insert(category)
                        }
                    } label: {
                        CategoryView(
                            category: category,
                            containsCategory: selectedCategories.contains(category)
                        )
                    }
                }
                .onDelete(perform: deleteCategoies)
            }
            
            Section(header: Text("Create a category")) {
                TextField("Name", text: $name)
                ColorPicker("Color", selection: $color)
                Button(action: handleCreate) {
                    Text("Create")
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .navigationTitle("Categories")
    }
    
    private func deleteCategoies(_ indexSet: IndexSet) {
        indexSet.forEach { i in
            let category = categories[i]
            selectedCategories.remove(category)
            viewContext.delete(category)
        }
        try? viewContext.save()
    }
    
    private func handleCreate() {
        let category = TransactionCategory(context: viewContext)
        category.name = name
        category.colorData = UIColor(color).encode()
        category.timestamp = Date()
        try? viewContext.save()
        self.name = ""
    }
}

