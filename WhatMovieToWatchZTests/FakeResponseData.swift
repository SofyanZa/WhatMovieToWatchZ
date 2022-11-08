//
//  FakeResponseData.swift
//  WhatMovieToWatchZ
//
//  Created by Sofyan Zarouri on 23/08/2022 
//  Copyright © 2022 Sofyan Zarouri. All rights reserved.
//
import Foundation

class FakeResponseData {
    // MARK: - Response
    /// Fausse bonne reponse 200
    static let responseOK = HTTPURLResponse(
        url: URL(string: "https://apple.com")!,
        statusCode: 200, httpVersion: nil, headerFields: [:])!
    /// Fausse mauvaise reponse 500
    static let responseKO = HTTPURLResponse(
        url: URL(string: "https://apple.com")!,
        statusCode: 500, httpVersion: nil, headerFields: [:])!

    // MARK: - Data
    /// Les fausses bonnes données issues du fichier json movies
    static var movieCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "movies", withExtension: "json")!
        return try? Data(contentsOf: url)
    }
    
    /// Fausse mauvaise donnée
    static let movieIncorrectData = "erreur".data(using: .utf8)!
    
    // MARK: - Error
    class testError: Error {}
    static let error = testError()
}
