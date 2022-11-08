//
//  WhatMovieToWatchZTests.swift
//  WhatMovieToWatchZTests
//
//  Created by SofyanZ on 07/11/2022.
//

import XCTest
@testable import WhatMovieToWatchZ
import FirebaseCore

final class MovieManagerTest: XCTestCase {
    
    override func setUp() {
        let appOptions = FirebaseOptions(
            googleAppID: "1:323818250208:ios:4c65e1f62969fecb9e9585",
            gcmSenderID: "323818250208"
        )
        appOptions.apiKey = "AIzaSyAVe5QwTOE-w1CO60kHpH2tpGh25MSuxpA"
        appOptions.projectID = "whatmovietowatchz"
        FirebaseApp.configure(options: appOptions)
    }
    
    // test if callback returns an error
    func testMovieManagerShouldPostFailedCallbackIfError() {
        
        // Given
        let session = URLSessionFake(data: nil, response: nil, error: FakeResponseData.error)
        let movieManager = MovieManager(session: session)

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        movieManager.fetchMovies(page: 1, sort: "") { result in
            // Then
            guard case .failure(let error) = result else {
                XCTFail("Test request method with an error failed")
                return
            }
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)

    }

    // test if callback doesn't return data
    func testMovieManagerShouldPostFailedCallbackIfNoData() {

        // Given
        let session = URLSessionFake(data: nil, response: nil, error: nil)
        let movieManager = MovieManager(session: session)

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        movieManager.fetchMovies(page: 1, sort: "") { result in
            // Then
            guard case .failure(let error) = result else {
                XCTFail("Test request method with an error failed")
                return
            }
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)

    }


    // test if callback returns incorrect data
    func testMovieManagerShouldPostFailedCallbackIncorrectData() {

        // Given
        let session = URLSessionFake(data: FakeResponseData.movieIncorrectData, response: FakeResponseData.responseOK, error: nil)
        let movieManager = MovieManager(session: session)

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        movieManager.fetchMovies(page: 1, sort: "") { result in
            // Then
            guard case .failure(let error) = result else {
                XCTFail("Test request method with an error failed")
                return
            }
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)

    }

    // test if callback returns success with no error and correct data
    func testMovieManagerShouldPostSuccessCallbackIfNoErrorAndCorrectData() {

        //Given
        let session = URLSessionFake(data: FakeResponseData.movieCorrectData, response: FakeResponseData.responseOK, error: nil)
        let movieManager = MovieManager(session: session)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        movieManager.fetchMovies(page: 1, sort: "") { result in
            // Then
            guard case .success(_) = result else {
                XCTFail("Test request method with an error failed")
                return
            }

            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)

    }
}
