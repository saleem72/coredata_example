//
//  ErrorView.swift
//  ArchitectureTestingApp
//
//  Created by Yousef on 10/26/21.
//

import SwiftUI

struct ErrorView: View {
    
    var error: String?
    var onRefresh: () -> Void
    
    init(error: String?, onRefresh: @escaping () -> Void) {
        self.error = error
        self.onRefresh = onRefresh
    }
    
    var body: some View {
        if let errorMessage = error {
            ZStack {
                VStack {
                    
                     Image(systemName: "xmark.octagon")
                        .resizable()
                        .foregroundColor(Color.pallet.error)
                        .frame(width: 300, height: 300)
                        .aspectRatio(contentMode: .fit)
                    Text(errorMessage)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.pallet.error)
                    
                    Spacer()
                        .frame(height: 50)
                    
                    Button(action: {
                        onRefresh()
                    }, label: {
                        Text("Re try")
                            .padding(.horizontal, 32)
                            .padding(.vertical, 8)
                            .background(Color.pallet.primary)
                            .foregroundColor(Color.pallet.onPrimary)
                            .clipShape(Capsule())
                    })
                    
                    Spacer()
                        .frame(height: 50)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.pallet.background)
            }
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(error: "Some thing bad") {
            
        }
    }
}
