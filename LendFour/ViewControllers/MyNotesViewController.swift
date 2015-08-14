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

class MyNotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TimelineComponentTarget {
    
    // @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var posts: [Post] = []
    
    // For TimelineComponentTargetProtocol
    let defaultRange = 0...9
    let additionalRangeSize = 10
    
    var timelineComponent: TimelineComponent<Post, MyNotesViewController>!
    
    func loadInRange(range: Range<Int>, completionBlock: ([Post]?) -> Void) {
        // 1
        ParseHelper.timelineRequestforCurrentUser(range) {
            (result: [AnyObject]?, error: NSError?) -> Void in
            // 2
            let posts = result as? [Post] ?? []
            // 3
            completionBlock(posts)
        }
    }
    
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
        
        timelineComponent = TimelineComponent(target:self)
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        timelineComponent.loadInitialIfRequired()
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
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        timelineComponent.targetWillDisplayEntry(indexPath.row)
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
        return timelineComponent.content.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Casted NoteTableViewCell
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! NoteTableViewCell
        
        let post = timelineComponent.content[indexPath.row]
        // trigger image download
        post.downloadImage()
        // assign the post that shall be displayed to the post property
        cell.post = post
        
        return cell
    }
}
