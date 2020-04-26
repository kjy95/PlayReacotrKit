//
//  ListAdapter.swift
//  NewHomework
//
//  Created by draak on 02/05/2019.
//  Copyright © 2019 Draak. All rights reserved.
//

import Foundation

class ListAdapter {
    
    func getMainList(page: Int, success: @escaping ([Product?]) -> Void, failure: @escaping (HttpAdapterErrorModel?) -> Void) {
//        HttpAdapter.get("http://s3.ap-northeast-2.amazonaws.com/goodchoice-notice/maintenance/App/\(page).json", failure: { error in
        HttpAdapter.get("https://gccompany.co.kr/App/json/\(page).json", failure: { error in
            failure(error)
        }, success: { (infoModel: InfoModel?) in
            if let product = infoModel?.data?.product {
                success(product)
            }
        })
    }
    
}
