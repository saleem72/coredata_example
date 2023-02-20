//
//  UrlImage.swift
//  coredata_example
//
//  Created by Yousef on 2/19/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct UrlImage: View {
    let url: String?
    var body: some View {
        if let url = url {
            WebImage(url: URL(string: url))
                // Supports options and context, like `.delayPlaceholder` to show placeholder only when error
                .onSuccess { image, data, cacheType in
                    // Success
                    // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
                }
                .resizable() // Resizable like SwiftUI.Image, you must use this modifier or the view will use the image bitmap size
                .placeholder(Image(systemName: "photo")) // Placeholder Image
                // Supports ViewBuilder as well
                .placeholder {
                    Rectangle().foregroundColor(.gray)
                }
                .indicator(.activity) // Activity Indicator
                .transition(.fade(duration: 0.5)) // Fade Transition with duration
        } else {
            Image(systemName: "photo")
                .scaledToFit()
        }
    }
}

struct UrlImage_Previews: PreviewProvider {
    static var previews: some View {
        UrlImage(url: nil)
    }
}
