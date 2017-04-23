//
//  MainController.swift
//  Copenhacks2017
//
//  Created by Alexander Danilyak on 22/04/2017.
//  Copyright © 2017 Alexander Danilyak. All rights reserved.
//

import UIKit
import Hero

let updateNotification: Notification.Name = Notification.Name("updateNotification")

class MainController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var sections: [[Any?]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.contentInset = UIEdgeInsetsMake(7.5, 0.0, 0.0, 0.0)
        
        sections = [[nil],
                    [Test.Result.negative, Test.Result.positive],
                    [Test.Result.additional]]
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateMe),
                                               name: updateNotification,
                                               object: nil)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !AuthModel.shared.isSignedIn {
            openSignIn()
        } else {
            updateMe()
        }
    }
    
    func openSignIn(animated: Bool = false) {
        let vc = Helper.mainStoryboard.instantiateViewController(withIdentifier: "signIn")
        present(vc, animated: animated, completion: nil)
    }
    
    @IBAction func onLogOut(_ sender: Any) {
        AuthModel.shared.clear()
        openSignIn(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInfections" {
            let result = sender as! Test.Result
            (segue.destination as! ChoseInfectionsController).type = result
        } else if segue.identifier == "toMe" {
            (segue.destination as! MeController).me = (sender as! MeModel)
        }
    }
    
    func updateMe() {
        if let cell = collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? MainMeCell {
            cell.start()
        }
        
        API.me(completion: { [unowned self] json in
            let me = MeModel(with: json)
            self.sections[0] = [me]
            self.collectionView.reloadSections(IndexSet(integer: 0))
        })
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        if motion == .motionShake {
            if AuthModel.shared.isSignedIn {
                onLogOut(self)
            }
        }
    }
    
}

extension MainController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainMeCell", for: indexPath) as! MainMeCell
            
            if sections[indexPath.section][indexPath.row] != nil {
                cell.configure(with: sections[indexPath.section][indexPath.row] as! MeModel)
                cell.isUserInteractionEnabled = true
            } else {
                cell.start()
                cell.isUserInteractionEnabled = true
            }
            
            return cell
            
        case 1,2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainSmallCell", for: indexPath) as! MainSmallCell
            
            cell.configure(for: sections[indexPath.section][indexPath.row] as! Test.Result)
            
            switch (indexPath.section, indexPath.row) {
            case (2,0):
                cell.heroID = "searchBack"
            case (1,0),(1,1):
                cell.heroID = (sections[indexPath.section][indexPath.row] as! Test.Result).heroID
            default:
                break
            }
            
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            Helper.createGradientOnView(view: cell, colors: (sections[indexPath.section][indexPath.row] as! Test.Result).colors())
        }
        cell.layer.cornerRadius = 13.0
        cell.layer.masksToBounds = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            performSegue(withIdentifier: "toMe", sender: sections[indexPath.section][indexPath.row])
            
        case 1:
            
            switch indexPath.row {
            case 0,1:
                performSegue(withIdentifier: "toInfections", sender: sections[indexPath.section][indexPath.row])
            default:
                break
            }
            
        case 2:
            performSegue(withIdentifier: "toSearch", sender: nil)
        default:
            break
        }
    }
    
}

extension MainController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(7.5, 15.0, 7.5, 15.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch indexPath.section {
        case 0:
            return CGSize(width: (UIScreen.main.bounds.width - 30.0),
                          height: (UIScreen.main.bounds.width - 45.0) / 2.5)
        case 1:
            return CGSize(width: (UIScreen.main.bounds.width - 45.0) / 2.0,
                          height: (UIScreen.main.bounds.width - 45.0) / 1.5)
        case 2:
            return CGSize(width: (UIScreen.main.bounds.width - 30.0),
                          height: (UIScreen.main.bounds.width - 45.0) / 2.5)
        default:
            return .zero
        }
        
    }
    
}
