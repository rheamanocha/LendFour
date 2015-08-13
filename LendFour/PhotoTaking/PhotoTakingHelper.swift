//
//  PhotoTakingHelper.swift
//  LendFour
//
//  Created by Rhea on 8/6/15.
//  Copyright (c) 2015 Rhea. All rights reserved.
//

import UIKit

typealias PhotoTakingHelperCallback = UIImage? -> Void // provide a function signature with a name; a function of type PhotoTakingHelperCallback takes a UIImage? as parameter and returns void

class PhotoTakingHelper : NSObject {
    
    /** View controller on which AlertViewController and UIImagePickerController are presented */
    weak var viewController: UIViewController! // stores a weak reference to a viewController because PhotoTakingHelper needs a UIViewController on which it can present other view controllers
    var callback: PhotoTakingHelperCallback
    var imagePickerController: UIImagePickerController?
    
    init(viewController: UIViewController, callback: PhotoTakingHelperCallback) { //recieves VC on which we wil present other VCs and callback
        self.viewController = viewController
        self.callback = callback
        
        super.init()
        
        showPhotoSourceSelection()
    }
    
    func showPhotoSourceSelection() { // will present dialog that allows user to choose b/t camera and library
        // Allow user to choose between photo library and camera
        let alertController = UIAlertController(title: nil, message: "Photo", preferredStyle: .ActionSheet) // Set up UIAlertController by giving it a message and preferredStyle (.ActionSheet displays from bottom edge)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Only show camera option if rear camera is available
        if (UIImagePickerController.isCameraDeviceAvailable(.Rear)) {
            let cameraAction = UIAlertAction(title: "Photo from Camera", style: .Default) { (action) in // cancel action
                self.showImagePickerController(.Camera)
            }
            alertController.addAction(cameraAction)
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo from Library", style: .Default) { (action) in 
            self.showImagePickerController(.PhotoLibrary)
        }
        
        alertController.addAction(photoLibraryAction)
        
        viewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showImagePickerController(sourceType: UIImagePickerControllerSourceType) {
        imagePickerController = UIImagePickerController()
        imagePickerController!.sourceType = sourceType
        imagePickerController!.delegate = self
        
        self.viewController.presentViewController(imagePickerController!, animated: true, completion: nil)
    }
    
}

// MARK: - Extensions

extension PhotoTakingHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        viewController.dismissViewControllerAnimated(false, completion: nil)
        
        callback(image)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
}