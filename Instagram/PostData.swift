//
//  PostData.swift
//  Instagram
//
//  Created by 白井淳 on 2021/02/15.
//

import UIKit
import Firebase

class PostData: NSObject {
var id: String  //投稿者ID、保存のために作成　＊String?にならない理由としては、下記イニシャライザにて id != nil（nilは絶対に入らない）の初期化宣言をしているため。
    var name: String?  //投稿者名　＊nilが入る可能性も考えて?をつけている
    var caption: String?  //キャプション：投稿者名と投稿者からのコメント　＊nilが入る可能性も考えて?をつけている
    var date: Date?  //日時　　＊nilが入る可能性も考えて?をつけている
    var likes: [String] = []  //複数のいいねした人のID（文字列）を扱うため、配列型にする
    var isLiked: Bool = false  //自分がいいねしたかどうかのフラグ
    var comment: [String] = []  //複数のコメント内容（文字列）を扱うため、配列型にする
    
    
    //イニシャライザ　＊上記プロパティのままだとデフォルト（初期）値がなく、変数の使い方がわからないため
    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID
        let postDic = document.data()
        self.name = postDic["name"] as? String
        self.caption = postDic["caption"] as? String
        let timestamp = postDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()
        
        //nilがくる可能性もあるので、そのうちString型の場合に限って、下記デフォルト値に代入して扱うという意味
        if let comment = postDic["comment"] as? [String] {
            self.comment = comment
        }
        
        
        //nilがくる可能性もあるので、そのうちString型の場合に限って、下記デフォルト値に代入して扱うという意味
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
