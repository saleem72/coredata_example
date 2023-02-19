//
//  ProductListItem.swift
//  coredata_example
//
//  Created by Yousef on 2/16/23.
//

import SwiftUI
import CoreData

struct ProductListItem: View {
    let product: Product
    @State var deleteButtonWidth: CGFloat = 30
    @State var isExpanded: Bool = false
    var body: some View {
        HStack(spacing: 16) {
            Rectangle()
                .fill(Color.pallet.tertiaryContainer)
                .frame(width: 75, height: 75)
            
            VStack(alignment: .leading) {
                Text(product.name)
                    .lineLimit(1)
                
                Text(product.size)
                Text(String(format: "%.0f $", product.price))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
                .frame(width: 30)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(
            ZStack(alignment: .trailing) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.pallet.secondaryContainer)
                    .shadow(color: Color.black.opacity(0.25), radius: 8, x: 0.0, y: 4)
                
                FlippingText(label: "Other", color: Color.pallet.error)
            }
        )
        .animation(.easeIn)
        
    }
    
}


