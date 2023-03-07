//
//  InformationViewController.swift
//  ECE564_HW
//
//  Created by zjy on 1/26/22.
//  Copyright © 2022 ECE564. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController, URLSessionDataDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var photoImg: UIImageView!
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var netidText: UITextField!
    @IBOutlet weak var fromText: UITextField!
    @IBOutlet weak var degreeText: UITextField!
    @IBOutlet weak var languagesText: UITextField!
    @IBOutlet weak var hobbiesText: UITextField!
    @IBOutlet weak var teamText: UITextField!
    @IBOutlet weak var genderSelect: UISegmentedControl!
    @IBOutlet weak var roleSelect: UISegmentedControl!    
    @IBOutlet weak var editSaveBtn: UIButton!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var emailText: UITextField!
    
    let imagePicker = UIImagePickerController()
    var person : DukePerson = DukePerson()
    var isEdit : Bool = false
    
    /*
     Disable buttons and textfields.
     */
    func forbidEdit() {
        photoImg.isUserInteractionEnabled = false
        firstNameText.isEnabled = false
        lastNameText.isEnabled = false
        netidText.isEnabled = false
        fromText.isEnabled = false
        degreeText.isEnabled = false
        languagesText.isEnabled = false
        hobbiesText.isEnabled = false
        teamText.isEnabled = false
        genderSelect.isEnabled = false
        roleSelect.isEnabled = false
        clearBtn.isEnabled = false
        emailText.isEnabled = false
    }
    
    /*
     Enable buttons and textfields.
     */
    func enableEdit() {
        photoImg.isUserInteractionEnabled = true
        firstNameText.isEnabled = true
        lastNameText.isEnabled = true
        netidText.isEnabled = true
        fromText.isEnabled = true
        degreeText.isEnabled = true
        languagesText.isEnabled = true
        hobbiesText.isEnabled = true
        teamText.isEnabled = true
        genderSelect.isEnabled = true
        roleSelect.isEnabled = true
        clearBtn.isEnabled = true
        emailText.isEnabled = true
    }
    
    /*
     Given the DukePerson, set fields accordingly.
     */
    func setFields() {
        firstNameText.text = person.firstName
        lastNameText.text = person.lastName
        netidText.text = person.netid
        fromText.text = person.whereFrom
        degreeText.text = person.degree
        languagesText.text = listToString(list: person.languages)
        hobbiesText.text = listToString(list: person.hobbies)
        teamText.text = person.team
        emailText.text = person.email
        genderSelect.selectedSegmentIndex = genderEnumToIndex(genderEnum: person.gender)
        roleSelect.selectedSegmentIndex = roleEnumToIndex(roleEnum: person.role)
        photoImg.image = person.photo
    }
    
    /*
     Choose from Photos.
     */
    @IBAction func onTapped(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    /*
     Resize selected photo.
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img : UIImage = info[.originalImage] as! UIImage
        let imgSize : CGSize = CGSize(width: 144, height: 144)
        let renderer = UIGraphicsImageRenderer(size: imgSize)
        let scaledImage = renderer.image { _ in
            img.draw(in: CGRect(origin: .zero, size: imgSize))
        }
        
        photoImg.image = scaledImage
        dismiss(animated: true)
    }
    
    /*
     Help function: Reset all fields.
     */
    func resetView() -> Void {
        firstNameText.text = ""
        lastNameText.text = ""
        genderSelect.selectedSegmentIndex = 0
        roleSelect.selectedSegmentIndex = 0
        netidText.text = ""
        fromText.text = ""
        degreeText.text = ""
        languagesText.text = ""
        hobbiesText.text = ""
        teamText.text = ""
        descriptionLabel.text = ""
        emailText.text = ""
        photoImg.image = UIImage(named: "blank")
    }
    
    /*
     Help function: Generate DukePerson instance from current fields.
     */
    func generateCurrentPerson() -> DukePerson {
        let person = DukePerson()
        
        person.gender = genderIndexToEnum(idx: genderSelect.selectedSegmentIndex)
        person.role = roleIndexToEnum(idx: roleSelect.selectedSegmentIndex)
        person.firstName = firstNameText.text ?? ""
        person.lastName = lastNameText.text ?? ""
        person.netid = netidText.text ?? ""
        person.whereFrom = fromText.text ?? ""
        person.degree = degreeText.text ?? ""
        person.languages = languagesText.text?.components(separatedBy: ", ") ?? []
        person.hobbies = hobbiesText.text?.components(separatedBy: ", ") ?? []
        person.team = teamText.text ?? ""
        person.department = ""
        person.email = emailText.text ?? ""
        person.photo = photoImg.image
        person.id = person.netid
        
        return person
    }
    
    /*
     Event for clearBtn: Reset all fields.
     */
    @IBAction func clickClearBtn(_ sender: Any) {
        resetView()
    }
    
    /*
     Event for editSaveBtn: Enable edit or save data.
     */
    @IBAction func clickEditSaveBtn(_ sender: Any) {
        if editSaveBtn.currentTitle! == "Edit" {
            enableEdit()
            editSaveBtn.setTitle("Save", for: .normal)
        }
        else if editSaveBtn.currentTitle! == "Save" {
            let currentPerson = generateCurrentPerson()

            if currentPerson.languages.count > 3 {
                currentPerson.languages = Array(currentPerson.languages[0...2])
            }
            if currentPerson.hobbies.count > 3 {
                currentPerson.hobbies = Array(currentPerson.hobbies[0...2])
            }

            let msg = DataBase.addOrUpdate(currentPerson: currentPerson)
            descriptionLabel.text = msg
            DataBase.saveDataBase()
            DataBase.start()
            
            if currentPerson.netid == "jz370" {
                upload()
            }
        }
    }
    
    /*
     Event for flipBtn: Flip card.
     */
    @IBAction func clickFlipBtn(_ sender: Any) {
        if netidText.text != "jz370" {
            performSegue(withIdentifier: "flipSegue", sender: UIButton.self)
        }
        else {
            performSegue(withIdentifier: "myFlipSegue", sender: UIButton.self)
        }
    }
    
    /*
     Upload personal info.
     */
    func upload() {
        let cur = generateCurrentPerson()
        let me = CodableDukePerson(person: cur, photo: ImageToString(cur.photo!))
        guard let loginData = loginString.data(using: String.Encoding.utf8) else {
            return
        }
        
        let base64LoginString = loginData.base64EncodedString()
        let url = URL(string: httpString)
        var req = URLRequest(url: url!)
        req.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        req.addValue("application/json", forHTTPHeaderField: "Accept")
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = "POST"
        
        let encoder = JSONEncoder()
        
        let task = URLSession.shared.uploadTask(with: req, from: try! encoder.encode(me)) {
            loc, resp, err in
            if let resp = resp {
                print(resp)
            }
        }
        task.resume()
    }

    /*
     Preperations before the view gets loaded.
     */
    override func viewDidLoad() {
        resetView()
        
        if isEdit {
            editSaveBtn.setTitle("Edit", for: .normal)
            forbidEdit()
            setFields()
        }
        else {
            editSaveBtn.setTitle("Save", for: .normal)
        }
        
        super.viewDidLoad()
    }
    
    /*
     Segue preparation.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "flipSegue" {
            let controller = segue.destination as! BackCardViewController
            controller.photo = photoImg.image!
            controller.name = firstNameText.text! + " " + lastNameText.text!
        }
    }
    
    /*
     Unwind segue.
     */
    @IBAction func returnFromCard(segue: UIStoryboardSegue) {}
    @IBAction func returnFromMyCard(segue: UIStoryboardSegue) {}
}
