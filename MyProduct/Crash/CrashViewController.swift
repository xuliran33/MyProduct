//
//  CrashViewController.swift
//  MyProduct
//
//  Created by dalong on 2022/10/14.
//

import UIKit

class CrashViewController: BaseViewController {

   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blue
        let signalBtn = UIButton(frame: CGRect(x: 80, y: 100, width: 160, height: 40))
        signalBtn.setTitle("signalCrash", for: .normal)
        signalBtn.addTarget(self, action: #selector(signalBtnAct), for: .touchUpInside)
        self.view.addSubview(signalBtn)

        let exceptionBtn = UIButton(frame: CGRect(x: 80, y: 160, width: 160, height: 40))
        exceptionBtn.setTitle("exceptionCrash", for: .normal)
        exceptionBtn.addTarget(self, action: #selector(exceptionBtnAct), for: .touchUpInside)
        self.view.addSubview(exceptionBtn)

        // Do any additional setup after loading the view, typically from a nib.
    }

    //NSException crash
    @objc func exceptionBtnAct(){
        let ttaar = NSArray()
        print(ttaar[66])
    }
    
    //signal crash
    @objc func signalBtnAct(){
        
        let filePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        //crash存储位置
        print(filePath)
        
        var strr:String!
        strr = strr + "...."
        
        
    }
    
    

}
