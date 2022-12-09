//
//  MockStoriesRepository.swift
//  TestNOUSTests
//
//  Created by Aurelian Gavrila on 09.12.2022.
//

import Foundation
import RxSwift
@testable import TestNOUS

class MockStoriesRepository: StoriesRepository {
    
    func getStories() -> Single<Stories> {
        return  Single.just(Stories(items: [
        Story(id: 14014907, title: "Der Alte: Vergiftete Freundschaft", description: "Das Kriminalteam hat es mit einem besonders kniffligen Fall zu tun: Eine ambitionierte Forscherin wurde in ihrem Labor von einer Mamba angegriffen. Voss und seine Kollegen zweifeln keine Sekunde daran, dass der scheinbar tragische Unfall in Wirklichkeit ein kaltblütiger Mord war.", imageUrl: "https://cloud.nousdigital.net/s/xdKCypE5ogtMq4s/preview"),
        Story(id: 14014905, title: "Eishockey-WM-Finale: Finnland - Kanada", description: "Der vermeintliche Außenseiter Finnland setzt sich im Finale der Eishockey-Weltmeisterschaft 2019 mit 3:1 gegen Kanada durch.", imageUrl: "https://cloud.nousdigital.net/s/DeHHbj35wiWdrgi/preview")
        ]))
    }
}
