//
//  HomeViewController.swift
//  Instagram
//
//  Created by 白井淳 on 2021/02/11.
//

import UIKit
import Firebase

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    //投稿データを格納する配列
    var postArray: [PostData] = []
    
    //Firestoreのリスナー
    var listener: ListenerRegistration?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //カスタムセルを登録する＊今回はUITableViewにUITableViewCellを実装する形じゃないため。
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")  //←登録
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        
        //ログイン済みかどうかを確認
        if Auth.auth().currentUser != nil {
            
            //listenerを登録して投稿データの更新を監視する
            let postsRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
            listener = postsRef.addSnapshotListener() {(querySnapshot,error) in  //↑クエリスナップショットに最新の投稿データが入っている。
                
                if let error = error {
                    print("DEBUG_PRINT: snapshotの取得に失敗しました。 \(error)")
                    return
                }
                //取得したdocumentをもとにPostDataを作成し、postArrayの配列にする
                //＊mapメソッドは新しい投稿データを新しい配列に変換して作成してくれる
                self.postArray = querySnapshot!.documents.map { document in
                    let postData = PostData(document: document)
                    return postData
                }
                //TableViewの表示を更新する
                self.tableView.reloadData()
            }
        }
    }
    //ホーム画面を閉じるとき
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("DEBUG_PRINT: viewWillDisappear")
        
        //listenerを削除して監視を停止する
        listener?.remove()
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //セルを取得してデータを設定する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        cell.setPostData(postArray[indexPath.row])
        
        //↑ここでPostTableViewControllerを取得しているので、下記でlikeButtonの設定もすることが可能
        
        //セル内のボタンのアクションをソースコードで設定する
        cell.likeButton.addTarget(self, action: #selector(handleButton(_:forEvent:)), for: .touchUpInside)
        //↑このaddTargetメソッドが青い線を引っ張ってActionボタンを設定する代わりになってくれる。
        //(_:forEvent:)はタップされた時の投稿データの位置（座標）を特定するために記述？＊「_」は第一引数の省略表示でUIButtonインスタンスが格納されている
        
        //セル内のコメント入力ボタンのアクションをソースコードで設定する
        cell.commentButton.addTarget(self, action: #selector(commentEditButton(_:forEvent:)), for: .touchUpInside)
        
        return cell
    }
    
    
    
    
//セル内のボタンがタップされると呼ばれるメソッド。＊UIEventの中身にはタップされた時の投稿データの位置（座標）が格納されている。特定するために必要
    @objc func handleButton(_ sender: UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: likeボタンがタップされました。")
        
        //タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)  //タッチしたlikeButtonのタッチ座標を割り出す
        let indexPath = tableView.indexPathForRow(at: point)
        //indexPathで数ある投稿画面（tableView）の中でどの投稿データに当たるのかを取得
        //そして下記にて投稿データの中身を取得
        
        //配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]
        
        //likesを更新する
        if let myid = Auth.auth().currentUser?.uid {
            //更新データを作成する
            var updateValue: FieldValue
            if postData.isLiked {
                //すでにいいねをしている場合は、いいね解除のためmyidを取り除く更新データを作成
                updateValue = FieldValue.arrayRemove([myid])
            }else {
                //今回新たにいいねを押した場合は、myidを追加する更新データを作成
                updateValue = FieldValue.arrayUnion([myid])
            }
            //likesに更新データを書き込む
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
            postRef.updateData(["likes": updateValue])
        }
    }
    
//セル内のコメント入力ボタンがタップされたときに呼ばれるメソッド
    @objc func commentEditButton(_ sender: UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: commentボタンがタップされました。")
        
        //タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        //配列からタップされたインデックスデータを取得
        let postData = postArray[indexPath!.row]
        
        //コメント入力画面へモーダル遷移
        let commentViewController = storyboard!.instantiateViewController(withIdentifier: "CommentEdit")
        present(commentViewController, animated: true, completion: nil)
        
        
        //更新する
        if let mycommentid = Auth.auth().currentUser?.uid {
            
            var commentUpdataValue: FieldValue
            if postData.iscommented {
                //すでにコメントしている場合は、別で新しいmycommentidを追加する更新データを作成
                commentUpdataValue = FieldValue.arrayUnion([mycommentid])
            }else {
                //今回初めてコメントする場合は、mycommentidを追加する更新データを作成
                commentUpdataValue = FieldValue.arrayUnion([mycommentid])
            }
            //新たにコメントを入力・追加する場合はmycommentidを追加する更新データを作成
            //commentUpdataValue = FieldValue.arrayUnion([mycommentid])
            //commentに更新データを書き込む
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
            postRef.updateData(["comment": commentUpdataValue])
            
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
