//
//  DateModel.swift
//  ReactorMvvm2
//
//  Created by 김동준 on 2020/08/25.
//  Copyright © 2020 김동준. All rights reserved.
//

import Foundation
import RealmSwift
class DataConvertModel{
    public func getDate()-> String{
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: now)
    }
    
    public func resultsToArray(results: Results<DiaryInfo>) -> Array<DiaryInfo>{
        var diaryList: Array<DiaryInfo> = []
        for diary in results {
            diaryList.append(diary)
        }
        return diaryList
    }
    
    public func changeBoolValue(val: Bool) -> Bool{
        if(val){
            return false
        }else{
            return true
        }
    }
    
}
