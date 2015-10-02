//
//  AppStrings.swift
//  Circle
//
//  Created by Ravi Rani on 2/26/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation

struct AppStrings {
    
    static let ActionSheetAddAPictureButtonTitle = NSLocalizedString("Add a picture", comment: "Title of window which asks user to add a picture")
    static let ActionSheetPickAPhotoButtonTitle = NSLocalizedString("Pick a photo", comment: "Button prompt to pick a photo from user's photos")
    static let ActionSheetTakeAPictureButtonTitle = NSLocalizedString("Take a picture", comment: "Button prompt to take a picture using the camera")
    
    static let CardTitlePeople = NSLocalizedString("People", comment: "Title of the card showing people")
    static let CardTitleOfficeTeam = NSLocalizedString("Office Teams", comment: "Title of the card showing teams in a office")
    static let CardTitleAddress = NSLocalizedString("Address", comment: "Title of the card showing address")
    
    static let ContactLabelCellPhone = NSLocalizedString("Cell Phone", comment: "Label for showing cell phone")
    static let ContactLabelPersonalEmail = NSLocalizedString("Personal Email", comment: "Label for showing personal email")
    static let ContactLabelWorkEmail = NSLocalizedString("Work Email", comment: "Label for showing work email")
    static let ContactLabelWorkPhone = NSLocalizedString("Work Phone", comment: "Label for showing work phone")
    
    static let EmailFeedbackSubject = NSLocalizedString("Feedback on circle", comment: "Subject of the feedback email")
    
    static let FieldLabelNickname = NSLocalizedString("Nickname", comment: "A person's nickname")

    static let GenericErrorMessage = NSLocalizedString("Oops! There was an error connecting to our server.", comment: "Generic error message shown when there is any error in fetching data")
    
    static let GenericCancelButtonTitle = NSLocalizedString("Cancel", comment: "Generic button title for cancelling a user action")
    static let GenericDoneButtonTitle = NSLocalizedString("Done", comment: "Generic button title for indicating a user has completed an action")
    static let GenericErrorDialogTitle = NSLocalizedString("Error", comment: "Generic title for a dialog showing an error message")
    static let GenericGetStartedButtonTitle = NSLocalizedString("Get Started", comment: "Generic button title to start some action")
    static let GenericNextButtonTitle = NSLocalizedString("Next", comment: "Generic button title for moving to next action")
    static let GenericNoThanksButtonTitle = NSLocalizedString("No thanks", comment: "Generic button title for declining an action")
    static let GenericNotNowButtonTitle = NSLocalizedString("Not now", comment: "Generic button title for declining an action for now")
    static let GenericYesButtonTitle = NSLocalizedString("Yes", comment: "Generic button title for confirming an action")
    static let GenericOKButtonTitle = NSLocalizedString("OK", comment: "Generic button title for positive affirmation of an action")
    static let GenericTryAgainButtonTitle = NSLocalizedString("Try Again", comment: "Generic button title to try some action again")
        
    static let NotificationTitle = NSLocalizedString("Notification", comment: "Title for showing a notification message")
    static let NotificationsTitle = NSLocalizedString("Notifications", comment: "Title of the view that shows content related to notifications")
    static let NotificationInfoText = NSLocalizedString("We'd like to notify you when new people join, you are invited to events or when someone on your team is having a work anniversary. Turn notifications on?", comment: "Message indicating the users why we would like to notify them and asking for notifications permission")
    
    static let RequestAccessButtonTitle = NSLocalizedString("Request Access", comment: "Title of the button to request access to the app")
    
    static let RequestAccessConfirmationTest = NSLocalizedString("Great! We will notify you when your account is ready to access. Thanks!", comment: "Confirmation text shown when user requests access to the app.")
    
    static let PasswordTextFieldPlaceholder = NSLocalizedString("Password", comment: "Placeholder for password text field")
    static let PrivateBetaInfoText = NSLocalizedString("luno is currently available only to employees at participating companies! You can request access below or try logging into a different account.", comment: "Message indicating that the app is only available to employees of participating companies and the user can either request access or try a different account")
    
    static let ProfileInfoEditButtonTitle = NSLocalizedString("Edit", comment: "Title of the button to edit info")
    static let ProfileInfoUpdateButtonTitle = NSLocalizedString("Update", comment: "Title of the button to update info")

    static let ProfileSectionStatusTitle = NSLocalizedString("Currently working on", comment: "Title of the section which shows user's status")
    static let ProfileSectionContactPreferencesTitle = NSLocalizedString("Contact Preferences", comment: "Title of the section which takes user to preferences on contact info")
    
    static let QuickActionNoneLabel = ""
    static let QuickActionCallLabel = NSLocalizedString("Call", comment: "Title for button used to initiate a call")
    static let QuickActionEmailLabel = NSLocalizedString("Email", comment: "Title for button used to send an email")
    static let QuickActionInfoLabel = NSLocalizedString("Info", comment: "Title for button used to see info")
    static let QuickActionMessageLabel = NSLocalizedString("Message", comment: "Title for button used to send a message")
    static let QuickActionSlackLabel = NSLocalizedString("Slack", comment: "Title for button used send a message via Slack")
    static let QuickActionVideoLabel = NSLocalizedString("Video", comment: "Title for button used to initial a video call")
    
    static let QuickActionNonePlaceholder = NSLocalizedString("Search People, Teams & Locations", comment: "Placeholder text for search field used to search people, teams and skills.")
    static let QuickActionEmailPlaceholder = NSLocalizedString("Who do you want to email?", comment: "Placeholder for search field used to search for the person user intends to email")
    static let QuickActionInfoPlaceholder = NSLocalizedString("Who do you want contact info on?", comment: "Placeholder for search field used to search for the person user intends to email")
    static let QuickActionMessagePlaceholder = NSLocalizedString("Who do you want to message?", comment: "Placeholder for search field used to search for the person user intends to send a message")
    static let QuickActionCallPlaceholder = NSLocalizedString("Who do you want to call?", comment: "Placeholder for search field used to search for the person user intends to call")
    static let QuickActionSlackPlaceholder = NSLocalizedString("Who do you want to message?", comment: "Placeholder for search field used to search for the person user intends to send a message")
    
    static let SignInCTA = NSLocalizedString("Sign In", comment: "Generic button title to sign in to the app")
    static let SignUpCTA = NSLocalizedString("Sign Up", comment: "Generic button title to sign up for the service")
    static let SocialConnectDefaultCTA = NSLocalizedString("Connect", comment: "Button title for connecting with generic social account")
    static let SocialSignInCTA = NSLocalizedString("Sign in with %@", comment: "Button title for sign in with provider button")
    static let StartUsingAppCTA = NSLocalizedString("Start using luno", comment: "Button title shown on the first screen to prompt user to sign up")

    static let TeamEditButtonTitle = NSLocalizedString("Edit team", comment: "Title of the button to edit detail of a team")
    static let TeamSubTeamsSectionTitle = NSLocalizedString("Teams", comment: "Title of the section showing sub-teams of a team")
    static let TeamNameFieldLabel = NSLocalizedString("Team name", comment: "Label for team name input field")
    static let TeamNameErrorCannotBeEmpty = NSLocalizedString("Team name cannot be empty.", comment: "Error message indicating team name cannot be an empty string")

    static let TitleEditButtonTitle = NSLocalizedString("Edit Title", comment: "Title of the view which allows a person to edit their job title")
    static let TitleFieldLabel = NSLocalizedString("Title", comment: "Label for title input field")
    static let TitleErrorCannotBeEmpty = NSLocalizedString("Title cannot be empty.", comment: "Error message indicating a person's title cannot be an empty string")
    
    static let TitleDownloadAppAlert = NSLocalizedString("Download %@ App", comment: "Title of the alert dialog asking user if they would like to download %@ app")
    static let TitleContactInfoView = NSLocalizedString("Contact Info", comment: "Title of window showing user's contact info")
    static let TextPlaceholderFilterTags = NSLocalizedString("Filter interests", comment: "Placeholder text for filter interests input box")
    static let TextDownloadApp = NSLocalizedString("We tried opening the %@ app but it looks like you do not have it installed. Would you like to download it from the App Store?", comment: "Message of the alert dialog asking user if they would like to download %@ app")
    
    static let WaitlistInfoText = NSLocalizedString("luno is currently available only to employees at participating companies! You are on our list and we will notify you when your account is ready. Thanks!", comment: "Message indicating that the app is only available to employees of participating companies and the user's request to access it is in progress")
    static let WelcomeTitleText = NSLocalizedString("Welcome to luno", comment: "Header text for welcoming users to the app")
    static let WelcomeInfoText = NSLocalizedString("The easiest way to access any information on the people, teams, and locations that make up your company.\n\nLets get started by setting up your profile.", comment: "Tag line message shown on welcome view")
    
    static let SignInPlaceHolderText = NSLocalizedString("Work email address", comment: "Placeholder text indicating text field for entering work email address")
    static let SignOutButtonTitle = NSLocalizedString("Sign out", comment: "Title of sign out button")
    static let SignOutDisconnectButtonTitle = NSLocalizedString("Sign out & disconnect account", comment: "Title of sign out and disconnect button")
}
