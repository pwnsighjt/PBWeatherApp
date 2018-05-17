////
////  ViewController.swift
////  PBWeather
////
////  Created by Pawan Jat on 16/05/18.
////  Copyright © 2018 PB. All rights reserved.
////

import UIKit
import CoreLocation

class ViewController: UITableViewController,CLLocationManagerDelegate,LocationSearchViewControllerDelegate {
    //MARK:- Veriable declaration
    var lat = 0.0
    var lng = 0.0
    var units = "metric"
    var unit = "C"
    var locationManager = CLLocationManager()
    var responseModel:ResponseModel? = nil
    var forecaseDetails:NSArray = []
    
    
    //MARK:- View life cycle delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        requestLocationPermision()
    }
    
    //MARK:- Location manager handling/delegate
    func requestLocationPermision() {
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            lat = location.coordinate.latitude
            lng = location.coordinate.longitude
            loadCurrentWeatherLocaion(place: "Indore")
            //            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                showAlert("Please Allow the Location Permision to get weather of your city")
            case .authorizedAlways, .authorizedWhenInUse:
                print("locationEnabled")
            }
        } else {
            showAlert("Please Turn ON the location services on your device")
            print("locationDisabled")
        }
        manager.stopUpdatingLocation()
    }
    
    class func isLocationEnabled() -> (status: Bool, message: String) {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                return (false,"No access")
            case .authorizedAlways, .authorizedWhenInUse:
                return(true,"Access")
            }
        } else {
            return(false,"Turn On Location Services to Allow App to Determine Your Location")
        }
    }
    
    //MARK:- Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.destination is LocationSearchViewController{
            let vc = segue.destination as? LocationSearchViewController
            vc?.delegate = self

        }
    }
    //MARK:- Weather API call/respnse handling
    func loadCurrentWeatherLocaion(place:String) {
        let yql = YQL()
        let queryStatement = String(format: "SELECT woeid FROM geo.places WHERE text=\"(%@)\"",place)
        yql.queryWoeid(queryStatement) { (response) -> Void in
            let query = response["query"] as! NSDictionary
            let result = query["results"] as! NSDictionary
            let place = result["place"] as! NSArray
            if(place.count > 0){
                let placeDetails = place[0] as! NSDictionary
                
                //Json object to model conversion using codable is working perfectly using id - 2502265
                let woeid = placeDetails["woeid"] //"2502265"
                let selectStatement = String(format: "SELECT * FROM weather.forecast WHERE woeid=%@",woeid as! CVarArg)
                yql.query(selectStatement) { (response) -> Void in
                    let query = response["query"] as! NSDictionary
                    let result = query.value(forKey: "results") as! NSDictionary
                    let channel = result.value(forKey: "channel") as! NSDictionary
                    let item = channel.value(forKey: "item") as! NSDictionary
                    self.forecaseDetails = item.value(forKey: "forecast") as! NSArray
                    if(self.forecaseDetails.count > 0){
                         self.tableView.reloadData()
                    }
                    
//**************** HAVING PROBLEM WITH JSONDecoder TO CONVERT THE JSON INTO MODEL ***************
//                    do{
//                        self.responseModel = try? JSONDecoder().decode(ResponseModel.self, from: response)
//                        if( self.responseModel?.query.results.channel.item.forecast.count != nil && (self.responseModel?.query.results.channel.item.forecast.count)! > 0){
//                            self.tableView.reloadData()
//                        }else{
//                            self.showAlert("No forecast available for location")
//                        }
//                    }catch{
//                        print(error.localizedDescription)
//
//                    }
                }
            }
        }
    }

    // MARK:- User custom methods
    func showAlert(_ message:String) {
        if(self.presentedViewController == nil){
            let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK:- LocationSearchViewController Delegate
    func userSelectedPlace(placeName:String){
//        self.loadCurrentWeatherLocaion(place: placeName)
    }
    
    //MARK:- UITableView delegate/data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //******* USING MODEL *******
//        if( self.responseModel?.query.results.channel.item.forecast.count != nil && (self.responseModel?.query.results.channel.item.forecast.count)! > 0){
//            return (self.responseModel?.query.results.channel.item.forecast.count)!
//        }
        if(self.forecaseDetails.count > 0){
            return self.forecaseDetails.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        //******* USING MODEL *******
//        cell.textLabel?.text = self.responseModel?.query.results.channel.item.forecast[indexPath.row].date
//        cell.detailTextLabel?.text =  (self.responseModel?.query.results.channel.item.forecast[indexPath.row].text).map { $0.rawValue }
        
        let weatherInfo = self.forecaseDetails[indexPath.row] as? NSDictionary
        cell.textLabel?.text = weatherInfo?["date"] as? String
        cell.detailTextLabel?.text = weatherInfo?["text"] as? String
        return cell
    }    
}
