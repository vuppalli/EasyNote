//
//  TableCell.swift
//  NoteTaker
//
//  Created by 597588 on 7/9/18.
//  Copyright © 2018 USCGSmartApplicator. All rights reserved.
//

import UIKit
import FirebaseDatabase

class TableCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var summaryButton: UIButton!
    
    var ref: DatabaseReference?
    var handleNoteName: DatabaseHandle?
    var handleNoteBody: DatabaseHandle?
    
    let summarizer = Summarizer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ref = Database.database().reference()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func editPressed(_ sender: Any) {
        noteNum = editButton.tag
        noteName = notesArray[noteNum].name
        handleNoteBody = ref?.child("Note Info").child("Note: " + noteName).child("Body").observe(.value, with: {(snapshot) in
            noteBody = snapshot.value as? String ?? ""
        })
        self.ref?.removeAllObservers()
    }
    
    @IBAction func summaryPressed(_ sender: Any) {
        noteNum = editButton.tag
        noteName = notesArray[noteNum].name
        handleNoteBody = ref?.child("Note Info").child("Note: " + noteName).child("Body").observe(.value, with: {(snapshot) in
            noteBody = snapshot.value as? String ?? ""
        })
        self.ref?.removeAllObservers()
    }
}
