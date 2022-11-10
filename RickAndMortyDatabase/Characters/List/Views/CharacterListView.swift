//
//  CharacterListView.swift
//  RickAndMortyDatabase
//
//  Created by Thomas Noury on 08/11/2022.
//

import UIKit

protocol CharacterListViewProtocol {
    func setCharacters(_ characters: [Character])
}

protocol CharacterListViewDelegate: AnyObject {
    func characterListView(didTap character: Character)
}

final class CharacterListView: UIView, CharacterListViewProtocol {
    
    private var characters: [Character]?
    
    weak var delegate: CharacterListViewDelegate?
    
    // MARK: - Views
    
    let tableView: UITableView = {
        let view = UITableView()
        view.register(CharacterListItemView.self, forCellReuseIdentifier: "characterCell")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.rowHeight = 76
        return view
    }()
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.setupViews()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    func setCharacters(_ characters: [Character]) {
        self.characters = characters
        self.tableView.reloadData()
    }
    
    // MARK: - Layout
    
    private func setupViews() {
        self.addSubview(self.tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}

extension CharacterListView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.characters?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "characterCell") as? CharacterListItemView else { return UITableViewCell() }
        guard let character = characters?[indexPath.row] else { return UITableViewCell() }
        
        cell.nameLabel.text = character.name
        
        guard let url = URL(string: character.imageUrl) else { return UITableViewCell() }
        cell.avatarView.loadFrom(url, size: CGSize(width: 48, height: 48))
        
        return cell
    }
}

extension CharacterListView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let character = self.characters?[indexPath.row] else { return }
        self.delegate?.characterListView(didTap: character)
    }
}
