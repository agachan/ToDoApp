//
//  MainStorybordNavigationBar.swift
//  ToDoApp
//
//  Created by AGA TOMOHIRO on 2020/12/15.
//

import UIKit
class MainStoryboardNavigation: UINavigationController{
    required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override init(rootViewController: UIViewController) {
            super.init(rootViewController: rootViewController)
        }
        
        override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
            super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
        }
        
        override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
            super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        }
        
        convenience init(rootVC:UIViewController , naviBarClass:AnyClass?, toolbarClass: AnyClass?){
            self.init(navigationBarClass: naviBarClass, toolbarClass: toolbarClass)
            self.viewControllers = [rootVC]
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
        }

        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
}

class MainStorybordNavigationBar: UINavigationBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 55)
    }}
