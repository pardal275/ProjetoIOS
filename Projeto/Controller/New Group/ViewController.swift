//
//  ViewController.swift
//  Projeto
//
//  Created by dev on 19/08/2018.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit
import os.log

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var nomeDepartamento: UITextField!
    @IBOutlet weak var siglaDepartamento: UITextField!
    @IBOutlet weak var SaveButton: UIBarButtonItem!
    @IBOutlet weak var funcionariosButton: UIButton!
    
    
    
    /*
     This value is either passed by `MealTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new meal.
     */
    var departamento: Departamento?
    var IdDep : Int = 1
    let defaults = UserDefaults.standard
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        nomeDepartamento.delegate = self
        siglaDepartamento.delegate = self
        
        let idDepart = defaults.integer(forKey: "idDepart")
        if idDepart == 0 {
            defaults.set(IdDep, forKey: "idDepart")
        }
        
        
        // Set up views if editing an existing Meal.
        if let departamento = departamento {
            navigationItem.title = departamento.nome
            nomeDepartamento.text   = departamento.nome
            siglaDepartamento.text = departamento.sigla
            
            
            
        }
        
        
        // Enable the Save button only if the text field has a valid Meal name.
        updateSaveButtonState()
       
        
    }
    @IBAction func FuncInfo(_ sender: UIButton) {
        
        
        
        
    }
    
    
    
    
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
    }
    //MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
        
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        
        let isPresentingInAddDepartamentoMode = presentingViewController is UINavigationController
        
        if isPresentingInAddDepartamentoMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
        
        
    }
    
    
    // This method lets you configure a view controller before it's presented.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        
        if segue.identifier == "func" {
            if let dest = segue.destination as? FuncTableViewController {
                dest.departamento = self.departamento
            }
        }
        
        
        
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === SaveButton else{
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        
        let nome = nomeDepartamento.text ?? ""
        let sigla = siglaDepartamento.text ?? ""
        let idDep2 = defaults.integer(forKey: "idDepart")
        
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        departamento = Departamento(id: idDep2, nome: nome, sigla: sigla)
        defaults.set((idDep2+1), forKey: "idDepart")
    }
    
    
    //MARK: Private Methods
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nomeDepartamento.text ?? ""
        SaveButton.isEnabled = !text.isEmpty
        if (departamento == nil){
            
            funcionariosButton.isEnabled = false
        }
        
    }

       
    
    
}

