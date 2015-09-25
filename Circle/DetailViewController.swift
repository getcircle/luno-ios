//
//  DetailViewController.swift
//  Circle
//
//  Created by Ravi Rani on 11/24/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import MessageUI
import UIKit
import ProtobufRegistry


class DetailViewController: BaseDetailViewController,
    UICollectionViewDelegate,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    TextInputViewControllerDelegate {

    var animationSourceRect: CGRect?
    var dataSource: CardDataSource!
    var delegate: CardCollectionViewDelegate!
    var layout: UICollectionViewFlowLayout!

    private(set) var activityIndicatorView: CircleActivityIndicatorView!
    private(set) var collectionView: UICollectionView!
    private(set) var errorMessageView: CircleErrorMessageView!

    private var addImageActionSheet: UIAlertController?
    private(set) var imageToUpload: UIImage?

    override func loadView() {
        let rootView = UIView(frame: UIScreen.mainScreen().bounds)
        rootView.opaque = true
        view = rootView

        if layout == nil {
            layout = initializeCollectionViewLayout()
        }
        collectionView = initializeCollectionView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureActivityIndicator()
        configureErrorMessageView()
        loadData()
    }
    
    final func loadData() {
        dataSource.loadData { (error) -> Void in
            self.activityIndicatorView.stopAnimating()
            if error == nil {
                self.errorMessageView.hide()
            }
            else if let error = error where self.dataSource.cards.count <= 1 {
                // Only show non-200 errors
                // TODO: Need to handle application specific errors.
                if error.domain != ServiceErrorDomain {
                    self.errorMessageView.error = error
                    self.errorMessageView.show()
                }
            }
            
            self.configureNavigationBar()
            
            self.collectionView.reloadData()
        }
    }

    // MARK: - Initialization
    
    func initializeCollectionViewLayout() -> StickyHeaderCollectionViewLayout {
        return StickyHeaderCollectionViewLayout()
    }
    
    func initializeCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
        return collectionView
    }
    
    // MARK: - Configuration
    
    /**
        Configures the collection view for the details - specifically sets the correct
        background color, registers the header, sets the collection view delegate.
    
        Subclasses must override this to actually set the data source and the delegate. So, 
        any custom implmentation should preceed the superstatic function call.
    */
    func configureCollectionView() {
        assert(dataSource != nil, { () -> String in
            return "Data source must be set before calling this function"
        }())
        collectionView.backgroundColor = UIColor.appViewBackgroundColor()
        collectionView.keyboardDismissMode = .OnDrag
        collectionView.showsVerticalScrollIndicator = true
        collectionView.bounces = true
        collectionView.alwaysBounceVertical = true
        (collectionView.delegate as! CardCollectionViewDelegate).delegate = self
    }
    
    private func configureActivityIndicator() {
        activityIndicatorView = view.addActivityIndicator(horizontalOffset: 0.15 * view.frameHeight)
    }
    
    private func configureErrorMessageView() {
        errorMessageView = view.addErrorMessageView(nil, tryAgainHandler: { () -> Void in
            self.errorMessageView.hide()
            self.activityIndicatorView.startAnimating()
            self.loadData()
        })
    }
    
    private func configureNavigationBar() {
        if dataSource.canEdit() {
            let rightBarButtonItem = UIBarButtonItem.roundedItemWithTitle(AppStrings.ProfileInfoEditButtonTitle.localizedUppercaseString(), target: self, action: "editButtonTapped:")
            navigationItem.rightBarButtonItem = rightBarButtonItem
        }
    }

    // MARK: - Orientation change
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - EditImageButtonDelegate
    
    func onEditImageButtonTapped(sender: UIView!) {
        
        let actionSheet = UIAlertController(
            title: AppStrings.ActionSheetAddAPictureButtonTitle,
            message: nil,
            preferredStyle: .ActionSheet
        )
        actionSheet.view.tintColor = UIColor.appActionSheetControlsTintColor()
        
        let takeAPictureActionControl = UIAlertAction(
            title: AppStrings.ActionSheetTakeAPictureButtonTitle,
            style: .Default,
            handler: takeAPictureAction
        )
        actionSheet.addAction(takeAPictureActionControl)
        
        let pickAPhotoActionControl = UIAlertAction(
            title: AppStrings.ActionSheetPickAPhotoButtonTitle,
            style: .Default,
            handler: pickAPhotoAction
        )
        actionSheet.addAction(pickAPhotoActionControl)
        
        let cancelControl = UIAlertAction(
            title: AppStrings.GenericCancelButtonTitle,
            style: .Cancel,
            handler: { (action) -> Void in
                self.dismissAddImageActionSheet(true)
            }
        )
        actionSheet.addAction(cancelControl)
        addImageActionSheet = actionSheet
        if let popoverViewController = actionSheet.popoverPresentationController {
            popoverViewController.sourceRect = sender.bounds
            popoverViewController.sourceView = sender
        }
        presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: - Image Upload

    func takeAPictureAction(action: UIAlertAction!) {
        dismissAddImageActionSheet(false)
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let pickerVC = UIImagePickerController()
            pickerVC.sourceType = .Camera
            pickerVC.cameraCaptureMode = .Photo
            if UIImagePickerController.isCameraDeviceAvailable(.Front) {
                pickerVC.cameraDevice = .Front
            }
            else {
                pickerVC.cameraDevice = .Rear
            }
            
            pickerVC.allowsEditing = true
            pickerVC.delegate = self
            presentViewController(pickerVC, animated: true, completion: nil)
        }
    }
    
    func pickAPhotoAction(action: UIAlertAction!) {
        dismissAddImageActionSheet(false)
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            let pickerVC = UIImagePickerController()
            pickerVC.sourceType = .PhotoLibrary
            pickerVC.allowsEditing = true
            pickerVC.delegate = self
            presentViewController(pickerVC, animated: true, completion: nil)
        }
    }
    
    private func dismissAddImageActionSheet(animated: Bool) {
        if addImageActionSheet != nil {
            addImageActionSheet!.dismissViewControllerAnimated(animated, completion: {() -> Void in
                self.addImageActionSheet = nil
            })
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageToUpload = pickedImage
        }
        else {
            imageToUpload = info[UIImagePickerControllerOriginalImage] as? UIImage
        }

        handleImageUpload { () -> Void in
            self.reloadHeader()
            self.imageToUpload = nil
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    internal func handleImageUpload(completion: () -> Void) {
        fatalError("Should be overriden by child classes")
    }
    
    internal func reloadHeader() {
        fatalError("Should be overriden by child classes")
    }
    
    // MARK: - TextInputViewControllerDelegate

    func onTextInputValueUpdated(updatedObject: AnyObject?) {
        loadData()
    }
    
    // MARK: - Actions
    
    @objc internal func editButtonTapped(sender: AnyObject) {
    }
}

