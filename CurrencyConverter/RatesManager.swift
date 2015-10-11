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
    
    func symbol() -> String {
        switch self {
        case .EUR: return "€"
        case .GBP: return "£"
        case .JPY: return "¥"
        default: return "$"
        }
    }
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
        //Because we're assuming fixer is perfect, we shouldn't ever be missing a rate. However as the compiler doesn't know that we still need to cater for the scneario that the key is missing. In this case we just return 0.
        return rates[currency.rawValue] ?? 0
    }
}
