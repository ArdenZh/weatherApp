//
//  ViewController.swift
//  clima
//
//  Created by Arden  on 16.07.2020.
//  Copyright © 2020 Arden Zhakhin. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ParentCityViewController: ButtonBarPagerTabStripViewController {


    @IBOutlet weak var mainTemperature: UILabel!
    @IBOutlet weak var mainWeatherImage: UIImageView!
    @IBOutlet weak var weather: UILabel!
    
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        configureButtonBar()
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(gotNotification), name: .notificationForMainView, object: nil)
                
    }
    
    //При получении уведомления обновляем интерфейс шапки
    @objc func gotNotification(notification: Notification) {
        guard let userInfo = notification.userInfo else{return}
        guard let weather = userInfo["weather"] as? WeatherModel else {return}
        DispatchQueue.main.async {
            self.mainTemperature.text = weather.getCurrentTemperature()
            self.mainWeatherImage.image = UIImage(systemName: weather.getCurrentIcon())
            self.weather.text = weather.currentSummary
        }
    }
        

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let child1 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CityChildTableViewController") as! CityChildTableViewController
        child1.cityName = "Санкт-Петербург"

        let child2 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CityChildTableViewController") as! CityChildTableViewController
        child2.cityName = "Москва"

        return [child1, child2]
    }
    
    //Настраиваем стиль переключателя между городами
    func configureButtonBar() {
        
        settings.style.buttonBarBackgroundColor = .white
         settings.style.buttonBarItemBackgroundColor = .white

         settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 20.0)
         settings.style.buttonBarItemTitleColor = .gray

         settings.style.buttonBarMinimumLineSpacing = 0
         settings.style.buttonBarItemsShouldFillAvailableWidth = true
         settings.style.buttonBarLeftContentInset = 0
         settings.style.buttonBarRightContentInset = 0

         settings.style.selectedBarHeight = 3.0
         settings.style.selectedBarBackgroundColor = .black

         // Changing item text color on swipe
         changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
               guard changeCurrentIndex == true else { return }
               oldCell?.label.textColor = .gray
            newCell?.label.textColor = .black
            if let curCity = newCell?.label.text{

                //Запрашиваем данные если перешли к другому городу
                self!.weatherManager.fetchWeather(cityName: curCity, sender: "ParentCityViewController")
            }
         }
        
    }
    

}

extension Notification.Name{
    static let notificationForMainView = Notification.Name(rawValue: "notificationForMainView")
    static let notificationForGoogleMaps = Notification.Name(rawValue: "notificationForGoogleMaps")
}


