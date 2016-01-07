//
//  Place.swift
//  WhereAmI
//
//  Created by Tim Pryor on 2016-01-07.
//  Copyright © 2016 Tim Pryor. All rights reserved.
//

import UIKit
import MapKit

class Place: NSObject, MKAnnotation {

    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}

