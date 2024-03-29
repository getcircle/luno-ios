// Generated by the protocol buffer compiler.  DO NOT EDIT!
// Source file get_profiles.proto

import Foundation

public extension Services.Profile.Actions{ public struct GetProfiles { }}

public func == (lhs: Services.Profile.Actions.GetProfiles.RequestV1, rhs: Services.Profile.Actions.GetProfiles.RequestV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.ids == rhs.ids)
  fieldCheck = fieldCheck && (lhs.hasLocationId == rhs.hasLocationId) && (!lhs.hasLocationId || lhs.locationId == rhs.locationId)
  fieldCheck = fieldCheck && (lhs.hasTeamId == rhs.hasTeamId) && (!lhs.hasTeamId || lhs.teamId == rhs.teamId)
  fieldCheck = fieldCheck && (lhs.hasInflations == rhs.hasInflations) && (!lhs.hasInflations || lhs.inflations == rhs.inflations)
  fieldCheck = fieldCheck && (lhs.hasManagerId == rhs.hasManagerId) && (!lhs.hasManagerId || lhs.managerId == rhs.managerId)
  fieldCheck = fieldCheck && (lhs.emails == rhs.emails)
  fieldCheck = fieldCheck && (lhs.hasIsAdmin == rhs.hasIsAdmin) && (!lhs.hasIsAdmin || lhs.isAdmin == rhs.isAdmin)
  fieldCheck = fieldCheck && (lhs.authenticationIdentifiers == rhs.authenticationIdentifiers)
  fieldCheck = fieldCheck && (lhs.hasFields == rhs.hasFields) && (!lhs.hasFields || lhs.fields == rhs.fields)
  fieldCheck = (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
  return fieldCheck
}

public func == (lhs: Services.Profile.Actions.GetProfiles.ResponseV1, rhs: Services.Profile.Actions.GetProfiles.ResponseV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.profiles == rhs.profiles)
  fieldCheck = (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
  return fieldCheck
}

public extension Services.Profile.Actions.GetProfiles {
  public struct GetProfilesRoot {
    public static var sharedInstance : GetProfilesRoot {
     struct Static {
         static let instance : GetProfilesRoot = GetProfilesRoot()
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
    public private(set) var ids:Array<String> = Array<String>()
    public private(set) var hasLocationId:Bool = false
    public private(set) var locationId:String = ""

    public private(set) var hasTeamId:Bool = false
    public private(set) var teamId:String = ""

    public private(set) var hasInflations:Bool = false
    public private(set) var inflations:Services.Common.Containers.InflationsV1!
    public private(set) var hasManagerId:Bool = false
    public private(set) var managerId:String = ""

    public private(set) var emails:Array<String> = Array<String>()
    public private(set) var hasIsAdmin:Bool = false
    public private(set) var isAdmin:Bool = false

    public private(set) var authenticationIdentifiers:Array<String> = Array<String>()
    public private(set) var hasFields:Bool = false
    public private(set) var fields:Services.Common.Containers.FieldsV1!
    required public init() {
         super.init()
    }
    override public func isInitialized() -> Bool {
     return true
    }
    override public func writeToCodedOutputStream(output:CodedOutputStream) throws {
      if !ids.isEmpty {
        for oneValueids in ids {
          try output.writeString(1, value:oneValueids)
        }
      }
      if hasLocationId {
        try output.writeString(2, value:locationId)
      }
      if hasTeamId {
        try output.writeString(3, value:teamId)
      }
      if hasInflations {
        try output.writeMessage(4, value:inflations)
      }
      if hasManagerId {
        try output.writeString(5, value:managerId)
      }
      if !emails.isEmpty {
        for oneValueemails in emails {
          try output.writeString(6, value:oneValueemails)
        }
      }
      if hasIsAdmin {
        try output.writeBool(7, value:isAdmin)
      }
      if !authenticationIdentifiers.isEmpty {
        for oneValueauthenticationIdentifiers in authenticationIdentifiers {
          try output.writeString(8, value:oneValueauthenticationIdentifiers)
        }
      }
      if hasFields {
        try output.writeMessage(9, value:fields)
      }
      try unknownFields.writeToCodedOutputStream(output)
    }
    override public func serializedSize() -> Int32 {
      var serialize_size:Int32 = memoizedSerializedSize
      if serialize_size != -1 {
       return serialize_size
      }

      serialize_size = 0
      var dataSizeIds:Int32 = 0
      for oneValueids in ids {
          dataSizeIds += oneValueids.computeStringSizeNoTag()
      }
      serialize_size += dataSizeIds
      serialize_size += 1 * Int32(ids.count)
      if hasLocationId {
        serialize_size += locationId.computeStringSize(2)
      }
      if hasTeamId {
        serialize_size += teamId.computeStringSize(3)
      }
      if hasInflations {
          if let varSizeinflations = inflations?.computeMessageSize(4) {
              serialize_size += varSizeinflations
          }
      }
      if hasManagerId {
        serialize_size += managerId.computeStringSize(5)
      }
      var dataSizeEmails:Int32 = 0
      for oneValueemails in emails {
          dataSizeEmails += oneValueemails.computeStringSizeNoTag()
      }
      serialize_size += dataSizeEmails
      serialize_size += 1 * Int32(emails.count)
      if hasIsAdmin {
        serialize_size += isAdmin.computeBoolSize(7)
      }
      var dataSizeAuthenticationIdentifiers:Int32 = 0
      for oneValueauthenticationIdentifiers in authenticationIdentifiers {
          dataSizeAuthenticationIdentifiers += oneValueauthenticationIdentifiers.computeStringSizeNoTag()
      }
      serialize_size += dataSizeAuthenticationIdentifiers
      serialize_size += 1 * Int32(authenticationIdentifiers.count)
      if hasFields {
          if let varSizefields = fields?.computeMessageSize(9) {
              serialize_size += varSizefields
          }
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseArrayDelimitedFromInputStream(input:NSInputStream) throws -> Array<Services.Profile.Actions.GetProfiles.RequestV1> {
      var mergedArray = Array<Services.Profile.Actions.GetProfiles.RequestV1>()
      while let value = try parseFromDelimitedFromInputStream(input) {
        mergedArray += [value]
      }
      return mergedArray
    }
    public class func parseFromDelimitedFromInputStream(input:NSInputStream) throws -> Services.Profile.Actions.GetProfiles.RequestV1? {
      return try Services.Profile.Actions.GetProfiles.RequestV1.Builder().mergeDelimitedFromInputStream(input)?.build()
    }
    public class func parseFromData(data:NSData) throws -> Services.Profile.Actions.GetProfiles.RequestV1 {
      return try Services.Profile.Actions.GetProfiles.RequestV1.Builder().mergeFromData(data, extensionRegistry:Services.Profile.Actions.GetProfiles.GetProfilesRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) throws -> Services.Profile.Actions.GetProfiles.RequestV1 {
      return try Services.Profile.Actions.GetProfiles.RequestV1.Builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) throws -> Services.Profile.Actions.GetProfiles.RequestV1 {
      return try Services.Profile.Actions.GetProfiles.RequestV1.Builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Profile.Actions.GetProfiles.RequestV1 {
      return try Services.Profile.Actions.GetProfiles.RequestV1.Builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) throws -> Services.Profile.Actions.GetProfiles.RequestV1 {
      return try Services.Profile.Actions.GetProfiles.RequestV1.Builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Profile.Actions.GetProfiles.RequestV1 {
      return try Services.Profile.Actions.GetProfiles.RequestV1.Builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func getBuilder() -> Services.Profile.Actions.GetProfiles.RequestV1.Builder {
      return Services.Profile.Actions.GetProfiles.RequestV1.classBuilder() as! Services.Profile.Actions.GetProfiles.RequestV1.Builder
    }
    public func getBuilder() -> Services.Profile.Actions.GetProfiles.RequestV1.Builder {
      return classBuilder() as! Services.Profile.Actions.GetProfiles.RequestV1.Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.Profile.Actions.GetProfiles.RequestV1.Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.Profile.Actions.GetProfiles.RequestV1.Builder()
    }
    public func toBuilder() throws -> Services.Profile.Actions.GetProfiles.RequestV1.Builder {
      return try Services.Profile.Actions.GetProfiles.RequestV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.Profile.Actions.GetProfiles.RequestV1) throws -> Services.Profile.Actions.GetProfiles.RequestV1.Builder {
      return try Services.Profile.Actions.GetProfiles.RequestV1.Builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) throws {
      var idsElementIndex:Int = 0
      for oneValueids in ids  {
          output += "\(indent) ids[\(idsElementIndex)]: \(oneValueids)\n"
          idsElementIndex++
      }
      if hasLocationId {
        output += "\(indent) locationId: \(locationId) \n"
      }
      if hasTeamId {
        output += "\(indent) teamId: \(teamId) \n"
      }
      if hasInflations {
        output += "\(indent) inflations {\n"
        try inflations?.writeDescriptionTo(&output, indent:"\(indent)  ")
        output += "\(indent) }\n"
      }
      if hasManagerId {
        output += "\(indent) managerId: \(managerId) \n"
      }
      var emailsElementIndex:Int = 0
      for oneValueemails in emails  {
          output += "\(indent) emails[\(emailsElementIndex)]: \(oneValueemails)\n"
          emailsElementIndex++
      }
      if hasIsAdmin {
        output += "\(indent) isAdmin: \(isAdmin) \n"
      }
      var authenticationIdentifiersElementIndex:Int = 0
      for oneValueauthenticationIdentifiers in authenticationIdentifiers  {
          output += "\(indent) authenticationIdentifiers[\(authenticationIdentifiersElementIndex)]: \(oneValueauthenticationIdentifiers)\n"
          authenticationIdentifiersElementIndex++
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
            for oneValueids in ids {
                hashCode = (hashCode &* 31) &+ oneValueids.hashValue
            }
            if hasLocationId {
               hashCode = (hashCode &* 31) &+ locationId.hashValue
            }
            if hasTeamId {
               hashCode = (hashCode &* 31) &+ teamId.hashValue
            }
            if hasInflations {
                if let hashValueinflations = inflations?.hashValue {
                    hashCode = (hashCode &* 31) &+ hashValueinflations
                }
            }
            if hasManagerId {
               hashCode = (hashCode &* 31) &+ managerId.hashValue
            }
            for oneValueemails in emails {
                hashCode = (hashCode &* 31) &+ oneValueemails.hashValue
            }
            if hasIsAdmin {
               hashCode = (hashCode &* 31) &+ isAdmin.hashValue
            }
            for oneValueauthenticationIdentifiers in authenticationIdentifiers {
                hashCode = (hashCode &* 31) &+ oneValueauthenticationIdentifiers.hashValue
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
        return "Services.Profile.Actions.GetProfiles.RequestV1"
    }
    override public func className() -> String {
        return "Services.Profile.Actions.GetProfiles.RequestV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.Profile.Actions.GetProfiles.RequestV1.self
    }
    //Meta information declaration end

    final public class Builder : GeneratedMessageBuilder {
      private var builderResult:Services.Profile.Actions.GetProfiles.RequestV1 = Services.Profile.Actions.GetProfiles.RequestV1()
      public func getMessage() -> Services.Profile.Actions.GetProfiles.RequestV1 {
          return builderResult
      }

      required override public init () {
         super.init()
      }
      public var ids:Array<String> {
           get {
               return builderResult.ids
           }
           set (array) {
               builderResult.ids = array
           }
      }
      public func setIds(value:Array<String>) -> Services.Profile.Actions.GetProfiles.RequestV1.Builder {
        self.ids = value
        return self
      }
      public func clearIds() -> Services.Profile.Actions.GetProfiles.RequestV1.Builder {
         builderResult.ids.removeAll(keepCapacity: false)
         return self
      }
      public var hasLocationId:Bool {
           get {
                return builderResult.hasLocationId
           }
      }
      public var locationId:String {
           get {
                return builderResult.locationId
           }
           set (value) {
               builderResult.hasLocationId = true
               builderResult.locationId = value
           }
      }
      public func setLocationId(value:String) -> Services.Profile.Actions.GetProfiles.RequestV1.Builder {
        self.locationId = value
        return self
      }
      public func clearLocationId() -> Services.Profile.Actions.GetProfiles.RequestV1.Builder{
           builderResult.hasLocationId = false
           builderResult.locationId = ""
           return self
      }
      public var hasTeamId:Bool {
           get {
                return builderResult.hasTeamId
           }
      }
      public var teamId:String {
           get {
                return builderResult.teamId
           }
           set (value) {
               builderResult.hasTeamId = true
               builderResult.teamId = value
           }
      }
      public func setTeamId(value:String) -> Services.Profile.Actions.GetProfiles.RequestV1.Builder {
        self.teamId = value
        return self
      }
      public func clearTeamId() -> Services.Profile.Actions.GetProfiles.RequestV1.Builder{
           builderResult.hasTeamId = false
           builderResult.teamId = ""
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
      public func setInflations(value:Services.Common.Containers.InflationsV1!) -> Services.Profile.Actions.GetProfiles.RequestV1.Builder {
        self.inflations = value
        return self
      }
      public func mergeInflations(value:Services.Common.Containers.InflationsV1) throws -> Services.Profile.Actions.GetProfiles.RequestV1.Builder {
        if builderResult.hasInflations {
          builderResult.inflations = try Services.Common.Containers.InflationsV1.builderWithPrototype(builderResult.inflations).mergeFrom(value).buildPartial()
        } else {
          builderResult.inflations = value
        }
        builderResult.hasInflations = true
        return self
      }
      public func clearInflations() -> Services.Profile.Actions.GetProfiles.RequestV1.Builder {
        inflationsBuilder_ = nil
        builderResult.hasInflations = false
        builderResult.inflations = nil
        return self
      }
      public var hasManagerId:Bool {
           get {
                return builderResult.hasManagerId
           }
      }
      public var managerId:String {
           get {
                return builderResult.managerId
           }
           set (value) {
               builderResult.hasManagerId = true
               builderResult.managerId = value
           }
      }
      public func setManagerId(value:String) -> Services.Profile.Actions.GetProfiles.RequestV1.Builder {
        self.managerId = value
        return self
      }
      public func clearManagerId() -> Services.Profile.Actions.GetProfiles.RequestV1.Builder{
           builderResult.hasManagerId = false
           builderResult.managerId = ""
           return self
      }
      public var emails:Array<String> {
           get {
               return builderResult.emails
           }
           set (array) {
               builderResult.emails = array
           }
      }
      public func setEmails(value:Array<String>) -> Services.Profile.Actions.GetProfiles.RequestV1.Builder {
        self.emails = value
        return self
      }
      public func clearEmails() -> Services.Profile.Actions.GetProfiles.RequestV1.Builder {
         builderResult.emails.removeAll(keepCapacity: false)
         return self
      }
      public var hasIsAdmin:Bool {
           get {
                return builderResult.hasIsAdmin
           }
      }
      public var isAdmin:Bool {
           get {
                return builderResult.isAdmin
           }
           set (value) {
               builderResult.hasIsAdmin = true
               builderResult.isAdmin = value
           }
      }
      public func setIsAdmin(value:Bool) -> Services.Profile.Actions.GetProfiles.RequestV1.Builder {
        self.isAdmin = value
        return self
      }
      public func clearIsAdmin() -> Services.Profile.Actions.GetProfiles.RequestV1.Builder{
           builderResult.hasIsAdmin = false
           builderResult.isAdmin = false
           return self
      }
      public var authenticationIdentifiers:Array<String> {
           get {
               return builderResult.authenticationIdentifiers
           }
           set (array) {
               builderResult.authenticationIdentifiers = array
           }
      }
      public func setAuthenticationIdentifiers(value:Array<String>) -> Services.Profile.Actions.GetProfiles.RequestV1.Builder {
        self.authenticationIdentifiers = value
        return self
      }
      public func clearAuthenticationIdentifiers() -> Services.Profile.Actions.GetProfiles.RequestV1.Builder {
         builderResult.authenticationIdentifiers.removeAll(keepCapacity: false)
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
      public func setFields(value:Services.Common.Containers.FieldsV1!) -> Services.Profile.Actions.GetProfiles.RequestV1.Builder {
        self.fields = value
        return self
      }
      public func mergeFields(value:Services.Common.Containers.FieldsV1) throws -> Services.Profile.Actions.GetProfiles.RequestV1.Builder {
        if builderResult.hasFields {
          builderResult.fields = try Services.Common.Containers.FieldsV1.builderWithPrototype(builderResult.fields).mergeFrom(value).buildPartial()
        } else {
          builderResult.fields = value
        }
        builderResult.hasFields = true
        return self
      }
      public func clearFields() -> Services.Profile.Actions.GetProfiles.RequestV1.Builder {
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
      public override func clear() -> Services.Profile.Actions.GetProfiles.RequestV1.Builder {
        builderResult = Services.Profile.Actions.GetProfiles.RequestV1()
        return self
      }
      public override func clone() throws -> Services.Profile.Actions.GetProfiles.RequestV1.Builder {
        return try Services.Profile.Actions.GetProfiles.RequestV1.builderWithPrototype(builderResult)
      }
      public override func build() throws -> Services.Profile.Actions.GetProfiles.RequestV1 {
           try checkInitialized()
           return buildPartial()
      }
      public func buildPartial() -> Services.Profile.Actions.GetProfiles.RequestV1 {
        let returnMe:Services.Profile.Actions.GetProfiles.RequestV1 = builderResult
        return returnMe
      }
      public func mergeFrom(other:Services.Profile.Actions.GetProfiles.RequestV1) throws -> Services.Profile.Actions.GetProfiles.RequestV1.Builder {
        if other == Services.Profile.Actions.GetProfiles.RequestV1() {
         return self
        }
        if !other.ids.isEmpty {
            builderResult.ids += other.ids
        }
        if other.hasLocationId {
             locationId = other.locationId
        }
        if other.hasTeamId {
             teamId = other.teamId
        }
        if (other.hasInflations) {
            try mergeInflations(other.inflations)
        }
        if other.hasManagerId {
             managerId = other.managerId
        }
        if !other.emails.isEmpty {
            builderResult.emails += other.emails
        }
        if other.hasIsAdmin {
             isAdmin = other.isAdmin
        }
        if !other.authenticationIdentifiers.isEmpty {
            builderResult.authenticationIdentifiers += other.authenticationIdentifiers
        }
        if (other.hasFields) {
            try mergeFields(other.fields)
        }
        try mergeUnknownFields(other.unknownFields)
        return self
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream) throws -> Services.Profile.Actions.GetProfiles.RequestV1.Builder {
           return try mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Profile.Actions.GetProfiles.RequestV1.Builder {
        let unknownFieldsBuilder:UnknownFieldSet.Builder = try UnknownFieldSet.builderWithUnknownFields(self.unknownFields)
        while (true) {
          let tag = try input.readTag()
          switch tag {
          case 0: 
            self.unknownFields = try unknownFieldsBuilder.build()
            return self

          case 10 :
            ids += [try input.readString()]

          case 18 :
            locationId = try input.readString()

          case 26 :
            teamId = try input.readString()

          case 34 :
            let subBuilder:Services.Common.Containers.InflationsV1.Builder = Services.Common.Containers.InflationsV1.Builder()
            if hasInflations {
              try subBuilder.mergeFrom(inflations)
            }
            try input.readMessage(subBuilder, extensionRegistry:extensionRegistry)
            inflations = subBuilder.buildPartial()

          case 42 :
            managerId = try input.readString()

          case 50 :
            emails += [try input.readString()]

          case 56 :
            isAdmin = try input.readBool()

          case 66 :
            authenticationIdentifiers += [try input.readString()]

          case 74 :
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
    public private(set) var profiles:Array<Services.Profile.Containers.ProfileV1>  = Array<Services.Profile.Containers.ProfileV1>()
    required public init() {
         super.init()
    }
    override public func isInitialized() -> Bool {
     return true
    }
    override public func writeToCodedOutputStream(output:CodedOutputStream) throws {
      for oneElementprofiles in profiles {
          try output.writeMessage(1, value:oneElementprofiles)
      }
      try unknownFields.writeToCodedOutputStream(output)
    }
    override public func serializedSize() -> Int32 {
      var serialize_size:Int32 = memoizedSerializedSize
      if serialize_size != -1 {
       return serialize_size
      }

      serialize_size = 0
      for oneElementprofiles in profiles {
          serialize_size += oneElementprofiles.computeMessageSize(1)
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseArrayDelimitedFromInputStream(input:NSInputStream) throws -> Array<Services.Profile.Actions.GetProfiles.ResponseV1> {
      var mergedArray = Array<Services.Profile.Actions.GetProfiles.ResponseV1>()
      while let value = try parseFromDelimitedFromInputStream(input) {
        mergedArray += [value]
      }
      return mergedArray
    }
    public class func parseFromDelimitedFromInputStream(input:NSInputStream) throws -> Services.Profile.Actions.GetProfiles.ResponseV1? {
      return try Services.Profile.Actions.GetProfiles.ResponseV1.Builder().mergeDelimitedFromInputStream(input)?.build()
    }
    public class func parseFromData(data:NSData) throws -> Services.Profile.Actions.GetProfiles.ResponseV1 {
      return try Services.Profile.Actions.GetProfiles.ResponseV1.Builder().mergeFromData(data, extensionRegistry:Services.Profile.Actions.GetProfiles.GetProfilesRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) throws -> Services.Profile.Actions.GetProfiles.ResponseV1 {
      return try Services.Profile.Actions.GetProfiles.ResponseV1.Builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) throws -> Services.Profile.Actions.GetProfiles.ResponseV1 {
      return try Services.Profile.Actions.GetProfiles.ResponseV1.Builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Profile.Actions.GetProfiles.ResponseV1 {
      return try Services.Profile.Actions.GetProfiles.ResponseV1.Builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) throws -> Services.Profile.Actions.GetProfiles.ResponseV1 {
      return try Services.Profile.Actions.GetProfiles.ResponseV1.Builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Profile.Actions.GetProfiles.ResponseV1 {
      return try Services.Profile.Actions.GetProfiles.ResponseV1.Builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func getBuilder() -> Services.Profile.Actions.GetProfiles.ResponseV1.Builder {
      return Services.Profile.Actions.GetProfiles.ResponseV1.classBuilder() as! Services.Profile.Actions.GetProfiles.ResponseV1.Builder
    }
    public func getBuilder() -> Services.Profile.Actions.GetProfiles.ResponseV1.Builder {
      return classBuilder() as! Services.Profile.Actions.GetProfiles.ResponseV1.Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.Profile.Actions.GetProfiles.ResponseV1.Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.Profile.Actions.GetProfiles.ResponseV1.Builder()
    }
    public func toBuilder() throws -> Services.Profile.Actions.GetProfiles.ResponseV1.Builder {
      return try Services.Profile.Actions.GetProfiles.ResponseV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.Profile.Actions.GetProfiles.ResponseV1) throws -> Services.Profile.Actions.GetProfiles.ResponseV1.Builder {
      return try Services.Profile.Actions.GetProfiles.ResponseV1.Builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) throws {
      var profilesElementIndex:Int = 0
      for oneElementprofiles in profiles {
          output += "\(indent) profiles[\(profilesElementIndex)] {\n"
          try oneElementprofiles.writeDescriptionTo(&output, indent:"\(indent)  ")
          output += "\(indent)}\n"
          profilesElementIndex++
      }
      unknownFields.writeDescriptionTo(&output, indent:indent)
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            for oneElementprofiles in profiles {
                hashCode = (hashCode &* 31) &+ oneElementprofiles.hashValue
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.Profile.Actions.GetProfiles.ResponseV1"
    }
    override public func className() -> String {
        return "Services.Profile.Actions.GetProfiles.ResponseV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.Profile.Actions.GetProfiles.ResponseV1.self
    }
    //Meta information declaration end

    final public class Builder : GeneratedMessageBuilder {
      private var builderResult:Services.Profile.Actions.GetProfiles.ResponseV1 = Services.Profile.Actions.GetProfiles.ResponseV1()
      public func getMessage() -> Services.Profile.Actions.GetProfiles.ResponseV1 {
          return builderResult
      }

      required override public init () {
         super.init()
      }
      public var profiles:Array<Services.Profile.Containers.ProfileV1> {
           get {
               return builderResult.profiles
           }
           set (value) {
               builderResult.profiles = value
           }
      }
      public func setProfiles(value:Array<Services.Profile.Containers.ProfileV1>) -> Services.Profile.Actions.GetProfiles.ResponseV1.Builder {
        self.profiles = value
        return self
      }
      public func clearProfiles() -> Services.Profile.Actions.GetProfiles.ResponseV1.Builder {
        builderResult.profiles.removeAll(keepCapacity: false)
        return self
      }
      override public var internalGetResult:GeneratedMessage {
           get {
              return builderResult
           }
      }
      public override func clear() -> Services.Profile.Actions.GetProfiles.ResponseV1.Builder {
        builderResult = Services.Profile.Actions.GetProfiles.ResponseV1()
        return self
      }
      public override func clone() throws -> Services.Profile.Actions.GetProfiles.ResponseV1.Builder {
        return try Services.Profile.Actions.GetProfiles.ResponseV1.builderWithPrototype(builderResult)
      }
      public override func build() throws -> Services.Profile.Actions.GetProfiles.ResponseV1 {
           try checkInitialized()
           return buildPartial()
      }
      public func buildPartial() -> Services.Profile.Actions.GetProfiles.ResponseV1 {
        let returnMe:Services.Profile.Actions.GetProfiles.ResponseV1 = builderResult
        return returnMe
      }
      public func mergeFrom(other:Services.Profile.Actions.GetProfiles.ResponseV1) throws -> Services.Profile.Actions.GetProfiles.ResponseV1.Builder {
        if other == Services.Profile.Actions.GetProfiles.ResponseV1() {
         return self
        }
        if !other.profiles.isEmpty  {
           builderResult.profiles += other.profiles
        }
        try mergeUnknownFields(other.unknownFields)
        return self
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream) throws -> Services.Profile.Actions.GetProfiles.ResponseV1.Builder {
           return try mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Profile.Actions.GetProfiles.ResponseV1.Builder {
        let unknownFieldsBuilder:UnknownFieldSet.Builder = try UnknownFieldSet.builderWithUnknownFields(self.unknownFields)
        while (true) {
          let tag = try input.readTag()
          switch tag {
          case 0: 
            self.unknownFields = try unknownFieldsBuilder.build()
            return self

          case 10 :
            let subBuilder = Services.Profile.Containers.ProfileV1.Builder()
            try input.readMessage(subBuilder,extensionRegistry:extensionRegistry)
            profiles += [subBuilder.buildPartial()]

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
