//
//  ViewController.swift
//  MapView
//
//  Created by Likhit Garimella on 03/07/19.
//  Copyright © 2019 Likhit Garimella. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UISearchBarDelegate {
    
    
    @IBOutlet weak var MapView: MKMapView!
    
    @IBAction func SearchButton(_ sender: Any)
    {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        //Ignoring User
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //Activity Indicator
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        //Hide search bar while viewing map
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        //Create search request
        //Taking text from search bar and inputting into search request
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            
            activityIndicator.stopAnimating()   //This for stopping animation after getting location
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil
            {
                print("Error")
            }
            else
            {
                //Remove Annotations
                //Each time I get a new location, to completely remove all annotations from the map
                let annotations = self.MapView.annotations
                self.MapView.removeAnnotations(annotations)
                
                //Getting Data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                //Creating Annotation
                let annotation = MKPointAnnotation()
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.MapView.addAnnotation(annotation)
                
                //Zooming in on an Annotation
                let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)  //Taking the coordinates of annotation
                let span = MKCoordinateSpanMake(0.1, 0.1)   //Creating span which enables how much do we want to zoom in on those coordinates
                let region = MKCoordinateRegionMake(coordinate, span)   //Combining span and coordinates to a region
                self.MapView.setRegion(region, animated: true)          //Setting the region on map
                

            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

