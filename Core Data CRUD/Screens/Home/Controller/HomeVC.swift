//
//  HomeVC.swift
//  Core Data CRUD
//
//  Created by Md Akash on 15/1/24.
//

import UIKit
import CoreData

class HomeVC: UIViewController {
    
    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var itemTableView: UITableView!
    
    private let cellIdentifier: String = "itemCell"
    
    var items: [Item]?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemTableView.delegate = self
        itemTableView.dataSource = self
        
        itemTableView.register(UINib(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        fetchItem()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Functions
    // show Save Alert View
    func showSaveAlertView() {
        let actionController = UIAlertController(title: "Add Item", message : nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Save", style: .default, handler: { (action) -> Void in
            if actionController.textFields![0].text == "" {
                print("Title")
            } else {
                guard let name = actionController.textFields?[0].text else {
                    return
                }
                
                self.itemDataSave(name)
            }
        } )
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        actionController.addAction(okAction)
        actionController.addAction(cancelAction)
        
        actionController.addTextField { textField -> Void in
            textField.placeholder = "Enter Title..."
        }
        
        self.present(actionController, animated: true, completion: nil)
    }
    
    // show Edit Alert View
    func showEditAlertView(_ itemName: String, _ indexNo: Int) {
        let actionController = UIAlertController(title: "Edit Item", message : nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Update", style: .default, handler: { (action) -> Void in
            if actionController.textFields![0].text == "" {
                print("Title")
            } else {
                guard let name = actionController.textFields?[0].text else {
                    return
                }
                
                self.updateItem(name, indexNo)
            }
        } )
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        actionController.addAction(okAction)
        actionController.addAction(cancelAction)
        
        actionController.addTextField { textField -> Void in
            textField.text = itemName
        }
        
        self.present(actionController, animated: true, completion: nil)
    }
    
    // MARK: - Action
    @IBAction func saveBarButtonItemAction(_ sender: UIBarButtonItem) {
        showSaveAlertView()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

// MARK: - Core Data

extension HomeVC {
    
    // core data save
    func itemDataSave(_ itemName: String) {
        let newItem = Item(context: self.context)
        newItem.name = itemName
        
        do {
            try self.context.save()
        } catch {
            print("Can't Save")
        }
        
        fetchItem()
    }
    
    // core data fetch
    func fetchItem() {
        do {
            let request = Item.fetchRequest() as NSFetchRequest<Item>
            self.items = try context.fetch(request)
            
            DispatchQueue.main.async {
                self.itemTableView.reloadData()
            }
        }  catch {
            print("Can't Save")
        }
    }
    
    // core data delete
    func deleteItem(_ item: Item) {
        self.context.delete(item)
        
        do {
            try self.context.save()
        } catch {
            print("Delete Error: \(error.localizedDescription)")
        }
        
        fetchItem()
    }
    
    // core data update
    func updateItem(_ itemName: String, _ indexNo: Int) {
        items?[indexNo].name = itemName
        
        do {
            try self.context.save()
        } catch {
            print("Update Error!")
        }
        
        fetchItem()
    }
    
}


// MARK: - Table View
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ItemTableViewCell {
            cell.configurateTheCell(items![indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemName = items![indexPath.row].name!
        
        showEditAlertView(itemName, indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
            // Get the item object from the array
            guard let item = self.items?[indexPath.row] else {
                completionHandler(false)
                return
            }
            // Delete the item
            self.deleteItem(item)
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}

