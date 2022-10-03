//
//  DayWeatherCell.swift
//  WeatherAgain
//
//  Created by Сергей Иванчихин on 01.10.2022.
//

import Foundation
import UIKit

class DayWeatherCell: UICollectionViewCell {
    
    @IBOutlet weak var dayWeatherImage: UIImageView!
    @IBOutlet weak var dayTime: UILabel!
    
    func setCellDataWith(_ day: Day, vm: WeatherViewModel) {
        dayTime.text = vm.getHourOfDay(day)
        loadImage(for: day, with: vm)
    }
    
    /// downloads image for cell
    private func loadImage(for day: Day, with vm: WeatherViewModel) {
        guard let url =  vm.getImageUrl(day) else { return }
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.dayWeatherImage.image = image
                        }
                    }
                }
            }
        }
}
