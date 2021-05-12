//
//  RemoteUsersViewModel.swift
//  CoinUsers
//
//  Created by Hovak Davtyan on 10.05.21.
//

import RxRelay
import RxSwift

// MARK: - RemoteUsersViewModel

final class RemoteUsersViewModel: BaseViewModel {
	// MARK: - Inputs

	let refresh = PublishRelay<Void>()
	let loadMore = PublishRelay<Void>()
	let search = BehaviorRelay(value: "")
	let save = PublishRelay<User>()
	let delete = PublishRelay<User>()

	// MARK: - Outputs

	let users = PublishRelay<[UserTableViewCell.Model]>()

	// MARK: - Services

	private let usersService: RemoteUsersServiceProtocol
	private let realmService: RealmServiceProtocol

	// MARK: - Internals

	private let isLoading = BehaviorRelay(value: false)
	private let allUsers = BehaviorRelay(value: [User]())
	private let filteredUsers = PublishRelay<[User]>()
	private let localUsers = PublishRelay<[User]>()

	init(usersService: RemoteUsersServiceProtocol, realmService: RealmServiceProtocol) {
		self.usersService = usersService
		self.realmService = realmService
		super.init()

		doBindings()
	}

	// MARK: - Reactive

	private func doBindings() {
		// MARK: - API

		let resultsPerPage = 50
		Observable.merge(refresh.asObservable(), loadMore.asObservable())
			.withLatestFrom(isLoading).filter { !$0 }
			.withLatestFrom(search).filter { $0.isEmpty }
			.withLatestFrom(allUsers) { $1.isEmpty ? 0 : $1.count / resultsPerPage }
			.do(onNext: { [isLoading] _ in isLoading.accept(true) })
			.flatMapLatest { [usersService] page in
				usersService.read(with: .init(results: resultsPerPage, page: page + 1))
					.catch { [weak self] in self?.handle($0) ?? .never() }
			}
			.do(onNext: { [isLoading] _ in isLoading.accept(false) })
			.withLatestFrom(allUsers) { $1 + $0 }
			.bind(to: allUsers)
			.disposed(by: disposeBag)

		// MARK: - Search

		search
			.withLatestFrom(allUsers) { query, users in
				users.filter { $0.searchFields.first(where: { $0.contains(query) }) != nil }
			}
			.bind(to: filteredUsers)
			.disposed(by: disposeBag)

		// MARK: - Users

		Observable.combineLatest(
			allUsers,
			filteredUsers,
			localUsers,
			search
		) { all, filtered, localUsers, search in
			let remoteUsers = filtered.isEmpty ? all : filtered
			return remoteUsers.map { remoteUser in
				.init(
					user: remoteUser,
					isSaved: localUsers.contains(where: { $0.id == remoteUser.id }),
					search: search
				)
			}
		}
		.bind(to: users)
		.disposed(by: disposeBag)

		bindRealm()
	}

	private func bindRealm() {
		refresh
			.flatMap { [realmService] in
				realmService.read()
			}
			.bind(to: localUsers)
			.disposed(by: disposeBag)

		save
			.flatMap { [realmService] user in
				realmService.save(user: user)
			}
			.flatMap { [realmService] _ in
				realmService.read()
			}
			.bind(to: localUsers)
			.disposed(by: disposeBag)

		delete
			.flatMap { [realmService] user in
				realmService.delete(user: user)
			}
			.flatMap { [realmService] _ in
				realmService.read()
			}
			.bind(to: localUsers)
			.disposed(by: disposeBag)
	}
}

// MARK: UserCellDelegate

extension RemoteUsersViewModel: UserCellDelegate {
	func didTapActionButton(for model: UserTableViewCell.Model) {
		model.isSaved ? delete.accept(model.user) : save.accept(model.user)
	}
}
