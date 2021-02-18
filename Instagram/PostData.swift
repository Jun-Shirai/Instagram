//
//  PostData.swift
//  Instagram
//
//  Created by 白井淳 on 2021/02/15.
//

import UIKit
import Firebase

class PostData: NSObject {
    var id: String  //投稿者ID、保存のために作成
    var name: String?  //投稿者名
    var caption: String?  //キャプション：投稿者名と投稿者からのコメント
    var date: Date?  //日時
    var likes: [String] = []  //いいねした人のIDの配列
    var isLiked: Bool = false  //自分がいいねしたかどうかのフラグ
    var comment: String?  //コメント入力者名とコメント     この設定でいいのか？後で修正
    var commentid: [String] = []  //コメントした人のIDの配列
    var iscommented: Bool = false  //コメントしてあるかどうかのフラグ
    
    
    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID
        let postDic = document.data()
        self.name = postDic["name"] as? String
        self.caption = postDic["caption"] as? String
        let timestamp = postDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()
        
        self.comment = postDic["comment"] as? String
        if let commentid = postDic["commentid"] as? [String] {
            self.commentid = commentid
        }
        if let mycommentid = Auth.auth().currentUser?.uid {
            if self.commentid.firstIndex(of: mycommentid) != nil {
                self.iscommented = true
            }
        }
        
        if let likes = postDic["likes"] as? [String] {
            self.likes = likes
        }
        if let myid = Auth.auth().currentUser?.uid {
            //likesの配列の中にmyidが含まれているかチェックすることで、自分が「いいね」を押しているかを判断
            if self.likes.firstIndex(of: myid) != nil {
                //myidがあれば、「いいね」を押していると認識する
                self.isLiked = true
            }
        }
    }
}
