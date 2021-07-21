//
//  ViewController.swift
//  Project7-DataFeed
//
//  Created by Matheus Lenke on 17/07/21.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filterString = ""
    var filteredPetitions = [Petition]()
    var isShowingFilteredPetitions = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let creditsButton = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(showInfo))
        let filterButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filterPetitions))
        let resetFilterButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(resetFilter))
        navigationItem.rightBarButtonItems = [filterButton, resetFilterButton]
        navigationItem.leftBarButtonItem = creditsButton
        
        performSelector(inBackground: #selector(fetchJSON), with: nil)
    }
    
    @objc func fetchJSON() {
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        
    }
    
    @objc func showError() {

        let ac = UIAlertController(title: "Loading Error", message: "There was a problem loading the feed; please check your connection and try again", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)

    }
    
    @objc func showInfo() {
        let ac = UIAlertController(title: "Info", message: "This data come from the We People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
    
    @objc func filterPetitions() {
        let ac = UIAlertController(title: "Filter", message: "Enter your filter to search in petitions", preferredStyle: .alert)
        ac.addTextField { (textField) in
            textField.text = ""
        }
        ac.addAction(UIAlertAction(title: "Ok", style: .default) { [weak ac] _ in
            self.filterString = ac?.textFields![0].text ?? ""
            if self.filterString != "" {
                self.isShowingFilteredPetitions = true
                for petition in self.petitions {
                    if (petition.title.contains(self.filterString) || petition.body.contains(self.filterString)) {
                        self.filteredPetitions.append(petition)
                    }
                }
                self.tableView.reloadData()
            }
        })
        present(ac, animated: true)
    }
    
    @objc func resetFilter() {
        isShowingFilteredPetitions = false
        filteredPetitions =  [Petition]()
        tableView.reloadData()
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            
            petitions = jsonPetitions.results
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isShowingFilteredPetitions {
            return filteredPetitions.count
        } else {
            return petitions.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition: Petition
        if isShowingFilteredPetitions {
            petition = filteredPetitions[indexPath.row]
        } else {
            petition = petitions[indexPath.row]
        }
        cell.textLabel?.text = petition.title
        cell.textLabel?.font = cell.textLabel?.font.withSize(20)
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = petition.body
        return cell;
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }

}

