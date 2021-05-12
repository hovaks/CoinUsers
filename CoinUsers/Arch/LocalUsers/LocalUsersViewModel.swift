//
//  LocalUsersViewModel.swift
//  CoinUsers
//
//  Created by Hovak Davtyan on 10.05.21.
//

import RxRelay
import RxSwift

final class LocalUsersViewModel: BaseViewModel {
	// MARK: - Inputs

	let refresh = PublishRelay<Void>()
	let search = BehaviorRelay(value: "")

	// MARK: - Outputs

	let users = PublishRelay<[UserTableViewCell.Model]>()

	// MARK: - Internals

	private let allUsers = BehaviorRelay(value: [User]())
	private let filteredUsers = PublishRelay<[User]>()
	private let delete = PublishRelay<User>()

	// MARK: - Services

	private let realmService: RealmServiceProtocol

	// MARK: - Init

	init(realmService: RealmServiceProtocol) {
		self.realmService = realmService
		super.init()

		doBindings()
	}

	// MARK: - Reactive

	private func doBindings() {
		// Read
		refresh
			.flatMap { [realmService] in
				realmService.read()
			}
			.bind(to: allUsers)
			.disposed(by: disposeBag)

		// Search

		search
			.withLatestFrom(allUsers) { query, users in
				users.filter { $0.searchFields.first(where: { $0.contains(query) }) != nil }
			}
			.bind(to: filteredUsers)
			.disposed(by: disposeBag)

		Observable.combineLatest(allUsers, filteredUsers, search) { all, filtered, search in
			let users = filtered.isEmpty ? all : filtered
			return users.map { .init(user: $0, isSaved: true, search: search) }
		}
		.bind(to: users)
		.disposed(by: disposeBag)

		// Delete
		delete
			.flatMap { [realmService] user in
				realmService.delete(user: user)
			}
			.flatMap { [realmService] _ in
				realmService.read()
			}
			.bind(to: allUsers)
			.disposed(by: disposeBag)
	}
}

// MARK: UserCellDelegate

extension LocalUsersViewModel: UserCellDelegate {
	func didTapActionButton(for model: UserTableViewCell.Model) {
		guard model.isSaved else { fatalError() }
		delete.accept(model.user)
	}
}
