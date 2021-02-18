//
//  TabBarController.swift
//  Instagram
//
//  Created by 白井淳 on 2021/02/13.
//

import UIKit
import Firebase

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    
    //この中でログイン状態を確認する
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Authクラスを使用してログイン状態を確認
        //nilならログインしていない
        if Auth.auth().currentUser == nil {
            //ログインしていないときの処理
            //LoginViewControllerにstoryboardIDを設定することで、該当のViewControllerを得る。→モーダル遷移処理する
            let loginViewCotroller = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            self.present(loginViewCotroller!, animated: true, completion: nil)
        }
    }
    
    
    //モーダル遷移画面：遷移時に遷移先の画面が下から現れる。閉じる時は画面が下がって消える。ユーザー情報の入力時や今回の写真投稿時、デバイス使用許可時？などに使われることが多い。多用はしない。
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //タブアイコンの色
        self.tabBar.tintColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1)
        //タブバーの背景色
        self.tabBar.barTintColor = UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 1)
        //UITabBarControllerDelegateプロトコルのメソッドをこのクラスで処理する。
        self.delegate = self
    }
    
    //タブバーのアイコンがタップされた時に呼ばれるdelegateメソッドを処理する。
    //このメソッドはタブ切り替えをしていいか否かを応答する役割をもつ
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        //↓切り替え先がImageSelectViewControllerのとき
        if viewController is ImageSelectViewController {
            //ImageSelectViewControllerは、タブ切り替えではなくモーダル画面遷移する
            let imageSelectViewController = storyboard!.instantiateViewController(withIdentifier: "ImageSelect")
            present(imageSelectViewController, animated: true)
            //↑記述の最後の「completion: nil」は省略している
            
            return false  //falseにすることでタブ切り替えが行われなくなる
        }else {
            //その他のViewController（ホーム画面と設定画面）は通常のタブ切り替えを実施
            return true
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
