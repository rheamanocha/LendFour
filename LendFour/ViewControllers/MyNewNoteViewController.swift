//
//  MyNewNoteViewController.swift
//  LendFour
//
//  Created by Rhea on 8/5/15.
//  Copyright (c) 2015 Rhea. All rights reserved.
//

import UIKit
import Parse

class MyNewNoteViewController: UIViewController {
    
   // var currentNote: Note?
    
    @IBOutlet weak var takePhotoButton: UIButton!
    
    var photoTakingHelper: PhotoTakingHelper?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
   /*     currentNote = Note()
        let noteViewController = segue.destinationViewController as! MyNoteDisplayViewController
        noteViewController.note = currentNote
        noteViewController.edit = true */
    }
    
    // MARK: PhotoTaking
    func takePhoto() {
        // instantiate photo taking class, provide callback for when photo  is selected
        photoTakingHelper = PhotoTakingHelper(viewController: PhotoViewController(), callback: { (image: UIImage?) in
            let post = Post()
            post.image = image
            post.uploadPost()
        })
    }
    
    
    func buttonController(button: UIButton, shouldSelectViewController viewController: UIViewController) -> Bool{
        if (viewController is PhotoViewController) {
            takePhoto()
            return false
        }
        else {
            return true
        }
    }

}
