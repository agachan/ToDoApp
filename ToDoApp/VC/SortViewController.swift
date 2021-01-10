//
//  SortViewController.swift
//  ToDoApp
//
//  Created by AGA TOMOHIRO on 2020/12/16.
//

import UIKit

class SortViewController: UIViewController {
    var sortDelegate:CatchProtocol?
    enum ButtonType: Int{
        case regist = 0
        case important = 1
        case category = 2
        case time = 3
    }
    @IBOutlet weak var mainView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.layer.cornerRadius = 10
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sortButton(_ sender: UIButton) {
        
        switch sender.tag {
        case ButtonType.regist.rawValue:
            sortDelegate?.sortViewData(tag: sender.tag)
            dismiss(animated: true, completion: nil)
        case ButtonType.important.rawValue:
            sortDelegate?.sortViewData(tag: sender.tag)
            dismiss(animated: true, completion: nil)
        case ButtonType.category.rawValue:
            sortDelegate?.sortViewData(tag: sender.tag)
            dismiss(animated: true, completion: nil)
        case ButtonType.time.rawValue:
            sortDelegate?.sortViewData(tag: sender.tag)
            dismiss(animated: true, completion: nil)
        default:
            break
        
    }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch in touches {
            if touch.view?.tag == 1 {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

}

class BlockButton:UIButton{
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
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.darkGray.cgColor

    }
}
