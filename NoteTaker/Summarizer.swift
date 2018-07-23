//
//  Summarizer.swift
//  NoteTaker
//
//  Created by 597588 on 7/19/18.
//  Copyright © 2018 USCGSmartApplicator. All rights reserved.
//

import Foundation
import UIKit

public class Summarizer{
    
    //NS Linguistic Tagger - Tag Schemes and Language
    private let options: NSLinguisticTagger.Options = [.omitWhitespace, .omitPunctuation, .omitOther]
    private lazy var tagger: NSLinguisticTagger = .init(
        tagSchemes: NSLinguisticTagger.availableTagSchemes(forLanguage: "en"),
        options: Int(self.options.rawValue)
    )
    
    //Tokenizes text, returns frequency of words as dictionary
    func features(from text: String) -> [String: Double] {
        var wordCounts = [String: Double]()
        
        tagger.string = text
        let range = NSRange(location: 0, length: text.utf16.count)
        
        // Tokenize and count the sentence
        tagger.enumerateTags(in: range, scheme: .nameType, options: options) { _, tokenRange, _, _ in
            let token = (text as NSString).substring(with: tokenRange).lowercased()
            // Skip small words
            guard token.count >= 3 else {
                return
            }
            
            if let value = wordCounts[token] {
                wordCounts[token] = value + 1
            } else {
                wordCounts[token] = 1
            }
        }
        return wordCounts
    }
    
    func summarize(text: String) -> String{
        let wordCounts = features(from: text)
        let sentences = text.split(separator: ".")
        var sentenceValue = [String: Double]()
        //sentenceValue.keys = sentences
        for sentence in sentences{
            for wordValue in wordCounts{
                if sentence.contains(wordValue.0){
                    if sentenceValue.keys.contains(String(sentence)){
                        let v = String(sentence)
                        sentenceValue[v]! += wordValue.1
                    }else{
                        let v = String(sentence)
                        sentenceValue[v] = wordValue.1
                    }
                }
            }
        }
        //Value to compare scores to
        var sumValue = 0.0
        for sentence in sentenceValue.keys{
            let v = String(sentence)
            sumValue += sentenceValue[v]!
        }
        let average = Double(sumValue / Double(sentenceValue.count))
        var summary = ""
        for sentence in sentences{
            if sentenceValue.keys.contains(String(sentence)) && sentenceValue[String(sentence)]! > 1.5 * average{
                summary += " " + sentence
            }
        }
        return summary
    }
}
