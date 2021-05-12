//
//  RemoteLocation.swift
//  CoinUsers
//
//  Created by Hovak Davtyan on 11.05.21.
//

import Foundation

struct RemoteLocation: Decodable, Hashable {
	// MARK: Street

	struct Street: Decodable, Hashable {
		let number: Int
		let name: String
	}

	// MARK: Coordinates

	struct Coordinates: Decodable, Hashable {
		let latitude, longitude: String
	}

	// MARK: Location

	let street: Street
	let city, state, country: String
	let coordinates: Coordinates
}

extension RemoteLocation: Address {
	var streetName: String { street.name }
	var streetNumber: String { String(street.number) }
	var latitude: String { coordinates.latitude }
	var longitude: String { coordinates.longitude }
}
