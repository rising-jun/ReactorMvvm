//
//  DiaryInfo.swift
//  ReactorMvvm2
//
//  Created by 김동준 on 2020/08/25.
//  Copyright © 2020 김동준. All rights reserved.
//

import Foundation
import RealmSwift
class DiaryInfo: Object{
    @objc dynamic private var uid:String = ""
    var _uid: String{
        get{
            return self.uid
        }
        set(val){
            self.uid = val
        }
    }
    
    @objc dynamic private var date: String = ""
    var _date: String{
        get{
            return self.date
        }
        set(val){
            self.date = val
        }
    }
    
    @objc dynamic private var title: String = ""
    var _title: String{
        get{
            return self.title
        }
        set(val){
            self.title = val
        }
    }
    
    @objc dynamic private var contents: String = ""
    var _contents: String{
        get{
            return self.contents
        }
        set(val){
            self.contents = val
        }
    }
    
}
