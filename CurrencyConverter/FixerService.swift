//
//  FixerService.swift
//  CurrencyConverter
//
//  Created by Priscilla Bevis on 11/10/2015.
//  Copyright © 2015 Priscilla. All rights reserved.
//

import Foundation

/// Responsible for retrieving and parsing currency information from fixer.io
class FixerService {
    
    /* 
    Retrieves the latest rates.
    This function assumes alot of information such as which rates will be required and an error will not occur as per the brief.
    Will simply return an empty array if anything fails.
    */
    static func retrieveLatestRates(completion: (rates: [String: Double]) -> Void) {
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.fixer.io/latest?base=AUD&symbols=CAD,EUR,GBP,JPY,USD")!)
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        session.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            if let _ = error {
                //Ideally this service would just rethrow the error so that the RatesManager could then gracefully fall back to cached data or show an appropriate error message.
                return
            }
            
            guard let data = data else {
                //Again this should throw an error.
                return
            }
            
            let jsonObject = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
            if let jsonDictionary = jsonObject as? NSDictionary {
                completion(rates: parseRatesFromJson(jsonDictionary))
            }
        }.resume()
    }
    
    private static func parseRatesFromJson(json: NSDictionary) -> [String: Double] {
        if let rates = json["rates"] as? [String: AnyObject] {
            /*
            Because the JSON serialization is all in Objective-C land, we lose the value type information and need to convert it to the final type that we want, which in this case is a Double.
            */
            var typedDictionary = [String: Double]()
        
            for (key, value) in rates {
                if let doubleValue = (value as? NSNumber)?.doubleValue {
                    typedDictionary[key] = doubleValue
                }
            }
            return typedDictionary
            
        } else {
            return [String: Double]()
        }
    }
}
