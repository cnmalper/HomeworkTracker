//
//  ViewController.swift
//  HomeworkTracker
//
//  Created by Alper Canımoğlu on 7.12.2022.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var idArray = [UUID]()
    var titleArray = [String]()
    var selectedHomework = ""
    var selectedID : UUID?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addHomework))
        
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newData"), object: nil)
    }
    
    @objc func getData(){
        
        // Delete duplicate datas
        
        idArray.removeAll(keepingCapacity: false)
        titleArray.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchReguest = NSFetchRequest<NSFetchRequestResult>(entityName:"Homeworks")
        fetchReguest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchReguest)
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    if let title = result.value(forKey: "hwTitle") as? String {
                        self.titleArray.append(title)
                    }
                    if let id = result.value(forKey: "hwID") as? UUID {
                        self.idArray.append(id)
                    }
                    self.tableView.reloadData()
                }
            }
        } catch {
            print("Error!")
        }
        
    }
    
    
    // Navigation Bar Function
    
    @objc func addHomework(){
        selectedHomework = ""
        performSegue(withIdentifier: "toSecondVC", sender: nil)
    }
    
    // TableView Functions
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedHomework = titleArray[indexPath.row]
        selectedID = idArray[indexPath.row]
        performSegue(withIdentifier: "toThirdVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.titleArray[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toThirdVC" {
            let destinationVC = segue.destination as! ThirdVC
            destinationVC.chosenHwID = selectedID
            destinationVC.chosenHomework = selectedHomework
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Homeworks")
            
            let idString = idArray[indexPath.row]
            fetchRequest.predicate = NSPredicate(format: "hwID = %@",idString as CVarArg)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let id = result.value(forKey:"hwID") as? UUID {
                            if id == idArray[indexPath.row] {
                                context.delete(result)
                                titleArray.remove(at: indexPath.row)
                                idArray.remove(at: indexPath.row)
                                self.tableView.reloadData()
                                
                                do {
                                    try context.save()
                                } catch {
                                    break
                                }
                            }
                        }
                    }
                }
            } catch {
                print("Error!")
            }
        }
    }
}

