//
//  ViewController.swift
//  Ghost Hunt
//
//  Created by Andrew Palmer on 11/16/18.
//  Copyright © 2018 Andrew Palmer. All rights reserved.
//

import UIKit
import MapKit
import ARKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, ARGhostNodeDelegate, GhostModelsDelegate, GhostModelDelegate {
    
    let defaultFileNames: [String] = ["model1", "model2", "model3", "model4", "model5", "model6", "model7", "model8"]
    let defaultNames: [String] = ["Earnest Walrath", "Raymond Snowden", "Douglas Van Vlack", "Samuel Bruner", "Troy Powell", "Ghost 6", "Ghost 7", "Ghost 8"]
    let defaultBios: [String] = ["default bio", "default bio", "default bio", "default bio", "default bio", "default bio", "default bio", "default bio"]
    let defaultLocations: [String] = ["location1", "location2", "location3", "location4", "location5", "location6", "location7", "location8"]
    let pinIconNames: [String] = ["", ""]
    let profilePicNames: [String] = ["", ""]
    
    var customPins: [CustomPointAnnotation] = []
    
    var ghostIndex: Int = 0
    var clickedIndex: Int = 0
    public var ghostObjects: [GhostModel] = []
    public var trackLocation: Bool = true
    private var ghosts: [NSManagedObject] = []
    
    var toggled: Bool = false   // ui button toggle
    var pinAnnotationView:MKPinAnnotationView!  // used to display custom pins
    var mapView:MKMapView?  // map view
    var locationManager:CLLocationManager?  // used to track user location
    var timer:Timer?
    
    public var blurView:UIVisualEffectView?   // used to blue the app when in background
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        getCurrentGhosts()
        startUpdateTimer()
        resumeTrackingLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupMap()
        requestLocation()
    }
    
    // Starts timer, navigations to game over view when time runs out
    func startUpdateTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute, .second]
            formatter.unitsStyle = .full
            let formattedString = formatter.string(from: TimeInterval((TimerModel.sharedTimer.getTimeLimit() - TimerModel.sharedTimer.getTimeElapsed())))!
            self.navigationItem.title = "Time Remaining: \(formattedString)"
            if TimerModel.sharedTimer.getTimeElapsed() >= TimerModel.sharedTimer.getTimeLimit() {
                print("time to end game")
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let vc = GhostListViewController()
                vc.gameOver = true
                vc.delegate = self
                let navigationContrller = UINavigationController(rootViewController: vc)
                navigationContrller.navigationBar.barTintColor = UIColor.IdahoMuseumBlue
                appDelegate.window?.rootViewController = navigationContrller
            }
        }
    }
    
    // Gets saved ghost data or sets up ghosts from default values
    func getCurrentGhosts() {
        if (ghostObjects.count == 0) {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Ghost")
            do {
                ghosts = try managedContext.fetch(fetchRequest)
                for ghost in ghosts {
                    setupGhost(ghost: ghost)
                }
            } catch let error as NSError {
                print("could not fetch: \(error) - \(error.userInfo)")
            }
            if (ghosts.count == 0) {
                setDefaultGhosts()
            }
        }
    }
    
    // Sets up data for ghost model and adds to ghostObjects array
    func setupGhost(ghost: NSManagedObject) {
        let ghostFileName: String = ghost.value(forKey: "model") as! String
        let ghostName: String = ghost.value(forKey: "name") as! String
        let ghostBio: String = ghost.value(forKey: "bio") as! String
        let ghostLocation: String = ghost.value(forKey: "location") as! String
        let ghostPoints: Int = ghost.value(forKey: "points") as! Int
        
        // using values to create models
        let ghostModel = GhostModel(fileName: ghostFileName, ghostName: ghostName, ghostYear: "1887", ghostBio: ghostBio, ghostLocation: ghostLocation, ghostPoints: ghostPoints, locked: true)
        ghostModel.image = UIImage(named: "round_sentiment_very_dissatisfied_black_36pt_2x.png")
        self.ghostObjects.append(ghostModel)
        if (ghostObjects.count == 1) {
            addGhostToMap(ghostModel: ghostObjects[0])
        }
        print(ghostObjects.count)
    }
    
    // Sets up defaults ghosts models and adds to ghostObjects array
    func setDefaultGhosts() {
        for i in 0...7 {
            // using hard coded default values to create models
            let ghostModel = GhostModel(fileName: defaultFileNames[i], ghostName: defaultNames[i], ghostYear: "1887", ghostBio: defaultBios[i], ghostLocation: defaultLocations[i], ghostPoints: 25, locked: true) 
            ghostModel.image = UIImage(named: "round_sentiment_very_dissatisfied_black_36pt_2x.png")
            self.ghostObjects.append(ghostModel)
            if (ghostObjects.count == 1) {
                addGhostToMap(ghostModel: ghostObjects[0])
            }
        }
        
    }
    
    // Adds specified ghost to map
    func addGhostToMap(ghostModel: GhostModel) {
        let ghostPin = MapViewController.generateCustomPointAnnotationWithTitle(title: ghostModel.ghostName)   // ghost  pin
        self.customPins.append(ghostPin)
        self.addCustomPinAtCoordinate(coordinate: ghostModel.ghostLocation, customPin: ghostPin)
    }
    
    // Called when ghost is captured in AR Controller
    func ghostCaptured() {
        if ghostIndex < ghostObjects.count - 1 {
            ghostIndex += 1
            print("Ghost Captured! Now at index: \(ghostIndex)")
            addGhostToMap(ghostModel: ghostObjects[ghostIndex])
        } else {
            print("Index out of bounds")
        }
    }
    
    // returns current ghost model of the delegate (sends info to ARSceneViewController)
    func getCurrentGhost() -> GhostModel {
        return ghostObjects[ghostIndex]
    }
    
    // returns ghost objects of the delegate (sends info to GhostListViewController)
    func getGhostModels() -> [GhostModel] {
        return ghostObjects
    }
    
    // returns ghost at current ghost index (sends info to Inmate VC)
    func getGhostModel() -> GhostModel {
        return ghostObjects[clickedIndex]
    }
    
    // general setup of navigation bar, starts hidden
    func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.IdahoMuseumBlue
        navigationItem.title = "Map"
        //self.navigationController?.navigationBar.isHidden = true
    }
    
    // sets up location manager and asks user to allow location
    func requestLocation() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.startUpdatingLocation()
    }
    
    // flips tracking bool, starts updating user location
    func resumeTrackingLocation() {
        trackLocation = true
        locationManager?.startUpdatingLocation()
    }
    
    // 37.33283141 -122.0312186
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userCoordinate = manager.location?.coordinate {
            if ghostIndex == 0 {    //TODO: Remove this line, testing purposes only
                if self.trackLocation { //TODO: MOVE THIS BACK INTO LOCATION TEST
                    print("Ghost Nearby!")
                    UIDevice.vibrate()
                    self.trackLocation = false
                    self.locationManager!.stopUpdatingLocation()
                    let arVC = ARSceneViewController()
                    arVC.delegate = self
                    navigationController?.pushViewController(arVC, animated: true)
                }
            }
            let finalIndex = ghostObjects.count - 1
            if ghostIndex == finalIndex && !ghostObjects[finalIndex].locked {
                print("game won!")
                self.locationManager?.stopUpdatingLocation()
                manager.stopUpdatingLocation()
                self.trackLocation = false
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let vc = GhostListViewController()
                vc.gameOver = true
                vc.gameWon = true
                vc.delegate = self
                let navigationContrller = UINavigationController(rootViewController: vc)
                navigationContrller.navigationBar.barTintColor = UIColor.IdahoMuseumBlue
                appDelegate.window?.rootViewController = navigationContrller
            } else {
                if !ghostObjects[ghostIndex].locked {
                    print("Ghost Already Captured...")
                    ghostCaptured()
                }
                if (customPins[ghostIndex].coordinate.latitude - userCoordinate.latitude < 0.00001 && customPins[ghostIndex].coordinate.latitude - userCoordinate.latitude > -0.0001) {
                        if (customPins[ghostIndex].coordinate.longitude - userCoordinate.longitude < 0.00001 && customPins[ghostIndex].coordinate.longitude - userCoordinate.longitude > -0.0001) {
                            // TODO: CODE GOES HERE
                        }
                }
            }
        }
    }
    
    // sets up map view to State Pen location
    func setupMap() {
        mapView = MKMapView(frame: view.frame)
        mapView?.delegate = self
        mapView?.mapType = MKMapType.hybrid
        mapView?.showsBuildings = true
        mapView?.isUserInteractionEnabled = true
        mapView?.isScrollEnabled = false
        mapView?.isRotateEnabled = false
        mapView?.isZoomEnabled = false
        mapView?.showsUserLocation = true
        mapView?.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.602401, longitude: -116.162292), latitudinalMeters: 200, longitudinalMeters: 200)
        view = mapView
    }
    
    // adds custom pin to map at given coordinate
    func addCustomPinAtCoordinate(coordinate: CLLocationCoordinate2D, customPin: CustomPointAnnotation) {
        customPin.coordinate = coordinate
        pinAnnotationView = MKPinAnnotationView(annotation: customPin, reuseIdentifier: "pin")
        mapView?.addAnnotation(customPin)
    }
    
    // constraint generator takes in format and creates constraints
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String : AnyObject]()
        for (index, view) in views.enumerated() {
            view.translatesAutoresizingMaskIntoConstraints = false
            let key = "v\(index)"
            viewsDictionary[key] = view
        }
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    // annotation Setup
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            // returns nil so user location is displayed instead of custom annotation
            return nil
        }
        let reuseIdentifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        let customPointAnnotation = annotation as! CustomPointAnnotation
        annotationView?.image = UIImage(named: customPointAnnotation.pinImage)
        return annotationView
    }
    
    // returns a round button to be added to view
    public static func generateButtonWithImage(image: UIImage, borderColor: CGColor, cornerRadius: CGFloat) -> UIButton {
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.imageView?.layer.cornerRadius = cornerRadius
        button.layer.borderWidth = 2
        button.backgroundColor = UIColor.lightGray
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.layer.borderColor = borderColor
        button.layer.borderWidth = 2
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowRadius = 6
        button.layer.shadowOpacity = 0.6
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.layer.cornerRadius =  cornerRadius
        return button
    }
    
    // returns custom point annotation
    public static func generateCustomPointAnnotationWithTitle(title: String) -> CustomPointAnnotation {
        let customPointAnnotation = CustomPointAnnotation()
        customPointAnnotation.pinImage = "round_sentiment_very_dissatisfied_black_36pt_1x.png"
        customPointAnnotation.title = title
        customPointAnnotation.subtitle = "Wandering the area..."
        return customPointAnnotation
    }
    
    // If ghost is unlocked, clicking on map annotation will navigate to inmate view controller
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //print(view.annotation?.title!)
        if let ghostPin: CustomPointAnnotation = view.annotation as? CustomPointAnnotation {
            if let index = self.customPins.firstIndex(of: ghostPin) {
                clickedIndex = index
                if !self.ghostObjects[index].locked {    // TODO: flip bool for testing
                    let vc = InmateViewController()
                    vc.delegate = self as GhostModelDelegate
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
            
        }
    }
    
}

extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
