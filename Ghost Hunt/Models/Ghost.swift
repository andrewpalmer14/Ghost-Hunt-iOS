//
//  Ghost.swift
//  Ghost Hunt
//
//  Created by Andrew Palmer on 1/7/19.
//  Copyright © 2019 Andrew Palmer. All rights reserved.
//

import Foundation

class Ghost : NSObject, Decodable {
    var name: String
    var bio: String
    var model: String
    var location: String
    var points: String
    var profileImage: String
    var pinImage: String
    
    init(name: String, bio: String, model: String, location: String, points: String, profileImage: String, pinImage: String) {
        self.name = name
        self.bio = bio
        self.model = model
        self.location = location
        self.points = points
        self.profileImage = profileImage
        self.pinImage = pinImage
    }
}
