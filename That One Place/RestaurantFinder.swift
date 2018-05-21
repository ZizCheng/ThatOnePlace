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
    let uuid: String
    var restaurant: Restaurant?
    
    init(Latitude: String, Longitude: String, uuid: String){
        self.Latitude = Latitude
        self.Longtitude = Longitude
        self.uuid = uuid
    }
    
    func getLatitude() -> String {
        return self.Latitude
    }
    
    func getLongtitude() -> String {
        return self.Longtitude
    }
    
    func getOne(completion: @escaping ((Restaurant) -> Void)) {
        
        let url = URL(string: "http://73.140.236.41:4000/api/getOnePlace")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = ("latitude=" + self.Latitude + "&longitude=" + self.Longtitude + "&uuid=" + self.uuid).data(using: .utf8)
        request.addValue("Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJUaGF0T25lUGxhY2UiLCJleHAiOjE1Mjg5ODE4NzIsImlhdCI6MTUyNjU2MjY3MiwiaXNzIjoiVGhhdE9uZVBsYWNlIiwianRpIjoiYzRiMGU2Y2UtZGEwMi00NTEyLWFiM2ItYzgyM2RlMDAwZDcyIiwibmJmIjoxNTI2NTYyNjcxLCJzdWIiOiIxMjMiLCJ0eXAiOiJhY2Nlc3MifQ.n1VEkxLaWiZRKSfiYc3v42vR3Ptnfj0hzCJmudrndbQhfc8fGvBWGtIeVMObsPgwtnIEILn0XRVxVLmnj5uvfw", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else {return}
            do {
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

struct getOnePlace {
    let wait: String?
    let message: String?
}
