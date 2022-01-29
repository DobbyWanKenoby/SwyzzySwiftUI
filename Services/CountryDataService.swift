//
//  CountryDataService.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 26.01.2022.
//

import Foundation
import Swinject

protocol CountryDataService {
    var countries: [Country] { get }
}

class PlistCountryDataService: CountryDataService {
    
    private(set) var countries: [Country] = []
    
    init() {
        loadCountriesFromLocalStorage()
    }
    
    private func loadCountriesFromLocalStorage() {
        var countries: [Country] = []
        guard let url = Bundle.main.url(forResource: "Countries", withExtension: "plist") else { return }
        let data = try! Data(contentsOf: url)
        let decoder = PropertyListDecoder()
        let sourceData = try! decoder.decode([Country].self, from: data)
        sourceData.forEach { item in
            countries.append(Country(name: item.name, phoneCode: item.phoneCode, imageName: item.imageName))
        }
        self.countries = countries
    }
}


