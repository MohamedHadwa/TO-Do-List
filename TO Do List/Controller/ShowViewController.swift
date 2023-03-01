//
//  ShowViewController.swift
//  TO Do List
//
//  Created by Mohamed Hadwa on 28/02/2023.
//

import UIKit
import RealmSwift

class ShowViewController: UIViewController {


    // MARK: - IBOutlets.
    @IBOutlet weak var itemLabel : UILabel!
    @IBOutlet weak var dateLabel : UILabel!
    
    @IBOutlet weak var deleteBtn: UIButton!
    // MARK: - Private Variables.
    
    public var item : ToDOListItem?
    public var deletionHandler : (()-> Void)?
    let realm = try! Realm()

    
    static let dateFormater : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        itemLabel.text = item?.item
        dateLabel.text = ShowViewController.dateFormater.string(from: item!.date)
        deleteBtn.layer.cornerRadius = 15
        
       // navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapDelete))
        
    }
    // MARK: - IBActions.
    
    @IBAction func deletBtnPressed(_ sender: Any) {
        
        didTapDelete()
    }
    
    // MARK: - Private Functions.
    func didTapDelete (){
       guard let myItem = self.item else{return}
       self.realm.beginWrite()
       realm.delete(myItem)
       try! realm.commitWrite()
       
       deletionHandler?()
       navigationController?.popViewController(animated: true)
        
    }
    
    
}



