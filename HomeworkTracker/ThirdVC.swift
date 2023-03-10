//
//  ThirdVC.swift
//  HomeworkTracker
//
//  Created by Alper Canımoğlu on 7.12.2022.
//

import UIKit
import CoreData

class ThirdVC: UIViewController {
    
    @IBOutlet weak var homework: UILabel!
    @IBOutlet weak var homeworkShowImage: UIImageView!
    @IBOutlet weak var homeworkShowTitle: UITextField!
    @IBOutlet weak var homeworkShowLesson: UITextField!
    @IBOutlet weak var homeworkShowDuration: UITextField!
    @IBOutlet weak var teacherShowName: UITextField!
    
    var chosenHomework = ""
    var chosenHwID : UUID?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if chosenHomework != "" {
            
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let context = appDelegate?.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Homeworks")
            
            let idString = chosenHwID?.uuidString
            fetchRequest.predicate = NSPredicate(format: "hwID = %@", idString!)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context!.fetch(fetchRequest)
                
                if results.count > 0 {
                    
                    for result in results as! [NSManagedObject]{
                        
                        if let title = result.value(forKey: "hwTitle") as? String {
                            homeworkShowTitle.text = title
                        }
                        
                        if let duration = result.value(forKey: "hwDuration") as? Int {
                            homeworkShowDuration.text = String(duration)
                        }
                        
                        if let lesson = result.value(forKey: "hwLesson") as? String {
                            homeworkShowLesson.text = lesson
                        }
                        
                        if let teacherName = result.value(forKey: "teacherName") as? String {
                            teacherShowName.text = teacherName
                        }
                        
                        if let imageData = result.value(forKey: "hwImage") as? Data {
                            let image = UIImage(data: imageData)
                            homeworkShowImage.image = image
                        }
                    }
                }
            } catch {
                print("Error!")
            }
            
        }
    }
    
}
