//
//  CurrencyConverterTests.swift
//  CurrencyConverterTests
//
//  Created by Priscilla Bevis on 11/10/2015.
//  Copyright © 2015 Priscilla. All rights reserved.
//

import XCTest
@testable import CurrencyConverter

class CurrencyConverterTests: XCTestCase {
    
    func testThatResultsExistWhenValueAdded() {
        let homeVC = UIStoryboard(name: "HomeVC", bundle: nil).instantiateInitialViewController() as! HomeViewController
        homeVC.loadView()
        
        homeVC.entryField.text = "100"
        homeVC.textFieldDidChange(homeVC.entryField)
        XCTAssertTrue(homeVC.resultLabel.text?.characters.count > 0)
    }
    
    func testThatResultIsEmptyWhenValueEmpty() {
        let homeVC = UIStoryboard(name: "HomeVC", bundle: nil).instantiateInitialViewController() as! HomeViewController
        homeVC.loadView()
        
        homeVC.entryField.text = ""
        homeVC.textFieldDidChange(homeVC.entryField)
        XCTAssertTrue(homeVC.resultLabel.text?.characters.count == 0)
    }

}
