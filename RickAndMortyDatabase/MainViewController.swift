//
//  MainViewController.swift
//  RickAndMortyDatabase
//
//  Created by Thomas Noury  on 08/11/2022.
//

import UIKit

class MainViewController: UINavigationController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let characterListViewContoller = CharacterListViewController()
        self.show(characterListViewContoller, sender: self)
    }
}
