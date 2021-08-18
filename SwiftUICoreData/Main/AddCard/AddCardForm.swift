//
//  AddCardForm.swift
//  AddCardForm
//
//  Created by Huy Ong on 7/21/21.
//

import SwiftUI
import Combine

struct AddCardForm: View {
    
    let card: Card?
    var didAddCard: ((Card) -> Void)? = nil
    
    var cancellables = Set<AnyCancellable>()
    
    init(card: Card? = nil, didAddCard: ((Card) -> Void)? = nil) {
        self.card = card
        self.didAddCard = didAddCard
        
        _name = State(initialValue: card?.name ?? "")
        _cardNumber = State(initialValue: card?.cardNumber ?? "")
        _cardType = State(initialValue: card?.cardType ?? "")
        
        if let limit = card?.limit {
            _limit = State(initialValue: String(limit))
        }
        
        _month = State(initialValue: Int(card?.expMonth ?? 1))
        _year = State(initialValue: Int(card?.expYear ?? Int16(currentYear)))
        
        if let data = card?.color, let uiColor = UIColor.color(data: data) {
            let c = Color(uiColor: uiColor)
            _color = State(initialValue: c)
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var viewContext
    
    @State private var name = ""
    @State private var cardNumber = ""
    @State private var limit = ""
    @State private var cardType = "Visa"
    @State private var month = 1
    @State private var year = Calendar.current.component(.year, from: Date())
    @State private var color = Color.blue
    
    private let currentYear = Calendar.current.component(.year, from: Date())
    
    var body: some View {
        NavigationView {
            Form {
                
                Section(header: Text("Card Info")) {
                    TextField("Name", text: $name)
                    TextField("Credit Card Number", text: $cardNumber)
                        .keyboardType(.numberPad)
                    TextField("Credit Limit", text: $limit)
                        .keyboardType(.numberPad)
                    
                    Picker("Type", selection: $cardType) {
                        ForEach(["Visa", "Mastercard", "Discover", "Citibank"], id: \.self) { cardType in
                            Text(String(cardType)).tag(String(cardType))
                        }
                    }
                }
                
                Section(header: Text("Expiration")) {
                    Picker("Month", selection: $month) {
                        ForEach(1..<13, id: \.self) { num in
                            Text(String(num)).tag(String(num))
                        }
                    }
                    
                    Picker("Year", selection: $year) {
                        ForEach(currentYear..<currentYear + 20, id: \.self) { num in
                            Text(String(num)).tag(String(num))
                        }
                    }
                }
                
                Section(header: Text("Color")) {
                    ColorPicker("Color", selection: $color)
                }
                
            }
            .navigationTitle(card != nil ? card?.name ?? "" : "Add Credit Card")
            .navigationBarItems(leading: leadingView, trailing: trailingView)
        }
    }
    
    private var trailingView: some View {
        Button("Save") {
            saveANewCard()
        }
        .customButton()
    }
    
    private var leadingView: some View {
        Button("Cancel") {
            presentationMode.wrappedValue.dismiss()
        }
        .customButton()
    }
    
    private func saveANewCard() {
        let card = self.card != nil ? self.card! : Card(context: viewContext)
        card.name = name
        card.cardNumber = cardNumber
        card.cardType = cardType.lowercased()
        card.limit = Int32(limit) ?? 0
        card.expMonth = Int16(month)
        card.expYear = Int16(year)
        card.timestamp = Date()
        card.color = UIColor(color).encode()
        try? viewContext.save()
        presentationMode.wrappedValue.dismiss()
        didAddCard?(card)
    }
    
}
