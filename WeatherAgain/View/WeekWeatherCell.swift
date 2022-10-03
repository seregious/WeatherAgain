//
//  WeatherCell.swift
//  WeatherSwiftUI
//
//  Created by Сергей Иванчихин on 29.09.2022.
//

import Foundation
import UIKit

class WeekWeatherCell: UICollectionViewCell {
    
    @IBOutlet weak var dayOfWeek: UILabel!
    @IBOutlet weak var dateOfDay: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var imageOfWeather: UIImageView!
    @IBOutlet weak var markerImage: UIImageView!
    
    func setCellDataWith(_ day: Day, vm: WeatherViewModel) {
        dayOfWeek.text = vm.getDayOfWeek(day)
        dateOfDay.text = vm.getDateOfDay(day)
        temperature.text = String(Int(day.main.temp))+"°"
        markerImage.image = UIImage(systemName: "play.fill")?.withTintColor(.blue, renderingMode: .alwaysOriginal)
        markerImage.alpha = vm.checkDayFor(day) ? 1 : 0
        
        loadImage(for: day, with: vm)
    }
    
    ///downloads image for cell
    private func loadImage(for day: Day, with vm: WeatherViewModel) {
        guard let url =  vm.getImageUrl(day) else { return }
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.imageOfWeather.image = image
                        }
                    }
                }
            }
        }
}
