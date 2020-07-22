//
//  WeatherManager.swift
//  clima
//
//  Created by Arden  on 19.07.2020.
//  Copyright © 2020 Arden Zhakhin. All rights reserved.
//

import Foundation
import CoreLocation

struct WeatherManager {
    
    let saintPetersburg = ["59.950015", "30.316599"]
    let moscow = ["55.753913", "37.620836"]
    let weatherURL = "https://api.darksky.net/forecast/3e7e519ea86c8e3fcf67c0f4870513d7/"
    
    var cache = NSCache<NSString, WeatherModel>()
    
    //Формируем ссылку
    func fetchWeather(cityName: String, sender: String) {
        var urlString: String
        if cityName == "Санкт-Петербург"{
            urlString = "\(weatherURL)\(saintPetersburg[0]),\(saintPetersburg[1])?exclude=hourly,flags&lang=ru&units=si"
        }else{
            urlString = "\(weatherURL)\(moscow[0]),\(moscow[1])?exclude=hourly,flags&lang=ru&units=si"
        }
        
        performRequest(with: urlString, sender: sender)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees, sender: String) {
        let urlString = "\(weatherURL)\(latitude),\(longitude)?exclude=hourly,flags&lang=ru&units=si"
        performRequest(with: urlString, sender: sender)
    }
    
    
    func performRequest(with urlString: String, sender: String){
        
        //Достаем данные из кэша если они там есть
        if let cachedVersion = cache.object(forKey: urlString as NSString) {
            let weather = cachedVersion
            
            let dictionary = ["weather": weather]
            
            //Отправляем notification. Ставим имя в зависимости от того, кто запросил данные
            if sender == "MapViewController"{
                NotificationCenter.default.post(name: .notificationForGoogleMaps, object: nil, userInfo: dictionary)
            }else{
                NotificationCenter.default.post(name: .notificationForMainView, object: nil, userInfo: dictionary)
            }
        } else{
            
            //Если в кэше нет нужных данных то:
            if let url = URL(string: urlString) {
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: url) { (data, response, error) in
                    if let err = error {
                        print("Error with task performing: \(err)")
                        return
                    }
                    if let safeData = data {
                        if let weather = self.parseJSON(safeData) {
                            
                            //Закидываем в кэш полученные данные если удалось успешно их получить и распарсить
                            self.cache.setObject(weather, forKey: urlString as NSString)
                            
                            //Отправляем Notification
                            let dictionary = ["weather": weather]
                            if sender == "MapViewController"{
                                NotificationCenter.default.post(name: .notificationForGoogleMaps, object: nil, userInfo: dictionary)
                            }else{
                                NotificationCenter.default.post(name: .notificationForMainView, object: nil, userInfo: dictionary)
                            }
                        }
                    }
                }
                task.resume()
            }
        }
    }
    
    //Парсим полученные данные
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            var decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let curTemp = decodedData.currently.temperature
            let curIcon = decodedData.currently.icon
            let curSummary = decodedData.currently.summary
            
            decodedData.daily.data.removeFirst(2)
            
            let dailyData = decodedData.daily.data
            
            let weather = WeatherModel()
            weather.currentTemperature = curTemp
            weather.currentIcon = curIcon
            weather.currentSummary = curSummary
            weather.dailyData = dailyData
            
            return weather
            
        } catch {
            print("Error with data parsing: \(error)")
            return nil
        }
    }
}
