//
//  AddConnectionController.swift
//  Copenhacks2017
//
//  Created by Alexander Danilyak on 22/04/2017.
//  Copyright © 2017 Alexander Danilyak. All rights reserved.
//

import UIKit
import Hero
import DatePickerDialog

class AddConnectionController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addButton: UIButton!
    var user: UserModel?
    var sections: [[Any]] = []
    
    var dates: [Date?] = [nil] {
        didSet {
            addButton.isEnabled = dates[0] != nil
        }
    }
    
    var segment: UISegmentedControl?
    var selectedIndex: Int = 0
    
    var switcher: UISwitch?
    var isCondom: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        isHeroEnabled = true
        Helper.createGradientOnView(view: view, colors: Test.Result.additional.colors())
        view.heroID = "searchBack"
        
        sections = [[user!],
                    [DateCell.DateType.once],
                    [isCondom]]
    }
    
    func onSegment() {
        selectedIndex = segment!.selectedSegmentIndex
        switch segment!.selectedSegmentIndex {
        case 0:
            sections = [[user!],
                        [DateCell.DateType.once],
                        [isCondom]]
            dates = [nil]
            break
            
        case 1:
            sections = [[user!],
                        [DateCell.DateType.start, DateCell.DateType.end]]
            dates = [nil, nil]
            break
            
        default:
            return
        }
        
        tableView.reloadData()
    }
    
    func onCondom() {
        isCondom = switcher!.isOn
    }
    
    @IBAction func onAdd(_ sender: Any) {
        var mDates = dates
        if mDates.count == 1 {
            mDates.append(dates[0])
        }
        API.add(with: user!, dates: mDates, condom: isCondom) { [unowned self] json in
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
}

extension AddConnectionController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchCell
            
            cell.configure(user: sections[indexPath.section][indexPath.row] as! UserModel)
            
            cell.personName.heroID = "searchName"
            cell.personImage.heroID = "searchPicture"
            
            return cell
            
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! DateCell
            
            cell.configure(with: sections[indexPath.section][indexPath.row] as! DateCell.DateType)
            
            if dates[indexPath.row] != nil {
                cell.date.text = dates[indexPath.row]!.sti
            }
            
            return cell
            
        case 2:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "condomCell", for: indexPath) as! CondomCell
            
            switcher = cell.switcher
            cell.switcher.addTarget(self, action: #selector(onCondom), for: .valueChanged)
            
            cell.switcher.isOn = isCondom
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
            
            segment = UISegmentedControl(items: ["Once", "Regular"])
            
            segment?.addTarget(self, action: #selector(onSegment), for: .valueChanged)
            segment?.center = CGPoint(x: UIScreen.main.bounds.size.width / 2.0, y: 40.0)
            segment?.selectedSegmentIndex = selectedIndex
            segment?.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 15.0)],
                                            for: .normal)
            
            header.addSubview(segment!)
            header.backgroundColor = UIColor.clear
            header.tintColor = UIColor.white
            
            return header
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 80.0
        }
        
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            let title = indexPath.row == 0 ? "Chose start date" : "Chose end date"
            
            DatePickerDialog().show(title: title,
                                    doneButtonTitle: "Done",
                                    cancelButtonTitle: "Cancel",
                                    defaultDate: dates[indexPath.row] ?? Date(),
                                    minimumDate: nil,
                                    maximumDate: nil,
                                    datePickerMode: .date,
                                    callback: { [unowned self] date in
                
                                        self.dates[indexPath.row] = date
                                        self.tableView.reloadRows(at: [indexPath], with: .none)
                
            })
            
        }
        
    }
    
}
