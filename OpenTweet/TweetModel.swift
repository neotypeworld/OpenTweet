//
//  TweetModel.swift
//  OpenTweet
//
//  Created by Yue Li on 8/21/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import Foundation

struct ResponseData: Codable, Hashable {
    let timeline: [Tweet]
}

struct Tweet: Codable, Identifiable, Hashable {
    let id: String
    let author: String
    let content: String
    let date: String
    let avatar: String?
    let inReplyTo: String?
}
