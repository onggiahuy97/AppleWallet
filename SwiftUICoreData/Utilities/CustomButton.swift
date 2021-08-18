//
//  NavigationButton.swift
//  NavigationButton
//
//  Created by Huy Ong on 7/21/21.
//

import SwiftUI

struct CustomButton: View {
//    @Environment(\.colorScheme) var scheme
    
    let name: String
    let action: () -> Void
    
    init(_ name: String, action: @escaping (() -> Void)) {
        self.name = name
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(name)
                .foregroundColor(Color(.systemBackground))
                .font(.system(size: 16, weight: .bold))
                .padding(8)
                .background(Color(.label))
                .cornerRadius(5)
        }
    }
}

struct CustomButtonStyle: ButtonStyle {
    static let defaultFont: Font = .system(size: 16, weight: .bold)
    
    private var font: Font
    
    init(_ font: Font = defaultFont) {
        self.font = font
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(Color(.systemBackground))
            .font(font)
            .padding(8)
            .background(Color(.label))
            .cornerRadius(5)
    }
}

extension Button {
    func customButton(font: Font = CustomButtonStyle.defaultFont) -> some View {
        self.buttonStyle(CustomButtonStyle(font))
    }
}
