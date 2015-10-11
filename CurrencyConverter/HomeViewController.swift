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
    
    private var currentCurrency: Currency = Currency.CAD {
        didSet {
            updateResult()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        entryField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        populateCurrencyScroller()
        
        //pull out the scrollview's gesture recognizer and pop it onto the container instead so that you can scroll outside the bounds of the scrollview itself.
        currencyContainer.addGestureRecognizer(scrollView.panGestureRecognizer)
    }
    
    //MARK: Currency Selection
    
    private func populateCurrencyScroller() {
        
        scrollView.backgroundColor = UIColor.purpleColor()
        scrollView.alpha = 0.8
        let size = scrollView.frame.size
        var currX: CGFloat = 0
        
        for currency in Currency.currencyList {
            let label = UILabel(frame: CGRectMake(currX, 0, size.width, size.height))
            label.backgroundColor = UIColor.blueColor()
            label.textAlignment = NSTextAlignment.Center
            label.alpha = 0.5
            label.font = UIFont.systemFontOfSize(56)
            label.textColor = UIColor.whiteColor()
            label.text = currency
            scrollView.addSubview(label)
            currX += size.width
        }
        
        scrollView.contentSize = CGSizeMake(currX, size.height)
    }
    
    
    //MARK: TextField Management
    
    @IBAction func textFieldDidChange(textField: UITextField) {
        updateResult()
    }
    
    private func updateResult() {
        if let text = entryField.text {
            
            //the number formatter framework doesn't work if there isn't a dollar symbol in front.
            var amount = text
            let dollarSymbol = "$"
            if !text.hasPrefix(dollarSymbol) {
                amount = dollarSymbol + text
            }
            resultLabel.text = formattedValue(amount, currency: currentCurrency)
        }
    }
    
    
    //MARK: Helpers
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

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if let currency = Currency.currencyForIndex(currentPage()) {
            currentCurrency = currency
        }
    }
    
    private func currentPage() -> Int {
        let pageWidth = CGRectGetWidth(scrollView.frame)
        let offset = scrollView.contentOffset.x
        return Int(offset/pageWidth)
    }
}


