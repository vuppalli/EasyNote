//
//  ArticleTextPopUpViewController.swift
//  NoteTaker
//
//  Created by 597588 on 7/13/18.
//  Copyright © 2018 USCGSmartApplicator. All rights reserved.
//

import UIKit

class ArticleTextPopUpViewController: UIViewController {

    @IBOutlet weak var articleScriptField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showAnimate()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        articleScriptField.text = articleText
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
            if (finished){
                self.view.removeFromSuperview()
            }
        });
    }
    
    @IBAction func takeOutArticleScript(_ sender: Any) {
        self.removeAnimate()
    }
}
