//
//  FishSpeciesViewController.swift
//  ScanAFish
//
//  Created by Németh Bendegúz on 2017. 10. 23..
//  Copyright © 2017. Németh Bendegúz. All rights reserved.
//

import UIKit

class FishSpeciesViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? WebViewController
            else { fatalError("unexpected view controller for segue") }
        guard let cell = sender as? UITableViewCell else { fatalError("unexpected sender") }
        destination.textOfLabel = (cell.textLabel?.text)!
        destination.isCameraButtonHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fishSpecies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FishCell", for: indexPath)
        
        cell.textLabel?.text = fishSpecies[indexPath.row]
        
        return cell
    }
    
    let fishSpecies = [
        "",
        "apteronotus albifrons",
        "betta splendens",
        "carnegiella strigata",
        "celestichthys margaritatus",
        "chromobotia macracanthus",
        "corydoras aeneus",
        "corydoras duplicareus",
        "corydoras paleatus",
        "crossocheilus oblongus",
        "ctenopoma acutirostre",
        "goldfish",
        "gymnocorymbus ternetzi",
        "hoplosternum thoracatum",
        "hyphessobrycon amandae",
        "hyphessobrycon herbertaxelrodi",
        "hyphessobrycon megalopterus",
        "hyphessobrycon pulchripinnis",
        "labeo bicolor",
        "labidochromis caeruleus",
        "melanochromis cyaneorhabdos",
        "melanotaenia boesemani",
        "mikrogeophagus ramirezi",
        "neolamprologus buescheri kamakonde",
        "osteoglossum bicirrhosum",
        "paracheirodon axelrodi",
        "paracheirodon innesi",
        "pethia conchonius",
        "petitella georgiae",
        "poecilia sphenops",
        "puntigrus tetrazona",
        "rocio octofasciata",
        "synodontis petricola",
        "tanichthys albonubes",
        "tropheus ikola",
        "xiphophorus helleri"]
}

