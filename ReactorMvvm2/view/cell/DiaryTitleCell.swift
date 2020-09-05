//
//  DiaryTitleCell.swift
//  ReactorMvvm2
//
//  Created by 김동준 on 2020/08/26.
//  Copyright © 2020 김동준. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class DiaryTitleCell: UITableViewCell{
    lazy var cellView: UIView = UIView()
    lazy var title: UILabel = UILabel()
    lazy var date: UILabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.addSubview(cellView)
        cellView.snp.makeConstraints { (make) in
            make.width.equalTo(contentView.frame.width)
            make.height.equalTo(80)
        }
        
        cellView.addSubview(title)
        title.text = "title"
        title.font = title.font.withSize(25)
        title.textAlignment = .center
        title.snp.makeConstraints { (make) in
            make.width.equalTo(self.cellView)
            make.height.equalTo(40)
            make.top.equalTo(cellView.snp.top).offset(5)
        }
        
        cellView.addSubview(date)
        date.text = "date"
        date.font = date.font.withSize(20)
        date.textAlignment = .center
        date.snp.makeConstraints { (make) in
            make.width.equalTo(self.cellView)
            make.height.equalTo(20)
            make.top.equalTo(title.snp.bottom).offset(5)
            
        }
        
    }
    
    
    public func setCellText(title:String, date:String){
        self.title.text = title
        self.date.text = date
    }
    
    
}
