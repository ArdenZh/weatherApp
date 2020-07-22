//
//  WeatherModel.swift
//  clima
//
//  Created by Arden  on 19.07.2020.
//  Copyright © 2020 Arden Zhakhin. All rights reserved.
//

import Foundation

class WeatherModel {
   
    var currentTemperature: Double = 0.0
    var currentIcon: String = ""
    var currentSummary: String = ""
    
    var dailyData: [DaysData] = []
   
    
    func getCurrentTemperature() -> String{
        return String(format: "%.1f", currentTemperature)
    }
    
    func getCurrentIcon() -> String{
        return selectIcon(icon: currentIcon)
    }

    
    func getDailyTemperatures() -> [String]{
        return dailyData.map { (DaysData) -> String in
            String(format: "%.1f", DaysData.temperatureHigh)
        }
    }
    
    func getDailyIcons() -> [String]{
        return dailyData.map { (DaysData) -> String in
            selectIcon(icon: DaysData.icon)
        }
    }
    
    //Приводим дату к нужному виду
    func getDailyDate() -> [String]{
        return dailyData.map { (DaysData) -> String in
           
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ru_RU")
            formatter.dateFormat = "EEE, d MMMM"
            
            let date = Date(timeIntervalSince1970: DaysData.time)
            let formatedDate = formatter.string(from: date)
            return formatedDate
        }
    }
    
    
    //В зависимости от полученных данных выбираем нужную иконку
    func selectIcon(icon: String) -> String{
        switch icon {
        case "clear-day":
            return "sun.max"
        case "clear-night":
            return "moon"
        case "rain":
            return "cloud.rain"
        case "snow":
            return "cloud.snow"
        case "sleet":
            return "cloud.sleet"
        case "wind":
            return "wind"
        case "fog":
            return "cloud.fog"
        case "cloudy":
            return "cloud"
        case "partly-cloudy-day":
            return "cloud.sun"
        case "partly-cloudy-night":
            return "cloud.moon"
        default:
            return "thermometer"
        }
    }
    
}
