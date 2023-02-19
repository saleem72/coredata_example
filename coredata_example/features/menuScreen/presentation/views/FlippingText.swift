//
//  FlippingText.swift
//  coredata_example
//
//  Created by Yousef on 2/16/23.
//

import SwiftUI

struct FlippingText: View {
    @State var isExpanded: Bool = false
    @State var textState: TextState = .collapsed
    let label: String
    let color: Color
    var totalWidth: CGFloat? {
        textState == .collapsed ? 30 :
            textState == .expanded ? 120 : nil
    }
    
    var corners: UIRectCorner {
        textState == .fullfill ? [.bottomRight, .topRight, .bottomLeft, .topLeft] : [.bottomRight, .topRight]
    }
    
    var body: some View {
        ZStack {
            CustomCornerShape(corners: corners, cornerRaduis: 12)
                .fill(textState == .fullfill ? color.opacity(0.3) : color)
                .frame(width: totalWidth)
            
            Text(label)
                .fontWeight(.bold)
                .foregroundColor(Color.pallet.onError)
                .rotationEffect(Angle(degrees: isExpanded ? 0 : -90))
                .offset(y: isExpanded ? 12 : 0)
                .opacity(textState == .fullfill ? 0 : 1)
            
        }
        .overlay(
            Rectangle()
                .fill(Color.yellow.opacity(0.001))
                .onTapGesture {
                    withAnimation(Animation.easeIn(duration: 0.5)) {
                        if textState == .collapsed {
                            textState = .expanded
                            isExpanded = true
                        } else if textState == .expanded {
                            textState = .fullfill
                        } else if textState == .fullfill {
                            textState = .collapsed
                            isExpanded = false
                        }
                        
                    }
                }
        )
    }
}

extension FlippingText {
    enum TextState {
        case collapsed
        case expanded
        case fullfill
    }
}
