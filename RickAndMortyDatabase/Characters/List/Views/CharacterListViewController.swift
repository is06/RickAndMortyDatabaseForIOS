//
//  CharacterListViewController.swift
//  RickAndMortyDatabase
//
//  Created by Thomas Noury on 08/11/2022.
//

import UIKit

final class CharacterListViewController: UIViewController {

    private static let errorMessages: [CharacterListError : String] = [
        .noCharacter: "characterList.error.noCharacter",
        .networkError: "characterList.error.networkError",
    ]
    
    private var viewModel: CharacterListViewModelProtocol?
    
    // MARK: - Views
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Error"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let characterListView: CharacterListView = {
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
        
        self.setupViews()
        self.setupConstraints()
        
        self.viewModel?.requestCharacters()
    }
    
    // MARK: - Layout
    
    private func setupViews() {
        self.view.addSubview(self.errorLabel)
        self.view.addSubview(self.characterListView)
    }
    
    private func setupConstraints() {
        self.setupListConstraints()
        self.setupErrorConstraints()
    }
    
    private func setupListConstraints() {
        NSLayoutConstraint.activate([
            self.characterListView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8),
            self.characterListView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            self.characterListView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            self.characterListView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
        ])
    }
    
    private func setupErrorConstraints() {
        NSLayoutConstraint.activate([
            self.errorLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            self.errorLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            self.errorLabel.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }
    
    // MARK: - Actions
    
    private func showCharacters(_ characters: [Character]) {
        self.characterListView.setCharacters(characters)
        self.characterListView.isHidden = false
        self.errorLabel.isHidden = true
    }
    
    private func showError(_ error: CharacterListError) {
        guard let key = CharacterListViewController.errorMessages[error] else { return }
        self.errorLabel.text = key.localized()
        self.characterListView.isHidden = true
        self.errorLabel.isHidden = false
    }
}

extension CharacterListViewController: CharacterListViewModelDelegate {
    
    func characterListViewModel(requestCharacterDidFinishWith result: Result<[Character], CharacterListError>) {
        // Back to the main thread for updating UI
        DispatchQueue.main.async { [weak self] in
            switch result {
            case .success(let characters):
                self?.showCharacters(characters)
            case .failure(let error):
                self?.showError(error)
            }
        }
    }
}
