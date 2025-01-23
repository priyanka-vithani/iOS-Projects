//
//  QuadraticViewController.swift
//  Priyanka_Vithani_MT_8875646
//
//  Created by Priyanka Vithani on 31/10/23.
//

import UIKit

class QuadraticViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var AtextField: UITextField!
    @IBOutlet weak var BtextField: UITextField!
    @IBOutlet weak var CtextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // To dismiss the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: IBAction
    @IBAction func calculateButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let Avalue = AtextField.text ?? ""
        let Bvalue = BtextField.text ?? ""
        let Cvalue = CtextField.text ?? ""
        
        if Avalue == "" || Bvalue == "" || Cvalue == ""{
            resultLabel.text = "Enter a value for A,B and C to find X."
            resultLabel.isHidden = false
            return
        }
        
        if (Double(Avalue) ?? 0) <= 0{
            resultLabel.text = "The value you entered for A is invalid."
            resultLabel.isHidden = false
            return
        }
        
        if let a = Double(Avalue), let b = Double(Bvalue), let c = Double(Cvalue) {
            let discriminant = b * b - 4 * a * c
            
            if discriminant > 0 {
                let root1 = (-b + sqrt(discriminant)) / (2 * a)
                let root2 = (-b - sqrt(discriminant)) / (2 * a)
                let strRoot1 = String(format: "%.2f", root1)
                let strRoot2 = String(format: "%.2f", root2)
                resultLabel.text = "There are two values for X \nX1: \(strRoot1), \nX2: \(strRoot2)"
            } else if discriminant == 0 {
                let root = -b / (2 * a)
                let strRoot = String(format: "%.2f", root)
                resultLabel.text = "There is only one value for X \nDouble Root: \(strRoot)"
            } else {
                
                resultLabel.text = "There are no results since the discriminant is less than zero."
            }
        } else {
            resultLabel.text = "Enter a value for A,B and C to find X."
        }
        resultLabel.isHidden = false
    }
    
    @IBAction func clearAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if AtextField.text != "" ||
            BtextField.text != "" ||
            CtextField.text != ""{
            AtextField.text = ""
            BtextField.text = ""
            CtextField.text = ""
            resultLabel.text = "Enter a value for A, B and C to find x1 and x2"
            resultLabel.isHidden = false
        }
    }
}

