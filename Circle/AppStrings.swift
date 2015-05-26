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

    static let AddNoteCTATitle = NSLocalizedString("Add private note", comment: "Title of the button to add a private note on a co-worker")
    static let AddTagsNavigationTitle = NSLocalizedString("Add Tags", comment: "Title of the view to add interests")
    static let AppreciateCTATitle = NSLocalizedString("Appreciate", comment: "Title of the button to leave an appreciation for a co-worker")
    
    static let CardTitlePeople = NSLocalizedString("People", comment: "Title of the card showing people")
    static let CardTitleOfficeTeam = NSLocalizedString("Office Teams", comment: "Title of the card showing teams in a office")
    static let CardTitleAddress = NSLocalizedString("Location", comment: "Title of the card showing address")
    
    static let ContactLabelCellPhone = NSLocalizedString("Cell Phone", comment: "Label for showing cell phone")
    static let ContactLabelPersonalEmail = NSLocalizedString("Personal Email", comment: "Label for showing personal email")
    static let ContactLabelWorkEmail = NSLocalizedString("Work Email", comment: "Label for showing work email")
    static let ContactLabelWorkPhone = NSLocalizedString("Work Phone", comment: "Label for showing work phone")
    
    static let EmailFeedbackSubject = NSLocalizedString("Feedback on circle", comment: "Subject of the feedback email")
    
    static let FieldLabelNickname = NSLocalizedString("Nickname", comment: "A person's nickname")

    static let GenericErrorMessage = NSLocalizedString("Oops! There was an error connecting to our server.", comment: "Generic error message shown when there is any error in fetching data")
    
    static let GenericCancelButtonTitle = NSLocalizedString("Cancel", comment: "Generic button title for cancelling a user action")
    static let GenericDoneButtonTitle = NSLocalizedString("Done", comment: "Generic button title for indicating a user has completed an action")
    static let GenericGetStartedButtonTitle = NSLocalizedString("Get Started", comment: "Generic button title to start some action")
    static let GenericNextButtonTitle = NSLocalizedString("Next", comment: "Generic button title for moving to next action")
    static let GenericNoThanksButtonTitle = NSLocalizedString("No thanks", comment: "Generic button title for declining an action")
    static let GenericNotNowButtonTitle = NSLocalizedString("Not now", comment: "Generic button title for declining an action for now")
    static let GenericYesButtonTitle = NSLocalizedString("Yes", comment: "Generic button title for confirming an action")
    static let GenericTryAgainButtonTitle = NSLocalizedString("Try Again", comment: "Generic button title to try some action again")
    
    static let GroupAddMembersNavTitle = NSLocalizedString("Add members", comment: "Title for view used to add members to a group")
    static let GroupLeaveGroupButtonTitle = NSLocalizedString("Leave group", comment: "Title of the button to leave a group")
    static let GroupManagersSectionTitle = NSLocalizedString("Managers", comment: "Label for the section listing managers of a group")
    static let GroupMembersSectionTitle = NSLocalizedString("Members", comment: "Label for the section listing members of a group")
    static let GroupMembersCount = NSLocalizedString("%d Members", comment: "Label indicating the number of members of a group")
    static let GroupOneMemberCount = NSLocalizedString("1 Member", comment: "Label indicating there is one member in a group")
    static let GroupRequestMessage = NSLocalizedString("%@ requested to join %@ group", comment: "Message indicating a person requested access to a group")
    
    static let NotificationsTitle = NSLocalizedString("Notifications", comment: "Title of the view that shows content related to notifications")
    static let NotificationInfoText = NSLocalizedString("We'd like to notify you when new people join, you are invited to events or when someone on your team is having a work anniversary. Turn notifications on?", comment: "Message indicating the users why we would like to notify them and asking for notifications permission")
    
    static let RequestAccessButtonTitle = NSLocalizedString("Request Access", comment: "Title of the button to request access to the app")
    
    static let RequestAccessConfirmationTest = NSLocalizedString("Great! We will notify you when your account is ready to access. Thanks!", comment: "Confirmation text shown when user requests access to the app.")
    
    static let PasswordTextFieldPlaceholder = NSLocalizedString("Password", comment: "Placeholder for password text field")
    static let PrivateBetaInfoText = NSLocalizedString("circle is currently available only to employees at participating companies! You can request access below or try logging into a different account.", comment: "Message indicating that the app is only available to employees of participating companies and the user can either request access or try a different account")
    
    static let ProfileInfoAddButtonTitle = NSLocalizedString("Add", comment: "Title of the button to add info")
    static let ProfileInfoEditButtonTitle = NSLocalizedString("Edit", comment: "Title of the button to edit info")
    
    static let ProfileNotesTabTitle = NSLocalizedString("Notes", comment: "Title of the Notes section")
    static let ProfileAppreciationTabTitle = NSLocalizedString("Appreciation", comment: "Title of the Appreciation section")
    
    static let ProfileSectionAboutTitle = NSLocalizedString("About", comment: "Title of the section which shows user bio, nick name and other personal info")
    static let ProfileSectionBioTitle = NSLocalizedString("Bio", comment: "Title of the section which shows user's bio")
    static let ProfileSectionContactPreferencesTitle = NSLocalizedString("Contact Preferences", comment: "Title of the section which takes user to preferences on contact info")
    static let ProfileSectionGroupsTitle = NSLocalizedString("Groups", comment: "Title of the section which lists the groups a user is part of")
    static let ProfileSectionInfoTitle = NSLocalizedString("Info", comment: "Title of the Info section")
    static let ProfileSectionOfficeTitle = NSLocalizedString("Office", comment: "Title of the section which shows a user's office")
    static let ProfileSectionOfficeTeamTitle = NSLocalizedString("Office & Team", comment: "Title of the section which shows a user's office and team")
    static let ProfileSectionOtherTitle = NSLocalizedString("Other", comment: "Title of the section which consists of misc. other info")
    static let ProfileSectionManagerTitle = NSLocalizedString("Manager", comment: "Title of the section which shows a user's manager")
    static let ProfileSectionManagerTeamTitle = NSLocalizedString("Manager & Team", comment: "Title of the section which shows a user's manager and team")
    static let ProfileSectionTagsTitle = NSLocalizedString("Tags", comment: "Title of the section which shows a user's interests")
    static let ProfileSectionExperienceTitle = NSLocalizedString("Experience", comment: "Title of the section which shows a user's experience")
    static let ProfileSectionEducationTitle = NSLocalizedString("Education", comment: "Title of the section which shows a user's education")
    static let ProfileSectionExpertiseTitle = NSLocalizedString("Expertise", comment: "Title of the section which shows a user's expertise")
    static let ProfileSectionInterestsTitle = NSLocalizedString("Interests", comment: "Title of the section which shows a user's interests")

    static let QuickActionNoneLabel = ""
    static let QuickActionCallLabel = NSLocalizedString("Call", comment: "Title for button used to initiate a call")
    static let QuickActionEmailLabel = NSLocalizedString("Email", comment: "Title for button used to send an email")
    static let QuickActionInfoLabel = NSLocalizedString("Info", comment: "Title for button used to see info")
    static let QuickActionMessageLabel = NSLocalizedString("Message", comment: "Title for button used to send a message")
    static let QuickActionNoteLabel = NSLocalizedString("Note", comment: "Title for button used to take a note")
    static let QuickActionSlackLabel = NSLocalizedString("Slack", comment: "Title for button used send a message via Slack")
    static let QuickActionVideoLabel = NSLocalizedString("Video", comment: "Title for button used to initial a video call")
    
    static let QuickActionNonePlaceholder = NSLocalizedString("Find people, teams, and skills", comment: "Placeholder text for search field used to search people, teams and skills.")
    static let QuickActionEmailPlaceholder = NSLocalizedString("Who do you want to email?", comment: "Placeholder for search field used to search for the person user intends to email")
    static let QuickActionInfoPlaceholder = NSLocalizedString("Who do you want contact info on?", comment: "Placeholder for search field used to search for the person user intends to email")
    static let QuickActionMessagePlaceholder = NSLocalizedString("Who do you want to message?", comment: "Placeholder for search field used to search for the person user intends to send a message")
    static let QuickActionNotePlaceholder = NSLocalizedString("Who do you want to take a note on?", comment: "Placeholder for search field used to search for the person user intends to take a note about")
    static let QuickActionCallPlaceholder = NSLocalizedString("Who do you want to call?", comment: "Placeholder for search field used to search for the person user intends to call")
    static let QuickActionSlackPlaceholder = NSLocalizedString("Who do you want to message?", comment: "Placeholder for search field used to search for the person user intends to send a message")
    
    static let SignInCTA = NSLocalizedString("Sign In", comment: "Generic button title to sign in to the app")
    static let SignUpCTA = NSLocalizedString("Sign Up", comment: "Generic button title to sign up for the service")
    static let SocialConnectDefaultCTA = NSLocalizedString("Connect", comment: "Button title for connecting with generic social account")
    static let SocialConnectGooglePlusCTA = NSLocalizedString("Sign in with Google", comment: "Button title for sign in with Google button")
    static let SocialConnectLinkedInCTA = NSLocalizedString("Connect with LinkedIn", comment: "Button title for connect with LinkedIn button")
    static let StartUsingAppCTA = NSLocalizedString("Start using circle", comment: "Button title shown on the first screen to prompt user to sign up")

    static let TitleDownloadAppAlert = NSLocalizedString("Download %@ App", comment: "Title of the alert dialog asking user if they would like to download %@ app")
    static let TitleContactInfoView = NSLocalizedString("Contact Info", comment: "Title of window showing user's contact info")
    static let TextPlaceholderFilterTags = NSLocalizedString("Filter interests", comment: "Placeholder text for filter interests input box")
    static let TextDownloadApp = NSLocalizedString("We tried opening the %@ app but it looks like you do not have it installed. Would you like to download it from the App Store?", comment: "Message of the alert dialog asking user if they would like to download %@ app")
    
    static let WaitlistInfoText = NSLocalizedString("circle is currently available only to employees at participating companies! You are on our list and we will notify you when your account is ready. Thanks!", comment: "Message indicating that the app is only available to employees of participating companies and the user's request to access it is in progress")
    static let WelcomeTitleText = NSLocalizedString("Welcome to circle", comment: "Header text for welcoming users to the app")
    static let WelcomeInfoText = NSLocalizedString("The easiest way to access any information on the people, teams, and locations that make up your company.\n\nLets get started by setting up your profile.", comment: "Tag line message shown on welcome view")
    
    static let SignInPlaceHolderText = NSLocalizedString("Work email address", comment: "Placeholder text indicating text field for entering work email address")
    static let SignOutButtonTitle = NSLocalizedString("Sign out", comment: "Title of sign out button")
}
