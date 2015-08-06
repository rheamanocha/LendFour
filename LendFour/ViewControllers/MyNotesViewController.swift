//
//  MyNotesViewController.swift
//  LendFour
//
//  Created by Rhea on 8/5/15.
//  Copyright (c) 2015 Rhea. All rights reserved.
//

import UIKit

class MyNotesViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    enum State {
        case DefaultMode
        case SearchMode
    }
    
    var state: State = .DefaultMode {
        didSet {
            // update notes and search bar whenever State changes
            switch (state) {
            case .DefaultMode:
                /* REALM STUFF: let realm = Realm()
                notes = realm.objects(Note).sorted("modificationDate", ascending: false) */
                self.navigationController!.setNavigationBarHidden(false, animated: true) //2
                searchBar.resignFirstResponder() // 3
                searchBar.text = ""
                searchBar.showsCancelButton = false
            case .SearchMode:
                let searchText = searchBar?.text ?? ""
                searchBar.setShowsCancelButton(true, animated: true) //4
                // REALM STUFF: notes = searchNotes(searchText) //5
                self.navigationController!.setNavigationBarHidden(true, animated: true) //6
            }
        }
    }
    
    var selectedNote: Note?
    
    func searchNotes(searchString: String) -> String /* REALM STUFF: Results<Note> */ {
        /* REALM STUFF
        let realm = Realm() */
        let searchPredicate = NSPredicate(format: "title CONTAINS[c] %@ OR content CONTAINS[c] %@", searchString, searchString)
        /* REALM STUFF
        return realm.objects(Note).filter(searchPredicate)
        */
        return "will do search functionality later"
    }
    
    /* REALM STUFF
    var notes: Results<Note>! {
        didSet {
            // Whenever notes update, update table view
            tableView?.reloadData()
        }
    }
    */

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        /* REALM STUFF
        let realm = Realm()
        notes = realm.objects(Note).sorted("dateBorrowed", ascending: false)
        */
        state = .DefaultMode
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func unwindToSegue(segue: UIStoryboardSegue) {
        if let identifier = segue.identifier {
            switch identifier {
                case "Save":
                let source = segue.sourceViewController as! MyNewNoteViewController
                
                println("Saved") //will remove
                /* REALM STUFF
                realm.write() {
                    realm.add(source.currentNote!)
                }
                */
                
                case "Delete":
                    println("Deleted")
                    /* REALM STUFF
                    realm.write() {
                        realm.delete(self.selectedNote!)
                    }
                    let source = segue.sourceViewController as! MyNoteDisplayViewController
                    source.note = nil;
                    */
            
            default:
                println("No one loves \(identifier)")
            }
            /* REALM STUFF
            notes = realm.objects(Note).sorted("dateBorrowed", ascending: false)
            */
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowExistingNote") {
            let noteViewController = segue.destinationViewController as! MyNoteDisplayViewController
            noteViewController.note = selectedNote
        }
    }
    

}

extension MyNotesViewController: UITableViewDataSource { //extending to implement additional protocal functionality required to prodive data source for table view
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NoteCell", forIndexPath: indexPath) as! NoteTableViewCell //returning a UITableViewCell with identifier "NoteCell"
        // Can create custom table view cells for different styles
        
        let row = indexPath.row
        cell.titleLabel.text = "Hello" // will be replaced
        cell.dateBorrowedLabel.text = "Today" // will be replaced
        /* REALM STUFF can do once Parse replaces Realm
        let note = notes[row] as Note
        cell.note = note 
        */
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5 //will be replaced
        /* REALM STUFF: do after replacing Realm with Parse
        return Int(notes?.count ?? 0) // if notes isn't empty, numberOfRowsInSection will return notes.count, otherwise returns 0
        */
    }
    
}

extension MyNotesViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //selectedNote = notes[indexPath.row] //1
        self.performSegueWithIdentifier("ShowExistingNote", sender: self) //2
    }
    
    //check if a row can be edited
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // activated when left swipe table view, presented with Delete option
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            /* REALM STUFF
            let note = notes[indexPath.row] as Object
            
            
            let realm = Realm()
            
            realm.write() {
                realm.delete(note)

            }
            
            notes = realm.objects(Note).sorted("dateBorrowed", ascending: false)
            */
        }
    }
}

extension MyNotesViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        state = .SearchMode
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        state = .DefaultMode
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        /* REALM STUFF
        notes = searchNotes(searchText)
        */
    }
}
