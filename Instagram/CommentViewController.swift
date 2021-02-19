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
    
    var postData: PostData!  //投稿データを受け取るためにプロパティ作成
    
    //入力完了ボタンがタップされた時に呼ばれるメソッド
    @IBAction func commentDoneButton(_ sender: Any) {
        
        let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)  //最後のpostData.idで数ある投稿データのうち選択したものを特定
        
        //HUDでコメント投稿処理中を表示を開始
        SVProgressHUD.show()
        
        //入力者名を取得して、commentに名前とコメントを同時に表示してしまう
        let name = Auth.auth().currentUser?.displayName
        let comment = name! + ":" + self.textField.text!
        //データを更新するための変数を作成
        var updateValue: FieldValue
        //今回新たにコメントを追加して更新するデータを作成
            updateValue = FieldValue.arrayUnion([comment])
        //Firebaseに保存→これでリスナーが更新してくれるはず
        postRef.updateData(["comment": updateValue])
            
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
