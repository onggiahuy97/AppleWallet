//
//  AddTransactionFormView.swift
//  AddTransactionFormView
//
//  Created by Huy Ong on 7/24/21.
//

import SwiftUI

struct AddTransactionFormView: View {
    
    let card: Card
    
    init(card: Card) {
        self.card = card
        
        let context = PersistenceController.shared.container.viewContext
        let request = TransactionCategory.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        
        do {
            let result = try context.fetch(request)
            if let first = result.first {
                self._selectedCategories = State(initialValue: [first])
            }
        } catch {
            print("Failed to preselect categories: \(error)")
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var amount = ""
    @State private var date = Date()
    @State private var photoData: Data?
    @State private var shouldPresentPhotoPicker = false
    @State private var selectedCategories = Set<TransactionCategory>()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Infomation")) {
                    TextField("Name", text: $name)
                    TextField("Amount", text: $amount)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    
                }
                
                Section {
                    NavigationLink {
                        CategoriesListView(selectedCategories: $selectedCategories)
                    } label: {
                        Text("Select categories")
                    }
                    
                    let categoriesArray = selectedCategories
                        .map { $0 }
                        .sorted(by: { $0.timestamp ?? Date() > $1.timestamp ?? Date() })
                   
                    ForEach(categoriesArray) { selectedCategory in
                        CategoryView(category: selectedCategory)
                    }
                }
                
                Section(header: Text("Photo/Receipt")) {
                    Button("Select photo") {
                        shouldPresentPhotoPicker.toggle()
                    }
                    .fullScreenCover(isPresented: $shouldPresentPhotoPicker) {
                        PhotoPickerView(photoData: $photoData)
                    }
                    
                    if let data = self.photoData, let image = UIImage.init(data: data) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .cornerRadius(5)
                    }
                    
                }
            }
            .navigationTitle("Add Transaction")
            .navigationBarItems(leading: leadingView, trailing: trailingView)
        }
    }
    
    private var leadingView: some View {
        Button("Cancel") {
            presentationMode.wrappedValue.dismiss()
        }
        .customButton()
    }
    
    private var trailingView: some View {
        Button("Save") {
            let context = PersistenceController.shared.container.viewContext
            let transaction = CardTransaction(context: context)
            transaction.name = name
            transaction.amount = Float(amount) ?? 0
            transaction.timestamp = Date()
            transaction.photoData = photoData
            transaction.card = self.card
            transaction.categories = self.selectedCategories as NSSet
            do {
                try context.save()
                presentationMode.wrappedValue.dismiss()
            } catch {
                print("Failed to save transaction \(error)")
            }
        }
        .customButton()
    }
}
