//
//  DetailViewController.swift
//  ReviewProject5-CountryFacts
//
//  Created by Matheus Lenke on 10/08/21.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var capitalLabel: UILabel!
    @IBOutlet var sizeLabel: UILabel!
    @IBOutlet var populationLabel: UILabel!
    @IBOutlet var currencyLabel: UILabel!
    @IBOutlet var languagesLabel: UILabel!
    @IBOutlet var presidentLabel: UILabel!
    @IBOutlet var flagImage: UIImageView!
    @IBOutlet var countryNameLabel: UILabel!
    
    var country: Country?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let safeCountry = country {
            countryNameLabel.text = safeCountry.name
            capitalLabel.text = safeCountry.capitalCity
            sizeLabel.text = "\(safeCountry.size) km2"
            populationLabel.text = "\(safeCountry.population)"
            currencyLabel.text = safeCountry.currency
            var languages = ""
            for lang in safeCountry.languages {
                languages += "\(lang) "
            }
            languagesLabel.text = languages
            presidentLabel.text = safeCountry.president
            flagImage.image = UIImage(named: safeCountry.flagImage)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func goBackTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
