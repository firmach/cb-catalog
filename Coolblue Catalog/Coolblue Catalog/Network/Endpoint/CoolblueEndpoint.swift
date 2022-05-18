//
//  CoolblueEndpoint.swift
//  Coolblue Catalog
//
//  Created by Roman Churkin on 18.05.2022.
//


/// Base endpoint for Coolblue requests.
///
/// Response data should contain meta information.
protocol CoolblueEndpoint: Endpoint {}

extension CoolblueEndpoint {

    var host: String { NetworkConstants.baseURL }

}
