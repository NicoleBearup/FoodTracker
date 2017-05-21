//
//  ViewController.swift
//  FoodTracker
//
//  Created by Nicole Bearup on 4/27/17.
//  Copyright © 2017 Nicole Bearup. All rights reserved.
//

import UIKit
import os.log


class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    
    var meal: Meal?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // handle the text field's user input through delegate candidate
        nameTextField.delegate = self
        
        // set up views if editing existing Meal
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        } 
        
        // enable Save button if text field has valid Meal name
        updateSaveButtonState()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // hide keyboard
        textField.resignFirstResponder()
        
        return true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // disable Save button
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
        
    }
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        // dismiss picker if user cancelled
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // you want original image, not other representations
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary with an image, but was provided: \(info)")
        }
        
        // set photoImageView to display selected image
        photoImageView.image = selectedImage
        
        // dismiss picker
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        // depending on style (model or push), this view controlloer needs to be dismissed in two different ways
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
             dismiss(animated: true, completion: nil)
            
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
            
        } else {
            fatalError("The MealViewController is not inside a navigation controller")
        }
       
    }
    
    
    // Lets you configure a view controller before its presented
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // configure the destination view controller view controller when saved
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not preseed, cancelling", log: OSLog.default, type: .debug)
            
            return
        }
        
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        
        // set meal to be passed to MealViewController after unwind segue
        meal = Meal(name: name, photo: photo, rating: rating)
    }
    

    //MARK: Actions
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        // hide keyboard
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from photo library
        let imagePickerController = UIImagePickerController()
        
        // only allow photos to be picked
        imagePickerController.sourceType = .photoLibrary
        
        // notify ViewController when image is picked
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    //MARK: Private Methods
    
    private func updateSaveButtonState() {
        // disable Save button if text field is empty
        let text = nameTextField.text ?? ""
        
        saveButton.isEnabled = !text.isEmpty
    }
   

}

