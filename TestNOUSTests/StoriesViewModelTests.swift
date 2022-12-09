//
//  StoriesViewModelTests.swift
//  TestNOUSTests
//
//  Created by Aurelian Gavrila on 09.12.2022.
//

import RxSwift
import XCTest
@testable import TestNOUS

class StoriesViewModelTests: XCTestCase {

    private let disposeBag = DisposeBag()
    fileprivate var sut: StoriesViewModel!
    fileprivate var repo: StoriesRepository!
    
    override func setUpWithError() throws {
        self.repo = MockStoriesRepository()
        self.sut = StoriesViewModel(storiesRepo: repo)
    }

    override func tearDownWithError() throws {
        self.repo = nil
        self.sut = nil
    }
  
    func test_getStories() {
        sut.filteredStoriesObservable
            .do(onNext: { stories in
                XCTAssertEqual(stories.count, 2)
                XCTAssertEqual(stories.first!.title, "Der Alte: Vergiftete Freundschaft")
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    func test_filteringStories() {
        sut.searchTextRelay.accept("Finale")
        
        sut.filteredStoriesObservable
            .do(onNext: { stories in
                XCTAssertEqual(stories.count, 1)
                XCTAssertEqual(stories.first!.title, "Eishockey-WM-Finale: Finnland - Kanada")
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
}
