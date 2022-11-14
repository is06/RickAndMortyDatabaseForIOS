//
//  CharacterDetailViewController.swift
//  RickAndMortyDatabase
//
//  Created by Thomas Noury on 08/11/2022.
//

import UIKit

final class CharacterDetailViewController: UIViewController {
    
    init(character: Character) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
    }
}
