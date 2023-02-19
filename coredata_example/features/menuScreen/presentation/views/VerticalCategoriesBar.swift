//
//  VerticalCategoriesBar.swift
//  coredata_example
//
//  Created by Yousef on 2/16/23.
//

import SwiftUI

struct VerticalCategoriesBar: View {
    let categories: [Category]
    let selectedCategory: Int?
    var onSelectionChange: (Category) -> Void
    
    @Namespace private var animation
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
                .frame(height: 16)
            ForEach(categories) { cat in
                VerticalText(
                    text: cat.name, isSelected: cat.id == selectedCategory,
                    animation: animation,
                    tag: "Selected_Vertical_Category"
                ) {
                    onSelectionChange(cat)
                }
            }
            Spacer()
                .frame(height: 16)
        }
        .frame(width: 44)
    }
}


