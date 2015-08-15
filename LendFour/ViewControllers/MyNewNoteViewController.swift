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
    
    var photoViewController: PhotoViewController!
    var photoTakingHelper: PhotoTakingHelper?

    @IBOutlet weak var takePhotoButton: UIButton!
    
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
        if let identifier = segue.identifier {
            switch identifier {
            case "Save":
                post.uploadPost()
                println("Saved")
                
            case "Cancel":
                post.deleteInBackgroundWithBlock(nil)
                println("Cancel")
                
            default:
                println("No one loves \(identifier)")
            }
        }
        
    }
    
    // MARK: PhotoTaking
    
    let post = Post()
    @IBAction func takePhoto(sender: UIButton) {
        // instantiate photo taking class, provide callback for when photo  is selected
        photoTakingHelper =
            PhotoTakingHelper(viewController: self.navigationController!) { (image: UIImage?) in
                
                self.post.image.value = image!
                
                
        }
    }
    
}

extension MyNewNoteViewController: UINavigationControllerDelegate {
    
}
