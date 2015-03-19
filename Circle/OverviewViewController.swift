//
//  BaseOverviewViewController.swift
//  Circle
//
//  Created by Michael Hahn on 3/18/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class OverviewViewController:
    UIViewController,
    UICollectionViewDelegate,
    SearchHeaderViewDelegate,
    CardDataSourceDelegate
{
    
    private(set) var activityIndicatorView: UIActivityIndicatorView!
    private(set) var collectionViewLayout: UICollectionViewLayout!
    private(set) var collectionView: UICollectionView!
    private(set) var searchContainerView: UIView!
    private(set) var collectionViewVerticalSpaceConstraint: NSLayoutConstraint?
    private(set) var searchHeaderView: SearchHeaderView?

    private(set) var dataSource: CardDataSource!
    private(set) var delegate = CardCollectionViewDelegate()
    
    override init() {
        super.init()
        customInit()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        customInit()
    }
    
    private func customInit() {
        dataSource = initializeDataSource()
        activityIndicatorView = initializeActivityIndicator()
        searchHeaderView = initializeSearchHeader()
        collectionViewLayout = initializeCollectionViewLayout()
        collectionView = initializeCollectionView()
    }
    
    override func loadView() {
        let rootView = UIView(frame: UIScreen.mainScreen().bounds)
        rootView.opaque = true
        view = rootView
        configureSearchHeaderView()
        configureCollectionView()
        configureActivityIndicator()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .None
        dataSource.delegate = self
        dataSource.loadData { (error) -> Void in
            if error == nil {
                self.hideFilterIfLimitedContent()
                self.activityIndicatorView.stopAnimating()
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        dataSource.loadData { (error) -> Void in
            if error == nil {
                self.activityIndicatorView.stopAnimating()
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Initialization
    
    func initializeDataSource() -> CardDataSource {
        fatalError("Subclass must override this method and initialize the dataSource")
    }
    
    func initializeCollectionViewLayout() -> UICollectionViewLayout {
        return UICollectionViewFlowLayout()
    }
    
    func initializeCollectionView() -> UICollectionView {
        return UICollectionView(frame: UIScreen.mainScreen().bounds, collectionViewLayout: collectionViewLayout)
    }
    
    func initializeSearchHeader() -> SearchHeaderView? {
        if let nibViews = NSBundle.mainBundle().loadNibNamed("SearchHeaderView", owner: nil, options: nil) as? [UIView] {
            if let headerView = nibViews.first as? SearchHeaderView {
                return headerView
            }
        }
        return nil
    }
    
    func initializeActivityIndicator() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        indicator.setTranslatesAutoresizingMaskIntoConstraints(true)
        return indicator
    }
    
    // MARK: - Configuration
    
    func filterPlaceHolderText() -> String {
        return "Filter content"
    }
    
    func filterPlaceHolderComment() -> String {
        return "Placeholder for text field used for filtering"
    }
    
    func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = UIColor.appViewBackgroundColor()
        collectionView.setTranslatesAutoresizingMaskIntoConstraints(false)
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        (collectionView.delegate as CardCollectionViewDelegate).delegate = self
        collectionView.bounces = true
        collectionView.alwaysBounceVertical = true
        
        collectionView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Top)
        if searchHeaderView != nil {
            collectionViewVerticalSpaceConstraint = collectionView.autoPinEdge(.Top, toEdge: .Bottom, ofView: searchHeaderView!)
        } else {
            collectionView.autoPinEdgeToSuperviewEdge(.Top)
        }
    }
    
    private func configureSearchHeaderView() {
        if searchHeaderView != nil {
            view.addSubview(searchHeaderView!)
            searchHeaderView!.delegate = self
            searchHeaderView!.searchTextField.placeholder = NSLocalizedString(filterPlaceHolderText(), comment: filterPlaceHolderComment())
            searchHeaderView!.searchTextField.addTarget(self, action: "filterChanged:", forControlEvents: .EditingChanged)
            searchHeaderView!.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Bottom)
            searchHeaderView!.autoSetDimension(.Height, toSize: 44.0)
            searchHeaderView!.layer.cornerRadius = 10.0
        }
    }
    
    private func configureActivityIndicator() {
        view.addSubview(activityIndicatorView)
        activityIndicatorView.autoCenterInSuperview()
        activityIndicatorView.startAnimating()
    }
    
    // MARK: Helpers
    
    private func hideFilterIfLimitedContent() {
        if dataSource.cardAtSection(0)?.content.count < 15 && collectionViewVerticalSpaceConstraint != nil {
            collectionViewVerticalSpaceConstraint!.constant = -44
            collectionView.setNeedsUpdateConstraints()
            searchHeaderView?.removeFromSuperview()
        }
    }
    
    // MARK: - CardDataSourceDelegate
    
    func onDataLoaded(indexPaths: [NSIndexPath]) {
        collectionView.insertItemsAtIndexPaths(indexPaths)
    }
    
    
    // MARK: - SearchHeaderViewDelegate
    
    func didCancel(sender: UIView) {
        dataSource.clearFilter { () -> Void in
            self.collectionView.reloadData()
        }
    }
    
    func filterChanged(sender: AnyObject?) {
        if searchHeaderView != nil {
            let query = searchHeaderView!.searchTextField.text
            if query.trimWhitespace() == "" {
                dataSource.clearFilter { () -> Void in
                    self.collectionView.reloadData()
                }
            } else {
                dataSource.filter(query) { (error) -> Void in
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        searchHeaderView?.searchTextField.resignFirstResponder()
    }

}
