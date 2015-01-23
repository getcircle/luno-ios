//
//  ProfileDetailsViewController.swift
//  Circle
//
//  Created by Michael Hahn on 1/21/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class ProfileDetailsViewController: UIViewController, OverlaidCollectionViewDelegate, UIScrollViewDelegate {
    
    // Segmented Control Helpers
    private var currentIndex = 0
    
    // Underlying Views
    private var underlyingScrollView: UIScrollView!
    
    // Overlay views
    private var overlayScrollView: UIScrollView!
    private var overlayContainerView: UIView!
    
    var detailViews = [OverlaidCollectionView]()
    
    convenience init(detailViews withDetailViews: [OverlaidCollectionView], underlyingScrollView withUnderlyingScrollView: UIScrollView) {
        self.init()
        detailViews = withDetailViews
        underlyingScrollView = withUnderlyingScrollView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        extendedLayoutIncludesOpaqueBars = true
        automaticallyAdjustsScrollViewInsets = false
        configureUnderlyingViews()
        configureOverlayViews()
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
        underlyingScrollView.contentSize = detailViews[0].contentSize
        overlayScrollView.contentSize = overlayContainerView.frame.size
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
    
    private func configureUnderlyingViews() {
        view.addSubview(underlyingScrollView)
        underlyingScrollView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
    }
    
    private func configureOverlayViews() {
        overlayContainerView = UIView.newAutoLayoutView()
        // Get the container size. Should account for the width of all the detailViews as well as the height of the navigation bar. We don't want the overlay view to scroll vertically, so we need to ensure its vertical content size matches the visible screen. This allows the collection views to take over vertically.
        let containerSize = CGSizeMake(CGFloat(detailViews.count ?? 1) * view.frame.width, view.frame.height)
        overlayContainerView.autoSetDimensionsToSize(containerSize)
        
        // Attach the detailViews to the overlayContainerView
        var previous: UIView?
        for detailView in detailViews {
            overlayContainerView.addSubview(detailView)
            detailView.backgroundColor = UIColor.clearColor()
            // Views should be aligned left to right
            if previous == nil {
                detailView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Right)
            } else {
                detailView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Left)
                detailView.autoPinEdge(.Left, toEdge: .Right, ofView: previous!)
            }
            detailView.autoSetDimension(.Width, toSize: view.frame.width)
            detailView.alwaysBounceVertical = true
            detailView.externalScrollDelegate = self
            previous = detailView
        }
        
        overlayScrollView = UIScrollView.newAutoLayoutView()
        overlayScrollView.pagingEnabled = true
        overlayScrollView.alwaysBounceVertical = false
        overlayScrollView.showsHorizontalScrollIndicator = false
        overlayScrollView.delegate = self
        
        // Attach the overlayContainerView to the overlayScrollView
        overlayScrollView.addSubview(overlayContainerView)
        overlayContainerView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
        
        // Attach the overlayScrollView to the main view
        view.addSubview(overlayScrollView)
        overlayScrollView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
    }
    
    // MARK: - OverlaidCollectionViewDelegate
    
    func overlaidCollectionViewDidChangeContentOffset(collectionView: UICollectionView, offset: CGFloat) {
        underlyingScrollView.contentOffset = CGPointMake(0, collectionView.contentOffset.y)
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        println("container scrollview: \(scrollView.contentOffset)")
        
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
        underlyingScrollView.contentSize = detailViews[currentIndex].contentSize
    }

}
