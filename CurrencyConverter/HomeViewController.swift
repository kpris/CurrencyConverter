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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

