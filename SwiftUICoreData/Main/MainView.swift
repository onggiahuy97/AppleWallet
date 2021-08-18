//
//  MainView.swift
//  MainView
//
//  Created by Huy Ong on 7/20/21.
//

import SwiftUI

struct MainView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Card.timestamp, ascending: false)],
        animation: .default
    ) private var cards: FetchedResults<Card>
    
    @State private var shouldPresentAddCardForm = false
    @State private var selectedCardHash = -1

    var body: some View {
        NavigationView {
            ScrollView {
                if !cards.isEmpty {
                    TabView(selection: $selectedCardHash) {
                        ForEach(cards) { card in
                            CreditCardView(card: card)
                                .padding(.bottom, 50)
                                .tag(card.hash)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .frame(height: 280)
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                    .onAppear { self.selectedCardHash = cards.first?.hash ?? -1 }
                    
                    if let firstIndex = cards.firstIndex(where: { $0.hash == selectedCardHash}) {
                        let card = self.cards[firstIndex]
                        TransactionListView(card: card)
                    }
                } else {
                    emptyPromtMessage
                }
                
                Spacer()
                    .fullScreenCover(isPresented: $shouldPresentAddCardForm, onDismiss: nil) {
                        AddCardForm(card: nil) { card in
                            self.selectedCardHash = card.hash
                        }
                    }
            }
            .navigationTitle("Credit Cards")
            .navigationBarItems(leading: leadingView, trailing: addCardButton)
        }
    }
    
    private var emptyPromtMessage: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("You currently don't have any card in your wallet.")
                .font(.system(size: 18, weight: .semibold))
                .multilineTextAlignment(.center)
            Text("Would you like to add a card?")
            Button("+ Add A New Card") {
                shouldPresentAddCardForm.toggle()
            }
            .customButton()
        }
        .padding()
    }
    
    var leadingView: some View {
        Button("Delete All") {
            withAnimation {
                cards.forEach { card in viewContext.delete(card) }
                try? viewContext.save()
            }
        }
        .customButton()
    }
    
    var addCardButton: some View {
        Button("+ Card") {
            shouldPresentAddCardForm.toggle()
        }
        .customButton()
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
