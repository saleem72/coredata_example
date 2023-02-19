//
//  LoadingView.swift
//  coredata_example
//
//  Created by Yousef on 2/14/23.
//

import SwiftUI

struct LoadingView: View {
    let isLoading: Bool
    var body: some View {
        if isLoading {
            ZStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.pallet.onPrimary))
                    .scaleEffect(3.0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(isLoading: true)
            .frame(width: .infinity, height: .infinity, alignment: .center)
            .background(Color.pallet.primary)
    }
}
