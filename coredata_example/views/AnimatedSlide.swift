//
//  AnimatedSlide.swift
//  coredata_example
//
//  Created by Yousef on 2/19/23.
//

import SwiftUI

struct AnimatedSlide: View {
    let amount: Int
    @State var isVisible: Bool = true
    @State var offset: CGFloat = 0
    var body: some View {
        ZStack {
            Text("\(amount)")
                .opacity(isVisible ? 1 : 0)
                .offset(y: offset)
        }
        .onChange(of: amount, perform: { value in
            performAnimation(value: value)
        })
        .clipped()
    }
    
    func performAnimation(value: Int) {
        isVisible = false
        if value > amount {
            offset = 16
        } else {
            offset = -16
        }
        isVisible = true
        withAnimation(Animation.easeIn(duration: 0.25)) {
            offset = 0
        }
        
    }
}

struct TestAnimatedSlide: View {
    @State var amount: Int = 0
    @State var badge: Int = 0
    
    var body: some View {
        VStack(spacing: 32) {
            HStack {
                Button(action: {
                    amount = amount + 1
                }, label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .foregroundColor(Color.green)
                        .frame(width: 24, height: 24, alignment: .center)
                })
                .frame(width: 44, height: 44, alignment: .center)
                
                AnimatedSlide(amount: amount)
                
                Button(action: {
                    if amount > 0 {
                        amount = amount -  1
                    }
                }, label: {
                    Image(systemName: "minus.circle.fill")
                        .resizable()
                        .foregroundColor(Color.green)
                        .frame(width: 24, height: 24, alignment: .center)
                })
                .frame(width: 44, height: 44, alignment: .center)
            }
        }
    }
}

struct AnimatedSlide_Previews: PreviewProvider {
    static var previews: some View {
        TestAnimatedSlide()
    }
}
