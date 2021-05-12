//
//  JSONDecoder+Extensions.swift
//  CoinUsers
//
//  Created by Hovak Davtyan on 12.05.21.
//

import Foundation

extension JSONDecoder {
	static var `default`: JSONDecoder = {
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		return decoder
	}()
}
