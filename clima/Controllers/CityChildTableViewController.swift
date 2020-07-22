//
//  SaintPChildViewController.swift
//  clima
//
//  Created by Arden  on 18.07.2020.
//  Copyright © 2020 Arden Zhakhin. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class CityChildTableViewController: UITableViewController, IndicatorInfoProvider{
    
    let cellIdentifier = "WeatherCellIdentifier"
    var cityName : String = ""
        
    var temperatures: [String]? = nil
    var dates: [String]? = nil
    var icons: [String]? = nil
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "WeatherTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: cellIdentifier)
//        tableView.estimatedRowHeight = 600.0
//        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 75.0
        
        NotificationCenter.default.addObserver(self, selector: #selector(gotNotification), name: .notificationForMainView, object: nil)
    }
    
    //При получении уведомления обновляем табличные данные
    @objc func gotNotification(notification: Notification) {
        guard let userInfo = notification.userInfo else{return}
        guard let weather = userInfo["weather"] as? WeatherModel else {return}
        DispatchQueue.main.async {
            self.temperatures = weather.getDailyTemperatures()
            self.dates = weather.getDailyDate()
            self.icons = weather.getDailyIcons()
            self.tableView.reloadData()
        }
    }
    
    
    
    
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "\(cityName)")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return temperatures?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! WeatherTableViewCell

        cell.date.text = dates?[indexPath.row]
        cell.temperature.text = temperatures?[indexPath.row]
        
        if let icon = icons?[indexPath.row]{
            cell.weatherImage.image = UIImage(systemName: icon)
        }
        
        return cell
    }
    
    
}




