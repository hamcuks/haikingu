//
//  HikerGridView.swift
//  HaikinguApp
//
//  Created by Ivan Nur Ilham Syah on 02/10/24.
//

import UIKit

protocol HikerGridViewDelegate: AnyObject {
    func didSelectHiker(_ hiker: Hiker)
}

class HikerGridView: UIView {
    
    // Delegates
    var delegate: HikerGridViewDelegate?
    
    private var stack: UIStackView!
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = .boldSystemFont(ofSize: 17)
        
        return label
    }()
    
    typealias Datasource = UICollectionViewDiffableDataSource<Int, Hiker>
    
    var collectionView: UICollectionView!
    var datasource: Datasource!
    var hikers: [Hiker] = []
    
    init(frame: CGRect, title: String) {
        super.init(frame: frame)
        
        titleLabel.text = title
        
        self.configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        stack = UIStackView(arrangedSubviews: [titleLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 16
        
        let divider = UIView()
        divider.backgroundColor = .lightGray
        stack.addArrangedSubview(divider)
        
        divider.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(1)
        }
        
        addSubview(stack)
        
        stack.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview()
        }
        
        self.configureCollectionView()
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: UIHelper.createColumnThreeLayout(in: self))
        
        addSubview(collectionView)
        
        collectionView.backgroundColor = .clear
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(stack.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        collectionView.delegate = self
        collectionView.register(HikerCell.self, forCellWithReuseIdentifier: HikerCell.reuseIdentifier)
        
        self.configureDatasource()
    }
    
    func configureDatasource() {
        datasource = Datasource(collectionView: collectionView, cellProvider: { collectionView, indexPath, hiker in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HikerCell.reuseIdentifier, for: indexPath) as? HikerCell
            
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

extension HikerGridView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item    = hikers[indexPath.item]
        
        self.delegate?.didSelectHiker(item)
    }
    
}

struct UIHelper {
    static func createColumnThreeLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width                           = view.bounds.width
        let padding: CGFloat                = 16
        let minimumItemSpacing: CGFloat     = 10
        let availableWidth                  = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth                       = availableWidth / 6
        
        let flowLayout                      = UICollectionViewFlowLayout()
        flowLayout.sectionInset             = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize                 = CGSize(width: itemWidth, height: itemWidth + 40)
        return flowLayout
    }
}
