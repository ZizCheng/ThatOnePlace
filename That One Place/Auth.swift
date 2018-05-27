//
//  Auth.swift
//  That One Place
//
//  Created by McKlyde Lagnada on 5/23/18.
//  Copyright © 2018 That One Place. All rights reserved.
//

import Foundation

class Auth {
    
    var Token: String?
    var Profile: Profile?
    let uuid: String
    
    var time = 0
    
    init(u: String)
    {
        uuid = u
    }
    
    func register() {
        let semaphore = DispatchSemaphore(value: 0)
        let url = URL(string: "https://thatoneplace.octohost.net/api/profile/register")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = ("uuid=" + self.uuid).data(using: .utf8)
        URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else {return}
            semaphore.signal()
        }).resume()
        
        semaphore.wait()
    }
    
    func login() -> SignIn {
        let semaphore = DispatchSemaphore(value: 0)
        let url = URL(string: "https://thatoneplace.octohost.net/api/profile/signin")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = ("uuid=" + self.uuid).data(using: .utf8)
        var info: SignIn?
        URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else {return}
            do {
                print(String(decoding: data, as: UTF8.self))
                info = try JSONDecoder().decode(SignIn.self, from: data)
                semaphore.signal()
            } catch let err {
                print(err)
            }
        }).resume()
        semaphore.wait()
        self.Token = "Bearer " + info!.token!
        self.time = info!.profile!.time!
        self.Profile = info!.profile!
        return info!
    }
}

struct SignIn: Decodable {
    var token: String?
    var profile: Profile?
}

struct Profile: Decodable {
    var lastRequest: String?
    var UUID: String?
    var time: Int?
}
