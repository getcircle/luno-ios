//
//  ProfileDetailsViewController.swift
//  Circle
//
//  Created by Michael Hahn on 1/21/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class ProfileDetailsViewController: UIViewController, UnderlyingCollectionViewDelegate, UIScrollViewDelegate {
    
    // Segmented Control Helpers
    private var currentIndex = 0
    
    // Overlay view
    private var overlaidCollectionView: UICollectionView!
    
    // Underlying views
    private var underlyingScrollView: UIScrollView!
    private var underlyingContainerView: UIView!
    
    var detailViews = [UnderlyingCollectionView]()
    
    convenience init(
        detailViews withDetailViews: [UnderlyingCollectionView],
        overlaidCollectionView withOverlaidCollectionView: UICollectionView,
        showLogOutButton: Bool,
        showCloseButton: Bool
    ) {
        self.init()
        detailViews = withDetailViews
        overlaidCollectionView = withOverlaidCollectionView
        if showLogOutButton {
            addLogOutButton()
        }
        
        if showCloseButton {
            addCloseButton()
        }
    }
    
    override func loadView() {
        view = UIView(frame: UIScreen.mainScreen().bounds)
        view.backgroundColor = UIColor.viewBackgroundColor()
        configureUnderlyingViews()
        configureOverlayView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        extendedLayoutIncludesOpaqueBars = true
        automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if isBeingPresentedModally() {
            navigationController?.navigationBar.makeTransparent()
        }
        else {
            transitionCoordinator()?.animateAlongsideTransition({ (transitionContext) -> Void in
                self.navigationController?.navigationBar.makeTransparent()
                return
            },
                completion: nil
            )
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        overlaidCollectionView.contentSize = detailViews[0].contentSize
        underlyingScrollView.contentSize = underlyingContainerView.frame.size
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Do not show the opaque bar again if:
        // a. this view was presented modally
        // b. this view is being dismissed vs disappearing because another view controller was added to the stack
        // c. the view controller prior to this one was a DetailViewController
        if !isBeingPresentedModally() && isMovingFromParentViewController() {
            if let totalViewControllers = navigationController?.viewControllers.count {
                let parentController = navigationController?.viewControllers[(totalViewControllers - 1)] as? UIViewController
                if !(parentController is ProfileDetailsViewController) {
                    transitionCoordinator()?.animateAlongsideTransition({ (transitionContext) -> Void in
                        self.navigationController?.setNavigationBarHidden(false, animated: true)
                        var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as UIViewController!
                        toViewController.navigationController?.navigationBar.makeOpaque()
                        
                        return
                    }, completion: nil)
                }
            }
        }
    }
    
    private func configureOverlayView() {
        view.addSubview(overlaidCollectionView)
        overlaidCollectionView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
    }
    
    private func configureUnderlyingViews() {
        underlyingContainerView = UIView.newAutoLayoutView()
        // Get the container size. Should account for the width of all the detailViews as well as the height of the navigation bar. We don't want the overlay view to scroll vertically, so we need to ensure its vertical content size matches the visible screen. This allows the collection views to take over vertically.
        let containerSize = CGSizeMake(CGFloat(detailViews.count ?? 1) * view.frame.width, view.frame.height)
        underlyingContainerView.autoSetDimensionsToSize(containerSize)
        
        // Attach the detailViews to the overlayContainerView
        var previous: UIView?
        for detailView in detailViews {
            underlyingContainerView.addSubview(detailView)
            // Views should be aligned left to right
            if previous == nil {
                detailView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Right)
            } else {
                detailView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Left)
                detailView.autoPinEdge(.Left, toEdge: .Right, ofView: previous!)
            }
            detailView.autoSetDimension(.Width, toSize: view.frame.width)
            detailView.externalScrollDelegate = self
            previous = detailView
        }
        
        underlyingScrollView = UIScrollView.newAutoLayoutView()
        underlyingScrollView.pagingEnabled = true
        underlyingScrollView.alwaysBounceVertical = false
        underlyingScrollView.showsHorizontalScrollIndicator = false
        underlyingScrollView.delegate = self
        
        // Attach the overlayContainerView to the overlayScrollView
        underlyingScrollView.addSubview(underlyingContainerView)
        underlyingContainerView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
        
        // Attach the overlayScrollView to the main view
        view.addSubview(underlyingScrollView)
        underlyingScrollView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
    }
    
    // MARK: - UnderlyingCollectionViewDelegate
    
    func underlyingCollectionViewDidChangeContentOffset(collectionView: UICollectionView, offset: CGFloat) {
        // Only update the overlaidCollectionView if the content offset changed for the current underlying view
        if collectionView == detailViews[currentIndex] {
            overlaidCollectionView.contentOffset = CGPointMake(0, collectionView.contentOffset.y)
        }
    }
    
    func underlyingCollectionViewDidEndScrolling(collectionView: UICollectionView) {
        // Update the content offset of the other detail views to match the current one.
        // We will only alter the content offset if it is greater than the stickySectionHeight.
        var offset = collectionView.contentOffset.y
        if let layout = overlaidCollectionView.collectionViewLayout as? StickyHeaderCollectionViewLayout {
            println("offset \(collectionView.contentOffset.y) - sectionHeight: \(layout.stickySectionHeight)")
            let maxOffset = (layout.headerHeight - layout.stickySectionHeight)
            if collectionView.contentOffset.y > maxOffset {
                offset = maxOffset
            }
            for (index, detailView) in enumerate(detailViews) {
                if index != currentIndex {
                    detailView.contentOffset = CGPointMake(0, offset)
                }
            }
        }
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.x > view.frame.width {
            navigationController?.interactivePopGestureRecognizer.enabled = false
        } else {
            navigationController?.interactivePopGestureRecognizer.enabled = true
        }
        if let headerView = profileHeaderView() {
            headerView.updateSectionIndicatorView(scrollView.contentOffset)
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollingEnded(scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        scrollingEnded(scrollView)
    }

    private func scrollingEnded(scrollView: UIScrollView) {
        currentIndex = Int(scrollView.contentOffset.x) / Int(view.frame.width)
    }
    
    // MARK: - Helpers
    
    private func addLogOutButton() {
        if navigationItem.rightBarButtonItem == nil {
            let logOutButton = UIBarButtonItem(title: "Log Out", style: .Plain, target: self, action: "logOutTapped:")
            navigationItem.rightBarButtonItem = logOutButton
        }
    }
    
    func logOutTapped(sender: AnyObject!) {
        AuthViewController.logOut()
    }
    
    private func addCloseButton() {
        if navigationItem.leftBarButtonItem == nil {
            let closeButton = UIBarButtonItem(
                image: UIImage(named: "Down"),
                style: .Plain,
                target: self,
                action: "closeButtonTapped:"
            )
            navigationItem.leftBarButtonItem = closeButton
        }
    }
    
    func closeButtonTapped(sender: AnyObject!) {
        if isBeingPresentedModally() {
            dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    private func profileHeaderView() -> ProfileHeaderCollectionReusableView? {
        return (overlaidCollectionView.dataSource as? ProfileOverlaidCollectionViewDataSource)?.profileHeaderView
    }

}
