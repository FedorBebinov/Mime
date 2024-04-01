//
//  MyErrors.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 21.02.2024.
//

import UIKit

enum AuthorizationError: Error {
    case userAlreadyExists
    case userDoesNotExist
    case wrongPassword
}

enum PasswordError: Error {
    case wrongBody
    case wrongOldPassword
}

enum BackendError: Error {
    case badResponse
}
