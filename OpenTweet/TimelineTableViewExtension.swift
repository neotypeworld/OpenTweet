//
//  TimelineTableViewExtension.swift
//  OpenTweet
//
//  Created by Yue Li on 8/21/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import UIKit

extension TimelineViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {       
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TweetTableViewCell
        cell.loadImage( tweets[indexPath.row].avatar)
        cell.userId.text = tweets[indexPath.row].id
        cell.author.text = tweets[indexPath.row].author
        cell.convertDate(tweets[indexPath.row].date)
        if let inReplyTo = tweets[indexPath.row].inReplyTo {
            cell.createAttributeStr(inReplyTo)
            cell.reply.isHidden = false
        } else {
            cell.reply.isHidden = true
        }
        cell.content.text = tweets[indexPath.row].content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        tableView.beginUpdates()
        tableView.endUpdates()
        if origin.isEmpty { origin = tweets }
        var thread: Set = [tweets[indexPath.row].id]
        for tweet in tweets {
            if let reply = tweet.inReplyTo, thread.contains(reply) {
                thread.insert(tweet.id)
            }
        }
        tweets = tweets.filter { thread.contains($0.id) }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.selectedRow = nil
            tableView.reloadData()
        }
            
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let selectedRow = selectedRow, selectedRow == indexPath.row {
            return 150
        }
        return 100
    }
   
    
   
}

class TweetTableViewCell: UITableViewCell {
    
    lazy var firstHstack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .top
        [avatar, firstVstack].forEach { view.addArrangedSubview($0) }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var firstVstack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.spacing = 5
        [secondHstack, reply, content].forEach { view.addArrangedSubview($0) }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var secondHstack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        [userId, author, date].forEach { view.addArrangedSubview($0) }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var avatar: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var userId: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Helvetica", size: 12.0)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var author: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Helvetica", size: 12.0)
        view.textColor = .blue
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var date: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Helvetica", size: 12.0)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var reply: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Helvetica", size: 12.0)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var content: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Helvetica", size: 15.0)
        view.numberOfLines = 0
        //view.adjustsFontSizeToFitWidth = true
        //view.minimumScaleFactor = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setUpUI() {
       
        contentView.addSubview(firstHstack)
        NSLayoutConstraint.activate([
            firstHstack.topAnchor.constraint(equalTo: contentView.topAnchor),
            firstHstack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            firstHstack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            firstHstack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            avatar.widthAnchor.constraint(equalTo: firstHstack.widthAnchor, multiplier: 0.2),
            avatar.heightAnchor.constraint(equalTo: firstHstack.heightAnchor, multiplier: 0.3),
            firstVstack.widthAnchor.constraint(equalTo: firstHstack.widthAnchor, multiplier: 0.8),
            userId.widthAnchor.constraint(equalTo: secondHstack.widthAnchor, multiplier: 0.2),
            author.widthAnchor.constraint(equalTo: secondHstack.widthAnchor, multiplier: 0.4),
            date.widthAnchor.constraint(equalTo: secondHstack.widthAnchor, multiplier: 0.4)
        ])
        
        
    }
    func convertDate(_ dateStr: String){
        let olDateFormatter = DateFormatter()
        olDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let oldDate = olDateFormatter.date(from: dateStr)
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = "MMM dd yyyy h:mm a"
        date.text = convertDateFormatter.string(from: oldDate!)
    }
    
    func createAttributeStr(_ str: String){
        let text = "Replying to "
        let attributedText = NSMutableAttributedString(string: text)
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.orange
        ]
        attributedText.append(NSAttributedString(string: str, attributes: attributes))
        reply.attributedText = attributedText
    }
    
    func loadImage(_ urlString: String?){
        
        guard let urlString = urlString else {
            avatar.image = UIImage(systemName: "person")
            return
        }
        let cache = URLCache.shared
        let request = URLRequest(url: URL(string: urlString)!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60.0)
        
        if let data = cache.cachedResponse(for: request)?.data {
            avatar.image = UIImage(data: data) ?? UIImage(systemName: "person")
        } else {
            URLSession.shared.dataTask(with: request) { (data, resp, err) in
                if let data = data, let resp = resp {
                    let cachedata = CachedURLResponse(response: resp, data: data)
                    cache.storeCachedResponse(cachedata, for: request)
                    DispatchQueue.main.async {
                        self.avatar.image = UIImage(data: data) ?? UIImage(systemName: "person")
                    }
                }
            }.resume()
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpUI()
       
        
    }
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
    }
    
}
