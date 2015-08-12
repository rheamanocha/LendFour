//
//  MyNoteDisplayViewController.swift
//  LendFour
//
//  Created by Rhea on 8/5/15.
//  Copyright (c) 2015 Rhea. All rights reserved.
//

import Foundation
import UIKit
import ConvenienceKit
import Parse

class MyNoteDisplayViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    // @IBOutlet weak var contentTextView: TextView!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var toolbarBottomSpace: NSLayoutConstraint!
   // @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var lendImage: UIImageView!
    
    var photoTakingHelper: PhotoTakingHelper?
    
    var keyboardNotificationHandler: KeyboardNotificationHandler?
    
    var edit: Bool = false
    
    var note: Note? {
        didSet {
            displayNote(note)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        displayNote(self.note)
        
        titleTextField.returnKeyType = .Next
        titleTextField.delegate = self
        
        keyboardNotificationHandler = KeyboardNotificationHandler()
        
        
        keyboardNotificationHandler!.keyboardWillBeHiddenHandler = { (height: CGFloat) in
            UIView.animateWithDuration(0.3){
                self.toolbarBottomSpace.constant = 0
                self.view.layoutIfNeeded()
            }
        
            if self.edit {
                self.deleteButton.enabled = false
            }
        
        }
        
        keyboardNotificationHandler!.keyboardWillBeShownHandler = { (height: CGFloat) in
            UIView.animateWithDuration(0.3) {
                self.toolbarBottomSpace.constant = -height
                self.view.layoutIfNeeded()
            }
        }
        self.navigationController!.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Business Logic
    
    func displayNote(note: Note?) {
        if let note = note, titleTextField = titleTextField /*, contentTextView = contentTextView */ {
            titleTextField.text = note.title
            // contentTextView.text = note.content
            
            if count(note.title) == 0 /* && count(note.content) == 0 */ {
                titleTextField.becomeFirstResponder()
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveNote()
    }
    
    func saveNote() {
        if let note = note {
            /* REALM STUFF
            
            let realm = Realm()
            realm.write {
                if (note.title != self.titleTextField.text || note.content != self.contentTextView.textValue) {
                    note.title = self.titleTextField.text
                    note.content = self.contentTextView.textValue
                    note.dateBorrowed = NSDate()
                }
            
            */
        }
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
    
    /*
    func buttonController(button: UIButton, shouldSelectViewController viewController: UIViewController) -> Bool{
        if (viewController is PhotoViewController) {
            takePhoto()
            return false
        }
        else {
            return true
        }
    }
    */

}

// MARK: - Extensions

extension MyNoteDisplayViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == titleTextField) {
            // contentTextView.returnKeyType = .Done
            // contentTextView.becomeFirstResponder()
        }
        return false
    }
}

