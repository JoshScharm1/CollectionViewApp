//
//  ViewController.swift
//  CollectionViewApp
//
//  Created by JScharm on 11/16/16.
//  Copyright © 2016 JScharm. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var list : [ToDoListClass] = []
    
  
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        myTableView.dataSource = self
        myTableView.delegate = self
        editButton.tag = 0
        
        myTableView.allowsSelection = true
        
        let defaults = UserDefaults.standard
        
        // pulls out data from disk
        if let savedList = defaults.object(forKey: "list") as? Data
        {
            
            // converts data back to an object
            list = NSKeyedUnarchiver.unarchiveObject(with: savedList) as! [ToDoListClass]
            
        }

    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        let defaults = UserDefaults.standard
        print(list)
        print("viewDidAppear")
        
        // pulls out data from disk
        if let savedList = defaults.object(forKey: "list") as? Data
        {
            // converts data back to an object
            list = NSKeyedUnarchiver.unarchiveObject(with: savedList) as! [ToDoListClass]
            
        }
       
    }
   

    @IBAction func editButtonTapped(_ sender: Any)
    {
        if editButton.tag == 0
        {
            myTableView.isEditing = true
            editButton.tag = 1
        }
        else
        {
            myTableView.isEditing = false
            editButton.tag = 0
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any)
    {
        let myAlert = UIAlertController(title: "Add List", message: nil, preferredStyle: .alert)
        myAlert.addTextField { (nameTextField) -> Void in
            nameTextField.placeholder = "Add List Here"
        }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
            myAlert.addAction(cancelAction)
            
            let addAction = UIAlertAction(title: "Add", style: .default) { (addAction) -> Void in
            let nameTF = myAlert.textFields![0] as UITextField
            self.list.append(ToDoListClass(name: nameTF.text!))
            self.myTableView.reloadData()
        }
        myAlert.addAction(addAction)
        
        self.present(myAlert, animated: true, completion: nil)
        
        print(self.list)
        
        saver()

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let myCell = myTableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        myCell.textLabel!.text = list[indexPath.row].name
        return myCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return list.count
        

    
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            list.remove(at: indexPath.row)
            myTableView.reloadData()
        }
        
        saver()
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        return true
        
       
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let lists = list[sourceIndexPath.row]
        list.remove(at: sourceIndexPath.row)
        list.insert(lists, at: destinationIndexPath.row)
        
        saver()
    }
    
    func saver()
    {
        //NSKeyedArchiver, convert our array into a data object
        let savedData = NSKeyedArchiver.archivedData(withRootObject: list)
        
        let defaults = UserDefaults.standard
        defaults.set(savedData, forKey: "list")
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let detailView = segue.destination as! detialViewController
        let selectedRow = myTableView.indexPathForSelectedRow?.row
        detailView.lists = list[selectedRow!]
    }
    


}

