//
//  Post.swift
//  LendFour
//
//  Created by Rhea on 8/10/15.
//  Copyright (c) 2015 Rhea. All rights reserved.
//

import Foundation
import Parse


class Post : PFObject, PFSubclassing { //need to inherit from PFObject and implement PFSubclassing protocol
    
    // Define each property to access on Prse class
    @NSManaged var imageFile: PFFile?
    @NSManaged var user: PFUser?
    // @NSManaged var title: PFObject
    
    var image: UIImage?
    var title: UITextField?
    var photoUploadTask: UIBackgroundTaskIdentifier?
    
    //MARK: PFSubclassing Protocol
    
    // Create conncetion between Parse class and Swift class
    static func parseClassName() -> String {
        return "Post"
    }
    
    // Boilerplate code
    override init () {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            //inform Parse about this subclass
            self.registerSubclass()
        }
    }
    
    func uploadPost() {
        
        let imageData = UIImageJPEGRepresentation(image, 0.8)
        let imageFile = PFFile(data: imageData)
        
        photoUploadTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
            UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
        }
        
        imageFile.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
        }

        
        user = PFUser.currentUser()
        self.imageFile = imageFile
        saveInBackgroundWithBlock(nil)
    }
}