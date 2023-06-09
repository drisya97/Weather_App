//
//  Weather_ViewModel.swift
//  Weather_App_942142
//
//  Created by Drisya Sudevan on 07/06/23.
//

import Foundation
import UIKit

class WeatherViewModel: NetworkManager {
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var weatherBase_GeoCoords: WeatherBase_GeoCoords?
    
    var didFetchSuccess: ((Bool)->Void)?
    var didFetchFailure: ((String)->Void)?
    
    func getDataByGeoCoords(parameter: String, isSearch: Bool) {

        ApiCalls().getDataByGeoCoords(parameters : parameter, isSearch: isSearch) { result in
            switch result {
            case .success(let weather):
                self.weatherBase_GeoCoords = weather
                let status = 200...299 ~= self.weatherBase_GeoCoords?.cod ?? 0
                
                //save search keyword if the user searched city/state/country
                if isSearch == true {
                    self.appDelegate?.searchKeyWord = parameter
                    self.appDelegate?.updateContext()
                }
                self.didFetchSuccess?(status)
            case .failure(let error):
                switch error {
                case NetworkError.InvalidURL :
                    self.didFetchFailure?("Invalid URL")
                case NetworkError.NoDataAvailable :
                    self.didFetchFailure?("No data available")
                case NetworkError.timeOut :
                    self.didFetchFailure?("Timed out")
                }
            }
        }
    }
    
}
