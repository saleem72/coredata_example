//
//  ShakedBadge.swift
//  coredata_example
//
//  Created by Yousef on 2/19/23.
//

import SwiftUI


struct ShakedBadge: View {
    let amount: Int
    let badgeBackgroundColor: Color
    let badgeForegroundColor: Color
    @State var selected = false
    var body: some View {
        ZStack {
            Text("\(amount)")
                .font(.caption)
                .foregroundColor(badgeForegroundColor)
                .padding(6)
                .background(badgeBackgroundColor)
                .clipShape(Circle())
                .offset(x: 12, y: -12)
                .opacity(amount > 0 ? 1 : 0)
                .offset(x: selected ? 6 : 0)
        }
        .onChange(of: amount, perform: { value in
            print("new Value: \(value)")
            selected = true
            withAnimation(Animation.default.repeatCount(6).speed(6)) {
                selected = false
            }
        })
    }
}

struct TestShakedBadge: View {
    @State var amount: Int = 0
    @State var badge: Int = 0
    
    var body: some View {
        VStack(spacing: 32) {
            HStack {
                Button(action: {
                    badge = badge + 1
                }, label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .foregroundColor(Color.green)
                        .frame(width: 24, height: 24, alignment: .center)
                })
                .frame(width: 44, height: 44, alignment: .center)
                
                ShakedBadge(amount: badge, badgeBackgroundColor: Color.red, badgeForegroundColor: Color.white)
                
                Button(action: {
                    if badge > 0 {
                        badge = badge -  1
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


struct ShakedBadge_Previews: PreviewProvider {
    static var previews: some View {
        TestShakedBadge()
    }
}
