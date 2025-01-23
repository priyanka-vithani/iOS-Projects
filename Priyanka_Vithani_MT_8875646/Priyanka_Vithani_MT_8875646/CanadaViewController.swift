//
//  CanadianCitesViewController.swift
//  Priyanka_Vithani_MT_8875646
//
//  Created by Priyanka Vithani on 31/10/23.
//

import UIKit

class CanadaViewController: UIViewController {
    
    //MARK: Variables
    var cities = ["Calgary", "Halifax", "Montreal", "Toronto", "Vancouver", "Winnipeg"]
    
    //MARK: IBOutlets
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    //MARK: View Life Cylcle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // To dismiss the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: IBAction
    @IBAction func findCityButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        var city = cityNameTextField.text ?? ""
        city = city.replacingOccurrences(of: " ", with: "")
        if cities.contains(city){
            errorMessageLabel.isHidden = true
            imageview.image = UIImage(named: city)
        }else{
            errorMessageLabel.isHidden = false
            imageview.image = UIImage(named: "Canada")
        }
    }
}

//MARK: TextField Delegate Methods
extension CanadaViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        errorMessageLabel.isHidden = true
        textField.text = ""
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}
