//
//  ViewController.swift
//  UpcomingMovies
//
//  Created by Frank Bara on 8/17/15.
//  Copyright © 2015 BaraLabs. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
	@IBOutlet var appTableView: UITableView!
	
	var searchResultsData: NSArray = [] //contains table data
	let api: APIController = APIController() //instance of the API controller
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let apiKey: String = "f04387ef50c4b5a723ab1f0b6108feca"
		let apiBaseURL: String = "http://api.themoviedb.org/3/movie/upcoming?api_key="
		//let urlString: String = "\(apiBaseURL)" + "\(apiKey)"
		let urlString: String = apiBaseURL + apiKey
		
		
		//Call the API by using the delegate and passing the API url
		self.api.delegate = self
		api.GetAPIResultsAsync(urlString)
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return searchResultsData.count
		
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cellIdentifier: String = "MovieResultsCell"
	
		let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
		
		//Create a variable that will contain the result data array item for each row
		let cellData: NSDictionary = self.searchResultsData[indexPath.row] as! NSDictionary
		//Assign and display the Title field
		cell.textLabel?.text = cellData["title"] as? String
		
		//Construct the posterURL to get an imageURL for the movie thumbnail
		let baseURL: String = "http://image.tmdb.org/t/p/w300"
		let movieURLString: String = (cellData["poster_path"] as? String)!
		//let urlString: String! = "\(baseURL)" + "\(movieURLString)"
		let urlString: String = baseURL + movieURLString
		
		let imgURL: NSURL = NSURL(string: urlString)!
		
		//Download an NSData representation of the image at the URL
		let imgData: NSData = NSData(contentsOfURL: imgURL)!
		cell.imageView?.image = UIImage(data: imgData)
		
		//Get the release data string for display in the subtitle
		let releaseDate: String = cellData["release_date"] as! String
		cell.detailTextLabel?.text = releaseDate
		
		
		return cell
		
	}
	
	func JSONAPIResults(results: NSArray) {
		dispatch_async(dispatch_get_main_queue(), {
			self.searchResultsData = results
			self.appTableView.reloadData()
		})
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

