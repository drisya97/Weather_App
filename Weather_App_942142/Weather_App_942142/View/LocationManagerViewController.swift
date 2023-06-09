//
//  LocationManagerViewController.swift
//  Weather_App_942142
//
//  Created by Drisya Sudevan on 07/06/23.
//

import UIKit
import CoreLocation
import CoreData

class LocationManagerViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    var weatherViewModel = WeatherViewModel()

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var weatherTableView: UITableView!
    @IBOutlet weak var weatherSearchBar: UISearchBar!
    
    @IBOutlet weak var weathertypeHolderView: UIView!
    
    @IBOutlet weak var currentWeatherBtn: UIButton!
    
    @IBOutlet weak var browsedDataBtn: UIButton!
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    var currentLat: Double = 0.0
    var currentLong: Double = 0.0
    var isSerach = false
    var searchKeyword = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        congigureUI()
        
        //checks whether already searched city/state/country and calls Api according to that
        if let searchKeyWord = appDelegate?.fetchData() {
            if searchKeyWord != "." {
                self.isSerach = true
                self.searchKeyword = searchKeyWord
                weatherViewModel.getDataByGeoCoords(parameter: searchKeyWord, isSearch: true)
            }
        }
        
        //size class
        layoutTraitBgImageView(traitCollection: UIScreen.main.traitCollection)
        
        //executes if Api response is successful
        weatherViewModel.didFetchSuccess = { status in
            self.view.backgroundColor = .clear
            self.weatherTableView.reloadData()
        }
        
        //executes if Api response is failure
        weatherViewModel.didFetchFailure = { error in
            print(error.description)
            self.showAlert(title: "Error", message: error, buttonTitle: "Cancel")
        }
        
        callApi()
        Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(callApi), userInfo: nil, repeats: true)
    }
    
    //setting delegates and datasource for UITableView, registering UITableViewCells
    //initialize and setting delegate for location manager
    func congigureUI() {
        
        //background imageview
        self.backgroundImageView.backgroundColor = .clear
        self.backgroundImageView.contentMode = .scaleToFill
        
        //UITableview
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        weatherTableView.backgroundColor = .clear
        weatherTableView.estimatedRowHeight = 250.0
        weatherTableView.separatorStyle = .none
        weatherTableView.allowsSelection = false
        weatherTableView.registerNib(withName: "WeatherTableViewCell")
        weatherTableView.registerNib(withName: "OtherDetailsTableViewCell")
        
        //location manager
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        //UISearchbar
        weatherSearchBar.backgroundColor = .blue.withAlphaComponent(0.1)
        weatherSearchBar.tintColor = .yellow//.clear
        weatherSearchBar.barTintColor = .white.withAlphaComponent(0.1)
        weatherSearchBar.isTranslucent = true
        weatherSearchBar.placeholder = "Search"
        weatherSearchBar.layer.cornerRadius = 15
        weatherSearchBar.layer.masksToBounds = true
        
        //weathertypeHolderView
        weathertypeHolderView.backgroundColor = .black.withAlphaComponent(0.2)
        weathertypeHolderView.layer.cornerRadius = weathertypeHolderView.frame.height / 2
        weathertypeHolderView.layer.masksToBounds = true
                
        //set button properties
        currentWeatherBtn.setButtonProperties(title: "Current Data", titleColor: .white, bgColor: .black.withAlphaComponent(0.1), cornerRadius: currentWeatherBtn.frame.height / 2, borderColor: .white)
        browsedDataBtn.setButtonProperties(title: "Browsed Data", titleColor: .white, bgColor: .black.withAlphaComponent(0.1), cornerRadius: browsedDataBtn.frame.height / 2, borderColor: .white)
    }
    
    //size class uses to change the background image according to the screen rotation
    func layoutTraitBgImageView(traitCollection:UITraitCollection) {
        
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            backgroundImageView.image = UIImage(named: "phone")
        } else if traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .compact{
            
            backgroundImageView.image = UIImage(named: "Landscape_phone")
        }
    }
    
    
    //fetch current weather details
    @IBAction func tappedOnCurrentWeatherBtn(_ sender: Any) {
        weatherViewModel.getDataByGeoCoords(parameter: "lat=\(currentLat)&lon=\(currentLong)", isSearch: false)
        currentWeatherBtn.setBorder(color: .yellow)
        browsedDataBtn.setBorder(color: .white)
    }
    
    //shows last browsed weather deta
    @IBAction func tappedOnBrowsedDataBtn(_ sender: Any) {
        if isSerach == true {
            weatherViewModel.getDataByGeoCoords(parameter: searchKeyword, isSearch: true)
            currentWeatherBtn.setBorder(color: .white)
            browsedDataBtn.setBorder(color: .yellow)
        }
        else {
            showAlert(title: "Browsed Data", message: "No Browsed data found", buttonTitle: "Okay")
        }
    }
    
    //MARK: calls every 1 minute to update the weather data
    @objc func callApi() {
        if isSerach == true {
            weatherViewModel.getDataByGeoCoords(parameter: searchKeyword, isSearch: true)
        }
        else {
            weatherViewModel.getDataByGeoCoords(parameter: "lat=\(currentLat)&lon=\(currentLong)", isSearch: false)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .restricted || status == .notDetermined || status == .denied {
            //show alert to allow location access
            showAlert(title: "Location Permission", message: "Please allow location access in settings", buttonTitle: "Okay")
            
        }
        else if status == .authorizedAlways || status == .authorizedWhenInUse {
            
            guard let location = manager.location else { return}
                
            //save the current latitude and longitude and calls api
            currentLat = location.coordinate.latitude
            currentLong = location.coordinate.longitude
                
//            if isSerach == false {
//                weatherViewModel.getDataByGeoCoords(parameter: "lat=\(currentLat)&lon=\(currentLong)", isSearch: false)
//            }
            
        }
    }
    
    //show alert
    func showAlert(title: String, message: String, buttonTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

extension LocationManagerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as? WeatherTableViewCell {
              
                cell.descriptionLabel.text = weatherViewModel.weatherBase_GeoCoords?.weather?[0].description?.firstUppercased ?? ""
                cell.feelsLikeLabel.text = "Feels like : \(weatherViewModel.weatherBase_GeoCoords?.main?.feels_like ?? 0.0)\u{00B0}"
                cell.temperatreLabel.text = "\(weatherViewModel.weatherBase_GeoCoords?.main?.temp ?? 0.0)\u{00B0}"
                cell.locationLabel.text = "\(weatherViewModel.weatherBase_GeoCoords?.name ?? "")"
                cell.weatherIcon.downloadImageFrom(urlString: "\(API_Urls.getImage.rawValue)\(weatherViewModel.weatherBase_GeoCoords?.weather?[0].icon ?? "")@2x.png", imageContentMode: .scaleAspectFit)
              //  cell.weatherIcon.downloadImageFrom(urlString: "\(API_Urls.getImage.rawValue)\(weatherViewModel.weatherBase_GeoCoords?.weather?[0].id ?? 0).png", imageContentMode: .scaleAspectFit)
                let st = "\(weatherViewModel.weatherBase_GeoCoords?.dt ?? 0)"
                cell.dateLabel.text = st.getDate()
                
                return cell
            }
        }
        else if indexPath.section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "OtherDetailsTableViewCell", for: indexPath) as? OtherDetailsTableViewCell {
                
                cell.humidityLabel.text = "Humidity : \(weatherViewModel.weatherBase_GeoCoords?.main?.humidity ?? 0)%"
                cell.pressureLabel.text = "Pressure : \(weatherViewModel.weatherBase_GeoCoords?.main?.pressure ?? 0) mm Hg"
                cell.windSpeedLabel.text = "Wind speed : \(weatherViewModel.weatherBase_GeoCoords?.wind?.speed ?? 0) mps"
                
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
}

extension LocationManagerViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //dismiss keyboard and calls the api
        self.view.endEditing(true)
        searchKeyword = searchBar.text ?? ""
        weatherViewModel.getDataByGeoCoords(parameter: searchKeyword, isSearch: true)
        isSerach = true
    }
}



