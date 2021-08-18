//
//  FilterSheetView.swift
//  FilterSheetView
//
//  Created by Huy Ong on 8/2/21.
//

import SwiftUI

struct FilterSheetView: View {
    
    @State var selectedCategories: Set<TransactionCategory>
    let didSaveFilters: (Set<TransactionCategory>) -> Void
    
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TransactionCategory.timestamp, ascending: false)],
        animation: .default
    ) private var categroies: FetchedResults<TransactionCategory>
        
    var body: some View {
        NavigationView {
            Form {
                ForEach(categroies) { category in
                    Button {
                        if selectedCategories.contains(category) {
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
            }
            .navigationTitle("Select filters")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) { trailingView }
            }
        }
    }
    
    private var trailingView: some View {
        Button("Save") {
            didSaveFilters(selectedCategories)
            presentationMode.wrappedValue.dismiss()
        }
            .customButton()
    }
}
