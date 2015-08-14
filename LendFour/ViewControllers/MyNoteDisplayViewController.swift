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
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var toolbarBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var lendImage: UIImageView!
    
    var keyboardNotificationHandler: KeyboardNotificationHandler?
    
    var edit: Bool = false
    
    var post: Post? {
        didSet {
            displayPost(post)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        displayPost(self.post)
        
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
    
    func displayPost(post: Post?) {
        if let post = post, titleTextField = titleTextField {
            titleTextField.text = post.title!.text
            
            /*
            if count(post.title!.text) == 0 /* && count(note.content) == 0 */ {
                titleTextField.becomeFirstResponder()
            }*/
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveNote()
    }
    
    func saveNote() {
        if let post = post {
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

