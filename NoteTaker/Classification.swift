//
//  Classification.swift
//  NoteTaker
//
//  Created by 597588 on 7/17/18.
//  Copyright © 2018 USCGSmartApplicator. All rights reserved.
//

import Foundation
import UIKit

public struct Classification {
    
    public enum Category: String {
        case business = "Business"
        case entertainment = "Entertainment"
        case politics = "Politics"
        case sports = "Sports"
        case technology = "Technology"
        
        var color: UIColor? {
            switch self{
            case .business:
                return UIColor.brown
            case .entertainment:
                return UIColor.cyan
            case .politics:
                return UIColor.red
            case .sports:
                return UIColor.green
            case .technology:
                return UIColor.lightGray
            }
        }
    }
    
    public struct Result {
        public let category: Category
        public let probability: Double
    }
    
    public let prediction: Result
    public let allResults: [Result]
    
}

extension Classification {
    
    init?(output: DocumentClassificationOutput) {
        guard let category = Category(rawValue: output.classLabel),
            let probability = output.classProbability[output.classLabel]
            else { return nil }
        let prediction = Result(category: category, probability: probability)
        let allResults = output.classProbability.flatMap(Classification.result)
        self.init(prediction: prediction, allResults: allResults)
    }
    
    static func result(from classProbability: (key: String, value: Double)) -> Result? {
        guard let category = Category(rawValue: classProbability.key) else { return nil }
        return Result(category: category, probability: classProbability.value)
    }
}
