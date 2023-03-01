//
//  BaseViewController.swift
//  TO Do List
//
//  Created by Mohamed Hadwa on 28/02/2023.
//

import UIKit
import RealmSwift

class ToDOListItem : Object {
    @objc dynamic var item : String = ""
    @objc dynamic var date : Date = Date()
}

class BaseViewController: UIViewController {

  
    // MARK: - IBOutlets.
    @IBOutlet weak var tableView : UITableView!
    
    // MARK: - Private Variables.
    var myTasks = [ToDOListItem]()
    let realm = try! Realm()

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView .dataSource = self
        myTasks = realm.objects(ToDOListItem.self).map({$0})
    }
    // MARK: - IBActions.
    @IBAction func didTapedAddButton () {
        let entryVC = storyboard?.instantiateViewController(withIdentifier: "entry") as! EntryViewController
        entryVC.navigationItem.largeTitleDisplayMode = .never
        entryVC.title = "New Item"
        entryVC.complitionHendler = { [weak self] in
            self?.refresh()
        }
        navigationController?.pushViewController(entryVC, animated: true)
        
    }
    
    // MARK: - Private Functions.
    
    func refresh(){
        myTasks = realm.objects(ToDOListItem.self).map({$0})
        tableView.reloadData()
        
    }
    
}

// MARK: -  Delegate & DataSource.

extension BaseViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myTasks .count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = myTasks[indexPath.row].item
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = myTasks[indexPath.row]
        let showVC = storyboard?.instantiateViewController(withIdentifier: "show") as! ShowViewController
        showVC.item = item
        showVC.deletionHandler = { [weak self] in
            self?.refresh()
        }
        showVC.navigationItem.largeTitleDisplayMode = .never
        showVC.title = item.item
        
        navigationController?.pushViewController(showVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        myTasks.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") { action, view, completionHendler in
            self.myTasks.remove(at:indexPath.row)
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
            completionHendler(true)
            
        }
        tableView.reloadData()
        
        return UISwipeActionsConfiguration(actions: [deleteAction])

        
    }
    
}
    
    





