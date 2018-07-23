//
//  PopUpViewController.swift
//  NoteTaker
//
//  Created by 597588 on 7/12/18.
//  Copyright © 2018 USCGSmartApplicator. All rights reserved.
//

import UIKit
import SwiftSoup
import Reductio

class PopUpViewController: UIViewController {
    
    typealias Item = (text: String, html: String)
    
    // current document
    var document: Document = Document.init("")
    // item founds
    var items: [Item] = []
    
    private let classificationService = ClassificationService()
    let classifier = DocumentClassifer()
    let summarizer = Summarizer()
    
    lazy var percentFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        return formatter
    }()
    
    @IBOutlet weak var urlField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showAnimate()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Functions for document classification
    func classify(_ text: String) {
        guard let classification = classifier.classify(text) else { return }
        let prediction = classification.prediction
        updateInterface(for: prediction)
    }
    
    func updateInterface(for prediction: Classification.Result) {
        guard let percent = percentFormatter.string(from: NSNumber(value: prediction.probability)) else { return }
        classificationLabel = prediction.category.rawValue + " " + "(\(percent))"
        classificationColor = prediction.category.color!
    }

    // function for when done button is pressed
    @IBAction func closePopUp(_ sender: Any) {
        //self.view.removeFromSuperview()
        removeAnimate()
    }
    // function for when cancel button is pressed
    @IBAction func cancelPopUp(_ sender: Any) {
        removeAnimate()
    }
    
    func showAnimate(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate(){
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /* Create Summary Here */
        if (segue.identifier == "articleSummary"){
            urlOfArticle = urlField.text!
            //Downloading and Parsing HTML of website article to text
            downloadHTML()
            //Finding the sentiment of the article
            let sentimentFromModel = classificationService.predictSentiment(from: articleText)
            sentColor = UIColor.blue
            sentColor = sentimentFromModel.color!
            sentEmoji = sentimentFromModel.emoji
            sentResult = sentimentFromModel.result
            //Finding the document's classification
            classify(articleText)
            print("classified")
            //Summarizing the text
            
            summarizedContent = summarizer.summarize(text: articleText)
            print(summarizedContent)
        }
    }
    
    //Download HTML
    func downloadHTML() {
        // url string to URL
        guard let url = URL(string: urlOfArticle) else {
            // an error occurred
            //UIAlertController.showAlert("Error: \(urlTextField.text ?? "") doesn't seem to be a valid URL", self)
            let alert = UIAlertController(title: "ERROR", message: urlOfArticle + "doesn't seem to be a valid URL", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        do {
            // content of url
            let html = try String.init(contentsOf: url)
            // parse it into a Document
            document = try SwiftSoup.parse(html)
            // parse css query
            parse()
        } catch let error {
            // an error occurred
            //UIAlertController.showAlert("Error: \(error)", self)
            let alert = UIAlertController(title: "ERROR", message: "\(error)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        
    }
    
    //Parse CSS selector
    func parse() {
        do {
            //empty old items
            items = []
            // firn css selector
            let elements: Elements = try document.select("div")
            //transform it into a local object (Item)
            for element in elements {
                let text = try element.text()
                let html = try element.outerHtml()
                items.append(Item(text: text, html: html))
            }
            articleText = items[0].text
        } catch let error {
            //UIAlertController.showAlert("Error: \(error)", self)
            let alert = UIAlertController(title: "ERROR", message: "\(error)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}
