//
//  ImageLoader.swift
//  Weather
//
//  Created by Soe Min Htet on 21/06/2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageLoader: View {
    
    let url: String
    var contentMode: ContentMode = .fill
    
    var body: some View {
        WebImage(url: URL(string: url))
            .resizable()
            .indicator(.activity)
            .transition(.fade)
            .aspectRatio(contentMode: contentMode)
    }
}

#Preview {
    ImageLoader(url: "https://openweathermap.org/img/wn/02d@2x.png")
}

