//
//  RatesManager.swift
//  CurrencyConverter
//
//  Created by Priscilla Bevis on 11/10/2015.
//  Copyright © 2015 Priscilla. All rights reserved.
//

import Foundation

enum Currency: String {
    case CAD, EUR, GBP, JPY, USD
}

class RatesManager {
    static let sharedManager = RatesManager()
    
    private var rates: [String: Double]
    
    private init() {
        rates = [String: Double]()
        retrieveLatestRates()
    }
    
    private func retrieveLatestRates() {
        FixerService.retrieveLatestRates { rates in
            self.rates = rates
        }
    }
    
    func rateForCurrency(currency: Currency) -> Double {
        
        return 0.0
    }
}
