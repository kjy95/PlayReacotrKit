//
//  Date+Ex.swift
//  PlayReactorKit
//
//  Created by tori on 20/04/2020.
//  Copyright © 2020 tori. All rights reserved.
//

import Foundation

extension Date {
    
    ///현재 날짜를 String으로 변환
    func getToday() -> String {
        
        let now = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let currentDateString = dateFormatter.string(from: now)
        
        return currentDateString
    }
}
