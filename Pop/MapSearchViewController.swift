//
//  MapSearchViewController.swift
//  Pop
//
//  Created by Hrishikesh Sawant on 09/05/15.
//  Copyright (c) 2015 Hrishikesh. All rights reserved.
//

import UIKit

protocol MapSearchViewControllerDelegate {
    
    func selectedLocation(mapTask: MapTask)
}

class MapSearchViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    
    
    @IBOutlet weak var mapView: GMSMapView!
    
    let locationManager = CLLocationManager()
    
    var searchController: UISearchController!
    var searchResultsController: UITableViewController?
    
    var results = [String]()
    
    var mapTasks = MapTask()

    var marker = GMSMarker()
    
    var delegate: MapSearchViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
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
        
        self.searchResultsController?.tableView.backgroundColor = UIColor.clearColor()
        
        self.definesPresentationContext = true
        
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        self.searchButtonClicked(self)
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        // 2
        if status == .AuthorizedWhenInUse {
            
            // 3
            locationManager.startUpdatingLocation()
            
            //4
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    // 5
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations.first as? CLLocation {
            
            // 6
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            
            // 7
            locationManager.stopUpdatingLocation()
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("locationCell") as! UITableViewCell
        
        let result = results[indexPath.row]
        
        cell.textLabel?.text = result
        
        return cell
    }
    

    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.results = []
        marker.map = nil
        let address = searchController.searchBar.text
        
        self.mapTasks.geocodeAddress(address, withCompletionHandler: { (status, success) -> Void in
            if !success {
                self.results = []
            }
            else {
                self.results.append(self.mapTasks.fetchedFormattedAddress)
                self.searchResultsController?.tableView.reloadData()
                let coordinate = CLLocationCoordinate2D(latitude: self.mapTasks.fetchedAddressLatitude, longitude: self.mapTasks.fetchedAddressLongitude)
                self.mapView.camera = GMSCameraPosition.cameraWithTarget(coordinate, zoom: 14.0)
                
                self.marker = GMSMarker(position: coordinate)
                self.marker.title = self.mapTasks.fetchedFormattedAddress
                self.marker.map = self.mapView
                
            }
        })
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.selectedLocation(self.mapTasks)
        self.searchController.dismissViewControllerAnimated(false, completion: { () -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        
    }
    
    @IBAction func cancelButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func searchButtonClicked(sender: AnyObject) {
        presentViewController(searchController, animated: true, completion: nil)
    }
}
