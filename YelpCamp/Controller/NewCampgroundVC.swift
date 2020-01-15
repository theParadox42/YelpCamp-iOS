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
    
    // IBOutlets
    @IBOutlet weak var campgroundNameTextField: UITextField!
    @IBOutlet weak var campgroundImageView: UIImageView!
    @IBOutlet weak var dollarLabel: UILabel!
    @IBOutlet weak var priceStepper: UIStepper!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    // Image To Send
    var campgroundImage: UIImage?
    
    // Loading alert
    var loadingAlert: UIAlertController?
    
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
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func takePicturePressed(_ sender: Any) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Executive actions
    @IBAction func restartCampgroundPressed(_ sender: Any) {
        clearInputs()
    }
    @IBAction func submitCampgroundPressed(_ sender: Any) {
        if let safeCampgroundImage = campgroundImage {
            if campgroundNameTextField.hasText && descriptionTextView.hasText {
                uploadImage(image: safeCampgroundImage) { (url) in
                    self.submitCampground(imageUrl: url)
                }
                loadingAlert = UIAlertController(title: "Submitting Campground...", message: "Please be patient, this can take a while to upload your photo", preferredStyle: .alert)
                present(loadingAlert!, animated: true, completion: nil)
            } else {
                let textAlert = UIAlertController(title: "Missing Labels", message: "Please fill in all the text boxes before submitting.", preferredStyle: .alert)
                textAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                present(textAlert, animated: true, completion: nil)
            }
        } else {
            let imageAlert = UIAlertController(title: "No Image", message: "Please choose an image before submitting.", preferredStyle: .alert)
            imageAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(imageAlert, animated: true, completion: nil)
        }
    }
    @IBAction func priceStepperChangedValue(_ sender: Any) {
        updatePrice()
    }
    
    //MARK: - Cloudinary Upload
    
    // Upload Image
    func uploadImage(image: UIImage, callback: @escaping (_ urlString: String) -> Void) {
        
        let enviroment = ProcessInfo.processInfo.environment
        
        let config = CLDConfiguration(cloudName: "paradox-programming", apiKey: enviroment["CLOUDINARY_API_KEY"], apiSecret: enviroment["CLOUDINARY_API_SECRET"], privateCdn: true, secure: true, cdnSubdomain: true, secureCdnSubdomain: true, secureDistribution: nil, cname: nil, uploadPrefix: nil)
        let cloudinary = CLDCloudinary(configuration: config)
        
        print(enviroment["CLOUDINARY_API_KEY"] ?? "No Enviroment Found")
        
        let uploader = cloudinary.createUploader()
        uploader.upload(data: image.pngData()!, uploadPreset: "l7fokzd7", params: nil, progress: nil) { (result, error) in
            if error == nil {
                
                callback(result?.secureUrl ?? result?.url ?? "https://dubsism.files.wordpress.com/2017/12/image-not-found.png")
                
            } else {
                print(error ?? "Unknown error")
                self.submitFailed("Unable to upload image")
            }
            
        }
    }
    
    //MARK: - Submit Request
    
    // Submit Campground
    func submitCampground(imageUrl: String) {
        
        // Create my nifty api thing
        let api = API(successFunc: { (data) in
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(RegularResponseObject.self, from: data)
                if response.type == "success" {
                    self.submitSucceeded()
                } else {
                    self.submitFailed("Response brought error")
                }
            } catch {
                self.submitFailed("Unable to parse response")
            }
        }) { (error) in
            self.submitFailed("Unable to send request")
        }
        
        // Create request
        print(api.urlString + "campgrounds")
        var campgroundRequest = URLRequest(url: URL(string: api.urlString + "campgrounds")!)
        campgroundRequest.httpMethod = "POST"
        campgroundRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // Prepare json data
        let parameters: [String: Any] = [
            "name": campgroundNameTextField.text!,
            "img": imageUrl,
            "price": priceStepper.value,
            "description": descriptionTextView.text ?? "No description found"
        ]
        campgroundRequest.httpBody = parameters.percentEscaped().data(using: .utf8)
        
        // Authorize Request
        if let authCampgroundRequest = api.setAuth(urlRequest: campgroundRequest) {
            let submitTask = URLSession.shared.dataTask(with: authCampgroundRequest, completionHandler: api.handleResponse(data:response:error:))
            submitTask.resume()
        }
        
    }
    
    // Error outcome
    func submitFailed(_ errorMessage: String?) {
        
        loadingAlert?.dismiss(animated: true, completion: nil)
        
        let failedAlert = UIAlertController(title: "Error Submitting Campground", message: errorMessage ?? "Unknown Error", preferredStyle: .alert)
        failedAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(failedAlert, animated: true, completion: nil)
    }
    // Success outcome
    func submitSucceeded() {
        
        loadingAlert?.dismiss(animated: true, completion: nil)
        
        let successAlert = UIAlertController(title: "Succesfully Submittedd Campground!", message: nil, preferredStyle: .alert)
        successAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(successAlert, animated: true, completion: nil)
        self.clearInputs()
        
    }
    
    
    //MARK: - Image Picker
    
    // UIImage Picker Controller
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            campgroundImage = userPickedImage.resizeWithWidth(width: 1080)
            campgroundImageView.image = campgroundImage
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    

}
