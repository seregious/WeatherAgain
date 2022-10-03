//
//  NetworkManager.swift
//  WeatherSwiftUI
//
//  Created by Сергей Иванчихин on 25.09.2022.
//

import Foundation
import Alamofire


class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() { }
    
    //making url for GET request
    private func makeUrl() -> String {
        var url = "https://api.openweathermap.org/data/2.5/forecast?"
        let key = "ebe0e3de881588e0d1f987ad74441747"
        let lat = "50.592047"
        let lon = "36.581393"
        let units = "metric"
        let lang = "ru"
        
        url += "lat=\(lat)&lon=\(lon)&appid=\(key)&units=\(units)&lang=\(lang)"
        return url
    }
    
    
    
    func getData(_ completion: @escaping (Weather) -> Void) {
        let url = makeUrl()
        AF.request(url)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let weatherData = try decoder.decode(Weather.self, from: data)
                        completion(weatherData)
                    } catch let error {
                        print(error)
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
}


