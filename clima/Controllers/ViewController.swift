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
    override func viewDidLoad() {
        super.viewDidLoad()
        
         configureButtonBar()
        
//        mainTemperature.text = "-2"
//        mainWeatherImage.image = UIImage(named: "лого2")
 //       weather.text = "ясно"
        
        // Do any additional setup after loading the view.
    }
    
    func configureButtonBar() {
         // Sets the background colour of the pager strip and the pager strip item
         settings.style.buttonBarBackgroundColor = .white
         settings.style.buttonBarItemBackgroundColor = .white

         // Sets the pager strip item font and font color
         settings.style.buttonBarItemFont = UIFont(name: "Helvetica", size: 16.0)!
         settings.style.buttonBarItemTitleColor = .gray

         // Sets the pager strip item offsets
         settings.style.buttonBarMinimumLineSpacing = 0
         settings.style.buttonBarItemsShouldFillAvailableWidth = true
         settings.style.buttonBarLeftContentInset = 0
         settings.style.buttonBarRightContentInset = 0

         // Sets the height and colour of the slider bar of the selected pager tab
         settings.style.selectedBarHeight = 3.0
         settings.style.selectedBarBackgroundColor = .orange

         // Changing item text color on swipe
         changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
               guard changeCurrentIndex == true else { return }
               oldCell?.label.textColor = .gray
               newCell?.label.textColor = .orange
         }
    }
    
    
    // MARK: - PagerTabStripDataSource

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {

        let child1 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CityChildTableViewController") as! CityChildTableViewController
        child1.cityName = "Санкт-Петербург"

        let child2 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CityChildTableViewController") as! CityChildTableViewController
        child2.cityName = "Москва"

        return [child1, child2]
        
        
//        let child1 = CityChildTableViewController(style: .plain, itemInfo: IndicatorInfo(title: "Санкт-Петербург"))
//
//        let child2 = CityChildTableViewController(style: .plain, itemInfo: IndicatorInfo(title: "Москва"))
//
//        return [child1, child2]

    }

    
    

}

