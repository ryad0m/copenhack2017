//
//  MainController.swift
//  Copenhacks2017
//
//  Created by Alexander Danilyak on 22/04/2017.
//  Copyright © 2017 Alexander Danilyak. All rights reserved.
//

import UIKit
import Hero

class MainController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var sections: [[Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.contentInset = UIEdgeInsetsMake(7.5, 0.0, 0.0, 0.0)
        
        if !AuthModel.shared.isSignedIn {
            openSignIn()
        }
        
        sections = [[Test.Result.negative, Test.Result.positive],
                    [Test.Result.additional]]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
    }
    
    func openSignIn(animated: Bool = false) {
        let vc = Helper.mainStoryboard.instantiateViewController(withIdentifier: "signIn")
        present(vc, animated: animated, completion: nil)
    }
    
    @IBAction func onLogOut(_ sender: Any) {
        AuthModel.shared.clear()
        openSignIn(animated: true)
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
        case 0,1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainSmallCell", for: indexPath) as! MainSmallCell
            
            cell.configure(for: sections[indexPath.section][indexPath.row] as! Test.Result)
            
            switch (indexPath.section, indexPath.row) {
            case (1,0):
                cell.heroID = "searchBack"
            default:
                break
            }
            
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        Helper.createGradientOnView(view: cell, colors: (sections[indexPath.section][indexPath.row] as! Test.Result).colors())
        cell.layer.cornerRadius = 13.0
        cell.layer.masksToBounds = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            break
        case 1:
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
            return CGSize(width: (UIScreen.main.bounds.width - 45.0) / 2.0,
                          height: (UIScreen.main.bounds.width - 45.0) / 1.5)
        case 1:
            return CGSize(width: (UIScreen.main.bounds.width - 30.0),
                          height: (UIScreen.main.bounds.width - 45.0) / 2.5)
        default:
            return .zero
        }
        
    }
    
}
