//
//  HorizontalCollectionView.swift
//  SplitViewControllerTutorial
//
//  Created by james rochabrun on 3/29/20.
//  Copyright © 2020 james rochabrun. All rights reserved.
//

import UIKit

protocol HorizontalCollectionViewDelegate: AnyObject {
    func didSelectAt(_ indexPath: IndexPath)
}

final class HorizontalCollectionView: BaseXibView {
    
    weak var delegate: HorizontalCollectionViewDelegate?
    
    @IBOutlet private var collectionView: UICollectionView! {
        didSet {
            collectionView.register(CircularCoverWithTitleViewCell.self)
            collectionView.register(StoryVideoCollectionViewCell.self)
            collectionView.register(PhotoPostCollectionViewCell.self)
            collectionView.register(VideoPostCollectionViewCell.self)
        }
    }
    
  //      private var dataSource: CellKindCollectionViewDataSource<HorizontalContent>?
    private var dataSource: UICollectionViewDiffableDataSource<HorizontalSection, HorizontalContent>?
    private var currentSnapshot: NSDiffableDataSourceSnapshot<HorizontalSection, HorizontalContent>?
    
    // MARK:- Layout
    func setupLayoutKind(_ layoutKind: LayoutKind) {
        collectionView.collectionViewLayout = layoutKind.layout
    }
    
    private var localmodels: [HorizontalContent] = []

    
    func setupDataSourceWith(_ models: [HorizontalContent]) {
        
        dataSource = UICollectionViewDiffableDataSource <HorizontalSection, HorizontalContent>(collectionView: collectionView) { collectionView, indexPath, model in
            switch model {
            case .hilightsSnippet(let viewModel):
                let cell: CircularCoverWithTitleViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
                cell.item = viewModel
                return cell
            case .storySnippet(let storySnippetViewModel):
                let cell: StoryVideoCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
                cell.item = storySnippetViewModel
                return cell
            case .post(let fileContent):
                switch fileContent {
                case .photo(let photoPostViewModel):
                    let cell: PhotoPostCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
                    cell.item = photoPostViewModel
                    return cell
                case .video(let videoPostViewModel):
                    let cell: VideoPostCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
                    cell.item = videoPostViewModel
                    return cell
                }
            case .userStoryCircularCover(let viewModel):
                let cell: CircularCoverWithTitleViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
                cell.item = viewModel
                return cell
            }
        }
        collectionView.dataSource = dataSource
        localmodels.append(contentsOf: models)
        
        currentSnapshot = NSDiffableDataSourceSnapshot<HorizontalSection, HorizontalContent>()
         currentSnapshot?.appendSections([.main])
         currentSnapshot?.appendItems(localmodels, toSection: .main)
         guard let snapShot = currentSnapshot else { return }
         dataSource?.apply(snapShot, animatingDifferences: true)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
    }
}

/// Diff stuff
enum HorizontalSection {
    case main
}

enum HorizontalContent: Hashable {
    
    var id: UUID { UUID() }
    
    static func == (lhs: HorizontalContent, rhs: HorizontalContent) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    case hilightsSnippet(HilightViewModel) // hilights holds an image and a title
    case storySnippet(StoryVideoCoverViewModel) // story previews
    case post(FileContent) // a post that can be a photo or an image
    case userStoryCircularCover(UserStoryCoverViewModel)
}


/// layout stuff 
enum LayoutKind {
    
    case horizontalHilightsLayout(UITraitCollection)
    case horizontalStorySnippetLayout(UITraitCollection)
    case horizontalPostsLayout(UITraitCollection)
    case horizontalStoryUserCoverLayout(UITraitCollection)
    
    var layout: UICollectionViewLayout {
        switch self {
        case .horizontalHilightsLayout(_):
            return UICollectionViewCompositionalLayout.layoutWith(width: 130.0,
                                                                  itemInset: UIEdgeInsets(top: 10, left: 10.0, bottom: 10, right: 10.0),
                                                                  sectionInset: .zero)
        case .horizontalStorySnippetLayout(_):
            return UICollectionViewCompositionalLayout.layoutWith(width: 160.0,
                                                                  itemInset: UIEdgeInsets(top: 10, left: 7.0, bottom: 10, right: 7.0),
                                                                  sectionInset: .zero)
        case .horizontalPostsLayout(_):
            return UICollectionViewCompositionalLayout.gridLayout(1, scrollAxis: .horizontal(.paging))
        case .horizontalStoryUserCoverLayout(_):
            return UICollectionViewCompositionalLayout.layoutWith(width: 150.0,
                                                                  itemInset: UIEdgeInsets(top: 10, left: 12.0, bottom: 10, right: 12.0),
                                                                  sectionInset: .zero)
        }
    }
}

protocol ContentCollection {}
extension HorizontalContent: ContentCollection {}

