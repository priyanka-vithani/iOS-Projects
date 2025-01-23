//
//  Lab3.swift
//  Priyanka_Vithani_MT_8875646
//
//  Created by Priyanka Vithani on 04/11/23.
//

import UIKit

class Lab3: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var hiddenLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var tableHeaderView: UIView!
    
    //MARK: View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Lab 3"
    }
    
    // To dismiss the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: IBActions
    @IBAction func addButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        detailsTextView.text = ""
        if let firstname = firstNameTF.text, firstname != ""{
            detailsTextView.text += "Full Name : \(firstname)"
        }
        if let lastname = lastNameTF.text, lastname != ""{
            detailsTextView.text += lastname
        }
        if let country = countryTF.text, country != ""{
            detailsTextView.text += "\nCountry : \(countryTF.text ?? "")"
        }
        if let age = ageTF.text, age != ""{
            detailsTextView.text += "\nAge : \(ageTF.text ?? "")"
        }
    }
    @IBAction func submitButtonAction(_ sender: UIButton){
        if detailsTextView.text.isEmpty{
            self.hiddenLabel.text = "Please click on add button to save the information"
            self.hiddenLabel.isHidden = false
        }else{
            self.hiddenLabel.isHidden = false
            if firstNameTF.text != "" && lastNameTF.text != "" && countryTF.text != "" && ageTF.text != ""{
                detailsTextView.text = " Full Name : \(firstNameTF.text ?? "") \(lastNameTF.text ?? "") \n Country : \(countryTF.text ?? "") \n Age : \(ageTF.text ?? "")"
            }else{
                detailsTextView.text = ""
            }
            
            if firstNameTF.text == "" || lastNameTF.text == "" || countryTF.text == "" || ageTF.text == ""{
                self.hiddenLabel.text = "Complete the missing Info!"
                self.hiddenLabel.textColor = .red
                
            }else{
                self.hiddenLabel.text = "Successfully submitted!"
                self.hiddenLabel.textColor = .systemGreen
                firstNameTF.text = ""
                lastNameTF.text = ""
                countryTF.text = ""
                ageTF.text = ""
            }
        }
        
    }
    @IBAction func clearButtonAction(_ sender: UIButton) {
        firstNameTF.text = ""
        lastNameTF.text = ""
        countryTF.text = ""
        ageTF.text = ""
        detailsTextView.text = ""
        hiddenLabel.isHidden = true
    }
}

//MARK: TextField Delegate Methods
extension Lab3: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}
