//
//  CharacterListItemView.swift
//  RickAndMortyDatabase
//
//  Created by Thomas Noury  on 08/11/2022.
//

import UIKit

final class CharacterListItemView: UITableViewCell {
    
    // MARK: - Views
    
    let avatarView: UIImageView = {
        let view = UIImageView(image: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "characterCell")
        
        self.setupViews()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func setupViews() {
        self.addSubview(self.avatarView)
        self.addSubview(self.nameLabel)
    }
    
    private func setupConstraints() {
        self.setupAvatarConstraints()
        self.setupNameConstraints()
    }
    
    private func setupAvatarConstraints() {
        NSLayoutConstraint.activate([
            self.avatarView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.avatarView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.avatarView.widthAnchor.constraint(equalToConstant: 48),
        ])
    }
    
    private func setupNameConstraints() {
        NSLayoutConstraint.activate([
            self.nameLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.nameLabel.leadingAnchor.constraint(equalTo: self.avatarView.trailingAnchor, constant: 16),
            self.nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}
