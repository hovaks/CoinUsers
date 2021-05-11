//
//  UsersService.swift
//  CoinUsers
//
//  Created by Hovak Davtyan on 11.05.21.
//

import Foundation

import Alamofire

import RxSwift

// MARK: - AlertableError

protocol AlertableError: Error {
	var title: String? { get }
	var message: String? { get }
}

// MARK: - ServiceError

enum RemoteServiceError: AlertableError {
	case networkError(title: String? = "Network Error", message: String? = nil)

	var title: String? {
		switch self {
		case .networkError(let title, _): return title
		}
	}

	var message: String? {
		switch self {
		case .networkError(_, let message): return message
		}
	}
}

// MARK: - UsersServiceProtocol

protocol RemoteUsersServiceProtocol {
	func read(with parameters: RemoteUsersRequest) -> Single<[User]>
}

// MARK: - UsersService

final class RemoteUsersService: RemoteUsersServiceProtocol {
	private let session: Session
	private let encoder: URLEncodedFormParameterEncoder

	init(session: Session, encoder: URLEncodedFormParameterEncoder) {
		self.session = session
		self.encoder = encoder
	}

	func read(with parameters: RemoteUsersRequest) -> Single<[User]> {
		return Single.create { [weak self] single in
			guard let self = self else { return Disposables.create() }
			self.session.request(Endpoints.users, parameters: parameters, encoder: self.encoder)
				.validate()
				.responseDecodable(
					of: RemoteUsersResponse.self,
					decoder: JSONDecoder.default
				) { response in
					switch response.result {
					case .success(let value):
						single(.success(value.results))
					case .failure(let error):
						single(.failure(RemoteServiceError.networkError(message: error.errorDescription)))
					}
				}
				.cURLDescription { description in
					print(description)
				}
			return Disposables.create()
		}
	}
}
