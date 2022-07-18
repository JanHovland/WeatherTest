//
//  ContentView.swift
//  WeatherTest
//
//  Created by Jan Hovland on 27/06/2022.
//

/// https://github.com/AsyncSwift/AsyncLocationKit?ref=iosexample.com
///
///
/// https://www.youtube.com/watch?v=PAPgcSpSpcs


import SwiftUI
import CoreLocation
import WeatherKit

// @available(macOS 13.0, *)
struct ContentView: View {
    
    var location: CLLocation =
    CLLocation(latitude: .init(floatLiteral: 37.322998),
               longitude: .init( floatLiteral: -122.032181)
    )
    
    @State var weather: Weather?
    
    func getWeather() async {
        do {
            weather = try await Task.detached(priority: .userInitiated) {
                return try await WeatherService.shared
                    .weather(for: location)
            } .value
        } catch {
            print("\(error)")
        }
    }
    
  
    var body: some View {
        NavigationView {
            Group {
                if let weather = weather {
                    Text("Humidity = \(weather.currentWeather.humidity.description)")
                } else {
                    ProgressView()
                        .task {
                            await getWeather()
                        }
                }
            }
            .navigationTitle("Cupertino")
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
