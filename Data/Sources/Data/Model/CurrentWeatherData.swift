//
//  File.swift
//  
//
//  Created by Soe Min Htet on 19/06/2024.
//

import Foundation

public struct CurrentWeatherData: Codable {
    public let weather: [Weather]
    public let main: Main
    public let name: String
    public let dt: Date
    public let id: Int
    
    public var displayWeather: Weather {
        weather.first ?? Weather(description: "No data", icon: "")
    }
    
    public var displayTime: String {
        let dateFormattter = DateFormatter()
        dateFormattter.dateFormat = "hh:mm"
        return dateFormattter.string(from: dt)
    }
}

public struct Weather: Codable {
    public let description: String
    public let icon: String
    
    public var weatherIcon: String {
        "https://openweathermap.org/img/wn/\(icon)@2x.png"
    }
}

public struct Main: Codable {
    public let temp: Double
    
    public var displayTemp: Int {
        Int(temp - 273.15)
    }
}

extension CurrentWeatherData {
    public static func fakeData() -> CurrentWeatherData {
        return CurrentWeatherData(
            weather: [Weather(description: "Sunny", icon: "02d")],
            main: Main(temp: 298.15), // 298.15 K is 25°C
            name: "Sample City",
            dt: Date.now,
            id: 123456
        )
    }
}
