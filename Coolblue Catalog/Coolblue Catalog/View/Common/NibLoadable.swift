//
//  NibLoadable.swift
//  Coolblue Catalog
//
//  Created by Roman Churkin on 18.05.2022.
//

import UIKit

/// NibRepresentable protocol
///
/// Shows that an object can/should be instantiated with Xib
public protocol NibRepresentable: AnyObject {

    static var className: String { get }

    static var nib: UINib { get }

}

public extension NibRepresentable {

    static var className: String {
        String(describing: self)
    }

    static var nib: UINib {
        UINib(nibName: className, bundle: Bundle(for: self))
    }

}

/// NibLoadable protocol
///
/// Automates View instantiation from Xib
public protocol NibLoadable: NibRepresentable {}

public extension NibLoadable where Self: UIView {

    static func loadFromNib() -> Self {
        let results: [Any] = nib.instantiate(withOwner: self, options: nil)
        for result in results {
            if let view = result as? Self {
                return view
            }
        }
        fatalError("\(self) not found")
    }
}
