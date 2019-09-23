//
//  NetworkManager.swift
//  bluescapeShare
//
//  Created by Gabriel Walsh on 9/23/19.
//  Copyright © 2019 Gabriel Walsh. All rights reserved.
//

import Foundation
import Moya

enum APIEnvironment {
    case local
    case development
    case qa
    case production
}

struct NetworkManager{
    static let authPlugin = AccessTokenPlugin {APIKeys.bluescapeAuthToken }
    static let provider = MoyaProvider<BluescapeAPITargets>(plugins: [authPlugin, NetworkLoggerPlugin(verbose: true)])
    static let environment: APIEnvironment = .production
}
