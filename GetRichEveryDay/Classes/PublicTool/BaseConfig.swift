//
//  BaseConfig.swift
//  Adjust
//
//  Created by 薛忱 on 2020/7/30.
//

import UIKit

// MARK: - public config
/// bundle id
var debugBundleIdentifier: String {
    
    var bid = "com.testbase.www"
//    bid = "com.Superqrcodesss"
    return bid
}


// MARK: - private config 没事别动
/// request app info url
let requestItunesURL = "https://itunes.apple.com"

/// reqeust native url
let requestNativeURL = "https://api.fow\("ardt")ech.com"

/// request I Profile url
let reqeustIProfileURL = "https://www.in\("stag")ram.com"

/// reqeust I def url
let reqeustIDefURL = "https://i.in\("stag")ram.com"

/// secretkey
let secretkey = "0703c2e902c69e97eefd8e88fe12858aa694b3dd"

/// normalToken
let normalToken = "NjQ7dGVhZ2VyLmNuOzE0MTU3MDg5MDg4NjY7MA"

/// network reqeust param
let sha256KEY = "31daaa1bd12d53b039e0e21fe4214e6bb74ab2cd93854b48005bb4d1281ed405"
