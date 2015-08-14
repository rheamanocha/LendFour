//
//  MyNotesViewController.swift
//  LendFour
//
//  Created by Rhea on 8/5/15.
//  Copyright (c) 2015 Rhea. All rights reserved.
//

import UIKit
import Parse
import ConvenienceKit

class MyNotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    // @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var posts: [Post] = []
    
    // MARK: Search
    
   /*  enum State {
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
                self.navigationController!.setNavigationBarHidden(false, animated: true)
                searchBar.resignFirstResponder()
                searchBar.text = ""
                searchBar.showsCancelButton = false
            case .SearchMode:
                let searchText = searchBar?.text ?? ""
                searchBar.setShowsCancelButton(true, animated: true)
                // REALM STUFF: notes = searchNotes(searchText)
                self.navigationController!.setNavigationBarHidden(true, animated: true)
            }
        }
    }
    
    // var selectedNote: Note?
    
    func searchNotes(searchString: String) -> String /* REALM STUFF: Results<Note> */ {
        /* REALM STUFF
        let realm = Realm() */
        //let searchPredicate = NSPredicate(format: "title CONTAINS[c] %@ OR content CONTAINS[c] %@ ", searchString, searchString)
        let searchPredicate = NSPredicate(format: "title CONTAINS[c] %@ ", searchString, searchString)
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
    */
    
    // MARK: Views

     override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        ParseHelper.timelineRequestforCurrentUser {
            (result: [AnyObject]?, error: NSError?) -> Void in
            self.posts = result as? [Post] ?? []
            
            self.tableView.reloadData()
        }
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
                
                println("Saved")
                
                case "Delete":
                    println("Deleted")
            
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
            // noteViewController.post = selectedNote
        }
    }
    

}

// MARK: - Extensions


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


/*
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
} */


extension MyNotesViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // table view needs to have as many rows as we have posts stored in the posts property
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Casted NoteTableViewCell
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! NoteTableViewCell
        
        let post = posts[indexPath.row]
        // trigger image download
        post.downloadImage()
        // assign the post that shall be displayed to the post property
        cell.post = post
        
        return cell
    }
}
