//
//  ViewController.swift
//  ReviewProject2-ShoppingList
//
//  Created by Matheus Lenke on 16/07/21.
//

import UIKit

class ViewController: UITableViewController {
    
    var shoppingItems:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Shopping List"
        navigationController?.navigationBar.prefersLargeTitles = true
        let refreshButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshList))
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        navigationItem.rightBarButtonItems = [addButtonItem, shareButton]
        navigationItem.leftBarButtonItem = refreshButtonItem
    }
    
    @objc func refreshList() {
        shoppingItems = []
        tableView.reloadData()
    }
    
    @objc func addItem() {
        let ac = UIAlertController(title: "Add new Item", message: "Please write the name of the shopping item", preferredStyle: .alert)
        ac.addTextField(configurationHandler: nil)
        ac.addAction( UIAlertAction(title: "Add", style: .default) {
            [weak self, weak ac] _ in
            guard let safeText = ac?.textFields?[0].text else { return }
        
            self?.shoppingItems.insert(safeText, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            self?.tableView.insertRows(at: [indexPath], with: .automatic)
            
        })
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        cell.textLabel?.text = shoppingItems[indexPath.row]
        cell.accessoryType = .none
        cell.selectionStyle = .none
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingItems.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .none {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }

        }
    }
    
    @objc func shareTapped() {
        let list = shoppingItems.joined(separator: "\n")
        
        let vc = UIActivityViewController(activityItems: [list], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

}

