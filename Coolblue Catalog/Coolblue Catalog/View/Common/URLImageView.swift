//
//  URLImageView.swift
//  Coolblue Catalog
//
//  Created by Roman Churkin on 18.05.2022.
//

import UIKit

/// Simple solution for loading images from URL
final class URLImageView: UIImageView {
    private var dataTask: Task<Void, Never>?

    @MainActor override var image: UIImage? {
        willSet { dataTask?.cancel() }
    }
    
    func setImage(with link: String) {
        image = nil
        dataTask = Task(priority: .utility) {
            let image = await loadImage(with: link)
            self.image = image
        }
    }
    
    private func loadImage(with link: String) async -> UIImage? {
        let imageURL = URL(string: link)!
        let request = URLRequest(url: imageURL)
        do {
            let (data, _) = try await URLSession.shared.data(for: request, delegate: nil)
            return UIImage(data: data)
        } catch {
            return nil
        }
    }
    
}
