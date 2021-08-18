//
//  CategoryView.swift
//  CategoryView
//
//  Created by Huy Ong on 7/28/21.
//

import SwiftUI

struct CategoryView: View {
    let category: TransactionCategory
    let containsCategory: Bool
    
    init(category: TransactionCategory, containsCategory: Bool = false) {
        self.category = category
        self.containsCategory = containsCategory
    }
    
    var body: some View {
        HStack {
            if let colorData = category.colorData, let uiColor = UIColor.color(data: colorData) {
                Circle()
                    .frame(width: 20)
                    .foregroundColor(Color(uiColor: uiColor))
            }
            Text(category.name ?? "")
                .foregroundColor(Color(.label))
            Spacer()
            Image(systemName: "checkmark")
                .foregroundColor(.blue)
                .opacity(containsCategory ? 1 : 0)
        }
    }
}
