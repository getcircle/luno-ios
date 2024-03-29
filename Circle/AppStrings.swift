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
    static let AddDetailsPlaceholder = NSLocalizedString("Add details", comment: "Generic text asking user to add details")
    static let AddTeamDescriptionPlaceholder = NSLocalizedString("Add a description for your team", comment: "Add a description to the team")
    
    static let CardTitlePeople = NSLocalizedString("People", comment: "Title of the card showing people")
    static let CardTitleOfficeTeam = NSLocalizedString("Office Teams", comment: "Title of the card showing teams in a office")
    static let CardTitleAddress = NSLocalizedString("Address", comment: "Title of the card showing address")
    
    static let ContactLabelCellPhone = NSLocalizedString("Cell Phone", comment: "Label for showing cell phone")
    static let ContactLabelPersonalEmail = NSLocalizedString("Personal Email", comment: "Label for showing personal email")
    static let ContactLabelWorkEmail = NSLocalizedString("Work Email", comment: "Label for showing work email")
    static let ContactLabelWorkPhone = NSLocalizedString("Work Phone", comment: "Label for showing work phone")
    
    static let ContactPlaceholderAddNumber = NSLocalizedString("Add Number", comment: "Placeholder for phone field when current user does not have a number added")
    static let ContactPlaceholderNumberNotAdded = NSLocalizedString("Number not added", comment: "Placeholder for phone field when a user does not have a number added")
    
    static let EditProfileFormWarning = NSLocalizedString("Your manager will be notified of changes when you hit Save.", comment: "Message indicating the user any changes to their profile will be notified to manager as well")
    static let EditProfileManagerPlaceholder = NSLocalizedString("Add Manager", comment: "Placeholder for manager field when current user does not have a manager")
    static let EditProfileSaveError = NSLocalizedString("Error updating profile", comment: "Message indicating that an error was encountered trying to save changes to the profile")
    static let EditTeamFormWarning = NSLocalizedString("The team manager will be notified of changes when you hit Save.", comment: "Message indicating the user any changes to the team will be notified to team's manager")
    static let EmailFeedbackSubject = NSLocalizedString("Feedback on luno", comment: "Subject of the feedback email")
    
    static let FieldLabelNickname = NSLocalizedString("Nickname", comment: "A person's nickname")

    static let GenericErrorMessage = NSLocalizedString("Oops! There was an error connecting to our server.", comment: "Generic error message shown when there is any error in fetching data")
    
    static let GenericEditButtonTitle = NSLocalizedString("Edit", comment: "Generic button title for editing any content")
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
    static let GenericSaveButtonTitle = NSLocalizedString("Save", comment: "Generic button title for saving changes a user has made")
    static let GenericPostButtonTitle = NSLocalizedString("Post", comment: "Generic button title for posting content")

    static let KnowledgePostTitle = NSLocalizedString("Knowledge Post", comment: "Generic title for all knowledge posts")
    static let LocalTimeLabel = NSLocalizedString("Local Time", comment: "Label indicating the local time of a location")

    static let NotificationTitle = NSLocalizedString("Notification", comment: "Title for showing a notification message")
    static let NotificationsTitle = NSLocalizedString("Notifications", comment: "Title of the view that shows content related to notifications")
    static let NotificationInfoText = NSLocalizedString("We'd like to notify you when new people join, you are invited to events or when someone on your team is having a work anniversary. Turn notifications on?", comment: "Message indicating the users why we would like to notify them and asking for notifications permission")
    
    static let RequestAccessButtonTitle = NSLocalizedString("Request Access", comment: "Title of the button to request access to the app")
    
    static let RequestAccessConfirmationTest = NSLocalizedString("Great! We will notify you when your account is ready to access. Thanks!", comment: "Confirmation text shown when user requests access to the app.")
    
    static let PasswordTextFieldPlaceholder = NSLocalizedString("Password", comment: "Placeholder for password text field")
    static let PrivateBetaInfoText = NSLocalizedString("luno is currently available only to employees at participating companies! You can request access below or try logging into a different account.", comment: "Message indicating that the app is only available to employees of participating companies and the user can either request access or try a different account")
    
    static let ProfileInfoEditButtonTitle = NSLocalizedString("Edit", comment: "Title of the button to edit info")
    static let ProfileInfoUpdateButtonTitle = NSLocalizedString("New Update", comment: "Title of the button to update info")

    static let ProfileEditTitle = NSLocalizedString("Edit Profile", comment: "Title of the view which allows the user to edit their profile")
    static let ProfileEditUpdatePhoto = NSLocalizedString("Update Photo", comment: "Button prompt to update user's profile photo")
    
    static let ProfileSectionContactPreferencesTitle = NSLocalizedString("Contact Preferences", comment: "Title of the section which takes user to preferences on contact info")
    static let ProfileSectionManagerTitle = NSLocalizedString("Reports to", comment: "Title of the section which shows user's manager")
    
    static let QuickActionNoneLabel = ""
    static let QuickActionCallLabel = NSLocalizedString("Call", comment: "Title for button used to initiate a call")
    static let QuickActionEmailLabel = NSLocalizedString("Email", comment: "Title for button used to send an email")
    static let QuickActionInfoLabel = NSLocalizedString("Info", comment: "Title for button used to see info")
    static let QuickActionMessageLabel = NSLocalizedString("Message", comment: "Title for button used to send a message")
    static let QuickActionSlackLabel = NSLocalizedString("Slack", comment: "Title for button used send a message via Slack")
    static let QuickActionVideoLabel = NSLocalizedString("Video", comment: "Title for button used to initial a video call")
    
    static let SearchPlaceholder = NSLocalizedString("Search knowledge, people, & teams", comment: "Placeholder text for search field used to search knowledge, people, teams, and locations.")
    static let SearchCategoryPosts = NSLocalizedString("Knowledge", comment: "Title of search category for company knowledge")
    
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

    static let TeamEditButtonTitle = NSLocalizedString("Edit Team", comment: "Title of the button to edit detail of a team")
    static let TeamSubTeamsSectionTitle = NSLocalizedString("Teams", comment: "Title of the section showing sub-teams of a team")
    static let TeamNameFieldLabel = NSLocalizedString("Team name", comment: "Label for team name input field")
    static let TeamNameErrorCannotBeEmpty = NSLocalizedString("Team name cannot be empty.", comment: "Error message indicating team name cannot be an empty string")
    static let TeamDescriptionFieldPlaceholder = NSLocalizedString("What is your team responsible for? Your team description should help your fellow coworkers understand if members of your team can answer their questions.", comment: "Placeholder text for team description text field")
    static let TeamDescriptionFieldLabel = NSLocalizedString("Description", comment: "Label for team description input field")
    
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
    
    static let ChangeManagerTitle = NSLocalizedString("Change Manager", comment: "Title of the view which allows a person to change their manager")
}
