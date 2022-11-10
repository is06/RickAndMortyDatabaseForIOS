//
//  UIImageView+FromUrl.swift
//  RickAndMortyDatabase
//
//  Created by Thomas Noury  on 09/11/2022.
//

import UIKit

extension UIImageView {
    func loadFrom(_ url: URL, size: CGSize? = nil) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async { [weak self] in
                guard let imageData = data else { return }
                guard let image = UIImage(data: imageData) else { return }
                if let size = size {
                    self?.image = image.resizeTo(size: size)
                } else {
                    self?.image = image
                }   
            }
        }
        task.resume()
    }
}
