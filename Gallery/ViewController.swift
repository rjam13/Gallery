//
//  ViewController.swift
//  Gallery
//
//  Created by Rey Jairus Marasigan on 9/14/21.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var pictures = [PictureCaption]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print()
        
        title = "Gallery"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPicture))
        
        let defaults = UserDefaults.standard
        
        //looking for pictures data from userDefaults
        if let savedData = defaults.object(forKey: "pictures") as? Data {
            //turning the data type in to array of PictureCaption
            if let decodedData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? [PictureCaption] {
                pictures = decodedData
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row].caption
        cell.detailTextLabel?.text = pictures[indexPath.row].date
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            
            // if the code after if let fail this wont run
            vc.picture = pictures[indexPath.row]
            vc.title = pictures[indexPath.row].caption
            
            //update tableViewController after returning from DetailViewController
            navigationController?.pushViewController(vc, animated: true)
            save()
        }
    }
    
    @objc func addNewPicture() {
        let picker = UIImagePickerController()
        //allows the user to crop picture
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //info is a dictionary with one of two keys: .editedImage and .originalImage
        //we make sure the item returned from info is a UIImage or else leave the method
        guard let image = info[.editedImage] as? UIImage else { return }
        
        //turns image into data type jpeg form for saving
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            //writes data to disk using imageName
            
            //finding out what time the picture was taken
            let day = Calendar.current.component(.day, from: Date())
            let month = Calendar.current.component(.month, from: Date())
            let year = Calendar.current.component(.year, from: Date())
            let pmOram: String
            var hour = Calendar.current.component(.hour, from: Date())
            if hour > 12
            {
                hour -= 12
                pmOram = "PM"
            }
            else
            {
                pmOram = "AM"
            }
            let minute = Calendar.current.component(.minute, from: Date())
            let second = Calendar.current.component(.second, from: Date())
            let date = "\(month)/\(day)/\(year) \(hour):\(minute):\(second)\(pmOram)"
            
            let picture = PictureCaption(caption: "unknown", imageData: jpegData, date: date)
            pictures.append(picture)
        }
        
        dismiss(animated: true)
        tableView.reloadData()
        save()
    }

    func save() {
        //turning array of PictureCaption s to data type
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: pictures, requiringSecureCoding: false) {
            //then storing that data type into userDefaults
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "pictures")
        }
    }
    


}

