//
//  TeamsView.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 30/09/24.
//

import UIKit
import SnapKit

class TeamsView: UIView {
    
    var yourTeamLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    var addFriendsButton = TextIconButton(icon: "person.2.fill", title: "Add Friends", color: .systemBrown)
    
    typealias Datasource = UICollectionViewDiffableDataSource<Int, Hiker>
    
    var collectionView: UICollectionView!
    var datasource: Datasource!
    var hikers: [Hiker] = []
    
    var roundedRectangleView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 20.0
        view.layer.masksToBounds = true
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private var horizontalStack: UIStackView = {
        let horizontal = UIStackView()
        horizontal.axis = .horizontal
        horizontal.spacing = 10
        horizontal.distribution = .fillProportionally
        horizontal.alignment = .leading
        return horizontal
    }()
    
    private var verticalStack: UIStackView = {
        let vertical = UIStackView()
        vertical.axis = .vertical
        vertical.spacing = 5
        vertical.distribution = .fillProportionally
        vertical.alignment = .leading
        return vertical
    }()
    
    var items: [Hiker] = []
    
    init(frame: CGRect, action: Selector?) {
        super.init(frame: frame)
        configure(action: action)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(action: Selector?) {
        
        yourTeamLabel.text = "Your team (0/5)"
        
        addSubview(verticalStack)
        
        horizontalStack.addArrangedSubview(yourTeamLabel)
        horizontalStack.addArrangedSubview(addFriendsButton)
        
        verticalStack.addArrangedSubview(horizontalStack)
        verticalStack.addArrangedSubview(roundedRectangleView)
        
        if let action {
            addFriendsButton.addTarget(nil, action: action, for: .touchUpInside)
        }
        
        verticalStack.snp.makeConstraints { make in
            make.edges.equalToSuperview() // Add padding around verticalStack
        }
        
        roundedRectangleView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(110)
            make.width.equalToSuperview()
        }
        
//        roundedRectangleView.addSubview(horizontalPersonStack)
        
        configureCollectionView()
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: UIHelper.createColumnThreeLayout(in: self))
        
        roundedRectangleView.addSubview(collectionView)
        
        collectionView.backgroundColor = .clear
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionView.register(YourTeamCell.self, forCellWithReuseIdentifier: YourTeamCell.reuseIdentifier)
        
        self.configureDatasource()
    }
    
    func configureDatasource() {
        datasource = Datasource(collectionView: collectionView, cellProvider: { collectionView, indexPath, hiker in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: YourTeamCell.reuseIdentifier, for: indexPath) as? YourTeamCell
            
            guard let cell else { return UICollectionViewCell() }
            
            cell.setData(with: hiker)
            
            return cell
        })
    }
    
    func updateData(on hikers: [Hiker]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Hiker>()
        
        snapshot.appendSections([0])
        snapshot.appendItems(hikers)
        
        self.hikers = hikers
        
        /// Update the datasource in main thread
        DispatchQueue.main.async {
            self.datasource.apply(snapshot, animatingDifferences: true)
        }
    }

}
