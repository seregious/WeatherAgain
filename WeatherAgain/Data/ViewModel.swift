//
//  ViewModel.swift
//  WeatherSwiftUI
//
//  Created by Сергей Иванчихин on 25.09.2022.
//

import Foundation
import UIKit

class WeatherViewModel: ObservableObject {
    
    @Published var dayList: [Day] = []
    @Published var selectedDay = ""
    private let networkManager = NetworkManager.shared
    
    @Published var weather: Weather?
    
    
    init() {
        setData()
        getSelectedDay()
    }
    
    /// getting data from network manager
    private func setData() {
        networkManager.getData { [self] data in
            self.weather = data
            self.dayList = weather?.list ?? []
        }
    }
    
    /// checks day in the list of week weather
    /// - Parameter day: gets day of week
    /// - Returns: returns TRUE if day equals selected day
    func checkDayFor(_ day: Day) -> Bool {
        getDayOfWeek(day) == selectedDay
    }
    
    ///function for changing current day in viewmodel
    /// - Parameter day: gets day when user select day
    func changeCurrentDay(_ day: Day) {
        selectedDay = getDayOfWeek(day)
    }
    
    /// setting the time in the specified format
    /// - Parameters:
    ///   - day: gets day form the list
    ///   - format: gets specific format of date
    /// - Returns: returns date in the specified format
    private func getDate(day: Day, format: String) -> String {
        let date = Date(timeIntervalSince1970: day.dt)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = format
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    /// getting the day of the week from time
    /// - Parameter day: gets day from the list
    /// - Returns: returns day of week e.g. "вторник"
    func getDayOfWeek(_ day: Day) -> String {
        return getDate(day: day, format: "EEEE")
    }
    
    /// getting the date from time
    /// - Parameter day: gets day from the list
    /// - Returns: returns date of the day e.g. "01.01.22"
    func getDateOfDay(_ day: Day) -> String {
        return getDate(day: day, format: "dd.MM.yy")
    }
    
    /// getting the hour from time
    /// - Parameter day: gets day from the list
    /// - Returns: returns hour for selected day e.g. "15"
    func getHourOfDay(_ day: Day) -> String {
        return getDate(day: day, format: "HH")
    }
    
    /// getting the hours and the minutes from time for sunrise and sunset
    /// - Parameter day: gets time of sunrise and sunset
    /// - Returns: returns time in formate "12:34"
    func getSunTime(_ sunTime: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(sunTime))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "HH:MM"
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    /// making url for download weather image
    /// - Parameter day: gets day from the list
    /// - Returns: returns url of weather image for current day
    func getImageUrl(_ day: Day) -> URL? {
        let url = "https://openweathermap.org/img/wn/"
        let id = day.weather.first?.icon ?? ""
        let type = ".png"
        return URL(string: url + id + type)
    }
    
    /// filtering the weather list with one weather for one day
    /// - Returns: returns list of weather with one weather data per day
    func getWeatherByDay() -> [Day] {
        var list: [Day] = []
        var currentDay = ""
        for day in dayList {
            if getDayOfWeek(day) != currentDay {
                currentDay = getDayOfWeek(day)
                list.append(day)
            }
        }
        return list
    }
    
    /// filtering the weather list for one day
    /// - Parameter dayName: get name of day e.g. "вторник"
    /// - Returns: returns list of weather for selected day of week
    func getWeatherByHour(dayName: String) -> [Day] {
        var list: [Day] = []
        for day in dayList {
            if getDayOfWeek(day) == dayName {
                list.append(day)
            }
        }
        if list.count < 8 && !dayList.isEmpty {
            let secondList = Array(dayList[0...7])
            return secondList
        }
        return list
    }
    
    /// with init of view model sets current day equals for first day in the weather list
    func getSelectedDay() {
        if !dayList.isEmpty {
            selectedDay = getDayOfWeek(dayList.first!)
        }
    }
    
    /// getting the background image depending on the weather
    /// - Parameter weather: gets weather model
    /// - Returns: returns name of weather image for current weather description or "Clear" if there is no matches
    func setImage(weather: Weather?) -> String {
        let weatherImages = [
            "Clear", "Clouds", "Drizzle", "Mist", "Rain", "Snow", "Thunderstorm"
        ]
        
        for image in weatherImages {
            if weather?.list.first?.weather.first?.main == image {
                return image
            }
        }
        return "Clear"
    }
}




