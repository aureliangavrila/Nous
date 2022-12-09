//
//  StoriesViewModel.swift
//  TestNOUS
//
//  Created by Aurelian Gavrila on 07.12.2022.
//

import Foundation
import RxSwift
import RxRelay

protocol StoriesViewModelProtocol {
    var disposeBag: DisposeBag { get }
    var searchTextRelay: BehaviorRelay<String> { get set }
    var filteredStoriesObservable: Observable<[Story]> { get }
}

class StoriesViewModel: StoriesViewModelProtocol {
    
    var disposeBag = DisposeBag()
    private let storiesRepo: StoriesRepository
    
    var searchTextRelay = BehaviorRelay(value: "")
    let storiesBehaviourRelay = BehaviorRelay<[Story]>.init(value: [])
    
    var filteredStoriesObservable: Observable<[Story]> {
        Observable.combineLatest(storiesBehaviourRelay.asObservable(), searchTextRelay.asObservable()) { stories, keyword in
            guard keyword != "" else {
                return stories
            }
            
            return stories.filter { $0.title.range(of: keyword, options: .caseInsensitive) != nil || $0.description.range(of: keyword, options: .caseInsensitive) != nil }
        }
    }
    
    init(storiesRepo: StoriesRepository = StoriesRepositoryImplementation()) {
        self.storiesRepo = storiesRepo
        
        getStories()
    }
    
    private func getStories() {
        storiesRepo.getStories()
            .do(onSuccess: { [weak self] stories in
                guard let self = self else { return }
    
                self.storiesBehaviourRelay.accept(stories.items)
            }, onError: { error in
                print(error)
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
}
