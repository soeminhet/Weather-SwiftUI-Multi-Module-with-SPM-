//
//  WeatherCell.swift
//  Weather
//
//  Created by Soe Min Htet on 21/06/2024.
//

import SwiftUI
import Data

struct WeatherCell: View {
    
    let data: CurrentWeatherData
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    ImageLoader(url: data.displayWeather.weatherIcon)
                        .frame(width: 70, height: 70)
                        .clipped()
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text(data.name)
                            .font(.title2)
                            .fontWeight(.heavy)
                        
                        Text(data.displayTime)
                            .font(.footnote)
                            .offset(y: -4)
                    }
                }
                
                Text(data.displayWeather.description)
                    .padding(.leading, 10)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .offset(y: -4)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("\(data.main.displayTemp)°")
                .font(.system(size: 46, weight: .bold))
        }
        .padding(.all, 8)
        .padding(.bottom, 10)
        .frame(maxWidth: .infinity)
        .foregroundStyle(.white)
        .background(.black)
    }
}

#Preview {
    WeatherCell(data: CurrentWeatherData.fakeData())
}
