//
//  Items.swift
//  muber-v2
//
//  Created by 中路亜理沙 on 23/04/2021.
//

import UIKit

protocol ItemsViewDelegate: class {
    func proceedToConfirm(_ view: ItemsView)
}

class ItemsView: UIView {
    weak var delegate: ItemsViewDelegate?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.text = "Items"
        return label
    }()

    private let promptLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.text = "Add items here"
        return label

    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white

        addShadow()

        let stack = UIStackView(arrangedSubviews: [titleLabel, promptLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fillEqually

        addSubview(stack)
        stack.centerX(inView: self)
        stack.anchor(top: topAnchor, paddingTop: 12)

//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//class ItemsView: UICollectionViewController, UICollectionViewDelegateFlowLayout {
//
//    weak var delegate: ItemsViewDelegate?
//
//    let cell = "cellId"
//
//    // MARK: - Lifecycle
//
//    override init(collectionViewLayout layout: UICollectionViewLayout) {
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
////        navigationItem.title = "home"
//        collectionView?.backgroundColor = .white
//        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cell)
//    }
//
//    override func collectionView(_ collectionView:UICollectionView, numberOfItemsInSection section:Int) ->Int{
//        return 3
//    }
//
//    override func collectionView(_ collectionView:UICollectionView, cellForItemAt indexPath:IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cell, for: indexPath)
//        cell.backgroundColor = .red
//        return cell
//    }
//
//
//    func collectionView(_ colletionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) ->CGSize{
//        return CGSize(width: 200, height: 200)
//    }

