//
//  Circle.swift
//  ToDoApp
//
//  Created by AGA TOMOHIRO on 2020/12/16.
//

import UIKit

class CircleButton:UIButton{
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    private func commonInit() {
        //角丸・枠線・背景色を設定する
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 4
        self.backgroundColor = .white
    }
}

class CircleImge:UIImageView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    private func commonInit() {
        //角丸・枠線・背景色を設定する
        self.layer.cornerRadius = self.frame.height/2
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.black.cgColor
        
    }
}

class CircleView:UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    private func commonInit() {
        //角丸・枠線・背景色を設定する
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 4
        self.backgroundColor = .white
    }
}
