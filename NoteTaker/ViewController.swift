//
//  ViewController.swift
//  NoteTaker
//
//  Created by 597588 on 7/9/18.
//  Copyright © 2018 USCGSmartApplicator. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var ref: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        ref = Database.database().reference()
        
        ref?.child("Note Info").observe(.value, with: { (snapshot) in
            let enumerator = snapshot.children
            notesArray.removeAll()
            while let cases = enumerator.nextObject() as? DataSnapshot{
                let theCaseInfo = cases.value as? NSDictionary
                let actualName = theCaseInfo?["Name"] as? String ?? ""
                notesArray.append(Note(name: actualName))
            }
            currentNotesArray = notesArray
            self.table.reloadData()
        })
    }
    
    @IBAction func editPressed(_ sender: Any) {
        table.isEditing = !table.isEditing
        if (table.isEditing){
            editButton.title = "Done"
             editButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: nil)
        }else{
            //editButton.title = "Delete Notes"
            editButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.trash, target: self, action: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Set up table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentNotesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? TableCell else{
            return UITableViewCell()
        }
        cell.nameLabel.text = currentNotesArray[indexPath.row].name
        
        cell.editButton.tag = indexPath.row
        cell.summaryButton.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let noteDeleteName = currentNotesArray[indexPath.row].name
            ref?.child("Note Info").observe(.value, with: { (snapshot) in
                let enumerator = snapshot.children
                while let cases = enumerator.nextObject() as? DataSnapshot{
                    let theCaseInfo = cases.value as? NSDictionary
                    let actualName = theCaseInfo?["Name"] as? String ?? ""
                    if (actualName == noteDeleteName){
                        self.ref?.child("Note Info").child("Note: " + actualName).removeValue()
                    }
                }
                currentNotesArray = notesArray
                self.table.reloadData()
            })
            table.reloadData()
        }
    }
    
    //Set up search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else{
            currentNotesArray = notesArray
            table.reloadData()
            return
        }
        currentNotesArray = notesArray.filter({ (Note) -> Bool in
            return Note.name.contains(searchText)
        })
        table.reloadData()
    }
}

class Note{
    let name: String
    init(name: String){
        self.name = name
    }
}
