//
//  RealmService.swift
//  CoinUsers
//
//  Created by Hovak Davtyan on 12.05.21.
//

import RealmSwift

import RxSwift

// MARK: - RealmServiceProtocol

protocol RealmServiceProtocol {
	func read() -> Single<[User]>
	func save(user: User) -> Single<Void>
	func delete(user: User) -> Single<Void>
}

// MARK: - RealmService

final class RealmService: RealmServiceProtocol {
	let realm: Realm

	init(realm: Realm) {
		self.realm = realm
	}

	func read() -> Single<[User]> {
		Single.create { [realm] single in
			let localUsers = Array(realm.objects(LocalUser.self))
			single(.success(localUsers))

			return Disposables.create()
		}
	}

	func save(user: User) -> Single<Void> {
		Single.create { [realm] single in
			let localUser = LocalUser(user: user)
			do {
				try realm.write { realm.add(localUser) }
				single(.success(()))
			} catch {
				single(.failure(error))
			}
			return Disposables.create()
		}
	}

	func delete(user: User) -> Single<Void> {
		Single.create { [realm] single in
			let localUser = realm.objects(LocalUser.self).filter("_id = %@", user.id)
			do {
				try realm.write { realm.delete(localUser) }
				single(.success(()))
			} catch {
				single(.failure(error))
			}
			return Disposables.create()
		}
	}
}
