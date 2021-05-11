//
//  RemoteUsersResponse.swift
//  CoinUsers
//
//  Created by Hovak Davtyan on 11.05.21.
//

struct RemoteUsersResponse: Decodable {
	let results: [RemoteUser]
}
