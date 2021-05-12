//
//  Address.swift
//  CoinUsers
//
//  Created by Hovak Davtyan on 11.05.21.
//

import Foundation

protocol Address {
	var country: String { get }
	var state: String { get }
	var city: String { get }
	var streetName: String { get }
	var streetNumber: String { get }
	var latitude: Double { get }
	var longitude: Double { get }
}
