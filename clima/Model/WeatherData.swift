//
//  WeatherData.swift
//  clima
//
//  Created by Arden  on 19.07.2020.
//  Copyright © 2020 Arden Zhakhin. All rights reserved.
//

import Foundation


struct WeatherData: Codable {
    let currently: Currently
    var daily: Daily
}

struct Currently: Codable{
    let summary: String
    let icon: String
    let temperature: Double
}

struct Daily: Codable {
    var data: [DaysData]
}

struct DaysData: Codable {
    let time: Double
    let icon: String
    let temperatureHigh: Double
}

