//
//  ViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/6/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {

    @IBOutlet weak var imgShow: UIButton!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var viewUserName: UIView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    var _loginController: ILogin!
    var _dataOfflineController: IDataOffline!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setBackground();
        viewUserName.setBorder(radius: 4)
        viewPassword.setBorder(radius: 5)
        btnLogin.setBorder(radius: 4)
       // imgShow.setRounded(radius: 4)
        if let info = Defaults.getUser(key: "LOGIN") {
             self.pushViewController(withIdentifier: "frmHome")
        }
       // SVProgressHUD.show()
        // Do any additional setup after loading the view, typically from a nib.
    }
    func setBackground(){
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "bg_login")
        backgroundImage.contentMode = UIView.ContentMode.scaleToFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    func toJsonLogin() -> Data{
        var jsonString:String = ""
        let json  : [String : AnyObject] = [
            "userName": txtUserName.text as AnyObject,
            "passWord": txtPassword.text as AnyObject
        ]
        do{
            let data = try JSONSerialization.data(withJSONObject: json, options:.prettyPrinted)
            jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as! String
            
        }
        catch let error as NSError{
            print(error.description)
        }
        print(jsonString)
        return jsonString.data(using: String.Encoding.utf8, allowLossyConversion: true)!
    }
    
    @IBAction func hidePassword(_ sender: Any) {
        if txtPassword.isSecureTextEntry == true{
            txtPassword.isSecureTextEntry = false
            imgShow.setImage(UIImage(named: "ic_view"), for: .normal)
        }
        else{
            imgShow.setImage(UIImage(named: "ic_hide_view"), for: .normal)
            txtPassword.isSecureTextEntry = true
        }
    }
    @IBAction func Login(_ sender: Any) {
        if txtUserName.text == "" {
            Function.Message("Thông báo", message: "Vui lòng nhập tên đăng nhâpj.")
            
            return;
        }
        if txtPassword.text == "" {
            Function.Message("Thông báo", message: "Vui lòng nhập mật khẩu.")
            return;
        }
      //  SVProgressHUD.show()
        let queue = DispatchQueue(label: "com.login")
        queue.async {
            self._loginController.Login(self.toJsonLogin(),url: URLs.URL_LOGIN) { (data, error) in
                DispatchQueue.main.async {
                    if data != nil {
                        //SVProgressHUD.dismiss()
                        data?.password = self.txtPassword.text!
                        Defaults.saveuser("LOGIN",data!)
                        self.pushViewController(withIdentifier: "frmHome")
                    }
                    else{
                        Function.Message("Thông báo", message: "Bạn nhập chưa đúng tài khoản đăng nhập.")
                    }
                }
            }
        }
       
    }
    
}

