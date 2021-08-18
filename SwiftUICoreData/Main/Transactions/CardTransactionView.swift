//
//  CardTransactionView.swift
//  CardTransactionView
//
//  Created by Huy Ong on 7/24/21.
//

import SwiftUI

struct CardTransactionView: View {
    let transaction: CardTransaction
    
    @State private var shouldPresentActionSheet = false
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(transaction.name ?? "")
                        .font(.headline)
                    
                    if let date = transaction.timestamp {
                        Text(Date.dateFormatter.string(from: date))
                    }
                }
                Spacer()
                
                VStack(alignment: .trailing) {
                    Button {
                        shouldPresentActionSheet.toggle()
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 24))
                    }
                    .padding(EdgeInsets(top: 6, leading: 8, bottom: 4, trailing: 0))
                    .actionSheet(isPresented: $shouldPresentActionSheet) {
                        ActionSheet(title: Text(transaction.name ?? ""), message: nil, buttons: [
                            .destructive(Text("Delete"), action: handleDelete),
                            .cancel()
                        ])
                    }
                    
                    Text("$\(String(format: "%.2f", transaction.amount))")
                    
                }
            }
            
            if let categories = transaction.categories as? Set<TransactionCategory>,
               let sortedByTimestampCategories = Array(categories).sorted(by: {$0.timestamp?.compare($1.timestamp ?? Date()) == .orderedDescending}) {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(sortedByTimestampCategories) { category in
                            Text(category.name ?? "")
                                .lineLimit(1)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 8)
                                .background(Color(uiColor: UIColor.color(data: category.colorData ?? Data()) ?? .black))
                                .cornerRadius(5)
                        }
                    }
                }
            }
            
            if let photoData = transaction.photoData, let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            }
        }
        .foregroundColor(Color(.label))
        .padding()
        .background(Color.white)
        .cornerRadius(5)
        .shadow(radius: 5)
        .padding()
    }
    
    private func handleDelete() {
        withAnimation {
            do {
                let context = PersistenceController.shared.container.viewContext
                context.delete(transaction)
                try context.save()
            } catch {
                print("Failed to delete transaction", error.localizedDescription)
            }
        }
    }
}
