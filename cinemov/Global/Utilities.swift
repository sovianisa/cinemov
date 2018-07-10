//
//  Utilities.swift
//  trivia
//
//  Created by Annisa Sofia Noviantina on 1/8/18.
//  Copyright © 2018 Annisa Sofia Noviantina. All rights reserved.
//

import Foundation
import SwiftyJSON
import SwiftHEXColors

class Utilities {
    
    class func navigationColor() -> UIColor {
        return UIColor(hexString: "#48184C")!
    }
    
    class func transformFromJSON(_ value: Any?) -> String? {
        return value.flatMap(String.init(describing:))
    }
    
}


