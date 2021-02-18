//
//  SettingViewController.swift
//  Instagram
//
//  Created by 白井淳 on 2021/02/11.
//

import UIKit
import Firebase
import SVProgressHUD

class SettingViewController: UIViewController {
    
    @IBOutlet weak var displayNameTextField: UITextField!
    
    //表示名変更ボタンがタップされたときに呼ばれるメソッド
    @IBAction func handleChangeButton(_ sender: Any) {
        
        if let displayName = displayNameTextField.text {
            
            //
            if displayName.isEmpty {
                SVProgressHUD.showError(withStatus: "表示名を入力して下さい")
                return
            }
            
            //
            let user = Auth.auth().currentUser
            
            if let user = user {
                let changeReqest = user.createProfileChangeRequest()
                changeReqest.displayName = displayName
                changeReqest.commitChanges {error in
                    if let error = error {
                        
                        SVProgressHUD.showError(withStatus: "表示名の変更に失敗しました。")
                        print("DEBUG_PRINT: " + error.localizedDescription)
                        return
                    }
                    print("DEBBUG_PRINT: [displayName = \(user.displayName!)]の設定に成功しました。")
                    
                    //HUDで完了を知らせる
                    SVProgressHUD.showSuccess(withStatus: "表示名を変更しました")
                    
                }
            }
        }
        //キーボードを閉じる
        self.view.endEditing(true)
    }
    
    //ログアウトボタンをタップしたときに呼ばれるメソッド
    @IBAction func handleLogoutButton(_ sender: Any) {
        //ログアウトする
        try!Auth.auth().signOut()
        
        //ログイン画面を表示する
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        self.present(loginViewController!, animated: true, completion: nil)
        
        //ログイン画面から戻ってきた時のためにホーム画面（index = 0）を選択している状態にする
        tabBarController?.selectedIndex = 0
    }
    
    
    //↓viewDidLoadではなくviewWillAppearにする理由
    //アプリを起動したまま別アカウントにログインし直したような場合を考慮して新しいアカウントの表示名を反映できるようにするため
    //viewWillAppearであれば、設定画面をひらくために現在ログインしているアカウントの表示名を反映させることができる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //表示名を取得してTextFieldに設定する
        let user = Auth.auth().currentUser
        
        if let user = user {
            displayNameTextField.text = user.displayName
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
