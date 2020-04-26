//
//  Collection+Ex.swift
//  Hoteltime2
//
//  Created by draak on 28/08/2019.
//  Copyright © 2019 Withinnovation. All rights reserved.
//

import Foundation

//https://yojkim.me/posts/swift-safe-way-of-accessing-array-by-index/
//일반적으로 배열에 index를 통해 접근하는 상황을 최소화해야 하는 것이 옳지만 어쩔 수 없이 관련된 상황이 발생하기 마련이다.
//Swift에서는 좀 더 안전한 처리를 위해 함수 단에서 guard 문을 지원하는데 Array의 경우 index를 통해 접근해서 가져오는 값이 Optional 타입이 아니기 때문에
//접근하는 index가 유효하지 않은 경우 Fatal error: Index out of range 크래시가 발생함
//let arr = [1, 2, 3, 4]
//arr[4] // Fatal error: Index out of range
//따라서, 해당 Array를 index를 통해 접근했을 때 Optional 타입으로 return을 해주면 발생 상황에 대한 예외 처리를 진행할 수 있기 때문에 좀 더 안전하게 Array accessing을 진행할 수 있다.
//아래 Extension을 사용하여 해당 배열에 접근하려는 index가 유효한지 판단한 뒤 유효할 경우 실제 Element를 반환하고 아닌 경우 nil 값을 넘겨준다.

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
