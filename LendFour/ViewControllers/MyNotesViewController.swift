//
//  MyNotesViewController.swift
//  LendFour
//
//  Created by Rhea on 8/5/15.
//  Copyright (c) 2015 Rhea. All rights reserved.
//

import UIKit
import Parse

class MyNotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var posts: [Post] = []
    
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
    
    // MARK: Search
    
    var selectedNote: Note?
    
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
    
    // MARK: Views

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
        
        // Creating the query that fetches the follow relationships for the current user
        let followingQuery = PFQuery(className: "Follow")
        followingQuery.whereKey("fromUser", equalTo: PFUser.currentUser()!)
        
        // Using the query to fetch posts created by users that current user is following
        let postsFromFollowedUsers = Post.query()
        postsFromFollowedUsers?.whereKey("user", matchesKey: "toUser", inQuery: followingQuery)
        
        // Creating query to retrueve all posts that the current user has posted
        let postsFromThisUser = Post.query()
        postsFromThisUser!.whereKey("user", equalTo: PFUser.currentUser()!)
        
        // combined query of last 2 queries (any post that meets either)
        let query = PFQuery.orQueryWithSubqueries([postsFromFollowedUsers!, postsFromThisUser!])
        
        // define that combied query should also fetch PFUser associated with the post
        query.includeKey("user")
        // results ordered by the createdAt field (posts on timeline will appear in chronological order)
        query.orderByDescending("createdAt")
        
        // start network request
        query.findObjectsInBackgroundWithBlock {(result: [AnyObject]?, error: NSError?) -> Void in
            // recieve all posts that meet our requirements
            self.posts = result as? [Post] ?? []
            // refresh table view
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
            // noteViewController.post = selectedNote
        }
    }
    

}

// MARK: - Extensions

/* DELETE
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
*/

/* DELETE
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
*/

extension MyNotesViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // table view needs to have as many rows as we have posts stored in the posts property
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // returning a simple placeholder with title post
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! UITableViewCell
        
        cell.textLabel!.text = "Post"
        
        return cell
    }
}
