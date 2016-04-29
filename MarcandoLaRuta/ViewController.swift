//
//  ViewController.swift
//  MarcandoLaRuta
//
//  Created by Fernando Renteria Correa on 28/04/2016.
//  Copyright © 2016 Fernando Renteria Correa. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var picker: UIPickerView!

    private let manejador = CLLocationManager()
    
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    
    var pickerData = ["Vista Normal", "Vista Satelital", "Hibrido"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        manejador.delegate = self
        // Connect data:
        picker.delegate = self
        picker.dataSource = self
        
        
        manejador.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manejador.requestWhenInUseAuthorization()
        
        manejador.distanceFilter = 50
        
        startLocation = nil
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            manejador.startUpdatingLocation()
            map.showsUserLocation = true
        } else {
            manejador.stopUpdatingLocation()
            map.showsUserLocation = false
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        var traveledDistance: CLLocationDistance = 0
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004))
        self.map.setRegion(region, animated: true)
        
        // Distance.
        if startLocation == nil {
            startLocation = locations.first
        } else {
            if let lastLocation = locations.last {
                traveledDistance = startLocation.distanceFromLocation(lastLocation)
            }
        }
        lastLocation = locations.last
        
        // Create Pin.
        let pin = MKPointAnnotation()
        pin.title = "Latitue: \(location!.coordinate.latitude) Longitude \(location!.coordinate.longitude)"
        pin.subtitle = "\(traveledDistance)"
        pin.coordinate = center
        map.addAnnotation(pin)

      //  self.manejador.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Errors: " + error.localizedDescription)
    }
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch (row) {
        case 0:
            map.mapType = .Standard
        case 1:
            map.mapType = .Satellite
        default: // or case 2
            map.mapType = .Hybrid
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

