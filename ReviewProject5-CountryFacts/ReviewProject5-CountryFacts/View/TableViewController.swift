//
//  ViewController.swift
//  ReviewProject5-CountryFacts
//
//  Created by Matheus Lenke on 10/08/21.
//

import UIKit

class TableViewController: UITableViewController {
    var countries = [Country]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = Bundle.main.url(forResource: "countries", withExtension: "json") {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            }
        }
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = countries[indexPath.row].name
        cell.textLabel?.font = cell.textLabel?.font.withSize(20)
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDetailView", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DetailViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.country = countries[indexPath.row]
        }
    }
    
    //MARK: - Parsing data Methods
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        do {
            let jsonCountries = try decoder.decode(Countries.self, from: json)
            countries = jsonCountries.countries
            tableView.reloadData()
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }

}

