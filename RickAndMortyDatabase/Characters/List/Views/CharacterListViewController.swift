//
//  CharacterListViewController.swift
//  RickAndMortyDatabase
//
//  Created by Thomas Noury on 08/11/2022.
//

import UIKit

final class CharacterListViewController: UIViewController {

    var viewModel: CharacterListViewModelProtocol?
    
    // MARK: - Views
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "test"
        return label
    }()
    
    let characterListView: CharacterListView = {
        let view = CharacterListView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Init
    
    init(viewModel: CharacterListViewModelProtocol = CharacterListViewModel()) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel?.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.viewModel?.getCharacters()
        
        self.setupViews()
        self.setupConstraints()
    }
    
    // MARK: - Layout
    
    private func setupViews() {
        self.view.addSubview(self.characterListView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.characterListView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8),
            self.characterListView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            self.characterListView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            self.characterListView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
        ])
    }
}

extension CharacterListViewController: CharacterListViewModelDelegate {
    
    func characterListViewModel(getCharacterDidFinishWith characters: [Character]) {
        self.characterListView.setCharacters(characters)
    }
}
