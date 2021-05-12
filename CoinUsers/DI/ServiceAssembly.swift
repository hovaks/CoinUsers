//
//  ServiceAssembly.swift
//  CoinUsers
//
//  Created by Hovak Davtyan on 10.05.21.
//

import Swinject
import SwinjectAutoregistration

import Alamofire
import RealmSwift

final class ServiceAssembly: Assembly {
	func assemble(container: Container) {
		// MARK: - Session

		container.autoregister(Session.self) {
			let session = Session()
			session.sessionConfiguration.headers = [
				"Accept": "application/json",
				"Content-Type": "application/json"
			]
			return session
		}

		// MARK: - RemoteUsersService

		container.register(RemoteUsersServiceProtocol.self) { r in
			let session = r ~> Session.self
			let encoder = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(keyEncoding: .convertToSnakeCase))
			return RemoteUsersService(session: session, encoder: encoder)
		}

		// MARK: - Realm

		container.register(Realm.self) { _ in
			do { return try Realm() }
			catch { fatalError() }
		}.inObjectScope(.container)

		container.autoregister(RealmServiceProtocol.self, initializer: RealmService.init)
	}
}
