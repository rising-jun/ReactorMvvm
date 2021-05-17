//
//  RealmDataModel.swift
//  ReactorMvvm2
//
//  Created by 김동준 on 2020/08/25.
//  Copyright © 2020 김동준. All rights reserved.
//

import Foundation
import RealmSwift
class RealmDataModel{
    private lazy var realm: Realm = {
        return try! Realm()
    }()
    
    public func updateDiary(diary: DiaryInfo){
        //modifyData
        if(!valNilCheck(val: diary._title) && !valNilCheck(val: diary._contents)){
        let updateDiary = realm.objects(DiaryInfo.self).filter("uid = %@", diary._uid).first
        try! realm.write{
            updateDiary?._title = diary._title
            updateDiary?._contents = diary._contents
        }
        }
    }
    
    public func wrtieDairy(diary: DiaryInfo){
        if(valNilCheck(val: diary._title) && valNilCheck(val: diary._contents)){
    
        try! realm.write{
            realm.add(diary)
            
        }
        }
    }
    
    public func getDairy()->Results<DiaryInfo>{
        let savedData = realm.objects(DiaryInfo.self)
        return savedData
    }
    
    public func deleteDairy(deleteDiaryList: Array<DiaryInfo>){
        try! realm.write{
            for i in 0 ..< deleteDiaryList.count{
                let predicate = NSPredicate(format: "uid = %@", deleteDiaryList[i]._uid)
                realm.delete(realm.objects(DiaryInfo.self).filter(predicate))
            }

        }
    }
    public func initDB(){
        let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
                let realmURLs = [
                    realmURL,
                    realmURL.appendingPathExtension("lock"),
                    realmURL.appendingPathExtension("note"),
                    realmURL.appendingPathExtension("management")
                ]
                for URL in realmURLs {
                    do {
                        try FileManager.default.removeItem(at: URL)
                    } catch {
                        // handle error
                    }
                }

    }
    
    private func valNilCheck(val: String) -> Bool{
        if(val == ""){
            return false
        }else{
            return true
        }
    }
    
}
