// Generated by the protocol buffer compiler.  DO NOT EDIT!

import Foundation
public extension Services.User.Actions{ public struct CompleteAuthorization { }}

public func == (lhs: Services.User.Actions.CompleteAuthorization.RequestV1, rhs: Services.User.Actions.CompleteAuthorization.RequestV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasVersion == rhs.hasVersion) && (!lhs.hasVersion || lhs.version == rhs.version)
  fieldCheck = fieldCheck && (lhs.hasProvider == rhs.hasProvider) && (!lhs.hasProvider || lhs.provider == rhs.provider)
  fieldCheck = fieldCheck && (lhs.hasOauth2Details == rhs.hasOauth2Details) && (!lhs.hasOauth2Details || lhs.oauth2Details == rhs.oauth2Details)
  fieldCheck = fieldCheck && (lhs.hasOauthSdkDetails == rhs.hasOauthSdkDetails) && (!lhs.hasOauthSdkDetails || lhs.oauthSdkDetails == rhs.oauthSdkDetails)
  return (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
}

public func == (lhs: Services.User.Actions.CompleteAuthorization.ResponseV1, rhs: Services.User.Actions.CompleteAuthorization.ResponseV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasVersion == rhs.hasVersion) && (!lhs.hasVersion || lhs.version == rhs.version)
  fieldCheck = fieldCheck && (lhs.hasUser == rhs.hasUser) && (!lhs.hasUser || lhs.user == rhs.user)
  fieldCheck = fieldCheck && (lhs.hasIdentity == rhs.hasIdentity) && (!lhs.hasIdentity || lhs.identity == rhs.identity)
  fieldCheck = fieldCheck && (lhs.hasNewUser == rhs.hasNewUser) && (!lhs.hasNewUser || lhs.newUser == rhs.newUser)
  fieldCheck = fieldCheck && (lhs.hasOauthSdkDetails == rhs.hasOauthSdkDetails) && (!lhs.hasOauthSdkDetails || lhs.oauthSdkDetails == rhs.oauthSdkDetails)
  return (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
}

public extension Services.User.Actions.CompleteAuthorization {
  public struct CompleteAuthorizationRoot {
    public static var sharedInstance : CompleteAuthorizationRoot {
     struct Static {
         static let instance : CompleteAuthorizationRoot = CompleteAuthorizationRoot()
     }
     return Static.instance
    }
    public var extensionRegistry:ExtensionRegistry

    init() {
      extensionRegistry = ExtensionRegistry()
      registerAllExtensions(extensionRegistry)
      Services.User.Containers.ContainersRoot.sharedInstance.registerAllExtensions(extensionRegistry)
    }
    public func registerAllExtensions(registry:ExtensionRegistry) {
    }
  }

  final public class RequestV1 : GeneratedMessage, GeneratedMessageProtocol {
    override public subscript(key: String) -> Any? {
           switch key {
           case "version": return version
           case "provider": return self.provider
           case "oauth2Details": return oauth2Details
           case "oauthSdkDetails": return oauthSdkDetails
           default: return nil
           }
    }

    public private(set) var hasVersion:Bool = false
    public private(set) var version:UInt32 = UInt32(1)

    public private(set) var provider:Services.User.Containers.IdentityV1.ProviderV1 = Services.User.Containers.IdentityV1.ProviderV1.Internal
    public private(set) var hasProvider:Bool = false
    public private(set) var hasOauth2Details:Bool = false
    public private(set) var oauth2Details:Services.User.Containers.OAuth2DetailsV1!
    public private(set) var hasOauthSdkDetails:Bool = false
    public private(set) var oauthSdkDetails:Services.User.Containers.OAuthSDKDetailsV1!
    required public init() {
         super.init()
    }
    override public func isInitialized() -> Bool {
     return true
    }
    override public func writeToCodedOutputStream(output:CodedOutputStream) {
      if hasVersion {
        output.writeUInt32(1, value:version)
      }
      if hasProvider {
        output.writeEnum(2, value:provider.rawValue)
      }
      if hasOauth2Details {
        output.writeMessage(3, value:oauth2Details)
      }
      if hasOauthSdkDetails {
        output.writeMessage(4, value:oauthSdkDetails)
      }
      unknownFields.writeToCodedOutputStream(output)
    }
    override public func serializedSize() -> Int32 {
      var serialize_size:Int32 = memoizedSerializedSize
      if serialize_size != -1 {
       return serialize_size
      }

      serialize_size = 0
      if hasVersion {
        serialize_size += version.computeUInt32Size(1)
      }
      if (hasProvider) {
        serialize_size += provider.rawValue.computeEnumSize(2)
      }
      if hasOauth2Details {
          if let varSizeoauth2Details = oauth2Details?.computeMessageSize(3) {
              serialize_size += varSizeoauth2Details
          }
      }
      if hasOauthSdkDetails {
          if let varSizeoauthSdkDetails = oauthSdkDetails?.computeMessageSize(4) {
              serialize_size += varSizeoauthSdkDetails
          }
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseFromData(data:NSData) -> Services.User.Actions.CompleteAuthorization.RequestV1 {
      return Services.User.Actions.CompleteAuthorization.RequestV1.builder().mergeFromData(data, extensionRegistry:Services.User.Actions.CompleteAuthorization.CompleteAuthorizationRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) -> Services.User.Actions.CompleteAuthorization.RequestV1 {
      return Services.User.Actions.CompleteAuthorization.RequestV1.builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) -> Services.User.Actions.CompleteAuthorization.RequestV1 {
      return Services.User.Actions.CompleteAuthorization.RequestV1.builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) ->Services.User.Actions.CompleteAuthorization.RequestV1 {
      return Services.User.Actions.CompleteAuthorization.RequestV1.builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) -> Services.User.Actions.CompleteAuthorization.RequestV1 {
      return Services.User.Actions.CompleteAuthorization.RequestV1.builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.User.Actions.CompleteAuthorization.RequestV1 {
      return Services.User.Actions.CompleteAuthorization.RequestV1.builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func builder() -> Services.User.Actions.CompleteAuthorization.RequestV1Builder {
      return Services.User.Actions.CompleteAuthorization.RequestV1.classBuilder() as! Services.User.Actions.CompleteAuthorization.RequestV1Builder
    }
    public func builder() -> Services.User.Actions.CompleteAuthorization.RequestV1Builder {
      return classBuilder() as! Services.User.Actions.CompleteAuthorization.RequestV1Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.User.Actions.CompleteAuthorization.RequestV1Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.User.Actions.CompleteAuthorization.RequestV1.builder()
    }
    public func toBuilder() -> Services.User.Actions.CompleteAuthorization.RequestV1Builder {
      return Services.User.Actions.CompleteAuthorization.RequestV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.User.Actions.CompleteAuthorization.RequestV1) -> Services.User.Actions.CompleteAuthorization.RequestV1Builder {
      return Services.User.Actions.CompleteAuthorization.RequestV1.builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) {
      if hasVersion {
        output += "\(indent) version: \(version) \n"
      }
      if (hasProvider) {
        output += "\(indent) provider: \(provider.rawValue)\n"
      }
      if hasOauth2Details {
        output += "\(indent) oauth2Details {\n"
        oauth2Details?.writeDescriptionTo(&output, indent:"\(indent)  ")
        output += "\(indent) }\n"
      }
      if hasOauthSdkDetails {
        output += "\(indent) oauthSdkDetails {\n"
        oauthSdkDetails?.writeDescriptionTo(&output, indent:"\(indent)  ")
        output += "\(indent) }\n"
      }
      unknownFields.writeDescriptionTo(&output, indent:indent)
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            if hasVersion {
               hashCode = (hashCode &* 31) &+ version.hashValue
            }
            if hasProvider {
               hashCode = (hashCode &* 31) &+ Int(provider.rawValue)
            }
            if hasOauth2Details {
                if let hashValueoauth2Details = oauth2Details?.hashValue {
                    hashCode = (hashCode &* 31) &+ hashValueoauth2Details
                }
            }
            if hasOauthSdkDetails {
                if let hashValueoauthSdkDetails = oauthSdkDetails?.hashValue {
                    hashCode = (hashCode &* 31) &+ hashValueoauthSdkDetails
                }
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.User.Actions.CompleteAuthorization.RequestV1"
    }
    override public func className() -> String {
        return "Services.User.Actions.CompleteAuthorization.RequestV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.User.Actions.CompleteAuthorization.RequestV1.self
    }
    //Meta information declaration end

  }

  final public class RequestV1Builder : GeneratedMessageBuilder {
    private var builderResult:Services.User.Actions.CompleteAuthorization.RequestV1

    required override public init () {
       builderResult = Services.User.Actions.CompleteAuthorization.RequestV1()
       super.init()
    }
    public var hasVersion:Bool {
         get {
              return builderResult.hasVersion
         }
    }
    public var version:UInt32 {
         get {
              return builderResult.version
         }
         set (value) {
             builderResult.hasVersion = true
             builderResult.version = value
         }
    }
    public func setVersion(value:UInt32)-> Services.User.Actions.CompleteAuthorization.RequestV1Builder {
      self.version = value
      return self
    }
    public func clearVersion() -> Services.User.Actions.CompleteAuthorization.RequestV1Builder{
         builderResult.hasVersion = false
         builderResult.version = UInt32(1)
         return self
    }
      public var hasProvider:Bool{
          get {
              return builderResult.hasProvider
          }
      }
      public var provider:Services.User.Containers.IdentityV1.ProviderV1 {
          get {
              return builderResult.provider
          }
          set (value) {
              builderResult.hasProvider = true
              builderResult.provider = value
          }
      }
      public func setProvider(value:Services.User.Containers.IdentityV1.ProviderV1)-> Services.User.Actions.CompleteAuthorization.RequestV1Builder {
        self.provider = value
        return self
      }
      public func clearProvider() -> Services.User.Actions.CompleteAuthorization.RequestV1Builder {
         builderResult.hasProvider = false
         builderResult.provider = .Internal
         return self
      }
    public var hasOauth2Details:Bool {
         get {
             return builderResult.hasOauth2Details
         }
    }
    public var oauth2Details:Services.User.Containers.OAuth2DetailsV1! {
         get {
             return builderResult.oauth2Details
         }
         set (value) {
             builderResult.hasOauth2Details = true
             builderResult.oauth2Details = value
         }
    }
    public func setOauth2Details(value:Services.User.Containers.OAuth2DetailsV1!)-> Services.User.Actions.CompleteAuthorization.RequestV1Builder {
      self.oauth2Details = value
      return self
    }
    public func mergeOauth2Details(value:Services.User.Containers.OAuth2DetailsV1) -> Services.User.Actions.CompleteAuthorization.RequestV1Builder {
      if (builderResult.hasOauth2Details) {
        builderResult.oauth2Details = Services.User.Containers.OAuth2DetailsV1.builderWithPrototype(builderResult.oauth2Details).mergeFrom(value).buildPartial()
      } else {
        builderResult.oauth2Details = value
      }
      builderResult.hasOauth2Details = true
      return self
    }
    public func clearOauth2Details() -> Services.User.Actions.CompleteAuthorization.RequestV1Builder {
      builderResult.hasOauth2Details = false
      builderResult.oauth2Details = nil
      return self
    }
    public var hasOauthSdkDetails:Bool {
         get {
             return builderResult.hasOauthSdkDetails
         }
    }
    public var oauthSdkDetails:Services.User.Containers.OAuthSDKDetailsV1! {
         get {
             return builderResult.oauthSdkDetails
         }
         set (value) {
             builderResult.hasOauthSdkDetails = true
             builderResult.oauthSdkDetails = value
         }
    }
    public func setOauthSdkDetails(value:Services.User.Containers.OAuthSDKDetailsV1!)-> Services.User.Actions.CompleteAuthorization.RequestV1Builder {
      self.oauthSdkDetails = value
      return self
    }
    public func mergeOauthSdkDetails(value:Services.User.Containers.OAuthSDKDetailsV1) -> Services.User.Actions.CompleteAuthorization.RequestV1Builder {
      if (builderResult.hasOauthSdkDetails) {
        builderResult.oauthSdkDetails = Services.User.Containers.OAuthSDKDetailsV1.builderWithPrototype(builderResult.oauthSdkDetails).mergeFrom(value).buildPartial()
      } else {
        builderResult.oauthSdkDetails = value
      }
      builderResult.hasOauthSdkDetails = true
      return self
    }
    public func clearOauthSdkDetails() -> Services.User.Actions.CompleteAuthorization.RequestV1Builder {
      builderResult.hasOauthSdkDetails = false
      builderResult.oauthSdkDetails = nil
      return self
    }
    override public var internalGetResult:GeneratedMessage {
         get {
            return builderResult
         }
    }
    public override func clear() -> Services.User.Actions.CompleteAuthorization.RequestV1Builder {
      builderResult = Services.User.Actions.CompleteAuthorization.RequestV1()
      return self
    }
    public override func clone() -> Services.User.Actions.CompleteAuthorization.RequestV1Builder {
      return Services.User.Actions.CompleteAuthorization.RequestV1.builderWithPrototype(builderResult)
    }
    public override func build() -> Services.User.Actions.CompleteAuthorization.RequestV1 {
         checkInitialized()
         return buildPartial()
    }
    public func buildPartial() -> Services.User.Actions.CompleteAuthorization.RequestV1 {
      var returnMe:Services.User.Actions.CompleteAuthorization.RequestV1 = builderResult
      return returnMe
    }
    public func mergeFrom(other:Services.User.Actions.CompleteAuthorization.RequestV1) -> Services.User.Actions.CompleteAuthorization.RequestV1Builder {
      if (other == Services.User.Actions.CompleteAuthorization.RequestV1()) {
       return self
      }
      if other.hasVersion {
           version = other.version
      }
      if other.hasProvider {
           provider = other.provider
      }
      if (other.hasOauth2Details) {
          mergeOauth2Details(other.oauth2Details)
      }
      if (other.hasOauthSdkDetails) {
          mergeOauthSdkDetails(other.oauthSdkDetails)
      }
      mergeUnknownFields(other.unknownFields)
      return self
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream) ->Services.User.Actions.CompleteAuthorization.RequestV1Builder {
         return mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.User.Actions.CompleteAuthorization.RequestV1Builder {
      var unknownFieldsBuilder:UnknownFieldSetBuilder = UnknownFieldSet.builderWithUnknownFields(self.unknownFields)
      while (true) {
        var tag = input.readTag()
        switch tag {
        case 0: 
          self.unknownFields = unknownFieldsBuilder.build()
          return self

        case 8 :
          version = input.readUInt32()

        case 16 :
          let valueIntprovider = input.readEnum()
          if let enumsprovider = Services.User.Containers.IdentityV1.ProviderV1(rawValue:valueIntprovider){
               provider = enumsprovider
          } else {
               unknownFieldsBuilder.mergeVarintField(2, value:Int64(valueIntprovider))
          }

        case 26 :
          var subBuilder:Services.User.Containers.OAuth2DetailsV1Builder = Services.User.Containers.OAuth2DetailsV1.builder()
          if hasOauth2Details {
            subBuilder.mergeFrom(oauth2Details)
          }
          input.readMessage(subBuilder, extensionRegistry:extensionRegistry)
          oauth2Details = subBuilder.buildPartial()

        case 34 :
          var subBuilder:Services.User.Containers.OAuthSDKDetailsV1Builder = Services.User.Containers.OAuthSDKDetailsV1.builder()
          if hasOauthSdkDetails {
            subBuilder.mergeFrom(oauthSdkDetails)
          }
          input.readMessage(subBuilder, extensionRegistry:extensionRegistry)
          oauthSdkDetails = subBuilder.buildPartial()

        default:
          if (!parseUnknownField(input,unknownFields:unknownFieldsBuilder, extensionRegistry:extensionRegistry, tag:tag)) {
             unknownFields = unknownFieldsBuilder.build()
             return self
          }
        }
      }
    }
  }

  final public class ResponseV1 : GeneratedMessage, GeneratedMessageProtocol {
    override public subscript(key: String) -> Any? {
           switch key {
           case "version": return version
           case "user": return user
           case "identity": return identity
           case "newUser": return newUser
           case "oauthSdkDetails": return oauthSdkDetails
           default: return nil
           }
    }

    public private(set) var hasVersion:Bool = false
    public private(set) var version:UInt32 = UInt32(1)

    public private(set) var hasUser:Bool = false
    public private(set) var user:Services.User.Containers.UserV1!
    public private(set) var hasIdentity:Bool = false
    public private(set) var identity:Services.User.Containers.IdentityV1!
    public private(set) var hasNewUser:Bool = false
    public private(set) var newUser:Bool = false

    public private(set) var hasOauthSdkDetails:Bool = false
    public private(set) var oauthSdkDetails:Services.User.Containers.OAuthSDKDetailsV1!
    required public init() {
         super.init()
    }
    override public func isInitialized() -> Bool {
     return true
    }
    override public func writeToCodedOutputStream(output:CodedOutputStream) {
      if hasVersion {
        output.writeUInt32(1, value:version)
      }
      if hasUser {
        output.writeMessage(2, value:user)
      }
      if hasIdentity {
        output.writeMessage(3, value:identity)
      }
      if hasNewUser {
        output.writeBool(4, value:newUser)
      }
      if hasOauthSdkDetails {
        output.writeMessage(5, value:oauthSdkDetails)
      }
      unknownFields.writeToCodedOutputStream(output)
    }
    override public func serializedSize() -> Int32 {
      var serialize_size:Int32 = memoizedSerializedSize
      if serialize_size != -1 {
       return serialize_size
      }

      serialize_size = 0
      if hasVersion {
        serialize_size += version.computeUInt32Size(1)
      }
      if hasUser {
          if let varSizeuser = user?.computeMessageSize(2) {
              serialize_size += varSizeuser
          }
      }
      if hasIdentity {
          if let varSizeidentity = identity?.computeMessageSize(3) {
              serialize_size += varSizeidentity
          }
      }
      if hasNewUser {
        serialize_size += newUser.computeBoolSize(4)
      }
      if hasOauthSdkDetails {
          if let varSizeoauthSdkDetails = oauthSdkDetails?.computeMessageSize(5) {
              serialize_size += varSizeoauthSdkDetails
          }
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseFromData(data:NSData) -> Services.User.Actions.CompleteAuthorization.ResponseV1 {
      return Services.User.Actions.CompleteAuthorization.ResponseV1.builder().mergeFromData(data, extensionRegistry:Services.User.Actions.CompleteAuthorization.CompleteAuthorizationRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) -> Services.User.Actions.CompleteAuthorization.ResponseV1 {
      return Services.User.Actions.CompleteAuthorization.ResponseV1.builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) -> Services.User.Actions.CompleteAuthorization.ResponseV1 {
      return Services.User.Actions.CompleteAuthorization.ResponseV1.builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) ->Services.User.Actions.CompleteAuthorization.ResponseV1 {
      return Services.User.Actions.CompleteAuthorization.ResponseV1.builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) -> Services.User.Actions.CompleteAuthorization.ResponseV1 {
      return Services.User.Actions.CompleteAuthorization.ResponseV1.builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.User.Actions.CompleteAuthorization.ResponseV1 {
      return Services.User.Actions.CompleteAuthorization.ResponseV1.builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func builder() -> Services.User.Actions.CompleteAuthorization.ResponseV1Builder {
      return Services.User.Actions.CompleteAuthorization.ResponseV1.classBuilder() as! Services.User.Actions.CompleteAuthorization.ResponseV1Builder
    }
    public func builder() -> Services.User.Actions.CompleteAuthorization.ResponseV1Builder {
      return classBuilder() as! Services.User.Actions.CompleteAuthorization.ResponseV1Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.User.Actions.CompleteAuthorization.ResponseV1Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.User.Actions.CompleteAuthorization.ResponseV1.builder()
    }
    public func toBuilder() -> Services.User.Actions.CompleteAuthorization.ResponseV1Builder {
      return Services.User.Actions.CompleteAuthorization.ResponseV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.User.Actions.CompleteAuthorization.ResponseV1) -> Services.User.Actions.CompleteAuthorization.ResponseV1Builder {
      return Services.User.Actions.CompleteAuthorization.ResponseV1.builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) {
      if hasVersion {
        output += "\(indent) version: \(version) \n"
      }
      if hasUser {
        output += "\(indent) user {\n"
        user?.writeDescriptionTo(&output, indent:"\(indent)  ")
        output += "\(indent) }\n"
      }
      if hasIdentity {
        output += "\(indent) identity {\n"
        identity?.writeDescriptionTo(&output, indent:"\(indent)  ")
        output += "\(indent) }\n"
      }
      if hasNewUser {
        output += "\(indent) newUser: \(newUser) \n"
      }
      if hasOauthSdkDetails {
        output += "\(indent) oauthSdkDetails {\n"
        oauthSdkDetails?.writeDescriptionTo(&output, indent:"\(indent)  ")
        output += "\(indent) }\n"
      }
      unknownFields.writeDescriptionTo(&output, indent:indent)
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            if hasVersion {
               hashCode = (hashCode &* 31) &+ version.hashValue
            }
            if hasUser {
                if let hashValueuser = user?.hashValue {
                    hashCode = (hashCode &* 31) &+ hashValueuser
                }
            }
            if hasIdentity {
                if let hashValueidentity = identity?.hashValue {
                    hashCode = (hashCode &* 31) &+ hashValueidentity
                }
            }
            if hasNewUser {
               hashCode = (hashCode &* 31) &+ newUser.hashValue
            }
            if hasOauthSdkDetails {
                if let hashValueoauthSdkDetails = oauthSdkDetails?.hashValue {
                    hashCode = (hashCode &* 31) &+ hashValueoauthSdkDetails
                }
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.User.Actions.CompleteAuthorization.ResponseV1"
    }
    override public func className() -> String {
        return "Services.User.Actions.CompleteAuthorization.ResponseV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.User.Actions.CompleteAuthorization.ResponseV1.self
    }
    //Meta information declaration end

  }

  final public class ResponseV1Builder : GeneratedMessageBuilder {
    private var builderResult:Services.User.Actions.CompleteAuthorization.ResponseV1

    required override public init () {
       builderResult = Services.User.Actions.CompleteAuthorization.ResponseV1()
       super.init()
    }
    public var hasVersion:Bool {
         get {
              return builderResult.hasVersion
         }
    }
    public var version:UInt32 {
         get {
              return builderResult.version
         }
         set (value) {
             builderResult.hasVersion = true
             builderResult.version = value
         }
    }
    public func setVersion(value:UInt32)-> Services.User.Actions.CompleteAuthorization.ResponseV1Builder {
      self.version = value
      return self
    }
    public func clearVersion() -> Services.User.Actions.CompleteAuthorization.ResponseV1Builder{
         builderResult.hasVersion = false
         builderResult.version = UInt32(1)
         return self
    }
    public var hasUser:Bool {
         get {
             return builderResult.hasUser
         }
    }
    public var user:Services.User.Containers.UserV1! {
         get {
             return builderResult.user
         }
         set (value) {
             builderResult.hasUser = true
             builderResult.user = value
         }
    }
    public func setUser(value:Services.User.Containers.UserV1!)-> Services.User.Actions.CompleteAuthorization.ResponseV1Builder {
      self.user = value
      return self
    }
    public func mergeUser(value:Services.User.Containers.UserV1) -> Services.User.Actions.CompleteAuthorization.ResponseV1Builder {
      if (builderResult.hasUser) {
        builderResult.user = Services.User.Containers.UserV1.builderWithPrototype(builderResult.user).mergeFrom(value).buildPartial()
      } else {
        builderResult.user = value
      }
      builderResult.hasUser = true
      return self
    }
    public func clearUser() -> Services.User.Actions.CompleteAuthorization.ResponseV1Builder {
      builderResult.hasUser = false
      builderResult.user = nil
      return self
    }
    public var hasIdentity:Bool {
         get {
             return builderResult.hasIdentity
         }
    }
    public var identity:Services.User.Containers.IdentityV1! {
         get {
             return builderResult.identity
         }
         set (value) {
             builderResult.hasIdentity = true
             builderResult.identity = value
         }
    }
    public func setIdentity(value:Services.User.Containers.IdentityV1!)-> Services.User.Actions.CompleteAuthorization.ResponseV1Builder {
      self.identity = value
      return self
    }
    public func mergeIdentity(value:Services.User.Containers.IdentityV1) -> Services.User.Actions.CompleteAuthorization.ResponseV1Builder {
      if (builderResult.hasIdentity) {
        builderResult.identity = Services.User.Containers.IdentityV1.builderWithPrototype(builderResult.identity).mergeFrom(value).buildPartial()
      } else {
        builderResult.identity = value
      }
      builderResult.hasIdentity = true
      return self
    }
    public func clearIdentity() -> Services.User.Actions.CompleteAuthorization.ResponseV1Builder {
      builderResult.hasIdentity = false
      builderResult.identity = nil
      return self
    }
    public var hasNewUser:Bool {
         get {
              return builderResult.hasNewUser
         }
    }
    public var newUser:Bool {
         get {
              return builderResult.newUser
         }
         set (value) {
             builderResult.hasNewUser = true
             builderResult.newUser = value
         }
    }
    public func setNewUser(value:Bool)-> Services.User.Actions.CompleteAuthorization.ResponseV1Builder {
      self.newUser = value
      return self
    }
    public func clearNewUser() -> Services.User.Actions.CompleteAuthorization.ResponseV1Builder{
         builderResult.hasNewUser = false
         builderResult.newUser = false
         return self
    }
    public var hasOauthSdkDetails:Bool {
         get {
             return builderResult.hasOauthSdkDetails
         }
    }
    public var oauthSdkDetails:Services.User.Containers.OAuthSDKDetailsV1! {
         get {
             return builderResult.oauthSdkDetails
         }
         set (value) {
             builderResult.hasOauthSdkDetails = true
             builderResult.oauthSdkDetails = value
         }
    }
    public func setOauthSdkDetails(value:Services.User.Containers.OAuthSDKDetailsV1!)-> Services.User.Actions.CompleteAuthorization.ResponseV1Builder {
      self.oauthSdkDetails = value
      return self
    }
    public func mergeOauthSdkDetails(value:Services.User.Containers.OAuthSDKDetailsV1) -> Services.User.Actions.CompleteAuthorization.ResponseV1Builder {
      if (builderResult.hasOauthSdkDetails) {
        builderResult.oauthSdkDetails = Services.User.Containers.OAuthSDKDetailsV1.builderWithPrototype(builderResult.oauthSdkDetails).mergeFrom(value).buildPartial()
      } else {
        builderResult.oauthSdkDetails = value
      }
      builderResult.hasOauthSdkDetails = true
      return self
    }
    public func clearOauthSdkDetails() -> Services.User.Actions.CompleteAuthorization.ResponseV1Builder {
      builderResult.hasOauthSdkDetails = false
      builderResult.oauthSdkDetails = nil
      return self
    }
    override public var internalGetResult:GeneratedMessage {
         get {
            return builderResult
         }
    }
    public override func clear() -> Services.User.Actions.CompleteAuthorization.ResponseV1Builder {
      builderResult = Services.User.Actions.CompleteAuthorization.ResponseV1()
      return self
    }
    public override func clone() -> Services.User.Actions.CompleteAuthorization.ResponseV1Builder {
      return Services.User.Actions.CompleteAuthorization.ResponseV1.builderWithPrototype(builderResult)
    }
    public override func build() -> Services.User.Actions.CompleteAuthorization.ResponseV1 {
         checkInitialized()
         return buildPartial()
    }
    public func buildPartial() -> Services.User.Actions.CompleteAuthorization.ResponseV1 {
      var returnMe:Services.User.Actions.CompleteAuthorization.ResponseV1 = builderResult
      return returnMe
    }
    public func mergeFrom(other:Services.User.Actions.CompleteAuthorization.ResponseV1) -> Services.User.Actions.CompleteAuthorization.ResponseV1Builder {
      if (other == Services.User.Actions.CompleteAuthorization.ResponseV1()) {
       return self
      }
      if other.hasVersion {
           version = other.version
      }
      if (other.hasUser) {
          mergeUser(other.user)
      }
      if (other.hasIdentity) {
          mergeIdentity(other.identity)
      }
      if other.hasNewUser {
           newUser = other.newUser
      }
      if (other.hasOauthSdkDetails) {
          mergeOauthSdkDetails(other.oauthSdkDetails)
      }
      mergeUnknownFields(other.unknownFields)
      return self
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream) ->Services.User.Actions.CompleteAuthorization.ResponseV1Builder {
         return mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.User.Actions.CompleteAuthorization.ResponseV1Builder {
      var unknownFieldsBuilder:UnknownFieldSetBuilder = UnknownFieldSet.builderWithUnknownFields(self.unknownFields)
      while (true) {
        var tag = input.readTag()
        switch tag {
        case 0: 
          self.unknownFields = unknownFieldsBuilder.build()
          return self

        case 8 :
          version = input.readUInt32()

        case 18 :
          var subBuilder:Services.User.Containers.UserV1Builder = Services.User.Containers.UserV1.builder()
          if hasUser {
            subBuilder.mergeFrom(user)
          }
          input.readMessage(subBuilder, extensionRegistry:extensionRegistry)
          user = subBuilder.buildPartial()

        case 26 :
          var subBuilder:Services.User.Containers.IdentityV1Builder = Services.User.Containers.IdentityV1.builder()
          if hasIdentity {
            subBuilder.mergeFrom(identity)
          }
          input.readMessage(subBuilder, extensionRegistry:extensionRegistry)
          identity = subBuilder.buildPartial()

        case 32 :
          newUser = input.readBool()

        case 42 :
          var subBuilder:Services.User.Containers.OAuthSDKDetailsV1Builder = Services.User.Containers.OAuthSDKDetailsV1.builder()
          if hasOauthSdkDetails {
            subBuilder.mergeFrom(oauthSdkDetails)
          }
          input.readMessage(subBuilder, extensionRegistry:extensionRegistry)
          oauthSdkDetails = subBuilder.buildPartial()

        default:
          if (!parseUnknownField(input,unknownFields:unknownFieldsBuilder, extensionRegistry:extensionRegistry, tag:tag)) {
             unknownFields = unknownFieldsBuilder.build()
             return self
          }
        }
      }
    }
  }

}

// @@protoc_insertion_point(global_scope)