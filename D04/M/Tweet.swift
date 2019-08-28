//
//  Tweet.swift
//  D04
//
//  Created by Yolankyi SERHII on 6/28/19.
//  Copyright © 2019 Yolankyi SERHII. All rights reserved.
//

import Foundation

struct Tweet: CustomStringConvertible {
    let name : String
    let text : String
    let date : String
    var description: String {
        return "\(name), \(text)"
    }
}
