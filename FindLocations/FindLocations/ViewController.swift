//
//  ViewController.swift
//  FindLocations
//
//  Created by Furkan Hanci on 9/20/20.
//

import UIKit
import MapKit
class ViewController: UIViewController {

    @IBOutlet weak var locationTextfield: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var goButton: UIButton!
    
    var locationRetrive : String?
    var coordinate : CLLocationCoordinate2D?
    let annotation  = MKPointAnnotation()
    var  location : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        goButton.layer.cornerRadius = 5
    }

    @IBAction func goTapped(_ sender: Any) {
        
        if locationTextfield.text != nil{
            let alert = UIAlertController(title: "Error", message: "Your Location is not be empty!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            mapView.removeAnnotation(annotation)
            locationRetrive = locationTextfield.text!
            search()
        }
        
    }
    
    
    func search() {
        guard let location = locationRetrive else {
            print("error location")
            return
        }
        
        CLGeocoder().geocodeAddressString(location) { (place, error) in
            
            guard error == nil else {
              print("Not find")
                return
            }
            
            
            self.location = location.uppercased()
            self.coordinate = place?.first?.location?.coordinate
            self.pin(coordinate: self.coordinate!)
            
        }
    }
    
    func pin(coordinate : CLLocationCoordinate2D) {
        annotation.coordinate = coordinate
        annotation.title = location
        
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        DispatchQueue.main.async {
            self.mapView.addAnnotation(self.annotation)
            self.mapView.setRegion(region, animated: true)
            self.mapView.regionThatFits(region)
        }
    }
    
    
    
}


extension ViewController : MKMapViewDelegate {
    
    
    func mapView(_ mapView : MKMapView , viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseid = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseid) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseid)
            pinView?.canShowCallout = true
            pinView?.pinTintColor = .blue
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            pinView?.animatesDrop = true
        } else {
            pinView?.annotation = annotation
        }
        
        return pinView
        
    }
    
}

