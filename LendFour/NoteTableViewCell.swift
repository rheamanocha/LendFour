//
//  NoteTableViewCell.swift
//  LendFour
//
//  Created by Rhea on 8/5/15.
//  Copyright (c) 2015 Rhea. All rights reserved.
//

import Foundation
import UIKit
import Bond

class NoteTableViewCell: UITableViewCell {
    
    // initialize date formatter only once, using a static computed property
    static var dateFormatter: NSDateFormatter = {
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateBorrowedLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    
    /* var note: Note? {
        didSet {
            if let note = note, titleLabel = titleLabel, dateBorrowed = dateBorrowedLabel /* , lendImageView = lendImageView */ {
                self.titleLabel.text = note.title
                self.dateBorrowedLabel.text = NoteTableViewCell.dateFormatter.stringFromDate(note.dateBorrowed)
                // self.lendImage
            }
        }
    } */
    
    var post: Post? {
        didSet{
            // optional binding to check whether new value is nil
            if let post = post {
                // if value isn't nil, create binding b/t image property of post and postImageView
                //bind the image of the post to the 'postImage' view
                post.image ->> postImageView
            }
        }
    }

    
}