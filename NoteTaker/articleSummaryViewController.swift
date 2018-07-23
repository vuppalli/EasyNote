//
//  articleSummaryViewController.swift
//  NoteTaker
//
//  Created by 597588 on 7/13/18.
//  Copyright © 2018 USCGSmartApplicator. All rights reserved.
//

import UIKit

class articleSummaryViewController: UIViewController {
    
    @IBOutlet weak var articleSummaryField: UITextView!
    @IBOutlet weak var sentimentLabel: UILabel!
    @IBOutlet weak var topicLabel: UILabel!
    
    let pasteboard = UIPasteboard.general
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isToolbarHidden = true
        sentimentLabel.backgroundColor = sentColor
        sentimentLabel.text = sentResult + " " + sentEmoji
        topicLabel.text = classificationLabel
        topicLabel.backgroundColor = classificationColor
        if (classificationColor == UIColor.brown){
            topicLabel.textColor = UIColor.white
        }
        articleSummaryField.text = summarizedContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func showArticleScript(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpArticleText") as! ArticleTextPopUpViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    @IBAction func copyToClipboard(_ sender: Any) {
        pasteboard.string = articleSummaryField.text
    }
    
}
