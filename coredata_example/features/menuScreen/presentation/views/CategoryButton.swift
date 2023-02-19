//
//  CategoryButton.swift
//  coredata_example
//
//  Created by Yousef on 2/16/23.
//

import SwiftUI


struct CategoryButton: View {
    
    var item: String
    var isActive: Bool
    var animation: Namespace.ID
    var tag: String
    var onChange: () -> Void
    @State var size: CGSize = .zero
    
    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                onChange()
            }
        }, label: {
            ZStack(alignment: Alignment.center) {
                
                if isActive {
                    Capsule()
                        .fill(Color.pallet.secondaryContainer)
                        .matchedGeometryEffect(id: tag, in: animation)
                        .frame(width: size.width, height: size.height)
                        .offset(y: 8)
                }
                
                Text(item)
                    .foregroundColor(isActive ? Color.pallet.onSecondaryContainer : Color.pallet.onBackground)
                    .padding(.top)
                    .padding(.horizontal)
                    .background(
                        GeometryReader { proxy -> Color in
                            
                            DispatchQueue.main.async {
                                self.size = proxy.size
                            }
                            
                            return Color.clear
                        }
                    )
            }
            
            .frame(height: 60, alignment: .top)
        })
    }
}

