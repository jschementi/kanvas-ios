//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import Foundation
import UIKit

/// Delegate for touch events on this cell
protocol StickerCollectionCellDelegate: class {
    /// Callback method when tapping a cell
    ///
    /// - Parameters:
    ///   - cell: the cell that was tapped
    ///   - recognizer: the tap gesture recognizer
    func didTap(cell: StickerCollectionCell, recognizer: UITapGestureRecognizer)
}

/// Constants for StickerCollectionCell
private struct Constants {
    static let height: CGFloat = 80
    static let width: CGFloat = 80
}

/// The cell in StickerCollectionView to display an individual sticker
final class StickerCollectionCell: UICollectionViewCell {
    
    static let height = Constants.height
    static let width = Constants.width
    
    private var imageTask: URLSessionTask?
    private let stickerView = UIImageView()
    
    weak var delegate: StickerCollectionCellDelegate?
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        setUpRecognizers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
        setUpRecognizers()
    }
    
    /// Updates the cell according to the sticker properties
    ///
    /// - Parameter sticker: The sticker to display
    func bindTo(_ sticker: Sticker, cache: NSCache<NSString, UIImage>) {
        if let image = cache.object(forKey: NSString(string: sticker.imageUrl)) {
            stickerView.image = image
        }
        else {
            imageTask = stickerView.load(from: sticker.imageUrl) { url, image in
                cache.setObject(image, forKey: NSString(string: url.absoluteString))
            }
        }
    }
    
    /// Updates the cell to be reused
    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        stickerView.image = nil
        stickerView.backgroundColor = nil
    }
    
    // MARK: - Layout
    
    private func setUpView() {
        contentView.addSubview(stickerView)
        stickerView.accessibilityIdentifier = "Sticker Collection Cell View"
        stickerView.translatesAutoresizingMaskIntoConstraints = false
        stickerView.contentMode = .scaleAspectFit
        stickerView.clipsToBounds = false
        stickerView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            stickerView.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor),
            stickerView.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
            stickerView.heightAnchor.constraint(equalToConstant: Constants.height),
            stickerView.widthAnchor.constraint(equalToConstant: Constants.width)
        ])
    }
    
    // MARK: - Gesture recognizers
    
    private func setUpRecognizers() {
        let tapRecognizer = UITapGestureRecognizer()
        contentView.addGestureRecognizer(tapRecognizer)
        tapRecognizer.addTarget(self, action: #selector(handleTap(recognizer:)))
    }
    
    @objc private func handleTap(recognizer: UITapGestureRecognizer) {
        delegate?.didTap(cell: self, recognizer: recognizer)
    }
}
