//
//  StoryDto.swift
//  TestNOUS
//
//  Created by Aurelian Gavrila on 08.12.2022.
//

import Foundation

struct StoryDto: Codable {
    let id: Int
    let title: String
    let description: String
    let imageUrl: String
}
