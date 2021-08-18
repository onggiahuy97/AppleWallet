//
//  CreditCardView.swift
//  CreditCardView
//
//  Created by Huy Ong on 7/21/21.
//

import SwiftUI

struct CreditCardView: View {
    let card: Card
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var fetchRequest: FetchRequest<CardTransaction>
    
    @State var refreshId = UUID()
    @State private var presentActionSheet = false
    @State private var presentEditForm = false
    
    init(card: Card) {
        self.card = card
        
        fetchRequest = FetchRequest<CardTransaction>(
            entity: CardTransaction.entity(),
            sortDescriptors: [.init(key: "timestamp", ascending: false)],
            predicate: .init(format: "card == %@", self.card)
        )
        
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(card.name ?? "Unknown")
                    .font(.system(size: 24, weight: .semibold))
                Spacer()
                Button {
                    presentActionSheet.toggle()
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 28, weight: .bold))
                }
                .actionSheet(isPresented: $presentActionSheet) {
                    ActionSheet(title: Text(card.name ?? ""), message: Text("Options"), buttons: [
                        .default(Text("Edit"), action: { presentEditForm.toggle() }),
                        .destructive(Text("Delete Card"), action: deleteCard),
                        .cancel()
                    ])
                }
            }
            
            HStack {
                Image(card.cardType ?? "Unknown")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 44)
                    .clipped()
                Spacer()
                
                if let balance = fetchRequest.wrappedValue.reduce(0, { $0 + $1.amount }),
                   let balanceString = String(format: "%.2f", balance) {
                    Text("Balance: $\(balanceString)")
                        .font(.system(size: 18, weight: .semibold))
                }
            }
            
            
            Text(card.cardNumber ?? "Unknown")
            
            Text("Credit Limit: $\(card.limit)")
            
            HStack { Spacer() }
        }
        .foregroundColor(.white)
        .padding()
        .frame(height: 220)
        .background(cardBackgroundColor)
        .overlay(RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.label).opacity(0.5), lineWidth: 1)
        )
        .cornerRadius(8)
        .shadow(radius: 5)
        .padding(.horizontal)
        .padding(.top, 8)
        .fullScreenCover(isPresented: $presentEditForm) {
            AddCardForm(card: card)
        }
    }
    
    var cardBackgroundColor: some View {
        VStack {
            if let colorData = card.color,
               let uiColor = UIColor.color(data: colorData),
               let actualColor = Color(uiColor) {
                LinearGradient(colors: [
                    actualColor.opacity(0.6),
                    actualColor
                ], startPoint: .center, endPoint: .bottom)
            } else {
                Color.purple
            }
        }
    }
    
    private func deleteCard() {
        withAnimation {
            let viewContext = PersistenceController.shared.container.viewContext
            viewContext.delete(card)
            try? viewContext.save()
        }
    }
}
