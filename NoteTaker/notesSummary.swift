//
//  notesSummary.swift
//  NoteTaker
//
//  Created by 597588 on 7/20/18.
//  Copyright © 2018 USCGSmartApplicator. All rights reserved.
//

import UIKit
import FirebaseDatabase

class notesSummary: UIViewController {

    @IBOutlet weak var summaryField: UITextView!
    var ref: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        summaryField.text = noteSumm
        self.navigationController?.title = noteName
    }

    @IBAction func savePressed(_ sender: Any) {
        let first = ref?.child("Note Info").child("Note: " + noteName)
        first?.child("Summary").setValue(summaryField.text)
    }
}
