//
//  NetworkService.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 06.12.2023.
//

import Foundation
import KeychainAccess

class NetworkService{
    
    var isAuthorized: Bool = false
    let baseURL = "http://34.32.59.134:8080"
    let keychain = Keychain(service: "ru.hse.Mime")
    
    init(){
        isAuthorized = keychain["token"] != nil
    }
    
    func register(data: UserData) async throws {
        let url:URL = URL(string: "\(baseURL)/v1/register")!
        var request: URLRequest = URLRequest(url:url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder: JSONEncoder = JSONEncoder()
        request.httpBody = try encoder.encode(data)
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw AuthorizationError.userAlreadyExists
        }
        try validate(response)
        try await login(data: data)
    }
    
    func login(data: UserData) async throws {
        let url:URL = URL(string: "\(baseURL)/v1/login")!
        var request: URLRequest = URLRequest(url:url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder: JSONEncoder = JSONEncoder()
        request.httpBody = try encoder.encode(data)
        let (data, response) = try await URLSession.shared.data(for: request)
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 404 {
                throw AuthorizationError.userDoesNotExist
            } else if httpResponse.statusCode == 409 {
                throw AuthorizationError.wrongPassword
            }
            try validate(response)
            let decoder: JSONDecoder = JSONDecoder()
            let tokenData = try decoder.decode(TokenData.self, from: data)
            saveToken(token: tokenData.token)
        }
    }
    
    func saveAvatar(data: AvatarData) async throws {
        guard let token = keychain["token"] else{
            print("no token")
            return
        }
        let url:URL = URL(string: "\(baseURL)/v1/avatar")!
        var request: URLRequest = URLRequest(url:url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let encoder: JSONEncoder = JSONEncoder()
        request.httpBody = try encoder.encode(data)
        let (_, _) = try await URLSession.shared.data(for: request)
    }
    
    func changePassport(data: PasswordData) async throws {
        guard let token = keychain["token"] else{
            print("no token")
            return
        }
        let url:URL = URL(string: "\(baseURL)/v1/user/password")!
        var request: URLRequest = URLRequest(url:url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let encoder: JSONEncoder = JSONEncoder()
        request.httpBody = try encoder.encode(data)
        let (_, response) = try await URLSession.shared.data(for: request)
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 500 {
                throw PasswordError.wrongBody
            } else if httpResponse.statusCode == 409 {
                throw PasswordError.wrongOldPassword
            }
        }
        try validate(response)
    }
    
    func changeUsername(data: NewUsername) async throws {
        guard let token = keychain["token"] else{
            print("no token")
            return
        }
        let url:URL = URL(string: "\(baseURL)/v1/user/username")!
        var request: URLRequest = URLRequest(url:url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let encoder: JSONEncoder = JSONEncoder()
        request.httpBody = try encoder.encode(data)
        let (_, response) = try await URLSession.shared.data(for: request)
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 500 {
                throw PasswordError.wrongBody
            }
        }
        try validate(response)
    }
    
    func getUsername() async throws -> String {
        guard let token = keychain["token"] else{
            print("no token")
            return ""
        }
        let url:URL = URL(string: "\(baseURL)/v1/user/info")!
        var request: URLRequest = URLRequest(url:url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let (data, response) = try await URLSession.shared.data(for: request)
        try validate(response)
        let decoder: JSONDecoder = JSONDecoder()
        let user = try decoder.decode(UserInfo.self, from: data)
        return user.username
    }
    
    func getPassword() async throws -> String {
        guard let token = keychain["token"] else{
            print("no token")
            return ""
        }
        let url:URL = URL(string: "\(baseURL)/v1/user/1")!
        var request: URLRequest = URLRequest(url:url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let (data, response) = try await URLSession.shared.data(for: request)
        try validate(response)
        let decoder: JSONDecoder = JSONDecoder()
        let user = try decoder.decode(UserData.self, from: data)
        return user.password
    }
    
    func getAvatar() async throws -> AvatarData {
        guard let token = keychain["token"] else{
            print("no token")
            return AvatarData(type: "", color: "")
        }
        let url:URL = URL(string: "\(baseURL)/v1/avatar")!
        var request: URLRequest = URLRequest(url:url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let (data, response) = try await URLSession.shared.data(for: request)
        try validate(response)
        let decoder: JSONDecoder = JSONDecoder()
        let avatar = try decoder.decode(AvatarData.self, from: data)
        return avatar
    }
    
    func saveToken(token: String){
        keychain["token"] = token
        isAuthorized = true
    }
    
    func deleteToken() {
        keychain["token"] = nil
        isAuthorized = false
    }
    
    func validate(_ response: URLResponse) throws{
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode >= 400 {
                throw BackendError.badResponse
            }
        }
    }
}
