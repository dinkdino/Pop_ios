//
//  LocationViewController.swift
//  Pop
//
//  Created by Hrishikesh Sawant on 09/05/15.
//  Copyright (c) 2015 Hrishikesh. All rights reserved.
//

import UIKit
import MapKit

class LocationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var annotation: MKAnnotation!
    
    
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    var searchController: UISearchController!
    var searchResultsController: UITableViewController?
    
    
    var results = [MKMapItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // A table for search results and its controller.
        let resultsTableView = UITableView(frame: self.view.frame)
        self.searchResultsController = UITableViewController()
        self.searchResultsController?.tableView = resultsTableView
        self.searchResultsController?.tableView.dataSource = self
        self.searchResultsController?.tableView.delegate = self
        
        // Register cell class for the identifier.
        self.searchResultsController?.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "locationCell")
        
        self.searchController = UISearchController(searchResultsController: self.searchResultsController!)
        self.searchController?.searchResultsUpdater = self
        self.searchController?.delegate = self
        self.searchController?.searchBar.sizeToFit() // bar size
        
        self.definesPresentationContext = true
        
        
        self.presentViewController(searchController!, animated: true, completion: nil)
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("locationCell") as! UITableViewCell
        
        let result = results[indexPath.row]
        
        
        return cell
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        self.results = []
        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0] as! MKAnnotation
            self.mapView.removeAnnotation(annotation)
        }
        
        let localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchController.searchBar.text
        localSearchRequest.region = self.mapView.region
        let localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                return
            }
            
            for mapItem in localSearchResponse.mapItems as! [MKMapItem] {
                self.results.append(mapItem)
            }
            
            
            self.searchResultsController?.tableView.reloadData()
            /*
            //3
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse.boundingRegion.center.latitude, longitude:     localSearchResponse.boundingRegion.center.longitude)
            
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation)
            */
        }
    }
    
    
}
