//
//  RemoteUser.swift
//  CoinUsers
//
//  Created by Hovak Davtyan on 11.05.21.
//

import Foundation

// MARK: - RemoteUser

struct RemoteUser: Decodable {
	// MARK: - Nested

	struct Login: Decodable, Hashable {
		let uuid: String
	}

	struct Name: Decodable, Hashable {
		let title: String
		let first: String
		let last: String
	}

	enum Gender: String, Decodable {
		case male
		case female
	}

	struct DateOfBirth: Decodable {
		let age: Int
	}

	struct Picture: Decodable, Hashable {
		let thumbnail: URL
		let medium: URL
		let large: URL
	}

	// MARK: - RemoteUser

	let login: Login
	let name: Name
	let gender: Gender
	let dob: DateOfBirth
	let email: String
	let phone: String
	let location: RemoteLocation
	let picture: Picture
}

extension RemoteUser: User {
	var id: String { login.uuid }
	var avatar: URL { picture.large }
	var title: String { name.title }
	var firstName: String { name.first }
	var lastName: String { name.last }
	var age: Int { dob.age }
	var address: Address { location }
}
