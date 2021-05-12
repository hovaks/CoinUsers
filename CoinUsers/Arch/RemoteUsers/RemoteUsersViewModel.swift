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

	// MARK: - Outputs

	let users = BehaviorRelay(value: [User]())

	// MARK: - Services

	private let usersService: RemoteUsersServiceProtocol

	// MARK: - Internals

	private let isLoading = BehaviorRelay(value: false)

	init(usersService: RemoteUsersServiceProtocol) {
		self.usersService = usersService
		super.init()

		doBindings()
	}

	// MARK: - Reactive

	private func doBindings() {
		let resultsPerPage = 50
		Observable.merge(refresh.asObservable(), loadMore.asObservable())
			.withLatestFrom(isLoading).filter { !$0 }
			.withLatestFrom(users)
			.map { $0.isEmpty ? 0 : $0.count / resultsPerPage }
			.do(onNext: { [isLoading] _ in isLoading.accept(true) })
			.flatMapLatest { [usersService] page in
				usersService.read(with: .init(results: resultsPerPage, page: page + 1))
					.catch { [weak self] in self?.handle($0) ?? .never() }
			}
			.do(onNext: { [isLoading] _ in isLoading.accept(false) })
			.withLatestFrom(users) { $1 + $0 }
			.bind(to: users)
			.disposed(by: disposeBag)
	}
}

// MARK: UserCellDelegate

extension RemoteUsersViewModel: UserCellDelegate {
	func didTapSaveButton(user: User) {
		print(user)
	}
}
