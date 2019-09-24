//
//  APITargetProtocol.swift
//  bluescapeShare
//
//  Created by Gabriel Walsh on 9/23/19.
//  Copyright © 2019 Gabriel Walsh. All rights reserved.
//

import Foundation
import Moya

protocol APITargetable {
    var provider: MoyaProvider<BluescapeAPITargets> { get }
    func getCanvases(workspaceId: Int, completion: @escaping (Canvases, Error)-> ())
}
