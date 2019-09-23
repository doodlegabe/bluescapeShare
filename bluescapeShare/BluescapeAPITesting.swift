//
//  BluescapeAPITesting.swift
//  bluescapeShare
//
//  Created by Gabriel Walsh on 9/23/19.
//  Copyright © 2019 Gabriel Walsh. All rights reserved.
//

import Foundation
import Moya

func stubbedResponse(_ fileName: String) -> Data{
    @objc class Spec: NSObject {}
    let factory = Bundle(for: Spec.self)
    let path = factory.path(forResource: fileName, ofType: "json")
    return (try! Data.init(contentsOf: URL(fileURLWithPath: path!)))
}

extension BluescapeAPITargets{
    var sampleData: Data{
        switch self {
            case .getCanvases : return stubbedResponse("Canvas")
        }
    }
}
