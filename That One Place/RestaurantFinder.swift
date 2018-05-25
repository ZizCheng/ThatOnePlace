//
//  RestaurantFinder.swift
//  Decide For Me!
//
//  Created by Akheron on 4/21/18.
//  Copyright © 2018 Lifely. All rights reserved.
//

import UIKit
import Foundation

class RestaurantFinder {
    let Latitude: String
    let Longtitude: String
    let auth: Auth
    var restaurant: Restaurant?
    
    init(Latitude: String, Longitude: String, auth: Auth){
        self.Latitude = Latitude
        self.Longtitude = Longitude
        self.auth = auth
    }
    
    func getLatitude() -> String {
        return self.Latitude
    }
    
    func getLongtitude() -> String {
        return self.Longtitude
    }
    
    func getOne(completion: @escaping ((Restaurant) -> Void)) {
        
        let url = URL(string: "https://thatoneplace.octohost.net/api/getOnePlace")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = ("latitude=" + self.Latitude + "&longitude=" + self.Longtitude + "&uuid=" + self.auth.uuid).data(using: .utf8)
        request.addValue(auth.Token!, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else {return}
            do {
                print(String(decoding: data, as: UTF8.self))
                let restaurants = try JSONDecoder().decode(Businesses.self, from: data)
                let randomnum = Int(arc4random_uniform(UInt32(restaurants.businesses.count)))
                self.restaurant = restaurants.businesses[randomnum]
                completion(restaurants.businesses[randomnum])
            } catch let err {
                print(err)
            }
        }).resume()
        

    }
    
    func getMany(completion: @escaping (([Restaurant]) -> Void))
    {
        let url = URL(string: "https://api.yelp.com/v3/businesses/search?text=del&latitude=" + self.Latitude + "&longitude=" + self.Longtitude)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("Bearer vbE9sKBXuhf07aNjLKnMEVuEmQl3wWorOFsORfmfEno04pb4SVoeM78KIMRDd0zkiN1aDAvsYX3Dwit4hLuR9YH9vXXEYvph2vv_eovMWsEziorHQvfOz7RWfVTMWnYx", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else {return}
            do {
                let restaurants = try JSONDecoder().decode(Businesses.self, from: data)
                let ret: [Restaurant] = restaurants.businesses
                completion(ret)
            } catch let err {
                print(err)
            }
        }).resume()
    }
    
    
}

struct Restaurant: Decodable {
    let name: String?
    let image_url: String?
    let rating: Double?
    let price: String?
    let id: String?
    let phone: String?
    let display_phone: String?
    let location: RestaurantLocation
    let coordinates: coordinates
    
    func fetchImage(completion: @escaping ((UIImage) -> Void)) {
        let url = URL(string: self.image_url!)
        URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            
            do {
                let image = UIImage(data: data!)
                completion(image!)
            }
            
        }).resume()
    }
    
    func equals(r: Restaurant) -> Bool
    {
        if(self.name == r.name && self.id == r.id && self.display_phone == r.display_phone)
        {
            return true
        }
        return false
    }
    
    
    
}

struct Businesses: Decodable {
    let businesses: [Restaurant]
    let total: Int
}

struct RestaurantLocation: Decodable {
    let address1: String?
    let address2: String?
    let address3: String?
    let city: String?
    let zip_code: String?
    let country: String?
    let state: String?
    let display_address: [String]?
}

struct coordinates: Decodable {
    let latitude: Double?
    let longitude: Double?
}

struct getOnePlace {
    let wait: String?
    let message: String?
}
