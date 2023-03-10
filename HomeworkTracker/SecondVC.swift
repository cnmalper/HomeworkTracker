//
//  SecondVC.swift
//  HomeworkTracker
//
//  Created by Alper Canımoğlu on 7.12.2022.
//

import UIKit
import CoreData

class SecondVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var homeworkTracker: UILabel!
    @IBOutlet weak var homeworkImage: UIImageView!
    @IBOutlet weak var homeworkTitle: UITextField!
    @IBOutlet weak var homeworkLesson: UITextField!
    @IBOutlet weak var homeworkDuration: UITextField!
    @IBOutlet weak var teacherName: UITextField!
    @IBOutlet weak var buttonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buttonOutlet.isEnabled = false
        
        // Recognizers
                
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
                
        homeworkImage?.isUserInteractionEnabled = true
        let tapImageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pickImage))
        homeworkImage.addGestureRecognizer(tapImageGestureRecognizer)

    }
    
    // Hide Keyboard Function
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    // Image Picking Functions
    
    @objc func pickImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        homeworkImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
        
        self.buttonOutlet.isEnabled = true
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        // CoreData Section
            
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
            
        let newHomework = NSEntityDescription.insertNewObject(forEntityName: "Homeworks", into: context)
            
        // Attributes
            
        newHomework.setValue(homeworkTitle.text!, forKey: "hwTitle")
        newHomework.setValue(homeworkLesson.text!, forKey: "hwLesson")
        newHomework.setValue(teacherName.text!, forKey: "teacherName")
        newHomework.setValue(UUID(), forKey: "hwID")
            
        if let duration = Int(homeworkDuration.text!){
            newHomework.setValue(duration, forKey: "hwDuration")
        }
            
        let imgData = homeworkImage.image!.jpegData(compressionQuality: 0.5)
        newHomework.setValue(imgData, forKey: "hwImage")
            
        do{
            try context.save()
            print("Your data has been saved succesfully.")
        } catch {
            print("Error!")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object: self.navigationController?.popViewController(animated: true))
        
    }

    
}
