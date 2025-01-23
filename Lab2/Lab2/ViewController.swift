//
//  ViewController.swift
//  Lab2
//
//  Created by Priyanka Vithani on 13/09/23.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var stepButton: UIButton!
    
    //MARK: Constants & Variables
    var result = 0
    var incrementBy = 1
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: Custom methods
    func SetOutputLabel(){
        outputLabel.text = "\(result)"
    }
    func incByOne(){
        incrementBy = 1
        stepButton.backgroundColor = .systemOrange
        stepButton.setTitle("Step = 2", for: .normal)
    }
    func incByTwo(){
        incrementBy = 2
        stepButton.backgroundColor = .systemPink
        stepButton.setTitle("Step = 1", for: .normal)
    }
    
    //MARK: IBActions
    @IBAction func subtractButtonAction(_ sender: UIButton) {
        result -= incrementBy
        SetOutputLabel()
    }
    
    @IBAction func addButtonAction(_ sender: UIButton) {
        result += incrementBy
        SetOutputLabel()
    }
    @IBAction func resetButtonAction(_ sender: UIButton) {
        result = 0
        incByOne()
        stepButton.isSelected = false
        SetOutputLabel()
    }
    @IBAction func stepButtonAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected{
            incByTwo()
        }else{
            incByOne()
        }
    }
}

