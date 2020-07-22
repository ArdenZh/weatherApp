//
//  MapMarkerInfoView.swift
//  clima
//
//  Created by Arden  on 22.07.2020.
//  Copyright © 2020 Arden Zhakhin. All rights reserved.
//

import UIKit

class MapMarkerInfoView: UIView {
    
    @IBOutlet weak var infoIcon: UIImageView!
    
    @IBOutlet weak var infoTemperature: UILabel!
    
    @IBOutlet weak var infoSummary: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.layer.cornerRadius = 30.0
        self.clipsToBounds = true
        
        hideInfo()
    }
    
    func hideInfo() {
        infoIcon.isHidden = true
        infoSummary.isHidden = true
        infoTemperature.isHidden = true
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    func showInfo() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        infoIcon.isHidden = false
        infoSummary.isHidden = false
        infoTemperature.isHidden = false
        
    }
}
