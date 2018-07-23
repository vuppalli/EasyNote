//
//  DocumentClassifier.swift
//  NoteTaker
//
//  Created by 597588 on 7/17/18.
//  Copyright © 2018 USCGSmartApplicator. All rights reserved.
//

import Foundation

public final class DocumentClassifer{
    
    public init() {}
    
    private let model = DocumentClassification()
    private let options: NSLinguisticTagger.Options = [.omitWhitespace, .omitPunctuation, .omitOther]
    private lazy var tagger: NSLinguisticTagger = {
        let tagSchemes = NSLinguisticTagger.availableTagSchemes(forLanguage: "en")
        return NSLinguisticTagger(tagSchemes: tagSchemes, options: Int(self.options.rawValue))
    }()
    
    public func classify(_ text: String) -> Classification? {
        let features = extractFeatures(from: text)
        guard
            features.count > 2,
            let output = try? model.prediction(input: features) else { return nil }
        return Classification(output: output)
    }
    
    func extractFeatures(from text: String) -> [String: Double] {
        var wordCounts = [String: Double]()
        tagger.string = text
        let range = NSRange(location: 0, length: text.count)
        tagger.enumerateTags(in: range, scheme: .tokenType, options: options) { _, tokenRange, _, _ in
            let token = (text as NSString).substring(with: tokenRange).lowercased()
            guard token.count >= 3 else { return }
            guard let value = wordCounts[token] else {
                wordCounts[token] = 1.0
                return
            }
            wordCounts[token] = value + 1.0
        }
        return wordCounts
    }
}
