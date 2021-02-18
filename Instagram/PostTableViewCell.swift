//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by 白井淳 on 2021/02/15.
//

import UIKit
import FirebaseUI
//↑画像を表示（ダウンロード）するためのメソッドを使用するためにインポート。
//これがあることによって、ホーム画面でスクロールして一度にたくさんの画像を表示したり、スクロールが停止しないようにしたり、一度DLした画像を再びDLし直したりしないようにできる。

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!  //いいねボタン
    @IBOutlet weak var likeLabel: UILabel!  //いいね数
    @IBOutlet weak var dateLabel: UILabel!  //日時
    @IBOutlet weak var captionLabel: UILabel!  //キャプション：投稿者名と投稿者からのコメント
    @IBOutlet weak var commentButton: UIButton!  //コメント入力時にタップして入力画面に遷移する
    @IBOutlet weak var commentLabel: UILabel!  //コメントした方の表示名：コメント表示
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //PostDataの内容をセルに表示（引っ張ってくる）
    func setPostData(_ postData: PostData) {
        
        //画像の表示
        postImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
        postImageView.sd_setImage(with: imageRef)
        
        //キャプションの表示
        self.captionLabel.text = "\(postData.name!) : \(postData.caption!)"
        
        //コメントの表示
        if postData.comment == nil {
            self.commentLabel.text = ""
        }else {
            self.commentLabel.text = "\(postData.name!) : \(postData.comment!)"
            
        }
        //コメントボタンの動作は別コントローラーで実装
        
        //日時の表示
        self.dateLabel.text = ""
        if let date = postData.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let  dateString = formatter.string(from: date)
            self.dateLabel.text = dateString
            
        }
        //いいね数の表示
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"
        
        //いいねボタンの表示
        if postData.isLiked {
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        }else {
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
    }
    
}
