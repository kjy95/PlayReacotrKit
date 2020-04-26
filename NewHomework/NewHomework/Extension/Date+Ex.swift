//
//  Date+Ex.swift
//  NewHomework
//
//  Created by draak on 07/05/2019.
//  Copyright © 2019 Draak. All rights reserved.
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
