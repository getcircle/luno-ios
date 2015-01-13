//
//  VerifyProfileViewController.swift
//  Circle
//
//  Created by Ravi Rani on 1/11/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class VerifyProfileViewController: UIViewController,
UITextFieldDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate {

    @IBOutlet weak private(set) var editImageButton: UIButton!
    @IBOutlet weak private(set) var firstNameField: UITextField!
    @IBOutlet weak private(set) var lastNameField: UITextField!
    @IBOutlet weak private(set) var profileImageView: UIImageView!
    @IBOutlet weak private(set) var titleField: UITextField!
    @IBOutlet weak private(set) var titleLabel: UILabel!
    @IBOutlet weak private(set) var verifyTextLabel: UILabel!

    private var addImageActionSheet: UIAlertController?
    private var nextButton: UIBarButtonItem!
    private var profile: ProfileService.Containers.Profile!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureView()
        populateData()
    }
    
    // MARK: - Configuration
    
    private func configureView() {
        automaticallyAdjustsScrollViewInsets = false
        edgesForExtendedLayout = .Top
        extendedLayoutIncludesOpaqueBars = true
        navigationController?.navigationBar.makeTransparent()
        
        view.backgroundColor = UIColor.appTintColor()
        editImageButton.tintColor = UIColor.whiteColor()
        editImageButton.setImage(
            editImageButton.imageForState(.Normal)?.imageWithRenderingMode(.AlwaysTemplate),
            forState: .Normal
        )
        
        firstNameField.addBottomBorder()
        lastNameField.addBottomBorder()
        titleField.addBottomBorder()
    }

    // MARK: - Data Source
    
    private func populateData() {
        profile = AuthViewController.getLoggedInUserProfile()
    
        firstNameField.text = profile.first_name
        lastNameField.text = profile.last_name
        titleField.text = profile.title
        //profileImageView.setImageWithProfile(profile)
    }
    
    // MARK: - IBActions
    
    @IBAction func nextButtonTapped(sender: AnyObject!) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tagSelectorVC = storyboard.instantiateViewControllerWithIdentifier("TagSelectorViewController") as TagSelectorViewController
        navigationController?.pushViewController(tagSelectorVC, animated: true)
    }
    
    @IBAction func editImageButtonTapped(sender: AnyObject!) {
        var actionSheet = UIAlertController(
            title: NSLocalizedString("Add a picture", comment: "Title of window which asks user to add a picture"),
            message: nil,
            preferredStyle: .ActionSheet
        )
        actionSheet.view.tintColor = UIColor.actionSheetControlsTintColor()

        var takeAPictureActionControl = UIAlertAction(
            title: NSLocalizedString("Take a picture", comment: "Button prompt to take a picture using the camera"),
            style: .Default,
            handler: takeAPictureAction
        )
        actionSheet.addAction(takeAPictureActionControl)

        var pickAPhotoActionControl = UIAlertAction(
            title: NSLocalizedString("Pick a photo", comment: "Button prompt to pick a photo from user's photos"),
            style: .Default,
            handler: pickAPhotoAction
        )
        actionSheet.addAction(pickAPhotoActionControl)

        var cancelControl = UIAlertAction(
            title: "Cancel",
            style: .Cancel,
            handler: { (action) -> Void in
                self.dismissAddImageActionSheet(true)
            }
        )
        actionSheet.addAction(cancelControl)
        addImageActionSheet = actionSheet
        presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func takeAPictureAction(action: UIAlertAction!) {
        dismissAddImageActionSheet(false)
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            var pickerVC = UIImagePickerController()
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
            var pickerVC = UIImagePickerController()
            pickerVC.sourceType = .PhotoLibrary
            pickerVC.allowsEditing = true
            pickerVC.delegate = self
            presentViewController(pickerVC, animated: true, completion: nil)
        }
    }
    
    // MARK: - Helpers
    
    private func dismissAddImageActionSheet(animated: Bool) {
        if addImageActionSheet != nil {
            addImageActionSheet!.dismissViewControllerAnimated(animated, completion: {() -> Void in
                self.addImageActionSheet = nil
            })
        }
    }
    
    // MARK: - UIImagePickerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImageView.image = pickedImage
        }
        else {
            profileImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
