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
    
    private struct Constants {
        static let selectedLabelColor = UIColor.whiteColor()
        static let unselectedLabelColor = UIColor(red: 0, green: 230.0/255.0, blue: 140.0/255.0, alpha: 1)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        entryField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        populateCurrencyScroller()
        
        //pull out the scrollview's gesture recognizer and pop it onto the container instead so that you can scroll outside the bounds of the scrollview itself.
        currencyContainer.addGestureRecognizer(scrollView.panGestureRecognizer)
        
        //And a gesture recognizer so that you can tap the background to dismiss the keyboard
        let tap = UITapGestureRecognizer(target: self, action: "tappedBackground:")
        self.view.addGestureRecognizer(tap)
        
    }
    
    //MARK: IBActions
    
    @IBAction func tappedBackground(tap: UITapGestureRecognizer) {
        entryField.resignFirstResponder()
    }
    
    //MARK: Refresh
    
    private func populateCurrencyScroller() {
        
        let size = scrollView.frame.size
        var currX: CGFloat = 0
        
        for currency in Currency.currencyList {
            let label = UILabel(frame: CGRectMake(currX, 0, size.width, size.height))
            label.backgroundColor = UIColor.clearColor()
            label.textAlignment = NSTextAlignment.Center
            label.font = UIFont(name: "Helvetica", size: 56)
            label.textColor = currX == 0 ? Constants.selectedLabelColor : Constants.unselectedLabelColor
            label.text = currency
            scrollView.addSubview(label)
            currX += size.width
        }
        
        scrollView.contentSize = CGSizeMake(currX, size.height)
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

//MARK: TextField Management
extension HomeViewController: UITextFieldDelegate {
    
    @IBAction func textFieldDidChange(textField: UITextField) {
        updateResult()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        entryField.resignFirstResponder()
        return false
    }
}

//MARK: ScrollView Management
extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let currPage = currentPage()
        if let currency = Currency.currencyForIndex(currPage) {
            currentCurrency = currency
        }
        
        //want to make the currently selected label white
        var i = 0
        for view in scrollView.subviews {
            if let label = view as? UILabel {
                label.textColor = i == currPage ? Constants.selectedLabelColor : Constants.unselectedLabelColor
                i++
            }
        }
    }
    
    private func currentPage() -> Int {
        let pageWidth = CGRectGetWidth(scrollView.frame)
        let offset = scrollView.contentOffset.x
        return Int(offset/pageWidth)
    }
}


