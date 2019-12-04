//
//  CommentView.swift
//  YelpCamp
//
//  Created by Nathaniel on 11/30/19.
//  Copyright © 2019 Nathaniel Fargo. All rights reserved.
//

import UIKit

protocol CommentViewDelegate {
    func usernamePressed(username: String)
}

class CommentView: UIView {
    
    // Comment Object
    @IBOutlet var contentView: UIView!
    @IBOutlet private weak var commentLabel: UILabel!
    @IBOutlet private weak var usernameButton: UIButton!
    @IBOutlet private weak var timeAgo: UILabel!
    private var username: String?
    var delegate: CommentViewDelegate?
    
    // Some setup
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    func commonInit(){
        Bundle.main.loadNibNamed("CommentView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    // Set
    func setCommentAttributes(comment: CommentObject) {
        commentLabel.text = comment.text
        username = comment.author.username
        usernameButton.setTitle(username, for: .normal)
        timeAgo.text = comment.sinceCreated ?? "a few UNKNOWN ago"
    }
    
    // Username Pressed
    @IBAction func usernamePressed(_ sender: Any) {
        if let safeUsername = username {
            delegate?.usernamePressed(username: safeUsername)
        }
    }
    
}
