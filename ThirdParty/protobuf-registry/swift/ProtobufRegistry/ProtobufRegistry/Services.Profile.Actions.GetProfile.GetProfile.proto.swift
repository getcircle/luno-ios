// Generated by the protocol buffer compiler.  DO NOT EDIT!
// Source file get_profile.proto

import Foundation

public extension Services.Profile.Actions{ public struct GetProfile { }}

public func == (lhs: Services.Profile.Actions.GetProfile.RequestV1, rhs: Services.Profile.Actions.GetProfile.RequestV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasProfileId == rhs.hasProfileId) && (!lhs.hasProfileId || lhs.profileId == rhs.profileId)
  fieldCheck = fieldCheck && (lhs.hasInflations == rhs.hasInflations) && (!lhs.hasInflations || lhs.inflations == rhs.inflations)
  fieldCheck = fieldCheck && (lhs.hasEmail == rhs.hasEmail) && (!lhs.hasEmail || lhs.email == rhs.email)
  fieldCheck = fieldCheck && (lhs.hasAuthenticationIdentifier == rhs.hasAuthenticationIdentifier) && (!lhs.hasAuthenticationIdentifier || lhs.authenticationIdentifier == rhs.authenticationIdentifier)
  fieldCheck = fieldCheck && (lhs.hasFields == rhs.hasFields) && (!lhs.hasFields || lhs.fields == rhs.fields)
  fieldCheck = (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
  return fieldCheck
}

public func == (lhs: Services.Profile.Actions.GetProfile.ResponseV1, rhs: Services.Profile.Actions.GetProfile.ResponseV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasProfile == rhs.hasProfile) && (!lhs.hasProfile || lhs.profile == rhs.profile)
  fieldCheck = (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
  return fieldCheck
}

public extension Services.Profile.Actions.GetProfile {
  public struct GetProfileRoot {
    public static var sharedInstance : GetProfileRoot {
     struct Static {
         static let instance : GetProfileRoot = GetProfileRoot()
     }
     return Static.instance
    }
    public var extensionRegistry:ExtensionRegistry

    init() {
      extensionRegistry = ExtensionRegistry()
      registerAllExtensions(extensionRegistry)
      Services.Common.Containers.ContainersRoot.sharedInstance.registerAllExtensions(extensionRegistry)
      Services.Profile.Containers.ContainersRoot.sharedInstance.registerAllExtensions(extensionRegistry)
    }
    public func registerAllExtensions(registry:ExtensionRegistry) {
    }
  }

  final public class RequestV1 : GeneratedMessage, GeneratedMessageProtocol {
    public private(set) var hasProfileId:Bool = false
    public private(set) var profileId:String = ""

    public private(set) var hasInflations:Bool = false
    public private(set) var inflations:Services.Common.Containers.InflationsV1!
    public private(set) var hasEmail:Bool = false
    public private(set) var email:String = ""

    public private(set) var hasAuthenticationIdentifier:Bool = false
    public private(set) var authenticationIdentifier:String = ""

    public private(set) var hasFields:Bool = false
    public private(set) var fields:Services.Common.Containers.FieldsV1!
    required public init() {
         super.init()
    }
    override public func isInitialized() -> Bool {
     return true
    }
    override public func writeToCodedOutputStream(output:CodedOutputStream) throws {
      if hasProfileId {
        try output.writeString(1, value:profileId)
      }
      if hasInflations {
        try output.writeMessage(2, value:inflations)
      }
      if hasEmail {
        try output.writeString(3, value:email)
      }
      if hasAuthenticationIdentifier {
        try output.writeString(4, value:authenticationIdentifier)
      }
      if hasFields {
        try output.writeMessage(5, value:fields)
      }
      try unknownFields.writeToCodedOutputStream(output)
    }
    override public func serializedSize() -> Int32 {
      var serialize_size:Int32 = memoizedSerializedSize
      if serialize_size != -1 {
       return serialize_size
      }

      serialize_size = 0
      if hasProfileId {
        serialize_size += profileId.computeStringSize(1)
      }
      if hasInflations {
          if let varSizeinflations = inflations?.computeMessageSize(2) {
              serialize_size += varSizeinflations
          }
      }
      if hasEmail {
        serialize_size += email.computeStringSize(3)
      }
      if hasAuthenticationIdentifier {
        serialize_size += authenticationIdentifier.computeStringSize(4)
      }
      if hasFields {
          if let varSizefields = fields?.computeMessageSize(5) {
              serialize_size += varSizefields
          }
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseArrayDelimitedFromInputStream(input:NSInputStream) throws -> Array<Services.Profile.Actions.GetProfile.RequestV1> {
      var mergedArray = Array<Services.Profile.Actions.GetProfile.RequestV1>()
      while let value = try parseFromDelimitedFromInputStream(input) {
        mergedArray += [value]
      }
      return mergedArray
    }
    public class func parseFromDelimitedFromInputStream(input:NSInputStream) throws -> Services.Profile.Actions.GetProfile.RequestV1? {
      return try Services.Profile.Actions.GetProfile.RequestV1.Builder().mergeDelimitedFromInputStream(input)?.build()
    }
    public class func parseFromData(data:NSData) throws -> Services.Profile.Actions.GetProfile.RequestV1 {
      return try Services.Profile.Actions.GetProfile.RequestV1.Builder().mergeFromData(data, extensionRegistry:Services.Profile.Actions.GetProfile.GetProfileRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) throws -> Services.Profile.Actions.GetProfile.RequestV1 {
      return try Services.Profile.Actions.GetProfile.RequestV1.Builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) throws -> Services.Profile.Actions.GetProfile.RequestV1 {
      return try Services.Profile.Actions.GetProfile.RequestV1.Builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Profile.Actions.GetProfile.RequestV1 {
      return try Services.Profile.Actions.GetProfile.RequestV1.Builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) throws -> Services.Profile.Actions.GetProfile.RequestV1 {
      return try Services.Profile.Actions.GetProfile.RequestV1.Builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Profile.Actions.GetProfile.RequestV1 {
      return try Services.Profile.Actions.GetProfile.RequestV1.Builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func getBuilder() -> Services.Profile.Actions.GetProfile.RequestV1.Builder {
      return Services.Profile.Actions.GetProfile.RequestV1.classBuilder() as! Services.Profile.Actions.GetProfile.RequestV1.Builder
    }
    public func getBuilder() -> Services.Profile.Actions.GetProfile.RequestV1.Builder {
      return classBuilder() as! Services.Profile.Actions.GetProfile.RequestV1.Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.Profile.Actions.GetProfile.RequestV1.Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.Profile.Actions.GetProfile.RequestV1.Builder()
    }
    public func toBuilder() throws -> Services.Profile.Actions.GetProfile.RequestV1.Builder {
      return try Services.Profile.Actions.GetProfile.RequestV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.Profile.Actions.GetProfile.RequestV1) throws -> Services.Profile.Actions.GetProfile.RequestV1.Builder {
      return try Services.Profile.Actions.GetProfile.RequestV1.Builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) throws {
      if hasProfileId {
        output += "\(indent) profileId: \(profileId) \n"
      }
      if hasInflations {
        output += "\(indent) inflations {\n"
        try inflations?.writeDescriptionTo(&output, indent:"\(indent)  ")
        output += "\(indent) }\n"
      }
      if hasEmail {
        output += "\(indent) email: \(email) \n"
      }
      if hasAuthenticationIdentifier {
        output += "\(indent) authenticationIdentifier: \(authenticationIdentifier) \n"
      }
      if hasFields {
        output += "\(indent) fields {\n"
        try fields?.writeDescriptionTo(&output, indent:"\(indent)  ")
        output += "\(indent) }\n"
      }
      unknownFields.writeDescriptionTo(&output, indent:indent)
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            if hasProfileId {
               hashCode = (hashCode &* 31) &+ profileId.hashValue
            }
            if hasInflations {
                if let hashValueinflations = inflations?.hashValue {
                    hashCode = (hashCode &* 31) &+ hashValueinflations
                }
            }
            if hasEmail {
               hashCode = (hashCode &* 31) &+ email.hashValue
            }
            if hasAuthenticationIdentifier {
               hashCode = (hashCode &* 31) &+ authenticationIdentifier.hashValue
            }
            if hasFields {
                if let hashValuefields = fields?.hashValue {
                    hashCode = (hashCode &* 31) &+ hashValuefields
                }
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.Profile.Actions.GetProfile.RequestV1"
    }
    override public func className() -> String {
        return "Services.Profile.Actions.GetProfile.RequestV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.Profile.Actions.GetProfile.RequestV1.self
    }
    //Meta information declaration end

    final public class Builder : GeneratedMessageBuilder {
      private var builderResult:Services.Profile.Actions.GetProfile.RequestV1 = Services.Profile.Actions.GetProfile.RequestV1()
      public func getMessage() -> Services.Profile.Actions.GetProfile.RequestV1 {
          return builderResult
      }

      required override public init () {
         super.init()
      }
      public var hasProfileId:Bool {
           get {
                return builderResult.hasProfileId
           }
      }
      public var profileId:String {
           get {
                return builderResult.profileId
           }
           set (value) {
               builderResult.hasProfileId = true
               builderResult.profileId = value
           }
      }
      public func setProfileId(value:String) -> Services.Profile.Actions.GetProfile.RequestV1.Builder {
        self.profileId = value
        return self
      }
      public func clearProfileId() -> Services.Profile.Actions.GetProfile.RequestV1.Builder{
           builderResult.hasProfileId = false
           builderResult.profileId = ""
           return self
      }
      public var hasInflations:Bool {
           get {
               return builderResult.hasInflations
           }
      }
      public var inflations:Services.Common.Containers.InflationsV1! {
           get {
               if inflationsBuilder_ != nil {
                  builderResult.inflations = inflationsBuilder_.getMessage()
               }
               return builderResult.inflations
           }
           set (value) {
               builderResult.hasInflations = true
               builderResult.inflations = value
           }
      }
      private var inflationsBuilder_:Services.Common.Containers.InflationsV1.Builder! {
           didSet {
              builderResult.hasInflations = true
           }
      }
      public func getInflationsBuilder() -> Services.Common.Containers.InflationsV1.Builder {
        if inflationsBuilder_ == nil {
           inflationsBuilder_ = Services.Common.Containers.InflationsV1.Builder()
           builderResult.inflations = inflationsBuilder_.getMessage()
           if inflations != nil {
              try! inflationsBuilder_.mergeFrom(inflations)
           }
        }
        return inflationsBuilder_
      }
      public func setInflations(value:Services.Common.Containers.InflationsV1!) -> Services.Profile.Actions.GetProfile.RequestV1.Builder {
        self.inflations = value
        return self
      }
      public func mergeInflations(value:Services.Common.Containers.InflationsV1) throws -> Services.Profile.Actions.GetProfile.RequestV1.Builder {
        if builderResult.hasInflations {
          builderResult.inflations = try Services.Common.Containers.InflationsV1.builderWithPrototype(builderResult.inflations).mergeFrom(value).buildPartial()
        } else {
          builderResult.inflations = value
        }
        builderResult.hasInflations = true
        return self
      }
      public func clearInflations() -> Services.Profile.Actions.GetProfile.RequestV1.Builder {
        inflationsBuilder_ = nil
        builderResult.hasInflations = false
        builderResult.inflations = nil
        return self
      }
      public var hasEmail:Bool {
           get {
                return builderResult.hasEmail
           }
      }
      public var email:String {
           get {
                return builderResult.email
           }
           set (value) {
               builderResult.hasEmail = true
               builderResult.email = value
           }
      }
      public func setEmail(value:String) -> Services.Profile.Actions.GetProfile.RequestV1.Builder {
        self.email = value
        return self
      }
      public func clearEmail() -> Services.Profile.Actions.GetProfile.RequestV1.Builder{
           builderResult.hasEmail = false
           builderResult.email = ""
           return self
      }
      public var hasAuthenticationIdentifier:Bool {
           get {
                return builderResult.hasAuthenticationIdentifier
           }
      }
      public var authenticationIdentifier:String {
           get {
                return builderResult.authenticationIdentifier
           }
           set (value) {
               builderResult.hasAuthenticationIdentifier = true
               builderResult.authenticationIdentifier = value
           }
      }
      public func setAuthenticationIdentifier(value:String) -> Services.Profile.Actions.GetProfile.RequestV1.Builder {
        self.authenticationIdentifier = value
        return self
      }
      public func clearAuthenticationIdentifier() -> Services.Profile.Actions.GetProfile.RequestV1.Builder{
           builderResult.hasAuthenticationIdentifier = false
           builderResult.authenticationIdentifier = ""
           return self
      }
      public var hasFields:Bool {
           get {
               return builderResult.hasFields
           }
      }
      public var fields:Services.Common.Containers.FieldsV1! {
           get {
               if fieldsBuilder_ != nil {
                  builderResult.fields = fieldsBuilder_.getMessage()
               }
               return builderResult.fields
           }
           set (value) {
               builderResult.hasFields = true
               builderResult.fields = value
           }
      }
      private var fieldsBuilder_:Services.Common.Containers.FieldsV1.Builder! {
           didSet {
              builderResult.hasFields = true
           }
      }
      public func getFieldsBuilder() -> Services.Common.Containers.FieldsV1.Builder {
        if fieldsBuilder_ == nil {
           fieldsBuilder_ = Services.Common.Containers.FieldsV1.Builder()
           builderResult.fields = fieldsBuilder_.getMessage()
           if fields != nil {
              try! fieldsBuilder_.mergeFrom(fields)
           }
        }
        return fieldsBuilder_
      }
      public func setFields(value:Services.Common.Containers.FieldsV1!) -> Services.Profile.Actions.GetProfile.RequestV1.Builder {
        self.fields = value
        return self
      }
      public func mergeFields(value:Services.Common.Containers.FieldsV1) throws -> Services.Profile.Actions.GetProfile.RequestV1.Builder {
        if builderResult.hasFields {
          builderResult.fields = try Services.Common.Containers.FieldsV1.builderWithPrototype(builderResult.fields).mergeFrom(value).buildPartial()
        } else {
          builderResult.fields = value
        }
        builderResult.hasFields = true
        return self
      }
      public func clearFields() -> Services.Profile.Actions.GetProfile.RequestV1.Builder {
        fieldsBuilder_ = nil
        builderResult.hasFields = false
        builderResult.fields = nil
        return self
      }
      override public var internalGetResult:GeneratedMessage {
           get {
              return builderResult
           }
      }
      public override func clear() -> Services.Profile.Actions.GetProfile.RequestV1.Builder {
        builderResult = Services.Profile.Actions.GetProfile.RequestV1()
        return self
      }
      public override func clone() throws -> Services.Profile.Actions.GetProfile.RequestV1.Builder {
        return try Services.Profile.Actions.GetProfile.RequestV1.builderWithPrototype(builderResult)
      }
      public override func build() throws -> Services.Profile.Actions.GetProfile.RequestV1 {
           try checkInitialized()
           return buildPartial()
      }
      public func buildPartial() -> Services.Profile.Actions.GetProfile.RequestV1 {
        let returnMe:Services.Profile.Actions.GetProfile.RequestV1 = builderResult
        return returnMe
      }
      public func mergeFrom(other:Services.Profile.Actions.GetProfile.RequestV1) throws -> Services.Profile.Actions.GetProfile.RequestV1.Builder {
        if other == Services.Profile.Actions.GetProfile.RequestV1() {
         return self
        }
        if other.hasProfileId {
             profileId = other.profileId
        }
        if (other.hasInflations) {
            try mergeInflations(other.inflations)
        }
        if other.hasEmail {
             email = other.email
        }
        if other.hasAuthenticationIdentifier {
             authenticationIdentifier = other.authenticationIdentifier
        }
        if (other.hasFields) {
            try mergeFields(other.fields)
        }
        try mergeUnknownFields(other.unknownFields)
        return self
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream) throws -> Services.Profile.Actions.GetProfile.RequestV1.Builder {
           return try mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Profile.Actions.GetProfile.RequestV1.Builder {
        let unknownFieldsBuilder:UnknownFieldSet.Builder = try UnknownFieldSet.builderWithUnknownFields(self.unknownFields)
        while (true) {
          let tag = try input.readTag()
          switch tag {
          case 0: 
            self.unknownFields = try unknownFieldsBuilder.build()
            return self

          case 10 :
            profileId = try input.readString()

          case 18 :
            let subBuilder:Services.Common.Containers.InflationsV1.Builder = Services.Common.Containers.InflationsV1.Builder()
            if hasInflations {
              try subBuilder.mergeFrom(inflations)
            }
            try input.readMessage(subBuilder, extensionRegistry:extensionRegistry)
            inflations = subBuilder.buildPartial()

          case 26 :
            email = try input.readString()

          case 34 :
            authenticationIdentifier = try input.readString()

          case 42 :
            let subBuilder:Services.Common.Containers.FieldsV1.Builder = Services.Common.Containers.FieldsV1.Builder()
            if hasFields {
              try subBuilder.mergeFrom(fields)
            }
            try input.readMessage(subBuilder, extensionRegistry:extensionRegistry)
            fields = subBuilder.buildPartial()

          default:
            if (!(try parseUnknownField(input,unknownFields:unknownFieldsBuilder, extensionRegistry:extensionRegistry, tag:tag))) {
               unknownFields = try unknownFieldsBuilder.build()
               return self
            }
          }
        }
      }
    }

  }

  final public class ResponseV1 : GeneratedMessage, GeneratedMessageProtocol {
    public private(set) var hasProfile:Bool = false
    public private(set) var profile:Services.Profile.Containers.ProfileV1!
    required public init() {
         super.init()
    }
    override public func isInitialized() -> Bool {
     return true
    }
    override public func writeToCodedOutputStream(output:CodedOutputStream) throws {
      if hasProfile {
        try output.writeMessage(1, value:profile)
      }
      try unknownFields.writeToCodedOutputStream(output)
    }
    override public func serializedSize() -> Int32 {
      var serialize_size:Int32 = memoizedSerializedSize
      if serialize_size != -1 {
       return serialize_size
      }

      serialize_size = 0
      if hasProfile {
          if let varSizeprofile = profile?.computeMessageSize(1) {
              serialize_size += varSizeprofile
          }
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseArrayDelimitedFromInputStream(input:NSInputStream) throws -> Array<Services.Profile.Actions.GetProfile.ResponseV1> {
      var mergedArray = Array<Services.Profile.Actions.GetProfile.ResponseV1>()
      while let value = try parseFromDelimitedFromInputStream(input) {
        mergedArray += [value]
      }
      return mergedArray
    }
    public class func parseFromDelimitedFromInputStream(input:NSInputStream) throws -> Services.Profile.Actions.GetProfile.ResponseV1? {
      return try Services.Profile.Actions.GetProfile.ResponseV1.Builder().mergeDelimitedFromInputStream(input)?.build()
    }
    public class func parseFromData(data:NSData) throws -> Services.Profile.Actions.GetProfile.ResponseV1 {
      return try Services.Profile.Actions.GetProfile.ResponseV1.Builder().mergeFromData(data, extensionRegistry:Services.Profile.Actions.GetProfile.GetProfileRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) throws -> Services.Profile.Actions.GetProfile.ResponseV1 {
      return try Services.Profile.Actions.GetProfile.ResponseV1.Builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) throws -> Services.Profile.Actions.GetProfile.ResponseV1 {
      return try Services.Profile.Actions.GetProfile.ResponseV1.Builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Profile.Actions.GetProfile.ResponseV1 {
      return try Services.Profile.Actions.GetProfile.ResponseV1.Builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) throws -> Services.Profile.Actions.GetProfile.ResponseV1 {
      return try Services.Profile.Actions.GetProfile.ResponseV1.Builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Profile.Actions.GetProfile.ResponseV1 {
      return try Services.Profile.Actions.GetProfile.ResponseV1.Builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func getBuilder() -> Services.Profile.Actions.GetProfile.ResponseV1.Builder {
      return Services.Profile.Actions.GetProfile.ResponseV1.classBuilder() as! Services.Profile.Actions.GetProfile.ResponseV1.Builder
    }
    public func getBuilder() -> Services.Profile.Actions.GetProfile.ResponseV1.Builder {
      return classBuilder() as! Services.Profile.Actions.GetProfile.ResponseV1.Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.Profile.Actions.GetProfile.ResponseV1.Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.Profile.Actions.GetProfile.ResponseV1.Builder()
    }
    public func toBuilder() throws -> Services.Profile.Actions.GetProfile.ResponseV1.Builder {
      return try Services.Profile.Actions.GetProfile.ResponseV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.Profile.Actions.GetProfile.ResponseV1) throws -> Services.Profile.Actions.GetProfile.ResponseV1.Builder {
      return try Services.Profile.Actions.GetProfile.ResponseV1.Builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) throws {
      if hasProfile {
        output += "\(indent) profile {\n"
        try profile?.writeDescriptionTo(&output, indent:"\(indent)  ")
        output += "\(indent) }\n"
      }
      unknownFields.writeDescriptionTo(&output, indent:indent)
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            if hasProfile {
                if let hashValueprofile = profile?.hashValue {
                    hashCode = (hashCode &* 31) &+ hashValueprofile
                }
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.Profile.Actions.GetProfile.ResponseV1"
    }
    override public func className() -> String {
        return "Services.Profile.Actions.GetProfile.ResponseV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.Profile.Actions.GetProfile.ResponseV1.self
    }
    //Meta information declaration end

    final public class Builder : GeneratedMessageBuilder {
      private var builderResult:Services.Profile.Actions.GetProfile.ResponseV1 = Services.Profile.Actions.GetProfile.ResponseV1()
      public func getMessage() -> Services.Profile.Actions.GetProfile.ResponseV1 {
          return builderResult
      }

      required override public init () {
         super.init()
      }
      public var hasProfile:Bool {
           get {
               return builderResult.hasProfile
           }
      }
      public var profile:Services.Profile.Containers.ProfileV1! {
           get {
               if profileBuilder_ != nil {
                  builderResult.profile = profileBuilder_.getMessage()
               }
               return builderResult.profile
           }
           set (value) {
               builderResult.hasProfile = true
               builderResult.profile = value
           }
      }
      private var profileBuilder_:Services.Profile.Containers.ProfileV1.Builder! {
           didSet {
              builderResult.hasProfile = true
           }
      }
      public func getProfileBuilder() -> Services.Profile.Containers.ProfileV1.Builder {
        if profileBuilder_ == nil {
           profileBuilder_ = Services.Profile.Containers.ProfileV1.Builder()
           builderResult.profile = profileBuilder_.getMessage()
           if profile != nil {
              try! profileBuilder_.mergeFrom(profile)
           }
        }
        return profileBuilder_
      }
      public func setProfile(value:Services.Profile.Containers.ProfileV1!) -> Services.Profile.Actions.GetProfile.ResponseV1.Builder {
        self.profile = value
        return self
      }
      public func mergeProfile(value:Services.Profile.Containers.ProfileV1) throws -> Services.Profile.Actions.GetProfile.ResponseV1.Builder {
        if builderResult.hasProfile {
          builderResult.profile = try Services.Profile.Containers.ProfileV1.builderWithPrototype(builderResult.profile).mergeFrom(value).buildPartial()
        } else {
          builderResult.profile = value
        }
        builderResult.hasProfile = true
        return self
      }
      public func clearProfile() -> Services.Profile.Actions.GetProfile.ResponseV1.Builder {
        profileBuilder_ = nil
        builderResult.hasProfile = false
        builderResult.profile = nil
        return self
      }
      override public var internalGetResult:GeneratedMessage {
           get {
              return builderResult
           }
      }
      public override func clear() -> Services.Profile.Actions.GetProfile.ResponseV1.Builder {
        builderResult = Services.Profile.Actions.GetProfile.ResponseV1()
        return self
      }
      public override func clone() throws -> Services.Profile.Actions.GetProfile.ResponseV1.Builder {
        return try Services.Profile.Actions.GetProfile.ResponseV1.builderWithPrototype(builderResult)
      }
      public override func build() throws -> Services.Profile.Actions.GetProfile.ResponseV1 {
           try checkInitialized()
           return buildPartial()
      }
      public func buildPartial() -> Services.Profile.Actions.GetProfile.ResponseV1 {
        let returnMe:Services.Profile.Actions.GetProfile.ResponseV1 = builderResult
        return returnMe
      }
      public func mergeFrom(other:Services.Profile.Actions.GetProfile.ResponseV1) throws -> Services.Profile.Actions.GetProfile.ResponseV1.Builder {
        if other == Services.Profile.Actions.GetProfile.ResponseV1() {
         return self
        }
        if (other.hasProfile) {
            try mergeProfile(other.profile)
        }
        try mergeUnknownFields(other.unknownFields)
        return self
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream) throws -> Services.Profile.Actions.GetProfile.ResponseV1.Builder {
           return try mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Profile.Actions.GetProfile.ResponseV1.Builder {
        let unknownFieldsBuilder:UnknownFieldSet.Builder = try UnknownFieldSet.builderWithUnknownFields(self.unknownFields)
        while (true) {
          let tag = try input.readTag()
          switch tag {
          case 0: 
            self.unknownFields = try unknownFieldsBuilder.build()
            return self

          case 10 :
            let subBuilder:Services.Profile.Containers.ProfileV1.Builder = Services.Profile.Containers.ProfileV1.Builder()
            if hasProfile {
              try subBuilder.mergeFrom(profile)
            }
            try input.readMessage(subBuilder, extensionRegistry:extensionRegistry)
            profile = subBuilder.buildPartial()

          default:
            if (!(try parseUnknownField(input,unknownFields:unknownFieldsBuilder, extensionRegistry:extensionRegistry, tag:tag))) {
               unknownFields = try unknownFieldsBuilder.build()
               return self
            }
          }
        }
      }
    }

  }

}

// @@protoc_insertion_point(global_scope)
