//
//  LoadingView.swift
//  Weather
//
//  Created by Soe Min Htet on 21/06/2024.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.2)
                .ignoresSafeArea()
            
            ProgressView()
                .padding()
                .background()
                .cornerRadius(10)
        }
    }
}

#Preview {
    LoadingView()
}
