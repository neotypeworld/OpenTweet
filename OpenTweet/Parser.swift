//
//  Parser.swift
//  OpenTweet
//
//  Created by Yue Li on 8/21/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import Foundation

class Parser {
    
    func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func parse(jsonData: Data) -> ResponseData? {
        do {
            let decodedData = try JSONDecoder().decode(ResponseData.self, from: jsonData)
            return decodedData
            
        } catch let error as NSError {
            print("decode error: " + error.localizedDescription)
        }
        return nil
    }
}
