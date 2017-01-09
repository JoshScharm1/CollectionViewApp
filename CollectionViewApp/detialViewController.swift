//
//  detialViewController.swift
//  CollectionViewApp
//
//  Created by JScharm on 11/17/16.
//  Copyright © 2016 JScharm. All rights reserved.
//

import UIKit

class detialViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{

    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var myLabel: UILabel!
    
    var lists : ToDoListClass?
    
    var people = [Person]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        navigationItem.title = lists?.name
        
        myCollectionView.allowsSelection = true
        
        unravel()
        

        sizer()
 
        save()

}
    override func viewDidAppear(_ animated: Bool)
    {
        unravel()
        save()
    }
    
    func unravel()
    {
        
        let defaults = UserDefaults.standard
        
        // pulls out data from disk
        if let savedPeople = defaults.object(forKey: (lists?.name)!) as? Data
        {
            
            // converts data back to an object
            people = NSKeyedUnarchiver.unarchiveObject(with: savedPeople) as! [Person]
            
        }
       
    }

    @IBAction func longTap(_ sender: UIGestureRecognizer)
    {
        print("long")
        
        switch(sender.state)
        {
            
        case UIGestureRecognizerState.began:
            print("case1")
            guard let selectedIndexPath = self.myCollectionView.indexPathForItem(at: sender.location(in: self.myCollectionView)) else {
                break
            }
            myCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case UIGestureRecognizerState.changed:
            print("case2")
            
            
            
            myCollectionView.updateInteractiveMovementTargetPosition(sender.location(in: sender.view!))
        case UIGestureRecognizerState.ended:
            print("case3")
            
            
            
            myCollectionView.endInteractiveMovement()
        default:
            print("case4")
            
            
            myCollectionView.cancelInteractiveMovement()
            
            
        }

    }
    

    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        let person = people[sourceIndexPath.row]
        people.remove(at: sourceIndexPath.row)
        people.insert(person, at: destinationIndexPath.row)
        
        save()
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return people.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "PersonCell", for: indexPath) as! PersonCollectionViewCell
        
        let person = people[indexPath.item]
        
        cell.myCellLabel.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.myCellImage.image = UIImage(contentsOfFile: path.path)
        
        return cell
        
        
    }
    
    func sizer()
    {
        let size0: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        size0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        size0.itemSize = CGSize(width: view.frame.width / 3, height: view.frame.height / 4)
        size0.minimumLineSpacing = 5
        size0.minimumInteritemSpacing = 0
        myCollectionView.collectionViewLayout = size0
    }
    
    func addNewPerson()
    {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        {
            picker.sourceType = UIImagePickerControllerSourceType.camera
            present(picker, animated: true, completion: nil)
        }
   }
    
    
    @IBAction func addButtonTapped(_ sender: Any)
    {
        addNewPerson()
        save()
    }
    
    func getDocumentsDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let doucmentsDirectory = paths[0]
        return doucmentsDirectory
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else {return}
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = UIImageJPEGRepresentation(image, 80)
        {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        myCollectionView?.reloadData()
        
        save()
        
        dismiss(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let person = people[indexPath.item]
        
        let ac = UIAlertController(title: "Rename List", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Cancle", style: .cancel))
        
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [unowned self, ac] _ in
            let newName = ac.textFields![0]
            person.name = newName.text!
            
            self.myCollectionView?.reloadData()
            })
    
        
        present(ac, animated: true)
        
        ac.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action: UIAlertAction!) -> Void in
           
            self.people.remove(at: indexPath.item)
            self.myCollectionView.deleteItems(at: [indexPath as IndexPath])
            self.myCollectionView.reloadData()
            self.save()
    }))
        
    }
    
    func save()
    {
        //NSKeyedArchiver, convert our array into a data object
        let savedData = NSKeyedArchiver.archivedData(withRootObject: people)
        
        let defaults = UserDefaults.standard
        defaults.set(savedData, forKey: (lists?.name)!)
        
    }

    
    
    
    
    
    
}
