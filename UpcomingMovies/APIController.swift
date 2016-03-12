//
//  APIController.swift
//  UpcomingMovies
//
//  Created by Frank Bara on 8/17/15.
//  Copyright © 2015 BaraLabs. All rights reserved.
//

import UIKit

protocol APIControllerProtocol {
	func JSONAPIResults(results: NSArray)
}

class APIController: NSObject {
	
	var delegate:APIControllerProtocol?
	
	func GetAPIResultsAsync(urlString: String) {
		//The URL that will be called
		let url = NSURL(string: urlString)
		//Create a request
		let request: NSURLRequest = NSURLRequest(URL: url!)
		//Create a queue to hold the call
		let queue: NSOperationQueue = NSOperationQueue()
		
		//Sending asynchronous request using NSURLConnection
		//NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{(response:NSURLResponse!, responseData:NSData!, error: NSError!) ->Void in
		  NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{(response: NSURLResponse?, responseData: NSData?, error: NSError?) -> Void in

			let error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
			//Serialize the JSON result into a dictionary
			//let jsonResult: NSDictionary! = NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableContainers, error: error) as? NSDictionary
			
			//let jsonResult = try NSJSONSerialization.JSONObjectWithData(responseData!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
			let jsonResult: NSDictionary!
			do {
				jsonResult = try NSJSONSerialization.JSONObjectWithData(responseData!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
			} catch _ {
				jsonResult = nil
			}
			
			
			
			//If there is a result, add the data into an array
			if jsonResult.count > 0 && jsonResult["results"]?.count > 0 {
				let results: NSArray = (jsonResult["results"] as? NSArray)!
				//Use the completion handler to pass the results
				self.delegate?.JSONAPIResults(results)
			} else {
				print(error)
			};
			
		})
		
	}

}
