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
    
    let defaultFileNames: [String] = ["model1", "model2", "model3", "model4", "model5", "model6", "model7", "model8", "model9", "model10", "model11", "model12", "model13", "model14", "model15", "model16"]
    let defaultNames: [String] = ["Ernest Walrath", "Raymond Snowden", "Douglas Van Vlack", "Troy Powell", "Ed Rice", "Frank Frisbee", "Noah Arnold", "Frank Jones", "Fred Seward", /*"George Hamilton",*/ "Ignacio Morsagaray", /*"James Conners",*/ "John Jurko", "Joseph Hayes", "Mike Penford", "Roberto Samaniego", "Ulyssus Bearup", "Fred Bond", /*"William Wild"*/]
    let defaultBios: [String] = ["Crime: 1st degree Murder.\n\nOn Friday, April 13, 1951, Troy Powell, age 21, and 20-year-old Ernest Walrath were hanged on a temporary gallows built just outside the walls by the #2 Yard gate. Powell married Walrath’s sister and the two men often spent time together. The duo set out to rob storekeeper Newton Wilson. While Powell admitted to hitting Wilson, Walrath confessed to delivering the fatal stab wounds. Still, both pled guilty and the judged determined he had no choice but to exact the ultimate punishment. Powell and Walrath are the youngest inmates ever executed in Idaho and it was the only double execution in the state’s history. The pair are buried next to each other at Morris Hill Cemetery in Boise.",
                                 
                                 "Crime: Murder in the 1st degree.\nTime Served: 11 months.\nDate of Death: October 17, 1957.\nAge at Death: 35.\n\nOn September 22, 1956, Raymond Snowden brutally murdered Cora Dean in Garden City, Idaho. After drinking and carousing at a bar, the pair decided to go to downtown Boise. Snowden claimed a physical altercation ensued about who would pay the cab fare. Ms. Dean allegedly kneed him in the groin, sending him into a murderous rage. The judge said Snowden possessed a cold-blooded and “malignant heart.” On October 18, 1957, just thirteen months after the crime, an executioner brought in from Walla Walla, Washington, pulled a lever releasing the trap door beneath Snowden’s feet. The execution was the first and last to take place in the #5 Cell House/Maximum Security gallows. Snowden was also the last man executed at the Idaho State Penitentiary.",
                                 
                                 "Crime: 1st degree Murder.\n\nDouglas Van Vlack was on the run after kidnapping his estranged wife, Mildred Hook near her home in Tacoma, Washington. Within a few days Van Vlack had murdered Hook, an Idaho State Trooper, and a Deputy Sherriff in southern Idaho. His family pleaded for his life through letters to the governor.  On December 9, 1937, Douglas Van Vlack was scheduled to hang for the murders. In the final hours of his life, after a final embrace with his mother, Van Vlack leapt on a table, pulled himself to the next level of cells, and then up to the top floor. For thirty minutes guards, Warden William Gess, and Van Vlack’s lawyer tried to coax him down. Some guards claimed Van Vlack said his mother told him he could choose the way he died. Just as guards prepared to bring in a net, Van Vlack assumed a diving position and jumped. He landed on his head and left shoulder. Coughing up blood and twitching, Van Vlack lived another four agonizing hours. At 12:32 a.m. on December 10, 1937, he died on the cell house floor.",
                                 
                                 "Crime: 1st degree Murder.\n\nOn Friday, April 13, 1951, Troy Powell, age 21, and 20-year-old Ernest Walrath were hanged on a temporary gallows built just outside the walls by the #2 Yard gate. Powell married Walrath’s sister and the two men often spent time together. The duo set out to rob storekeeper Newton Wilson. While Powell admitted to hitting Wilson, Walrath confessed to delivering the fatal stab wounds. Still, both pled guilty and the judged determined he had no choice but to exact the ultimate punishment. Powell and Walrath are the youngest inmates ever executed in Idaho and it was the only double execution in the state’s history. The pair are buried next to each other at Morris Hill Cemetery in Boise.",
                                 
                                 "Crime: Murder in the 1st degree.\nTime Served: 1 year.\nDate of Death: November 30, 1901.\nAge at Death: 43.\n\nEd Rice murdered storekeeper Mat Mailley in Shoshone County. He bungled a haphazard attempt to cover up the crime by leaving behind a handkerchief with his initials embroidered on it. In January 1901, Rice attempted suicide in his prison cell. On December 1, 1901, he died by hanging. His voice barely audible, Rice kept uttering, “There is lots of time,” as he approached the gallows.",
                                 
                                 "Crime: Burglary.\nTime Served: 10 months.\nDate of Death: December 28, 1918.\nAge at Death: 40.\n\nA native of Ireland, Frank Frisbee did not reveal much about his past to prison officials. The Idaho Statesman reported, “Mr. Frisbee was one of the best-behaved prisoners, but always refused to give information about himself.…He was well educated but always said he was just a down-and-outer.” Frisbee and five other inmates died of Spanish Influenza within weeks of one another.",
                                 
                                 "Crime: Murder in the 1st degree.\nTime Served: 1 year, 3 months.\nDate of Death: December 19, 1924.\nAge at Death: 32.\n\nNoah Arnold was convicted of first degree murder and sentenced to hang after murdering a pool hall owner in Hope, Idaho. He was executed in the rose garden on a frigid December day. His final words to prison officials were “Do a good job of it because I don’t want to strangle.” Prison administration created a device that would make Arnold’s weight release water from a bucket, acting as a counterweight to the trap door.  During the execution, it was discovered after several minutes that the hole in the bucket had frozen shut. Guards brought a bucket of hot water over to continue the process. The trap then sprung, completing Arnold’s execution.  He was buried in the prison cemetery the next morning.",
                                 
                                 "Crime: Forgery.\nTime Served: 3 years.\nDate of Death: December 19, 1918.\nAge at Death: 24.\n\nFrank Jones was convicted of forgery in Ada County after he was caught writing several bad checks in Boise. He was sentenced to a term of one to fourteen years. Given trusty status, Jones worked in the kitchen and was allowed outside the walls. One afternoon a year into his sentence he escaped. He was recaptured the next day hiding in a haystack near Lovers’ Lane, located near River and Ash Street. Jones caught the 1918 Spanish Influenza that had spread throughout the prison. He was the youngest inmate at the Idaho State Penitentiary to die from the pandemic that killed millions around the world. His parents resided in Toppenish, Washington, and were unable to obtain his body for burial.",
                                 
                                 "Crime: Murder in the 1st degree.\nTime Served: 4 months.\nDate of Death: May 7, 1909.\nAge at Death: 28.\n\nFred Seward murdered Clara O’Neill. He fell in love with O’Neill and shot her in a fit of jealous rage after unsuccessfully trying to convince her to go away with him. He then turned the gun on himself and fired. He caused severe damage to his right eye and face, but survived to face trial. After a final meal of “mush” and milk, Seward reportedly asked the executioner to “Do a good job of it.” He died by hanging at 8:15 a.m. on May 7, 1909.",
                                 
                                 /*"Crime: Robbery.\n\nIn February, 1895, George Hamilton and another man held up and robbed a sheepherder near Nampa. They were arrested the same day and locked in the county jail. A month later, they sawed their way out of their cell and knocked bricks out of the wall to secure their escape. Both men were apprehended within the week. In April, they were jointly charged with robbery and sentenced to seven years of hard labor in the Idaho State Penitentiary. In his intake papers, Hamilton explained that he had nine to ten years of education and worked as a draughtsman and telegraph operator for the N.P.R.R. (Northern Pacific Railroad or Northern Pennsylvania Railroad) for nine years. The warden put Hamilton in charge of designing and superintending the construction of the dining hall. It was completed in 1898. The basement included rooms for a cellar, shoe shop, butcher shop, bakery, laundry and plunge bath. The main floor contained a large dining room that could easily seat 300 men, a guards dining area and a kitchen. Hamilton was released in October of 1897 with the condition that he leave the state of Idaho. The warden purchased a train ticket to Oregon for Hamilton. Boarding the train, he told a guard that “if he found the liquor habit still had control of him he would conquer it by taking morphine and ending his career.” Hamilton didn’t complete his journey. He stopped in Nampa, and checked into a hotel. He indulged in a bottle of whiskey, and fulfilled his promise. He overdosed on morphine. His body was found the next day. It was revealed that “George Hamilton” was an alias to defend the honor of his wealthy family.",*/
                                 
                                 "Crime: Burglary.\nTime Served: 2 years, 4 months.\nDate of Death: July 11, 1923.\nAge at Death: 29.\n\nIgnacio Morsagaray was convicted of burglary in Bingham County when police followed snow tracks from a burglarized store to his home where he and two other men were sitting with wet shoes. He was sentenced to one to fifteen years in prison. Not long into his sentence, the 29-year old became very depressed and attempted to end his life by leaping from the fourth floor of his cell house. He survived but remained despondent as he healed in the hospital. He was scheduled to be released on parole on August 22, 1923. A month before his release, he left the hospital and was returned to his cell. Soon after, Morsagaray gave his watch away to a friend saying “I’m afraid I might lose it.” He skipped breakfast one morning, and while the other convicts were eating, he used a small paring knife to cut his own throat. He bled to death in his cell. His family in Michoacán, Mexico, were unable to be reached.",
                                 
                                 /*"Crime: Murder in the 1st degree.\nTime Served: 1 year, 2 months.\nDate of Death: December 16, 1904.\nAge at Death: 40.\n\nIn 1903, James Connors shot and killed Deputy Sheriff E. P. Sweet and wounded another deputy in Blackfoot. Tradition dictated each doomed inmate be offered a drink before his death.  An insufferable, mean-spirited drunk, Connors showed signs of clarity as he approached the gallows for his execution. Refusing the drink he said, “I was a pretty good fellow when I was sober. Whiskey brought me to where I am and I don’t want any more of it.”",*/
                                 
                                 "Crime: 1st degree Murder.\n\nJohn Jurko killed his business partner A. W. B. Vandenmark at a pool hall in Twin Falls. Vandenmark earlier threatened to kill Jurko and made advances towards his wife. Many believed, however, Jurko, a native of Eastern Europe, did not receive a fair trial because many unfairly associated him with communism. At his execution July 9, 1926, he exclaimed, “No mercy, no justice! But I forgive everyone.”",
                                 
                                 "Crime: Persistent violation of prohibition laws.\nTime Served: 7 months, 20 days.\nDate of Death: December 24, 1918.\nAge at Death: 46.\n\nJoseph H. Hayes was a farmer from Lincoln County. A widower with a 15year-old daughter, Hayes was convicted of persistent violation of prohibition laws. He was sentenced to one to two years in prison. He was stricken with the worldwide 1918 flu pandemic that killed millions of people. An autopsy report declared that he died on Christmas Eve of pneumonia brought on by the flu. The warden attempted to contact Hayes’s only known adult relative, a brother-in-law from El Paso, Texas, to no avail.",
                                 
                                 "Crime: 2nd degree burglary.\nTime Served: 1 year, 3 months.\nDate of Death: January 5, 1919.\nAge at Death: 40.\n\nMike Penfold was convicted of second degree burglary in Bingham County and sentenced to one to five years. Addicted to morphine, Penfold’s health declined drastically as he began having withdrawals. With his immune system weakened, he caught the 1918 flu that was decimating the world’s population. He died shortly after in the prison hospital. Penfold was the last of six convicts to die from the 1918 flu. His extensive criminal record and list of aliases made tracking down relatives impossible.",
                                 
                                 "Crime: Murder.\nTime Served: 1 year, 4 months.\nDate of Death: September 15, 1953.\nAge at Death: 30.\n\nWithout provocation and brandishing a razor, Roberto Samaniego attacked fellow inmate Frank Lane in the mess hall line. As he frantically thrust the blade, an unidentified inmate tossed Lane a knife to defend himself. Lane fatally stabbed Samaniego. Several inmates claimed he was seeking revenge against Lane. Lane apparently interrupted Samaniego days earlier as he attempted to assault another inmate. Even after a lengthy investigation, no inmate revealed who provided the knife to Lane.",
                                 
                                 "Crime: Murder in the 1st degree.\nTime Served: 7 months.\nDate of Death: May 23, 1914.\nAge at Death: 28.\n\nUlysses Bearup was a bootlegger. He was detained by a deputy sheriff from Bannock County after being caught with liquor. Bearup took the deputy’s revolver out of his hand and killed him. Bearup fled, but was captured two days later in Nevada. He stood trial in Pocatello and received a life sentence for murder. Less than a year into his sentence he and three other men attempted an escape. During a guard change they leaned a makeshift ladder up against the wall and Bearup and two others sprung over the top. The trio ran toward Warm Springs Avenue, a guard on their heels. The guard shot Bearup first, above his left hip. The other two men were stopped with bullets in the forearm and the leg. On his deathbed, Bearup told the warden he suffered from  a painful kidney condition called “Bright’s disease” that prevented him from holding an honest job. He knew he would be shot and killed. Bearup was buried in the prison cemetery.",
                                 
                                 "Crime: Murder in the 1st degree.\nTime Served: 1 year, 6 months.\nDate of Death: August 10, 1906.\nAge at Death: 27.\n\nWilliam “Fred” Bond fell in love with Jennie Daley after living as a boarder in a house she shared with her much-older husband Charles. Fred and Jennie often walked around town acting as man and wife with her young child. Jennie first claimed she shot her husband, then bashed his head in with a hatchet, and finished him off with a bullet to the heart. After speaking with police again, she recanted her story, stating Bond alone killed her husband. After enjoying a final meal of ham, fried eggs, tomatoes, toast, potatoes, pies, and coffee, Bond was hanged on the gallows.",
                                 
                                 /*"William Wild was serving a sentence for Grand Larceny, horse stealing. He became the prison Barber in 1920, and quickly became enemies with a former barber named J.C. McDonald who was a life long criminal and convict. He was serving his sentence for breaking into a drug store and stealing cocaine. When the yard captain realized that Wild and McDonald didn’t get along, the captain took McDonald away to find different work. McDonald returned the next week to get his own haircut, when the two men began arguing and swearing at each other. McDonald stormed out of the barbershop and ran to the multipurpose building to pick up a piece of 2 x 4 that was being used to build new turkey coops. He returned to continue the argument with William Wild, and in a brash decision, beat William Wild across the forehead with the board. William Wild fell unconscious, and the yard captain arrived on the scene and apprehended McDonald and tossed him in solitary confinement. Wild was sent to the hospital, where he ultimately died."*/]
    let dod: [String] = ["dod1","dod2","dod3","dod4","dod5","dod6","dod7","dod8","dod9","dod10","dod11","dod12","dod13","dod14","dod15","dod16"]
    let defaultLocations: [String] = ["location2", "location5", "location6", "location8", "location9", "location8", "location9", "location11", "location2", "location5", "location6", "location8", "location9", "location8", "location9", "location11", "location2", "location5", "location6", "location8", "location9"]
    var animationFiles = [["StabbingFixed","TauntFixed","DefeatedFixed","PrayingFixed"],
                         ["StabbingFixed","TauntFixed","DefeatedFixed","PrayingFixed"],
                         ["StabbingFixed","TauntFixed","DefeatedFixed","PrayingFixed"],
                         ["StabbingFixed","TauntFixed","DefeatedFixed","PrayingFixed"],
                         ["StabbingFixed","TauntFixed","DefeatedFixed","PrayingFixed"],
                         ["StabbingFixed","TauntFixed","DefeatedFixed","PrayingFixed"],
                         ["StabbingFixed","TauntFixed","DefeatedFixed","PrayingFixed"],
                         ["StabbingFixed","TauntFixed","DefeatedFixed","PrayingFixed"],
                         ["StabbingFixed","TauntFixed","DefeatedFixed","PrayingFixed"],
                         ["StabbingFixed","TauntFixed","DefeatedFixed","PrayingFixed"],
                         ["StabbingFixed","TauntFixed","DefeatedFixed","PrayingFixed"],
                         ["StabbingFixed","TauntFixed","DefeatedFixed","PrayingFixed"],
                         ["StabbingFixed","TauntFixed","DefeatedFixed","PrayingFixed"],
                         ["StabbingFixed","TauntFixed","DefeatedFixed","PrayingFixed"],
                         ["StabbingFixed","TauntFixed","DefeatedFixed","PrayingFixed"],
                         ["StabbingFixed","TauntFixed","DefeatedFixed","PrayingFixed"],
                         ["StabbingFixed","TauntFixed","DefeatedFixed","PrayingFixed"],
                         ["StabbingFixed","TauntFixed","DefeatedFixed","PrayingFixed"],
                         ["StabbingFixed","TauntFixed","DefeatedFixed","PrayingFixed"],
                         ["StabbingFixed","TauntFixed","DefeatedFixed","PrayingFixed"],
                         ["StabbingFixed","TauntFixed","DefeatedFixed","PrayingFixed"]]
    var animationKeys = [["stabbing", "taunt", "defeated", "praying"],
                          ["stabbing", "taunt", "defeated", "praying"],
                          ["stabbing", "taunt", "defeated", "praying"],
                          ["stabbing", "taunt", "defeated", "praying"],
                          ["stabbing", "taunt", "defeated", "praying"],
                          ["stabbing", "taunt", "defeated", "praying"],
                          ["stabbing", "taunt", "defeated", "praying"],
                          ["stabbing", "taunt", "defeated", "praying"],
                          ["stabbing", "taunt", "defeated", "praying"],
                          ["stabbing", "taunt", "defeated", "praying"],
                          ["stabbing", "taunt", "defeated", "praying"],
                          ["stabbing", "taunt", "defeated", "praying"],
                          ["stabbing", "taunt", "defeated", "praying"],
                          ["stabbing", "taunt", "defeated", "praying"],
                          ["stabbing", "taunt", "defeated", "praying"],
                          ["stabbing", "taunt", "defeated", "praying"],
                          ["stabbing", "taunt", "defeated", "praying"],
                          ["stabbing", "taunt", "defeated", "praying"],
                          ["stabbing", "taunt", "defeated", "praying"],
                          ["stabbing", "taunt", "defeated", "praying"],
                          ["stabbing", "taunt", "defeated", "praying"]]
    let pinIcons: [String] = ["pinIcon1",
                              "pinIcon2",
                              "pinIcon3",
                              "pinIcon4",
                              "pinIcon5",
                              "pinIcon6",
                              "pinIcon7",
                              "pinIcon8",
                              "pinIcon9",
                              "pinIcon10",
                              "pinIcon11",
                              "pinIcon12",
                              "pinIcon13",
                              "pinIcon14",
                              "pinIcon15",
                              "pinIcon16"]
    let profilePicNames: [String] = ["profilePic1", "profilePic2", "profilePic3", "profilePic4", "profilePic5", "profilePic6", "profilePic7", "profilePic8", "profilePic9", "profilePic10", "profilePic11", "profilePic12", "profilePic13", "profilePic14", "profilePic15", "profilePic16"]
    
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
        refreshPins()
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
    
    func refreshPins() {
        for pin in customPins {
            mapView?.removeAnnotation(pin)
        }
        customPins = []
        for i in 0...ghostIndex {
            addGhostToMap(ghostModel: ghostObjects[i])
        }
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
        let ghostPinIcon: String = ghost.value(forKey: "pinIcon") as! String
        
        // using values to create models
        let ghostModel = GhostModel(fileName: ghostFileName, ghostName: ghostName, ghostYear: "1887", ghostBio: ghostBio, ghostLocation: ghostLocation, ghostPoints: ghostPoints, locked: true, animationKeys: [], animationFiles: [], ghostPinIcon: ghostPinIcon, profilePic: "", dod: "")
        //ghostModel.image = UIImage(named: ghostPinIcon)
        self.ghostObjects.append(ghostModel)
        if (ghostObjects.count == 1) {
            addGhostToMap(ghostModel: ghostObjects[0])
        }
        print(ghostObjects.count)
    }
    
    // Sets up defaults ghosts models and adds to ghostObjects array
    func setDefaultGhosts() {
        for i in 0...15 {
            // using hard coded default values to create models
            let ghostModel = GhostModel(fileName: defaultFileNames[i], ghostName: defaultNames[i], ghostYear: "1887", ghostBio: defaultBios[i], ghostLocation: defaultLocations[i], ghostPoints: 25, locked: false/***/, animationKeys: animationKeys[i], animationFiles: animationFiles[i], ghostPinIcon: pinIcons[i], profilePic: profilePicNames[i], dod: dod[i])
            self.ghostObjects.append(ghostModel)
            if (ghostObjects.count == 1) {
                addGhostToMap(ghostModel: ghostObjects[0])
            }
        }
        print("LOOK: \(ghostObjects)")

        
    }
    
    // Adds specified ghost to map
    func addGhostToMap(ghostModel: GhostModel) {
        var ghostPin: CustomPointAnnotation
        if ghostModel.locked {
            ghostPin = MapViewController.generateCustomPointAnnotationWithTitle(title: ghostModel.ghostName, pinIcon: "locked_\(ghostModel.pinIcon)")   // locked ghost  pin
        } else {
            ghostPin = MapViewController.generateCustomPointAnnotationWithTitle(title: ghostModel.ghostName, pinIcon: ghostModel.pinIcon)   // ghost  pin
        }
        self.customPins.append(ghostPin)
        self.addCustomPinAtCoordinate(coordinate: ghostModel.ghostLocation, customPin: ghostPin)
    }
    
    // Called when ghost is captured in AR Controller
    func ghostCaptured() {
        if ghostIndex < ghostObjects.count - 1 {
            ghostIndex += 1
            print("Ghost Captured! Now at index: \(ghostIndex)")
            //let annotation = customPins[ghostIndex - 1]
            //mapView?.removeAnnotation(annotation)
            //addGhostToMap(ghostModel: ghostObjects[ghostIndex - 1])
            //mapView?.addAnnotation(annotation)
            //addGhostToMap(ghostModel: ghostObjects[ghostIndex - 1])
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
            print("tracking user location")
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
    public static func generateCustomPointAnnotationWithTitle(title: String, pinIcon: String) -> CustomPointAnnotation {
        let customPointAnnotation = CustomPointAnnotation()
        customPointAnnotation.pinImage = pinIcon
        customPointAnnotation.title = title
        customPointAnnotation.subtitle = "Wandering the area..."
        return customPointAnnotation
    }
    
    // If ghost is unlocked, clicking on map annotation will navigate to inmate view controller
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //print(view.annotation?.title!)
        if let ghostPin: CustomPointAnnotation = view.annotation as? CustomPointAnnotation {
            if let index = self.customPins.firstIndex(of: ghostPin) {
                print("clicked: \(index)")
                clickedIndex = index
                if !self.ghostObjects[index].locked {    // TODO: flip bool for testing
                    let vc = InmateViewController()
                    vc.delegate = self as GhostModelDelegate
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    UIDevice.vibrate()
                    self.trackLocation = false
                    self.locationManager!.stopUpdatingLocation()
                    let arVC = ARSceneViewController()
                    arVC.delegate = self
                    navigationController?.pushViewController(arVC, animated: true)
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
