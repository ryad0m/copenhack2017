//
//  ChoseInfectionsController.swift
//  Copenhacks2017
//
//  Created by Alexander Danilyak on 22/04/2017.
//  Copyright © 2017 Alexander Danilyak. All rights reserved.
//

import UIKit
import Hero
import DatePickerDialog

class ChoseInfectionsController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var test: Test = Test()
    
    var type: Test.Result?
    
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        test.result = type!
        
        Helper.createGradientOnView(view: view, colors: type!.colors())
        
        title = type!.heroID.capitalized
        
        API.getInfections { [unowned self] json in
            self.test.infections = parseInfections(json: json)
            self.updateSendButton()
            self.tableView.reloadData()
        }
        
        view.heroID = type!.heroID
        
        sendButton.setTitleColor(type!.colors().first!, for: .normal)
    }
    
    func updateSendButton() {
        sendButton.isEnabled = test.infections.contains(where: { infection -> Bool in
            infection.include == true
        })
    }
    
    @IBAction func onSend(_ sender: Any) {
        DatePickerDialog().show(title: "When did you pass test?",
                                doneButtonTitle: "Done",
                                cancelButtonTitle: "Cancel",
                                defaultDate: Date(),
                                minimumDate: nil, maximumDate: Date(),
                                datePickerMode: .date) { [unowned self] date in
                                    self.test.date = date
                                    API.check(test: self.test, completion: { [unowned self] _ in
                                        self.navigationController?.popToRootViewController(animated: true)
                                    })
        }
    }
    
}

extension ChoseInfectionsController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return test.infections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infectionCell", for: indexPath) as! InfectionCell
        
        cell.configure(with: test.infections[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        test.infections[indexPath.row].include = !test.infections[indexPath.row].include
        updateSendButton()
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
}
