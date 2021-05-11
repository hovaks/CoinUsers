//
//  RemoteUsersViewModel.swift
//  CoinUsers
//
//  Created by Hovak Davtyan on 10.05.21.
//

import RxRelay
import RxSwift

final class RemoteUsersViewModel: BaseViewModel {
	// MARK: - Inputs

	let refresh = PublishRelay<Void>()

	// MARK: - Outputs

	let users = PublishRelay<[User]>()

	// MARK: - Services

	private let usersService: RemoteUsersServiceProtocol

	init(usersService: RemoteUsersServiceProtocol) {
		self.usersService = usersService
		super.init()

		doBindings()
	}

	// MARK: - Reactive

	private func doBindings() {
		refresh
			.flatMapLatest { [usersService] in
				usersService.read(with: .init(results: 50, page: 1))
					.catch { [weak self] in self?.handle($0) ?? .never() }
			}
			.bind(to: users)
			.disposed(by: disposeBag)
	}
}
