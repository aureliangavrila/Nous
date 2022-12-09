//
//  StoriesRepoTests.swift
//  TestNOUSTests
//
//  Created by Aurelian Gavrila on 09.12.2022.
//

import RxSwift
import XCTest
@testable import TestNOUS

class StoriesRepoTests: XCTestCase {

    fileprivate let disposeBag = DisposeBag()
    fileprivate var sut: StoriesRepository!
    
    override func setUpWithError() throws {
        self.sut = StoriesRepositoryImplementation(networkService: NetworkService())
    }

    override func tearDownWithError() throws {
        self.sut = nil
    }
    
    func test_getStories() {
        let expectation = expectation(description: "Should get the stories")
        
        sut.getStories()
            .do(onSuccess: { stories in
                expectation.fulfill()
                
                XCTAssertEqual(stories.items.count, 8)
                XCTAssertEqual(stories.items[3].title, "Eishockey-WM-Finale: Finnland - Kanada")
            }, onError: { _ in
                expectation.fulfill()
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 2.0)
    }

}
