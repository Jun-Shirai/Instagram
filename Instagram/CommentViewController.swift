//
//  CommentViewController.swift
//  Instagram
//
//  Created by 白井淳 on 2021/02/16.
//

import UIKit
import Firebase
import SVProgressHUD

class CommentViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    var postData: PostData?
    
    //入力完了ボタンがタップされた時に呼ばれるメソッド
    @IBAction func commentDoneButton(_ sender: Any) {
        
        let postRef = Firestore.firestore().collection(Const.PostPath).document()
        
        //HUDでコメント投稿処理中を表示を開始
        SVProgressHUD.show()
        
        //FireStoreにコメントデータを保存する
        let name = Auth.auth().currentUser?.displayName
        let postDic = ["name": name!,
                       "comment": self.textField.text!,
                      ] as [String: Any]
        postRef.setData(postDic)
        
        //入力内容を遷移元に返す
        self.textField.text = postData?.comment
            
        //HUDでコメント投稿完了を表示
        SVProgressHUD.showSuccess(withStatus: "コメントしました")
        
        //ホーム画面に戻る
        self.dismiss(animated: true, completion: nil)
        
    }
    
    //キャンセルボタンをタップしたときに呼ばれるメソッド
    @IBAction func commentCancelButton(_ sender: Any) {
        //ホーム画面に戻る
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
