//
//  Ghost.swift
//  Ghost Hunt
//
//  Created by Zachary Broeg on 11/21/18.
//  Copyright © 2018 Andrew Palmer. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class GhostModel : NSObject {
    var fileName:String = ""
    var ghostName:String = ""
    var ghostDirName:String = ""
    var ghostYear:String = ""
    var ghostBio: String = ""
    var ghostLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var ghostPoints: Int = 0
    var locked:Bool = true
    var image:UIImage?
    var animationKeys:[String] = []
    var animationFiles:[String] = []
    var pinIcon:String = ""
    var profilePic:String = ""
    var dod:String = ""
    
    enum Model: String {
        case Model1 = "model1"  //Ernest Walrath
        case Model2 = "model2"
        case Model3 = "model3"
        case Model4 = "model4"
        case Model5 = "model5"
        case Model6 = "model6"
        case Model7 = "model7"
        case Model8 = "model8"
        case Model9 = "model9"
        case Model10 = "model10"
        case Model11 = "model11"
        case Model12 = "model12"
        case Model13 = "model13"
        case Model14 = "model14"
        case Model15 = "model15"
        case Model16 = "model16"
    }
    
    enum DateOfDeath: String {
        case Dod1 = "dod1"
        case Dod2 = "dod2"
        case Dod3 = "dod3"
        case Dod4 = "dod4"
        case Dod5 = "dod5"
        case Dod6 = "dod6"
        case Dod7 = "dod7"
        case Dod8 = "dod8"
        case Dod9 = "dod9"
        case Dod10 = "dod10"
        case Dod11 = "dod11"
        case Dod12 = "dod12"
        case Dod13 = "dod13"
        case Dod14 = "dod14"
        case Dod15 = "dod15"
        case Dod16 = "dod16"
        case Dod17 = "dod17"
        case Dod18 = "dod18"
        case Dod19 = "dod19"
    }
    
    enum Location: String {
        case Location1 = "location1"
        case Location2 = "location2"
        case Location3 = "location3"
        case Location4 = "location4"
        case Location5 = "location5"
        case Location6 = "location6"
        case Location7 = "location7"
        case Location8 = "location8"
        case Location9 = "location9"
        case Location10 = "location10"
        case Location11 = "location11"
        case Location12 = "location12"
        case Location13 = "location13"
        case Location14 = "location14"
        case Location15 = "location15"
        case Location16 = "location16"
    }
    
    enum PinIcons: String {
        case Icon1 = "pinIcon1"
        case Icon2 = "pinIcon2"
        case Icon3 = "pinIcon3"
        case Icon4 = "pinIcon4"
        case Icon5 = "pinIcon5"
        case Icon6 = "pinIcon6"
        case Icon7 = "pinIcon7"
        case Icon8 = "pinIcon8"
        case Icon9 = "pinIcon9"
        case Icon10 = "pinIcon10"
        case Icon11 = "pinIcon11"
        case Icon12 = "pinIcon12"
        case Icon13 = "pinIcon13"
        case Icon14 = "pinIcon14"
        case Icon15 = "pinIcon15"
        case Icon16 = "pinIcon16"
        case Icon17 = "pinIcon17"
        case Icon18 = "pinIcon18"
        case Icon19 = "pinIcon19"
    }
    
    enum ProfilePics: String {
        case ProfilePic1 = "profilePic1"
        case ProfilePic2 = "profilePic2"
        case ProfilePic3 = "profilePic3"
        case ProfilePic4 = "profilePic4"
        case ProfilePic5 = "profilePic5"
        case ProfilePic6 = "profilePic6"
        case ProfilePic7 = "profilePic7"
        case ProfilePic8 = "profilePic8"
        case ProfilePic9 = "profilePic9"
        case ProfilePic10 = "profilePic10"
        case ProfilePic11 = "profilePic11"
        case ProfilePic12 = "profilePic12"
        case ProfilePic13 = "profilePic13"
        case ProfilePic14 = "profilePic14"
        case ProfilePic15 = "profilePic15"
        case ProfilePic16 = "profilePic16"
        case ProfilePic17 = "profilePic17"
        case ProfilePic18 = "profilePic18"
        case ProfilePic19 = "profilePic19"
    }
    
    init(fileName: String, ghostName: String, ghostYear: String, ghostBio:String, ghostLocation:String, ghostPoints:Int, locked: Bool, animationKeys: [String], animationFiles: [String], ghostPinIcon: String, profilePic: String, dod: String) {
        super.init()
        // Initialize stored properties.
        self.fileName = self.getModel(modelString: fileName)
        self.ghostName = ghostName
        self.ghostDirName = self.getDirName(modelString: fileName)
        self.ghostYear = ghostYear
        self.ghostBio = ghostBio
        self.ghostLocation = self.getLocation(locationString: ghostLocation)
        self.ghostPoints = ghostPoints
        self.locked = locked
        self.animationKeys = animationKeys
        self.animationFiles = animationFiles
        self.pinIcon = self.getPinIcon(iconString: ghostPinIcon)
        self.profilePic = self.getProfilePic(profilePicString: profilePic)
        self.image = UIImage(named: self.getProfilePic(profilePicString: profilePic))
        self.dod = self.getDod(dodString: dod)
    }
    
    func getProfilePic(profilePicString:String) -> String {
        if let profilePic = ProfilePics.init(rawValue: profilePicString) {
            switch profilePic {
            case .ProfilePic1:
                return "Ernest_Walrath_bio.jpg"
            case .ProfilePic2:
                return "Raymond_Snowden_bio.jpg"
            case .ProfilePic3:
                return "Douglas_Van_Vlack_bio.jpg"
            case .ProfilePic4:
                return "Troy_Powell_bio.jpg"
            case .ProfilePic5:
                return "Ed_Rice_bio.jpg"
            case .ProfilePic6:
                return "Frank_Frisbee_bio.jpg"
            case .ProfilePic7:
                return "Noah_Arnold_bio.JPG"
            case .ProfilePic8:
                return "Frank_Jones_bio.jpg"
            case .ProfilePic9:
                return "Fred_Seward_bio.jpg"
            case .ProfilePic10:
                return "George_Hamilton_bio.jpg"
            case .ProfilePic11:
                return "Ignacio_Morsagaray_bio.jpg"
            case .ProfilePic12:
                return "James_Conners_bio.jpg"
            case .ProfilePic13:
                return "John_Jurko_bio.JPG"
            case .ProfilePic14:
                return "Joseph_Hayes_bio.jpg"
            case .ProfilePic15:
                return "Mike_Penford_bio.jpg"
            case .ProfilePic16:
                return "Roberto_Samaniego_bio.jpg"
            case .ProfilePic17:
                return "Ulyssus_Bearup_bio.jpg"
            case .ProfilePic18:
                return "Fred_Bond_bio.jpg"
            case .ProfilePic19:
                return "William_Wild_bio.jpg"
            }
        }
        return "Ernest_Walrath_bio.jpg"
    }

    func getDod(dodString:String) ->String {
        if let dod = DateOfDeath.init(rawValue: dodString) {
            switch dod {
            case .Dod1:
                return "April 13th, 1951"
            case .Dod2:
                return "October 17th, 1957"
            case .Dod3:
                return "December 10th, 1937"
            case .Dod4:
                return "November 30th, 1901"
            case .Dod5:
                return "December 28th, 1918"
            case .Dod6:
                return "December 19th, 1924"
            case .Dod7:
                return "December 19th, 1918"
            case .Dod8:
                return "May 7th, 1909"
            case .Dod9:
                return "October 1897"
            case .Dod10:
                return "July 11, 1923"
            case .Dod11:
                return "December 16th, 1904"
            case .Dod12:
                return "July 9th, 1926"
            case .Dod13:
                return "December 24th, 1918"
            case .Dod14:
                return "January 5th, 1919"
            case .Dod15:
                return "September 15th, 1953"
            case .Dod16:
                return "May 23rd, 1914"
            case .Dod17:
                return "August 10th, 1906"
            case .Dod18:
                return "May 4th, 1920"
            case .Dod19:
                return "May 4th, 1920"
            }
        }
         return "April 13th, 1951"
    }
    
    func getDirName(modelString: String) -> String {
        if let name = Model.init(rawValue: modelString) {
            switch name {
            case .Model1:
                return "Ghost1" //Ernest Walrath
            case .Model2:
                return "Ghost2"
            case .Model3:
                return "Ghost3"
            case .Model4:
                return "Ghost4"
            case .Model5:
                return "Ghost5"
            case .Model6:
                return "Ghost6"
            case .Model7:
                return "Ghost7"
            case .Model8:
                return "Ghost8"
            case .Model9:
                return "Ghost9"
            case .Model10:
                return "Ghost10"
            case .Model11:
                return "Ghost11"
            case .Model12:
                return "Ghost12"
            case .Model13:
                return "Ghost13"
            case .Model14:
                return "Ghost14"
            case .Model15:
                return "Ghost15"
            case .Model16:
                return "Ghost16"
            }
        }
        return "Ghost1"
    }
    
    func getPinIcon(iconString: String) -> String {
        if let pinIconString = PinIcons.init(rawValue: iconString) {
            switch pinIconString {
            case .Icon1:
                return "Ernest_Walrath.png"
            case .Icon2:
                return "Raymond_Snowden.png"
            case .Icon3:
                return "Douglas_Van_Vlack.png"
            case .Icon4:
                return "Troy_Powell.png"
            case .Icon5:
                return "Ed_Rice.png"
            case .Icon6:
                return "Frank_Frisbee.png"
            case .Icon7:
                return "Noah_Arnold.png"
            case .Icon8:
                return "Frank_Jones"
            case .Icon9:
                return "Fred_Seward"
            case .Icon10:
                return "George_Hamilton"
            case .Icon11:
                return "Ignacio_Morsagaray"
            case .Icon12:
                return "James_Conners"
            case .Icon13:
                return "John_Jurko"
            case .Icon14:
                return "Joseph_Hayes"
            case .Icon15:
                return "Mike_Penford"
            case .Icon16:
                return "Roberto_Samaniego"
            case .Icon17:
                return "Ulyssus_Bearup"
            case .Icon18:
                return "Fred_Bond"
            case .Icon19:
                return "William_Wild"
            }
        }
        return "Ernest_Walrath.png"
    }
    
    func getModel(modelString: String) -> String {
        if let model = Model.init(rawValue: modelString) {
            switch model {
                
            case .Model1:
                return "ghost1.scn" //Ernest Walrath
            case .Model2:
                return "ghost2.scn"
            case .Model3:
                return "ghost3.scn"
            case .Model4:
                return "ghost4.scn"
            case .Model5:
                return "ghost5.scn"
            case .Model6:
                return "ghost6.scn"
            case .Model7:
                return "ghost7.scn"
            case .Model8:
                return "ghost8.scn"
            case .Model9:
                return "ghost9.scn"
            case .Model10:
                return "ghost10.scn"
            case .Model11:
                return "ghost11.scn"
            case .Model12:
                return "ghost12.scn"
            case .Model13:
                return "ghost13.scn"
            case .Model14:
                return "ghost14.scn"
            case .Model15:
                return "ghost15.scn"
            case .Model16:
                return "ghost16.scn"
            }
        }
        return "ghost1.scn"
    }
    
    func getLocation(locationString: String) -> CLLocationCoordinate2D {
        if let location = Location.init(rawValue: locationString) {
            switch location {
                case .Location1:  // top left
                    return CLLocationCoordinate2D(latitude: 43.602686, longitude: -116.163052)
                case .Location2:  // top mid
                    return CLLocationCoordinate2D(latitude: 43.602686, longitude: -116.161985)
                case .Location3:  // top right
                    return CLLocationCoordinate2D(latitude: 43.602686, longitude: -116.161370)
                case .Location4:  // medtop left
                    return CLLocationCoordinate2D(latitude: 43.602564, longitude: -116.163052)
                case .Location5: // medtop mid
                    return CLLocationCoordinate2D(latitude: 43.602564, longitude: -116.161985)
                case .Location6: //medtop right
                    return CLLocationCoordinate2D(latitude: 43.602564, longitude: -116.161370)
                case .Location7: // center left
                    return CLLocationCoordinate2D(latitude: 43.602397, longitude: -116.163052)
                case .Location8:    // center mid
                    return CLLocationCoordinate2D(latitude: 43.602397, longitude: -116.161985)
                case .Location9:    // center right
                    return CLLocationCoordinate2D(latitude: 43.602397, longitude: -116.161370)
                case .Location10:  //medbottom left
                    return CLLocationCoordinate2D(latitude: 43.602226, longitude: -116.163052)
                case .Location11:  //medbottom mid
                    return CLLocationCoordinate2D(latitude: 43.602226, longitude: -116.161985)
                case .Location12:  //medbottom right
                    return CLLocationCoordinate2D(latitude: 43.602226, longitude: -116.161370)
                case .Location13:  //bottom random?
                    return CLLocationCoordinate2D(latitude: 43.602111, longitude: -116.162449)
                case .Location14:  //bottom left
                    return CLLocationCoordinate2D(latitude: 43.601830, longitude: -116.163052)
                case .Location15:  // bottom mid
                    return CLLocationCoordinate2D(latitude: 43.601830, longitude: -116.161985)
                case .Location16:  // bottom right
                    return CLLocationCoordinate2D(latitude: 43.601830, longitude: -116.161370)
            }
        }
        return CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
    
}
