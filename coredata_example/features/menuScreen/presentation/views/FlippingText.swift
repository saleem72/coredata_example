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
    let buttonColor: Color
    let onIncrement: () -> ()
    let onDecrement: () -> ()
    var totalWidth: CGFloat? {
        textState == .collapsed ? 30 :
            textState == .expanded ? 180 : nil
    }
    
    var corners: UIRectCorner {
        textState == .fullfill ? [.bottomRight, .topRight, .bottomLeft, .topLeft] : [.bottomRight, .topRight]
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            CustomCornerShape(corners: corners, cornerRaduis: 12)
                .fill(textState == .fullfill ? color.opacity(0.3) : color)
                .frame(width: totalWidth)
            
            Rectangle()
                .fill(Color.yellow.opacity(0.001))
                .onTapGesture {
                    if textState == .expanded {
                        isExpanded = false
                    }
                    withAnimation(Animation.easeIn(duration: 0.5)) {
                        if textState == .collapsed {
                            textState = .expanded
                        } else if textState == .expanded {
                            textState = .collapsed
                        }
                    }
                    if textState == .expanded {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            isExpanded = true
                        }
                    }
                    
                }
            
            
            HStack {
                if isExpanded {
                    Button(action: onIncrement, label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .foregroundColor(buttonColor)
                            .frame(width: 24, height: 24, alignment: .center)
                            .animation(.none)
                    })
                    .frame(width: 44, height: 44, alignment: .center)
                    .animation(.none)
                }
                
                
//                AnimatedSlide(amount: product.cartCount)
                Text(label)
                    .fontWeight(.bold)
                    .foregroundColor(buttonColor)
                    .rotationEffect(Angle(degrees: textState == .expanded ? 0 : -90))
                
                if isExpanded {
                    Button(action: onDecrement, label: {
                        Image(systemName: "minus.circle.fill")
                            .resizable()
                            .foregroundColor(buttonColor)
                            .frame(width: 24, height: 24, alignment: .center)
                            .animation(.none)
                    })
                    .frame(width: 44, height: 44, alignment: .center)
                }
                
            }
            .frame(width: totalWidth)
        }
    }
}

extension FlippingText {
    enum TextState {
        case collapsed
        case expanded
        case fullfill
    }
}
