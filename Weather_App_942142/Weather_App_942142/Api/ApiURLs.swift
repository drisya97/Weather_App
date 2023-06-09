//
//  ApiURLs.swift
//  Weather_App_942142
//
//  Created by Drisya Sudevan on 07/06/23.
//

import Foundation

enum API_Urls : String {
    case getByGeoCoordinates = "https://api.openweathermap.org/data/2.5/weather?units=metric&"
    case getByCityStateCountry = "https://api.openweathermap.org/data/2.5/weather?units=metric&q="
    case getImage = "https://openweathermap.org/img/wn/" //10d@2x.png
}
