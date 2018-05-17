//
//  Response.swift
//  PBWeather
//
//  Created by Pawan Jat on 17/05/18.
//  Copyright © 2018 PB. All rights reserved.
//

import Foundation
// To parse the JSON, add this file to your project and do:

struct ResponseModel: Codable {
    let query: Query
}

struct Query: Codable {
    let count: Int
    let created, lang: String
    let results: Results
}

struct Results: Codable {
    let channel: Channel
}

struct Channel: Codable {
    let units: Units
    let title, link, description, language: String
    let lastBuildDate, ttl: String
    let location: Location
    let wind: Wind
    let atmosphere: Atmosphere
    let astronomy: Astronomy
    let image: Image
    let item: Item
}

struct Astronomy: Codable {
    let sunrise, sunset: String
}

struct Atmosphere: Codable {
    let humidity, pressure, rising, visibility: String
}

struct Image: Codable {
    let title, width, height, link: String
    let url: String
}

struct Item: Codable {
    let title, lat, long, link: String
    let pubDate: String
    let condition: Condition
    let forecast: [Forecast]
    let description: String
    let guid: GUID
}

struct Condition: Codable {
    let code, date, temp, text: String
}

struct Forecast: Codable {
    let code, date, day, high: String
    let low: String
    let text: Text
}

enum Text: String, Codable {
    case mostlyCloudy = "Mostly Cloudy"
    case partlyCloudy = "Partly Cloudy"
}

struct GUID: Codable {
    let isPermaLink: String
}

struct Location: Codable {
    let city, country, region: String
}

struct Units: Codable {
    let distance, pressure, speed, temperature: String
}

struct Wind: Codable {
    let chill, direction, speed: String
}

