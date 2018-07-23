//
//  Sentiment.swift
//  NoteTaker
//
//  Created by 597588 on 7/17/18.
//  Copyright © 2018 USCGSmartApplicator. All rights reserved.
//

import UIKit

enum Sentiment {
    case neutral
    case positive
    case negative
    
    var emoji: String {
        switch self {
        case .neutral:
            return "😐"
        case .positive:
            return "😃"
        case .negative:
            return "😔"
        }
    }
    
    var result: String {
        switch self {
        case .neutral:
            return "Neutral"
        case .positive:
            return "Positive"
        case .negative:
            return "Negative"
        }
    }
    
    var color: UIColor? {
        switch self {
        case .neutral:
            return UIColor.blue
        case .positive:
            return UIColor.green
        case .negative:
            return UIColor.red
        }
    }
}
