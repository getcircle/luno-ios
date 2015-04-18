//
//  TagsOverviewViewController.swift
//  Circle
//
//  Created by Ravi Rani on 2/15/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class TagsOverviewViewController: UIViewController, UICollectionViewDelegateFlowLayout, SearchHeaderViewDelegate {

    @IBOutlet weak private(set) var collectionView: UICollectionView!
    @IBOutlet weak private(set) var searchContainerView: UIView!

    private(set) var dataSource = TagsOverviewDataSource()
    
    private var cachedItemSizes = [String: CGSize]()
    private var prototypeCell: TagCollectionViewCell!
    private(set) var searchHeaderView: SearchHeaderView!
    private var isFilterView = false
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        customInit()
    }
    
    convenience init(nibName: String?, bundle: NSBundle?, isFilterView withIsFilterView: Bool) {
        self.init(nibName: nibName, bundle: bundle)
        isFilterView = withIsFilterView
        customInit()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    
    private func customInit() {
        initializeSearchHeaderView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureView()
        configureCollectionView()
        configurePrototypeCell()
        configureSearchHeaderView()
    }
    
    // MARK: - Initialization
    
    private func initializeSearchHeaderView() {
        if let nibViews = NSBundle.mainBundle().loadNibNamed("SearchHeaderView", owner: nil, options: nil) as? [UIView] {
            searchHeaderView = nibViews.first as SearchHeaderView
        }
    }

    // MARK: - Configuration
    
    private func configureView() {
        view.backgroundColor = UIColor.appViewBackgroundColor()
        edgesForExtendedLayout = .None
        automaticallyAdjustsScrollViewInsets = false        
    }
    
    private func configurePrototypeCell() {
        // Init prototype cell
        let cellNibViews = NSBundle.mainBundle().loadNibNamed("TagCollectionViewCell", owner: self, options: nil)
        prototypeCell = cellNibViews.first as TagCollectionViewCell
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = UIColor.whiteColor()
        // Header
        collectionView.registerNib(
            UINib(nibName: "ProfileSectionHeaderCollectionReusableView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: ProfileSectionHeaderCollectionReusableView.classReuseIdentifier
        )

        // Footer
        collectionView.registerClass(
            SeparatorDecorationView.self,
            forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
            withReuseIdentifier: SeparatorDecorationView.classReuseIdentifier
        )
        
        // Item
        collectionView.registerNib(
            UINib(nibName: "TagCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: TagCollectionViewCell.classReuseIdentifier
        )
        
        collectionView.keyboardDismissMode = .OnDrag
        collectionView.allowsMultipleSelection = false
        collectionView.dataSource = dataSource
    }
    
    private func configureSearchHeaderView() {
        searchHeaderView.delegate = self
        searchHeaderView.searchTextField.placeholder = NSLocalizedString("Filter interests",
            comment: "Placeholder for text field used for filtering interests by name")
        searchHeaderView.searchTextField.addTarget(self, action: "filterData:", forControlEvents: .EditingChanged)
        searchContainerView.addSubview(searchHeaderView)
        searchHeaderView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
        searchHeaderView.layer.cornerRadius = 10.0
    }
    
    // MARK: - UICollectionViewDelegate

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let selectedTag = dataSource.interest(collectionView: collectionView, atIndexPath: indexPath) {
            trackTagSelected(selectedTag)
            let viewController = TagDetailViewController()
            (viewController.dataSource as TagDetailDataSource).selectedTag = selectedTag
            navigationController?.pushViewController(viewController, animated: true)
        }
        
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if let interest = dataSource.interest(collectionView: collectionView, atIndexPath: indexPath) {
            let interestText = interest.name.capitalizedString
            if cachedItemSizes[interestText] == nil {
                prototypeCell.interestLabel.text = interestText
                prototypeCell.setNeedsLayout()
                prototypeCell.layoutIfNeeded()
                cachedItemSizes[interestText] = prototypeCell.intrinsicContentSize()
            }
            
            return cachedItemSizes[interestText]!
        }
        
        return CGSizeZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSizeMake(view.frameWidth, ProfileSectionHeaderCollectionReusableView.height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
            return CGSizeMake(view.frameWidth, 1.0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10.0, 15.0, 15.0, 15.0)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 14.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10.0
    }
    
    // MARK: - Helpers
    
    private func activateSearchField() {
        if searchHeaderView.searchTextField.text != "" {
            searchHeaderView.searchTextField.becomeFirstResponder()
        }
    }
    
    // MARK: - SearchHeaderViewDelegate
    
    func didCancel(sender: UIView) {
        dataSource.filterData("")
        collectionView.reloadData()
    }
    
    func filterData(sender: AnyObject?) {
        if isFilterView && searchHeaderView.searchTextField.text == "" {
            navigationController?.popViewControllerAnimated(true)
        } else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
                self.dataSource.filterData(self.searchHeaderView.searchTextField.text)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.collectionView.reloadData()
                })
            })
        }
    }
    
    // MARK: - Tracking
    
    private func trackTagSelected(interest: Services.Profile.Containers.TagV1) {
        let properties = [
            TrackerProperty.withKey(.ActiveViewController).withString(self.dynamicType.description()),
            TrackerProperty.withKey(.Source).withSource(.Overview),
            TrackerProperty.withKey(.SourceOverviewType).withOverviewType(.Tags),
            TrackerProperty.withKey(.Destination).withSource(.Detail),
            TrackerProperty.withKey(.DestinationDetailType).withDetailType(.Tag),
            TrackerProperty.withDestinationId("interest_id").withString(interest.id)
        ]
        Tracker.sharedInstance.track(.DetailItemTapped, properties: properties)
    }
}
