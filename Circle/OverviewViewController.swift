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
    
    private(set) var activityIndicatorView: CircleActivityIndicatorView!
    private(set) var collectionViewLayout: UICollectionViewLayout!
    private(set) var collectionView: UICollectionView!
    private(set) var collectionViewVerticalSpaceConstraint: NSLayoutConstraint?
    private(set) var dataSource: CardDataSource!
    private(set) var delegate = CardCollectionViewDelegate()
    private(set) var errorMessageView: CircleErrorMessageView!
    private(set) var searchHeaderView: SearchHeaderView?
    
    private var minimumResultsForFilter = 15
    private var isFilterView = false
    
    // By default, all overview view controllers get a searchHeaderView
    // If this is true and other criteria like min. results are greater than
    // a certain number, a search/filter view is added.
    var addSearchFilterView = true
    
    init() {
        super.init(nibName: nil, bundle: nil)
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
    
    convenience init(isFilterView withIsFilterView: Bool) {
        self.init()
        isFilterView = withIsFilterView
    }
    
    private func customInit() {
        dataSource = initializeDataSource()
        searchHeaderView = initializeSearchHeader()
        collectionViewLayout = initializeCollectionViewLayout()
        collectionView = initializeCollectionView()
    }
    
    override func loadView() {
        let rootView = UIView(frame: UIScreen.mainScreen().bounds)
        rootView.opaque = true
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .None
        configureSearchHeaderView()
        configureCollectionView()
        configureActivityIndicator()
        configureErrorMessageView()
        dataSource.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.makeOpaque()
        activateSearchIfApplicable()
        loadData()
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
        (collectionView.delegate as! CardCollectionViewDelegate).delegate = self
        collectionView.bounces = true
        collectionView.alwaysBounceVertical = true
        
        collectionView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Top)
        collectionViewVerticalSpaceConstraint = collectionView.autoPinEdgeToSuperviewEdge(.Top, withInset: addSearchFilterView ? 44.0 : 0.0)
    }
    
    private func configureSearchHeaderView() {
        if searchHeaderView != nil && addSearchFilterView {
            view.addSubview(searchHeaderView!)
            searchHeaderView!.delegate = self
            searchHeaderView!.searchTextField.placeholder = NSLocalizedString(filterPlaceHolderText(), comment: filterPlaceHolderComment())
            searchHeaderView!.searchTextField.addTarget(self, action: "filterChanged:", forControlEvents: .EditingChanged)
            searchHeaderView!.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Bottom)
            searchHeaderView!.autoSetDimension(.Height, toSize: 44.0)
            searchHeaderView!.layer.cornerRadius = 10.0
            searchHeaderView!.addBottomBorder()
        }
    }
    
    private func configureActivityIndicator() {
        activityIndicatorView = view.addActivityIndicator()
    }
    
    private func configureErrorMessageView() {
        errorMessageView = view.addErrorMessageView(nil, tryAgainHandler: { () -> Void in
            self.errorMessageView.hide()
            self.activityIndicatorView.startAnimating()
            self.loadData()
        })
    }
    
    // MARK: Helpers
    
    final func loadData() {
        dataSource.loadData { (error) -> Void in
            self.activityIndicatorView.stopAnimating()
            
            if error == nil {
                self.hideFilterIfLimitedContent()
                self.errorMessageView.hide()
                self.collectionView.reloadData()
            }
            else if self.dataSource.cards.count <= 1 {
                self.errorMessageView.error = error
                self.errorMessageView.show()
            }
        }
    }
    
    private func hideFilterIfLimitedContent() {
        if dataSource.cards.count > 0 &&
           dataSource.cardAtSection(0)?.content.count < minimumResultsForFilter && 
           collectionViewVerticalSpaceConstraint != nil &&
           addSearchFilterView {
            collectionViewVerticalSpaceConstraint!.constant = 0.0
            collectionView.setNeedsUpdateConstraints()
        }
    }
    
    private func activateSearchIfApplicable() {
        if dataSource.cards.count > 0 && 
            dataSource.cardAtSection(0)?.content.count < minimumResultsForFilter && 
            addSearchFilterView {
            searchHeaderView?.searchTextField.resignFirstResponder()
        }
    }
    
    // MARK: - CardDataSourceDelegate
    
    func onDataLoaded(indexPaths: [NSIndexPath]) {
        let lcollectionView = collectionView
        collectionView.performBatchUpdates({ () -> Void in
            lcollectionView.insertItemsAtIndexPaths(indexPaths)
        }, completion: nil)
    }
    
    
    // MARK: - SearchHeaderViewDelegate
    
    func didCancel(sender: UIView) {
        dataSource.clearFilter { () -> Void in
            self.collectionView.reloadData()
        }
    }
    
    func filterChanged(sender: AnyObject?) {
        if searchHeaderView != nil && addSearchFilterView {
            if isFilterView && searchHeaderView!.searchTextField.text == "" {
                navigationController?.popViewControllerAnimated(true)
            } else {
                filter(searchHeaderView!.searchTextField.text)
            }
        }
    }
    
    final internal func filter(query: String) {
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
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        searchHeaderView?.searchTextField.resignFirstResponder()
    }

}
