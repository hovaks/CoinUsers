//
//  RemoteUsersRequest.swift
//  CoinUsers
//
//  Created by Hovak Davtyan on 11.05.21.
//

struct RemoteUsersRequest: Encodable {
	let results: Int
	let page: Int
}
