//
//  CartButton.swift
//  coredata_example
//
//  Created by Yousef on 2/19/23.
//

import SwiftUI


struct CartButton: View {
    let count: Int
    private var badgeBackgroundColor: Color = Color.red
    private var badgeForegroundColor: Color = Color.white
    private var iconColor: Color = Color.blue
    init(count: Int, onTap: () -> Void) {
        self.count = count
    }
    var body: some View {
        Button(action: {}, label: {
            ZStack {
                Image(systemName: "cart.fill")
                    .resizable()
                    .frame(width: 24, height: 24, alignment: .center)
                    .foregroundColor(iconColor)
                
                ShakedBadge(
                    amount: count,
                    badgeBackgroundColor: badgeBackgroundColor,
                    badgeForegroundColor: badgeForegroundColor
                )
                
            }
        })
        .frame(width: 44, height: 44, alignment: .center)
    }
    
    func badgeBackgroundColor(_ color: Color) -> CartButton {
        var view = self
        view.badgeBackgroundColor = color
        return view
    }
    
    func badgeForegroundColor(_ color: Color) -> CartButton {
        var view = self
        view.badgeForegroundColor = color
        return view
    }
    
    func iconColor(_ color: Color) -> CartButton {
        var view = self
        view.iconColor = color
        return view
    }
}

struct TestCartButton: View {
    @State var badge: Int = 0
    var body: some View {
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
            
            CartButton(count: badge) {}
                .iconColor(Color.pallet.secondary)
                .badgeBackgroundColor(Color.pallet.error)
                .badgeForegroundColor(Color.pallet.onError)
            
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

struct CartButton_Previews: PreviewProvider {
    static var previews: some View {
        TestCartButton()
    }
}
