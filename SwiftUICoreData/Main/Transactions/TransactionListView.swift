//
//  TransactionListView.swift
//  TransactionListView
//
//  Created by Huy Ong on 7/24/21.
//

import SwiftUI

struct TransactionListView: View {
    let card: Card
    
    init(card: Card) {
        self.card = card
        
        fetchRequest = FetchRequest<CardTransaction>(
            entity: CardTransaction.entity(),
            sortDescriptors: [NSSortDescriptor(key: "timestamp", ascending: false)],
            predicate: NSPredicate(format: "card == %@", card)
        )
    }
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var shouldShowAddTransactionForm = false
    @State private var shouldFilterSheet = false
    @State var selectedCategories = Set<TransactionCategory>()
    
    var fetchRequest: FetchRequest<CardTransaction>
    
    var body: some View {
        VStack {
            if fetchRequest.wrappedValue.isEmpty {
                Text("Get started by adding your first transaction")
                Button("+ Transaction") {
                    shouldShowAddTransactionForm.toggle()
                }
                .customButton(font: .callout)
            } else {
                HStack {
                    Spacer()
                    addTransaction
                    filterButton
                }
                .padding(.horizontal)
                
                ForEach(filterTransactions(selectedCategories)) { transaction in
                    CardTransactionView(transaction: transaction)
                }
            }
        }
        .fullScreenCover(isPresented: $shouldShowAddTransactionForm) {
            AddTransactionFormView(card: card)
        }
    }
    
    private var addTransaction: some View {
        Button("+ Transaction") {
            shouldShowAddTransactionForm.toggle()
        }
        .customButton()
    }
    
    private func filterTransactions(_ selectedCategories: Set<TransactionCategory>) -> [CardTransaction] {
        if selectedCategories.isEmpty {
            return Array(fetchRequest.wrappedValue)
        }
        
        return fetchRequest.wrappedValue.filter { transaction in
            var shouldKeep = false
            
            if let categories = transaction.categories as? Set<TransactionCategory> {
                categories.forEach { category in
                    if selectedCategories.contains(category) {
                        shouldKeep = true
                    }
                }
            }
            
            return shouldKeep
        }
    }
    
    private var filterButton: some View {
        Button {
            shouldFilterSheet.toggle()
        } label: {
            Label("Filter", systemImage: "line.3.horizontal.decrease.circle.fill")
        }
        .customButton()
        .sheet(isPresented: $shouldFilterSheet) {
            FilterSheetView(selectedCategories: selectedCategories) { categories in
                selectedCategories = categories
            }
        }
    }
}
