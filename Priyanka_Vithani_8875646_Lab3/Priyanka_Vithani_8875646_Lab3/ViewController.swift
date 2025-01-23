//
//  ViewController.swift
//  Priyanka_Vithani_8875646_Lab3
//
//  Created by Priyanka Vithani on 08/09/23.
//

import UIKit

class ViewController: UIViewController {
    
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
    
        //MARK: View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: IBActions
    
    @IBAction func addButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
    
        detailsTextView.text = "Full Name : \(firstNameTF.text ?? "") \(lastNameTF.text ?? "") \n Country : \(countryTF.text ?? "") \n Age : \(ageTF.text ?? "")"
    }
//    func errorTextfields(_ textField: UITextField){
//        textField.layer.borderColor = UIColor.red.cgColor
//        textField.layer.borderWidth = 1
//    }
    
    @IBAction func submitButtonAction(_ sender: UIButton){
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
    @IBAction func clearButtonAction(_ sender: UIButton) {
        firstNameTF.text = ""
        lastNameTF.text = ""
        countryTF.text = ""
        ageTF.text = ""
        detailsTextView.text = ""
        hiddenLabel.isHidden = true
    }
}

extension ViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}
