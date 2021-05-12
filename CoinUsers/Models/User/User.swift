//
//  User.swift
//  CoinUsers
//
//  Created by Hovak Davtyan on 11.05.21.
//

import Foundation

protocol User {
	var id: String { get }
	var avatar: URL { get }
	var title: String { get }
	var firstName: String { get }
	var lastName: String { get }
	var genderSign: String { get }
	var age: Int { get }
	var email: String { get }
	var phone: String { get }
	var address: Address { get }
}

extension User {
	var fullName: String { firstName + " " + lastName }
	var addressText: String { address.country + ", " + address.state + ", " + address.city }
	var searchFields: [String] { [fullName, email, phone, addressText] }
}
