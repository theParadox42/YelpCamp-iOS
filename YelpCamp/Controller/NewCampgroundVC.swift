//
//  NewCampgroundVC.swift
//  YelpCamp
//
//  Created by Nathaniel on 11/28/19.
//  Copyright © 2019 Nathaniel Fargo. All rights reserved.
//

import UIKit
import Cloudinary

class NewCampgroundVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    //MARK: - Setup
    
    
    // Image Picker
    var imagePicker = UIImagePickerController()
    
    // Cloudinary stuff
    
    // IBOutlets
    @IBOutlet weak var campgroundNameTextField: UITextField!
    @IBOutlet weak var campgroundImageView: UIImageView!
    @IBOutlet weak var dollarLabel: UILabel!
    @IBOutlet weak var priceStepper: UIStepper!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    // Image To Send
    var campgroundImage: UIImage?
    
    
    // View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Price setup
        priceStepper.value = 8
        updatePrice()
        
        // Image Picker Delegate
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
    }
    
    
    //MARK: - UI Changes
    
    
    // Update price label based on priceStepper value
    func updatePrice() {
        dollarLabel.text = "$\(Int(priceStepper.value))"
    }
    
    func updateImage() {
        campgroundImageView.image = campgroundImage
    }
    
    // Clear All UI Input
    func clearInputs() {
        
        // Campground Name
        campgroundNameTextField.text = ""
        
        // Campground Image
        campgroundImage = nil
        updateImage()
        
        // Dollar label
        priceStepper.value = 8
        updatePrice()
        
        // Description Text Field
        descriptionTextView.text = "Campground Description Here..."
        
    }
    
    
    //MARK: - IBActions
    
    // Image Input
    @IBAction func chooseImagePressed(_ sender: Any) {
    }
    @IBAction func takePicturePressed(_ sender: Any) {
    }
    
    // Upload Image
    func uploadImage(image: UIImage) {
        let config = CLDConfiguration(cloudName: "paradox-programming", apiKey: <#T##String?#>, apiSecret: <#T##String?#>, privateCdn: <#T##Bool#>, secure: <#T##Bool#>, cdnSubdomain: <#T##Bool#>, secureCdnSubdomain: <#T##Bool#>, secureDistribution: <#T##String?#>, cname: <#T##String?#>, uploadPrefix: <#T##String?#>)
        let cloudinary = CLDCloudinary(configuration: config)
        
        let uploader = cloudinary.createUploader()
        uploader.upload(data: <#T##Data#>, uploadPreset: <#T##String#>, params: <#T##CLDUploadRequestParams?#>, progress: <#T##((Progress) -> Void)?##((Progress) -> Void)?##(Progress) -> Void#>, completionHandler: <#T##((CLDUploadResult?, NSError?) -> ())?##((CLDUploadResult?, NSError?) -> ())?##(CLDUploadResult?, NSError?) -> ()#>)
        
    }
    
    // Executive actions
    @IBAction func restartCampgroundPressed(_ sender: Any) {
        clearInputs()
    }
    @IBAction func submitCampgroundPressed(_ sender: Any) {
    }
    @IBAction func priceStepperChangedValue(_ sender: Any) {
        updatePrice()
    }
    

}
