//
//  RatingView.swift
//  Coolblue Catalog
//
//  Created by Roman Churkin on 18.05.2022.
//

import UIKit

/// View for displaying product rating as 􀋆􀋆􀋆􀋆􀋆 progress bar
final class RatingView: UIView {

    // MARK: Public Properties
    
    /// Rating from 0 to 1
    var rating: Double = 1 {
        didSet { layoutIfNeeded() }
    }
    
    // MARK: - Private Properties
    
    private let starsMaskView: UIView = {
        let label = UILabel(frame: .zero)
        
        let fullString = NSMutableAttributedString(string: "")
        for _ in 1...5 {
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(systemName: "star.circle.fill")?.withTintColor(.white)
            fullString.append(NSAttributedString(attachment: imageAttachment))
        }
        label.attributedText = fullString
        
        return label
    }()
    
    private let ratingBarView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(named: "RatingColor")
        return view
    }()
    
    // MARK: - UIView
    override var intrinsicContentSize: CGSize {
        return starsMaskView.intrinsicContentSize
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSetup()
    }
    
    func initialSetup() {
        self.mask = starsMaskView
        addSubview(ratingBarView)
        backgroundColor = UIColor(named: "DisabledColor")
    }
    
    //MARK: - UIView
    
    override func layoutSubviews() {
        super.layoutSubviews()
        starsMaskView.frame = bounds
        let width = starsMaskView.intrinsicContentSize.width * rating
        ratingBarView.frame = CGRect(origin: .zero, size: CGSize(width: width, height: bounds.height))
    }
    
}
