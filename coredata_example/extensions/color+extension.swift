//
//  color+extension.swift
//  coredata_example
//
//  Created by Yousef on 2/14/23.
//

import SwiftUI

extension Color {
    
    static let pallet = Pallet()
    
    struct Pallet {
        let primary: Color = Color("primary")
        let onPrimary: Color = Color("onPrimary")
        let primaryContainer: Color = Color("primaryContainer")
        let onPrimaryContainer: Color = Color("onPrimaryContainer")
        let secondary: Color = Color("secondary")
        let onSecondary: Color = Color("onSecondary")
        let secondaryContainer: Color = Color("secondaryContainer")
        let onSecondaryContainer: Color = Color("onSecondaryContainer")
        let tertiary: Color = Color("tertiary")
        let onTertiary: Color = Color("onTertiary")
        let tertiaryContainer: Color = Color("tertiaryContainer")
        let onTertiaryContainer: Color = Color("onTertiaryContainer")
        let error: Color = Color("error")
        let errorContainer: Color = Color("errorContainer")
        let onError: Color = Color("onError")
        let onErrorContainer: Color = Color("onErrorContainer")
        let background: Color = Color("background")
        let onBackground: Color = Color("onBackground")
    }
    
}
