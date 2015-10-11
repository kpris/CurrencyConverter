//
//  HomeViewController.swift
//  CurrencyConverter
//
//  Created by Priscilla Bevis on 11/10/2015.
//  Copyright © 2015 Priscilla. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var entryField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var currencyContainer: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var currentCurrency: Currency {
        get {
            return Currency.EUR
        }
        set {
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        entryField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        
        dispatch_after(UInt64(1), dispatch_get_main_queue()) { () -> Void in
            self.entryField.text = "asdf"
        }
    }
    
    @IBAction func textFieldDidChange(textField: UITextField) {
        if let text = textField.text {
            
            //the number formatter framework doesn't work if there isn't a dollar symbol in front.
            var amount = text
            let dollarSymbol = "$"
            if !text.hasPrefix(dollarSymbol) {
                amount = dollarSymbol + text
            }
            resultLabel.text = formattedValue(amount, currency: currentCurrency)
        }
    }
    
    private func formattedValue(value: String, currency: Currency) -> String? {
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.currencySymbol = "$"

        if let number = formatter.numberFromString(value) {
            let converted = number.doubleValue * RatesManager.sharedManager.rateForCurrency(currency)
            formatter.currencySymbol = currency.symbol()
            return formatter.stringFromNumber(NSNumber(double: converted))
        }

        return nil
    }
}


