//
//  ViewController.swift
//  WeatherAgain
//
//  Created by Сергей Иванчихин on 29.09.2022.
//

import UIKit
import Combine


class UIkitViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    
    @IBOutlet weak var sunrise: UILabel!
    @IBOutlet weak var sunriseImage: UIImageView!
    @IBOutlet weak var sunset: UILabel!
    @IBOutlet weak var sunsetImage: UIImageView!
    
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var weekWeatherCollectionView: UICollectionView!
    @IBOutlet weak var dayWeatherCollectionView: UICollectionView!
    
    private let vm = WeatherViewModel()
    private var cancellable = Set<AnyCancellable>()
    private var weather: Weather?
    private var lastSelected = [IndexPath(row: 0, section: 0)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        weekWeatherCollectionView.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        weekWeatherCollectionView.layer.cornerRadius = 25
        
        dayWeatherCollectionView.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        dayWeatherCollectionView.layer.cornerRadius = 25
        
    }
    
    //set data for header
    private func setHeader() {
        sunriseImage.image = UIImage(systemName: "sunrise.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        sunsetImage.image = UIImage(systemName: "sunset.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        
        city.text = weather?.city.name
        sunrise.text = self.vm.getSunTime(weather?.city.sunrise ?? 0)
        sunset.text = self.vm.getSunTime(weather?.city.sunset ?? 0)
        
        let currentTemp = String(Int(weather?.list.first?.main.temp ?? 0.0))+"°"
        temperature.text = currentTemp
        
        let description = weather?.list.first?.weather.first?.weatherDescription
        weatherDescription.text = description
        backgroundImage.image = UIImage(named: self.vm.setImage(weather: weather))
        
    }
    
    //get data from view model
    private func getData() {
        vm.$weather
            .sink { data in
                self.weather = data
                self.setHeader()
                self.dayWeatherCollectionView.reloadData()
                self.weekWeatherCollectionView.reloadData()
                self.vm.getSelectedDay()
                print("day " + self.vm.selectedDay)
                print(self.vm.getWeatherByHour(dayName: self.vm.selectedDay))
            }
            .store(in: &cancellable)
    }
}

extension UIkitViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == weekWeatherCollectionView {
            return vm.getWeatherByDay().count
        } else {
            return vm.getWeatherByHour(dayName: vm.selectedDay).count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == weekWeatherCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekID", for: indexPath) as! WeekWeatherCell
            if weather != nil {
               let data = vm.getWeatherByDay()[indexPath.row]
                cell.setCellDataWith(data, vm: self.vm)
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayID", for: indexPath) as! DayWeatherCell
            if weather != nil {
                let data = vm.getWeatherByHour(dayName: vm.selectedDay)[indexPath.row]
                cell.setCellDataWith(data, vm: self.vm)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
      didSelectItemAt indexPath: IndexPath) {
        if collectionView == weekWeatherCollectionView {
            let day = vm.getWeatherByDay()[indexPath.row]
            vm.changeCurrentDay(day)
            dayWeatherCollectionView.reloadData()
            weekWeatherCollectionView.reloadItems(at: lastSelected)
            weekWeatherCollectionView.reloadItems(at: [indexPath])
            lastSelected = [indexPath]
        }
      }
}

