//
//  RecipleaseObjects.swift
//  Reciplease
//
//  Created by Thibault Bargat on 25/03/2019.
//  Copyright © 2019 Thibault Bargat. All rights reserved.
//
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseWelcome { response in
//     if let welcome = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

struct RecipeObject: Codable {
    let criteria: Criteria?
    let recipes: [Recipe]?
    let facetCounts: FacetCounts?
    let totalMatchCount: Int?
    let attribution: Attribution?
    
    enum CodingKeys: String, CodingKey {
        case criteria = "criteria"
        case recipes = "matches"
        case facetCounts = "facetCounts"
        case totalMatchCount = "totalMatchCount"
        case attribution = "attribution"
    }
}

struct Attribution: Codable {
    let html: String?
    let url: String?
    let text: String?
    let logo: String?
    
    enum CodingKeys: String, CodingKey {
        case html = "html"
        case url = "url"
        case text = "text"
        case logo = "logo"
    }
}

struct Criteria: Codable {
    let allowedIngredient: [String]?
    let q: JSONNull?
    let excludedIngredient: JSONNull?
    
    enum CodingKeys: String, CodingKey {
        case allowedIngredient = "allowedIngredient"
        case q = "q"
        case excludedIngredient = "excludedIngredient"
    }
}

struct FacetCounts: Codable {
}

struct Recipe: Codable {
    let imageUrlsBySize: ImageUrlsBySize?
    let sourceDisplayName: String?
    let ingredients: [String]?
    let id: String?
    let smallImageUrls: [String]?
    let recipeName: String?
    let totalTimeInSeconds: Int?
    let attributes: Attributes?
    let flavors: Flavors?
    let rating: Int?
    
    enum CodingKeys: String, CodingKey {
        case imageUrlsBySize = "imageUrlsBySize"
        case sourceDisplayName = "sourceDisplayName"
        case ingredients = "ingredients"
        case id = "id"
        case smallImageUrls = "smallImageUrls"
        case recipeName = "recipeName"
        case totalTimeInSeconds = "totalTimeInSeconds"
        case attributes = "attributes"
        case flavors = "flavors"
        case rating = "rating"
    }
}

struct Attributes: Codable {
    let course: [String]?
    let cuisine: [String]?
    let holiday: [String]?
    
    enum CodingKeys: String, CodingKey {
        case course = "course"
        case cuisine = "cuisine"
        case holiday = "holiday"
    }
}

struct Flavors: Codable {
    let piquant: Double?
    let meaty: Double?
    let bitter: Double?
    let sweet: Double?
    let sour: Double?
    let salty: Double?
    
    enum CodingKeys: String, CodingKey {
        case piquant = "piquant"
        case meaty = "meaty"
        case bitter = "bitter"
        case sweet = "sweet"
        case sour = "sour"
        case salty = "salty"
    }
}

struct ImageUrlsBySize: Codable {
    let the90: String?
    
    enum CodingKeys: String, CodingKey {
        case the90 = "90"
    }
}

// MARK: Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

fileprivate func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

fileprivate func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

// MARK: - Alamofire response handlers

extension DataRequest {
    fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            guard error == nil else { return .failure(error!) }
            
            guard let data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }
            
            return Result { try newJSONDecoder().decode(T.self, from: data) }
        }
    }
    
    @discardableResult
    fileprivate func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseWelcome(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<RecipeObject>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
