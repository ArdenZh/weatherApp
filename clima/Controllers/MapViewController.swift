//
//  MapViewController.swift
//  clima
//
//  Created by Arden  on 20.07.2020.
//  Copyright © 2020 Arden Zhakhin. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import MapKit

class MapViewController: UIViewController, GMSMapViewDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    let marker = GMSMarker()
    
    //Кастомный вид маркера отображающий погоду
    let customInfoView = Bundle.main.loadNibNamed("MapMarkerInfoView", owner: self, options: nil)?[0] as! MapMarkerInfoView
    
    override func viewDidLoad() {
          super.viewDidLoad()
                
        NotificationCenter.default.addObserver(self, selector: #selector(gotNotification), name: .notificationForGoogleMaps, object: nil)
        
        self.mapView.delegate = self
        
        marker.iconView = customInfoView
        marker.appearAnimation = .pop
        
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    //Если было нажатие на карту
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if marker.map != nil{
            customInfoView.hideInfo()
            marker.map = nil
        }else{
            showWeatherByCoordinate(coordinate: coordinate)
        }
    }
    
    //Нажатие на My Location Button
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        
        if let location = mapView.myLocation{
            showWeatherByCoordinate(coordinate: location.coordinate)
        }
        return false
    }
    
    //При получении уведомления обновляем данные маркера
    @objc func gotNotification(notification: Notification) {
        guard let userInfo = notification.userInfo else{return}
        guard let weather = userInfo["weather"] as? WeatherModel else {return}
        DispatchQueue.main.async {
            self.customInfoView.infoTemperature.text = weather.getCurrentTemperature()
            self.customInfoView.infoSummary.text = weather.currentSummary
            self.customInfoView.infoIcon.image = UIImage(systemName: weather.getCurrentIcon())
            self.customInfoView.showInfo()
            
        }
    }
    
    
    //Запрашиваем данные, устанавливаем камеру по координатам, ставим маркер
    func showWeatherByCoordinate(coordinate: CLLocationCoordinate2D) {
        
        weatherManager.fetchWeather(latitude: coordinate.latitude, longitude: coordinate.longitude, sender: "MapViewController")
        
        mapView.camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: mapView.camera.zoom)
        
        marker.position = coordinate
        marker.map = mapView
        
    }
    
}


extension MapViewController: CLLocationManagerDelegate{
    
    //проверка статуса гео-локации
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            
            locationManager.startUpdatingLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first{
            mapView.camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 10.0)
            showWeatherByCoordinate(coordinate: location.coordinate)
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager error: \(error)")
    }
}
