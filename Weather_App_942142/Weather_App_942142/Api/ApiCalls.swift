//
//  ApiCalls.swift
//  Weather_App_942142
//
//  Created by Drisya Sudevan on 08/06/23.
//

import Foundation

class ApiCalls: NetworkManager {
    
    func getDataByGeoCoords(parameters: String, isSearch: Bool, completion: @escaping(Result<WeatherBase_GeoCoords, NetworkError>) -> Void) {
        
        let urlStr = isSearch == true ? API_Urls.getByCityStateCountry.rawValue + "\(parameters)&appid=" : API_Urls.getByGeoCoordinates.rawValue + "\(parameters)&appid="
        
        getData(with: urlStr, method: .get, parameters: [:], decode: {(json) -> WeatherBase_GeoCoords? in
            guard let settings = json as? WeatherBase_GeoCoords else { return nil}
            return settings}, completionHandler: completion)
    }
    
}
