//
//  CustomCornerShape.swift
//  CMeeApplication
//
//  Created by Yousef on 12/9/21.
//

import SwiftUI

struct CustomCornerShape: Shape {
    
    var corners: UIRectCorner
    var cornerRaduis: CGFloat = 16
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRaduis, height: cornerRaduis))
        
        return Path(path.cgPath)
    }
}
