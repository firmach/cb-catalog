//
//  ProductCell.swift
//  Coolblue Catalog
//
//  Created by Roman Churkin on 18.05.2022.
//

import UIKit

/// Product list cell
class ProductCell: UITableViewCell, NibRepresentable {
    
    /*
     It can be build in code,
     but I've decided to do it in XIB in case of this test assignment
     just to do it faster.
     */
    
    // MARK: Constants
    
    enum Strings {
        static let deliveredTomorrow = " Delivered tomorrow"
        static let availableForPickup = "Available for pickup in "
        static let stores = " stores"
        static let store = " store"
        static let reviews = " reviews"
        static let review = " review"
    }
    
    // MARK: - IB Outlets
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var photoView: URLImageView!
    @IBOutlet private var ratingView: RatingView!
    @IBOutlet private var reviewsLabel: UILabel!
    @IBOutlet private var additionalInfoStackView: UIStackView!
    @IBOutlet private var infoContainer: UIView!
    @IBOutlet private var infoLabel: UILabel!

    // MARK: - Private Properties
    
    static private let currencyFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: "nl_NL")
        return numberFormatter
    }()
    private var priceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    private let nextDayDeliveryLabel: UILabel = {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "checkmark.circle.fill")!
            .withTintColor(UIColor(named: "DeliveryColor")!)

        let fullString = NSMutableAttributedString()
        fullString.append(NSAttributedString(attachment: imageAttachment))
        fullString.append(NSAttributedString(string: Strings.deliveredTomorrow))
        
        let font = UIFont.preferredFont(forTextStyle: .callout)
        let fullStringRange = NSRange(location: 0, length: 1 + Strings.deliveredTomorrow.count)
        fullString.addAttribute(.font, value: font, range: fullStringRange)
        
        let label = UILabel(frame: .zero)
        label.textColor = UIColor(named: "DeliveryColor")!
        label.attributedText = fullString
        return label
    }()
    private let availabilityLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    // MARK: - UIView
    
    override func awakeFromNib() {
        super.awakeFromNib()
        infoContainer.layer.cornerRadius = 4
    }
    
    // MARK: - UITableViewCell
    
    override func prepareForReuse() {
        photoView.image = nil
        additionalInfoStackView.subviews.forEach { $0.removeFromSuperview() }
    }
    
    // MARK: - Public methods
    
    func configure(for product: Product) {
        // Product Name
        titleLabel.text = product.productName
        
        // Product Photo
        photoView.setImage(with: product.productImage)
        
        // Product Reviews
        if product.reviewInformation.reviewSummary.reviewCount > 1 {
            reviewsLabel.text = "\(product.reviewInformation.reviewSummary.reviewCount)" + Strings.reviews
        } else {
            reviewsLabel.text = "\(product.reviewInformation.reviewSummary.reviewCount)" + Strings.review
        }
        // converting rating from 0to10 format to 1to5
        var rating = product.reviewInformation.reviewSummary.reviewAverage*5/10
        // making it in 0.5 steps
        rating -= rating.truncatingRemainder(dividingBy: 0.5)
        ratingView.rating = rating/5 // converting to 0to1 format
        
        // USPs
        product.usps.forEach({ usp in
            let label = UILabel(frame: .zero)
            label.font = .preferredFont(forTextStyle: .callout)
            label.text = "• \(usp)"
            label.numberOfLines = 0
            additionalInfoStackView.addArrangedSubview(label)
        })
        
        // Price
        additionalInfoStackView.setCustomSpacing(16, after: additionalInfoStackView.arrangedSubviews.last!)
        priceLabel.text = ProductCell.currencyFormatter.string(for: product.salesPriceIncVat)
        additionalInfoStackView.addArrangedSubview(priceLabel)
        
        // Next Day Delivery
        if product.nextDayDelivery {
            additionalInfoStackView.addArrangedSubview(nextDayDeliveryLabel)
        }

        // Availability State
        additionalInfoStackView.setCustomSpacing(8, after: additionalInfoStackView.arrangedSubviews.last!)
        switch product.availabilityState {
        case 0:
            break
        case 1:
            availabilityLabel.text = Strings.availableForPickup + String(product.availabilityState) + Strings.store
            additionalInfoStackView.addArrangedSubview(availabilityLabel)
        default:
            availabilityLabel.text = Strings.availableForPickup + String(product.availabilityState) + Strings.stores
            additionalInfoStackView.addArrangedSubview(availabilityLabel)
        }
        
        // Coolblues Choice
        infoContainer.isHidden = product.coolbluesChoiceInformationTitle == nil
        infoLabel.text = product.coolbluesChoiceInformationTitle
    }
    
}
