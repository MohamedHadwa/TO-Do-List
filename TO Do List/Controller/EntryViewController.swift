//
//  EntryViewController.swift
//  TO Do List
//
//  Created by Mohamed Hadwa on 28/02/2023.
//

import UIKit
import RealmSwift
class EntryViewController: UIViewController {
    
    
    // MARK: - IBOutlets.
    @IBOutlet weak var entryTextFieled : UITextField!
    @IBOutlet weak var entryDataPicker : UIDatePicker!
    
    
    // MARK: - Private Variables.
    let realm = try! Realm()
    
    var complitionHendler : (()->Void)?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        entryTextFieled.delegate = self
        entryTextFieled.becomeFirstResponder()
        entryDataPicker.setDate(Date(), animated: true)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(didTapedSaveButton))
        
    }
    // MARK: - IBActions.
    @objc func didTapedSaveButton (){
        
        if let text = entryTextFieled.text , !text.isEmpty {
            let date = entryDataPicker.date
            
            realm.beginWrite()
            let newItem = ToDOListItem()
            newItem.date = date
            newItem.item = text
            realm.add(newItem)
            try! realm.commitWrite()
            
            complitionHendler?()
            navigationController?.popViewController(animated: true)
            
            
        }
        else{
            print("has no data")
        }
    }
    
    // MARK: - Private Functions.
    
    
    
}

// MARK: - UI EntryViewController Delegate & DataSource.

extension EntryViewController :UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        entryTextFieled.resignFirstResponder()
        
        return true
    }
    

    
}


