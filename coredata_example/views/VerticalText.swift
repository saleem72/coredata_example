//
//  VerticalText.swift
//  AboShaker
//
//  Created by Yousef on 3/28/22.
//

import SwiftUI

struct VerticalText: View {
    
    enum Direction {
        case up
        case down
    }
    
    var text: String
    var isSelected: Bool
    var animation: Namespace.ID
    var tag: String
    var onTap: () -> Void
     var textFont: UIFont = .systemFont(ofSize: 14)
     var textDirection: Direction = .up
    @State private var labelWidth: CGFloat = 100
    @State private var labelHeight: CGFloat = 24
    
    
    
    var body: some View {
//        let langStr = Locale.current.languageCode
        HStack(alignment: .top, spacing: 8) {
            
            Text(text)
                .font(Font(textFont as CTFont))
                .fixedSize()
                .onAppear {
                    calcDimintions()
                }
                .frame(width: labelHeight + 13, height: labelWidth)
                .rotationEffect(Angle(degrees: textDirection == .up ? -90 : 90))
            
            if isSelected {
                Capsule()
                    .frame(width: 5, height: labelWidth)
                    .matchedGeometryEffect(id: tag, in: animation)
            } else {
                Capsule()
                    .fill(Color.clear)
                    .frame(width: 5, height: labelWidth)
            }
        }
        .onTapGesture {
            withAnimation(.spring()) {
                onTap()
            }
        }
    }
    
    func calcDimintions() {
        let label = UILabel()
        label.font = textFont
        label.text = text
        label.sizeToFit()
        labelWidth = label.frame.size.width + 8
        labelHeight = label.frame.size.height
        
    }
    
    func font(_ font: UIFont) -> VerticalText {
        var view = self
        view.textFont = font
        return view
    }
    
    func direction(_ direction: Direction) -> VerticalText {
        var view = self
        view.textDirection = direction
        return view
    }
}
//
//struct TestVerticalText: View {
//    var body: some View {
//        VStack {
//            VerticalText(text: "Hello world!", isSelected: true, animation: Namespace.init(), tag: "")
//                .font(UIFont.boldSystemFont(ofSize: 20))
//                .direction(.down)
//                .foregroundColor(.green)
//        }
//    }
//}
//
//struct TestVerticalText_Previews: PreviewProvider {
//    static var previews: some View {
//        TestVerticalText()
//    }
//}
