//
//  MeController.swift
//  Copenhacks2017
//
//  Created by Alexander Danilyak on 23/04/2017.
//  Copyright © 2017 Alexander Danilyak. All rights reserved.
//

import UIKit

class MeController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var me: MeModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWeb" {
            (segue.destination as! WebController).name = (sender as! InfectionModel).name
            (segue.destination as! WebController).url = (sender as! InfectionModel).url
        }
    }
    
}

extension MeController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return me!.scores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infectionMeCell", for: indexPath) as! InfectionMeCell
        
        cell.configure(with: me!.scores[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if me!.scores[indexPath.row].infection.url != nil {
            performSegue(withIdentifier: "toWeb", sender: me!.scores[indexPath.row].infection)
        }
    }
    
}
