// Generated by the protocol buffer compiler.  DO NOT EDIT!
// Source file get_authentication_instructions.proto

import Foundation

public extension Services.User.Actions{ public struct GetAuthenticationInstructions { }}

public func == (lhs: Services.User.Actions.GetAuthenticationInstructions.RequestV1, rhs: Services.User.Actions.GetAuthenticationInstructions.RequestV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasVersion == rhs.hasVersion) && (!lhs.hasVersion || lhs.version == rhs.version)
  fieldCheck = fieldCheck && (lhs.hasEmail == rhs.hasEmail) && (!lhs.hasEmail || lhs.email == rhs.email)
  fieldCheck = (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
  return fieldCheck
}

public func == (lhs: Services.User.Actions.GetAuthenticationInstructions.ResponseV1, rhs: Services.User.Actions.GetAuthenticationInstructions.ResponseV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasVersion == rhs.hasVersion) && (!lhs.hasVersion || lhs.version == rhs.version)
  fieldCheck = fieldCheck && (lhs.hasBackend == rhs.hasBackend) && (!lhs.hasBackend || lhs.backend == rhs.backend)
  fieldCheck = fieldCheck && (lhs.hasUserExists == rhs.hasUserExists) && (!lhs.hasUserExists || lhs.userExists == rhs.userExists)
  fieldCheck = fieldCheck && (lhs.hasAuthorizationUrl == rhs.hasAuthorizationUrl) && (!lhs.hasAuthorizationUrl || lhs.authorizationUrl == rhs.authorizationUrl)
  fieldCheck = (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
  return fieldCheck
}

public extension Services.User.Actions.GetAuthenticationInstructions {
  public struct GetAuthenticationInstructionsRoot {
    public static var sharedInstance : GetAuthenticationInstructionsRoot {
     struct Static {
         static let instance : GetAuthenticationInstructionsRoot = GetAuthenticationInstructionsRoot()
     }
     return Static.instance
    }
    public var extensionRegistry:ExtensionRegistry

    init() {
      extensionRegistry = ExtensionRegistry()
      registerAllExtensions(extensionRegistry)
      Services.User.Containers.ContainersRoot.sharedInstance.registerAllExtensions(extensionRegistry)
      Services.User.Actions.AuthenticateUser.AuthenticateUserRoot.sharedInstance.registerAllExtensions(extensionRegistry)
    }
    public func registerAllExtensions(registry:ExtensionRegistry) {
    }
  }

  final public class RequestV1 : GeneratedMessage, GeneratedMessageProtocol {
    public private(set) var hasVersion:Bool = false
    public private(set) var version:UInt32 = UInt32(1)

    public private(set) var hasEmail:Bool = false
    public private(set) var email:String = ""

    required public init() {
         super.init()
    }
    override public func isInitialized() -> Bool {
     return true
    }
    override public func writeToCodedOutputStream(output:CodedOutputStream) throws {
      if hasVersion {
        try output.writeUInt32(1, value:version)
      }
      if hasEmail {
        try output.writeString(2, value:email)
      }
      try unknownFields.writeToCodedOutputStream(output)
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
      if hasEmail {
        serialize_size += email.computeStringSize(2)
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseArrayDelimitedFromInputStream(input:NSInputStream) throws -> Array<Services.User.Actions.GetAuthenticationInstructions.RequestV1> {
      var mergedArray = Array<Services.User.Actions.GetAuthenticationInstructions.RequestV1>()
      while let value = try parseFromDelimitedFromInputStream(input) {
        mergedArray += [value]
      }
      return mergedArray
    }
    public class func parseFromDelimitedFromInputStream(input:NSInputStream) throws -> Services.User.Actions.GetAuthenticationInstructions.RequestV1? {
      return try Services.User.Actions.GetAuthenticationInstructions.RequestV1.Builder().mergeDelimitedFromInputStream(input)?.build()
    }
    public class func parseFromData(data:NSData) throws -> Services.User.Actions.GetAuthenticationInstructions.RequestV1 {
      return try Services.User.Actions.GetAuthenticationInstructions.RequestV1.Builder().mergeFromData(data, extensionRegistry:Services.User.Actions.GetAuthenticationInstructions.GetAuthenticationInstructionsRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) throws -> Services.User.Actions.GetAuthenticationInstructions.RequestV1 {
      return try Services.User.Actions.GetAuthenticationInstructions.RequestV1.Builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) throws -> Services.User.Actions.GetAuthenticationInstructions.RequestV1 {
      return try Services.User.Actions.GetAuthenticationInstructions.RequestV1.Builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.User.Actions.GetAuthenticationInstructions.RequestV1 {
      return try Services.User.Actions.GetAuthenticationInstructions.RequestV1.Builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) throws -> Services.User.Actions.GetAuthenticationInstructions.RequestV1 {
      return try Services.User.Actions.GetAuthenticationInstructions.RequestV1.Builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.User.Actions.GetAuthenticationInstructions.RequestV1 {
      return try Services.User.Actions.GetAuthenticationInstructions.RequestV1.Builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func getBuilder() -> Services.User.Actions.GetAuthenticationInstructions.RequestV1.Builder {
      return Services.User.Actions.GetAuthenticationInstructions.RequestV1.classBuilder() as! Services.User.Actions.GetAuthenticationInstructions.RequestV1.Builder
    }
    public func getBuilder() -> Services.User.Actions.GetAuthenticationInstructions.RequestV1.Builder {
      return classBuilder() as! Services.User.Actions.GetAuthenticationInstructions.RequestV1.Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.User.Actions.GetAuthenticationInstructions.RequestV1.Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.User.Actions.GetAuthenticationInstructions.RequestV1.Builder()
    }
    public func toBuilder() throws -> Services.User.Actions.GetAuthenticationInstructions.RequestV1.Builder {
      return try Services.User.Actions.GetAuthenticationInstructions.RequestV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.User.Actions.GetAuthenticationInstructions.RequestV1) throws -> Services.User.Actions.GetAuthenticationInstructions.RequestV1.Builder {
      return try Services.User.Actions.GetAuthenticationInstructions.RequestV1.Builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) throws {
      if hasVersion {
        output += "\(indent) version: \(version) \n"
      }
      if hasEmail {
        output += "\(indent) email: \(email) \n"
      }
      unknownFields.writeDescriptionTo(&output, indent:indent)
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            if hasVersion {
               hashCode = (hashCode &* 31) &+ version.hashValue
            }
            if hasEmail {
               hashCode = (hashCode &* 31) &+ email.hashValue
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.User.Actions.GetAuthenticationInstructions.RequestV1"
    }
    override public func className() -> String {
        return "Services.User.Actions.GetAuthenticationInstructions.RequestV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.User.Actions.GetAuthenticationInstructions.RequestV1.self
    }
    //Meta information declaration end

    final public class Builder : GeneratedMessageBuilder {
      private var builderResult:Services.User.Actions.GetAuthenticationInstructions.RequestV1 = Services.User.Actions.GetAuthenticationInstructions.RequestV1()
      public func getMessage() -> Services.User.Actions.GetAuthenticationInstructions.RequestV1 {
          return builderResult
      }

      required override public init () {
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
      public func setVersion(value:UInt32) -> Services.User.Actions.GetAuthenticationInstructions.RequestV1.Builder {
        self.version = value
        return self
      }
      public func clearVersion() -> Services.User.Actions.GetAuthenticationInstructions.RequestV1.Builder{
           builderResult.hasVersion = false
           builderResult.version = UInt32(1)
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
      public func setEmail(value:String) -> Services.User.Actions.GetAuthenticationInstructions.RequestV1.Builder {
        self.email = value
        return self
      }
      public func clearEmail() -> Services.User.Actions.GetAuthenticationInstructions.RequestV1.Builder{
           builderResult.hasEmail = false
           builderResult.email = ""
           return self
      }
      override public var internalGetResult:GeneratedMessage {
           get {
              return builderResult
           }
      }
      public override func clear() -> Services.User.Actions.GetAuthenticationInstructions.RequestV1.Builder {
        builderResult = Services.User.Actions.GetAuthenticationInstructions.RequestV1()
        return self
      }
      public override func clone() throws -> Services.User.Actions.GetAuthenticationInstructions.RequestV1.Builder {
        return try Services.User.Actions.GetAuthenticationInstructions.RequestV1.builderWithPrototype(builderResult)
      }
      public override func build() throws -> Services.User.Actions.GetAuthenticationInstructions.RequestV1 {
           try checkInitialized()
           return buildPartial()
      }
      public func buildPartial() -> Services.User.Actions.GetAuthenticationInstructions.RequestV1 {
        let returnMe:Services.User.Actions.GetAuthenticationInstructions.RequestV1 = builderResult
        return returnMe
      }
      public func mergeFrom(other:Services.User.Actions.GetAuthenticationInstructions.RequestV1) throws -> Services.User.Actions.GetAuthenticationInstructions.RequestV1.Builder {
        if other == Services.User.Actions.GetAuthenticationInstructions.RequestV1() {
         return self
        }
        if other.hasVersion {
             version = other.version
        }
        if other.hasEmail {
             email = other.email
        }
        try mergeUnknownFields(other.unknownFields)
        return self
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream) throws -> Services.User.Actions.GetAuthenticationInstructions.RequestV1.Builder {
           return try mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.User.Actions.GetAuthenticationInstructions.RequestV1.Builder {
        let unknownFieldsBuilder:UnknownFieldSet.Builder = try UnknownFieldSet.builderWithUnknownFields(self.unknownFields)
        while (true) {
          let tag = try input.readTag()
          switch tag {
          case 0: 
            self.unknownFields = try unknownFieldsBuilder.build()
            return self

          case 8 :
            version = try input.readUInt32()

          case 18 :
            email = try input.readString()

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
    public private(set) var hasVersion:Bool = false
    public private(set) var version:UInt32 = UInt32(1)

    public private(set) var backend:Services.User.Actions.AuthenticateUser.RequestV1.AuthBackendV1 = Services.User.Actions.AuthenticateUser.RequestV1.AuthBackendV1.Internal
    public private(set) var hasBackend:Bool = false
    public private(set) var hasUserExists:Bool = false
    public private(set) var userExists:Bool = false

    public private(set) var hasAuthorizationUrl:Bool = false
    public private(set) var authorizationUrl:String = ""

    required public init() {
         super.init()
    }
    override public func isInitialized() -> Bool {
     return true
    }
    override public func writeToCodedOutputStream(output:CodedOutputStream) throws {
      if hasVersion {
        try output.writeUInt32(1, value:version)
      }
      if hasBackend {
        try output.writeEnum(2, value:backend.rawValue)
      }
      if hasUserExists {
        try output.writeBool(3, value:userExists)
      }
      if hasAuthorizationUrl {
        try output.writeString(4, value:authorizationUrl)
      }
      try unknownFields.writeToCodedOutputStream(output)
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
      if (hasBackend) {
        serialize_size += backend.rawValue.computeEnumSize(2)
      }
      if hasUserExists {
        serialize_size += userExists.computeBoolSize(3)
      }
      if hasAuthorizationUrl {
        serialize_size += authorizationUrl.computeStringSize(4)
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseArrayDelimitedFromInputStream(input:NSInputStream) throws -> Array<Services.User.Actions.GetAuthenticationInstructions.ResponseV1> {
      var mergedArray = Array<Services.User.Actions.GetAuthenticationInstructions.ResponseV1>()
      while let value = try parseFromDelimitedFromInputStream(input) {
        mergedArray += [value]
      }
      return mergedArray
    }
    public class func parseFromDelimitedFromInputStream(input:NSInputStream) throws -> Services.User.Actions.GetAuthenticationInstructions.ResponseV1? {
      return try Services.User.Actions.GetAuthenticationInstructions.ResponseV1.Builder().mergeDelimitedFromInputStream(input)?.build()
    }
    public class func parseFromData(data:NSData) throws -> Services.User.Actions.GetAuthenticationInstructions.ResponseV1 {
      return try Services.User.Actions.GetAuthenticationInstructions.ResponseV1.Builder().mergeFromData(data, extensionRegistry:Services.User.Actions.GetAuthenticationInstructions.GetAuthenticationInstructionsRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) throws -> Services.User.Actions.GetAuthenticationInstructions.ResponseV1 {
      return try Services.User.Actions.GetAuthenticationInstructions.ResponseV1.Builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) throws -> Services.User.Actions.GetAuthenticationInstructions.ResponseV1 {
      return try Services.User.Actions.GetAuthenticationInstructions.ResponseV1.Builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.User.Actions.GetAuthenticationInstructions.ResponseV1 {
      return try Services.User.Actions.GetAuthenticationInstructions.ResponseV1.Builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) throws -> Services.User.Actions.GetAuthenticationInstructions.ResponseV1 {
      return try Services.User.Actions.GetAuthenticationInstructions.ResponseV1.Builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.User.Actions.GetAuthenticationInstructions.ResponseV1 {
      return try Services.User.Actions.GetAuthenticationInstructions.ResponseV1.Builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func getBuilder() -> Services.User.Actions.GetAuthenticationInstructions.ResponseV1.Builder {
      return Services.User.Actions.GetAuthenticationInstructions.ResponseV1.classBuilder() as! Services.User.Actions.GetAuthenticationInstructions.ResponseV1.Builder
    }
    public func getBuilder() -> Services.User.Actions.GetAuthenticationInstructions.ResponseV1.Builder {
      return classBuilder() as! Services.User.Actions.GetAuthenticationInstructions.ResponseV1.Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.User.Actions.GetAuthenticationInstructions.ResponseV1.Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.User.Actions.GetAuthenticationInstructions.ResponseV1.Builder()
    }
    public func toBuilder() throws -> Services.User.Actions.GetAuthenticationInstructions.ResponseV1.Builder {
      return try Services.User.Actions.GetAuthenticationInstructions.ResponseV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.User.Actions.GetAuthenticationInstructions.ResponseV1) throws -> Services.User.Actions.GetAuthenticationInstructions.ResponseV1.Builder {
      return try Services.User.Actions.GetAuthenticationInstructions.ResponseV1.Builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) throws {
      if hasVersion {
        output += "\(indent) version: \(version) \n"
      }
      if (hasBackend) {
        output += "\(indent) backend: \(backend.rawValue)\n"
      }
      if hasUserExists {
        output += "\(indent) userExists: \(userExists) \n"
      }
      if hasAuthorizationUrl {
        output += "\(indent) authorizationUrl: \(authorizationUrl) \n"
      }
      unknownFields.writeDescriptionTo(&output, indent:indent)
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            if hasVersion {
               hashCode = (hashCode &* 31) &+ version.hashValue
            }
            if hasBackend {
               hashCode = (hashCode &* 31) &+ Int(backend.rawValue)
            }
            if hasUserExists {
               hashCode = (hashCode &* 31) &+ userExists.hashValue
            }
            if hasAuthorizationUrl {
               hashCode = (hashCode &* 31) &+ authorizationUrl.hashValue
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.User.Actions.GetAuthenticationInstructions.ResponseV1"
    }
    override public func className() -> String {
        return "Services.User.Actions.GetAuthenticationInstructions.ResponseV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.User.Actions.GetAuthenticationInstructions.ResponseV1.self
    }
    //Meta information declaration end

    final public class Builder : GeneratedMessageBuilder {
      private var builderResult:Services.User.Actions.GetAuthenticationInstructions.ResponseV1 = Services.User.Actions.GetAuthenticationInstructions.ResponseV1()
      public func getMessage() -> Services.User.Actions.GetAuthenticationInstructions.ResponseV1 {
          return builderResult
      }

      required override public init () {
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
      public func setVersion(value:UInt32) -> Services.User.Actions.GetAuthenticationInstructions.ResponseV1.Builder {
        self.version = value
        return self
      }
      public func clearVersion() -> Services.User.Actions.GetAuthenticationInstructions.ResponseV1.Builder{
           builderResult.hasVersion = false
           builderResult.version = UInt32(1)
           return self
      }
        public var hasBackend:Bool{
            get {
                return builderResult.hasBackend
            }
        }
        public var backend:Services.User.Actions.AuthenticateUser.RequestV1.AuthBackendV1 {
            get {
                return builderResult.backend
            }
            set (value) {
                builderResult.hasBackend = true
                builderResult.backend = value
            }
        }
        public func setBackend(value:Services.User.Actions.AuthenticateUser.RequestV1.AuthBackendV1) -> Services.User.Actions.GetAuthenticationInstructions.ResponseV1.Builder {
          self.backend = value
          return self
        }
        public func clearBackend() -> Services.User.Actions.GetAuthenticationInstructions.ResponseV1.Builder {
           builderResult.hasBackend = false
           builderResult.backend = .Internal
           return self
        }
      public var hasUserExists:Bool {
           get {
                return builderResult.hasUserExists
           }
      }
      public var userExists:Bool {
           get {
                return builderResult.userExists
           }
           set (value) {
               builderResult.hasUserExists = true
               builderResult.userExists = value
           }
      }
      public func setUserExists(value:Bool) -> Services.User.Actions.GetAuthenticationInstructions.ResponseV1.Builder {
        self.userExists = value
        return self
      }
      public func clearUserExists() -> Services.User.Actions.GetAuthenticationInstructions.ResponseV1.Builder{
           builderResult.hasUserExists = false
           builderResult.userExists = false
           return self
      }
      public var hasAuthorizationUrl:Bool {
           get {
                return builderResult.hasAuthorizationUrl
           }
      }
      public var authorizationUrl:String {
           get {
                return builderResult.authorizationUrl
           }
           set (value) {
               builderResult.hasAuthorizationUrl = true
               builderResult.authorizationUrl = value
           }
      }
      public func setAuthorizationUrl(value:String) -> Services.User.Actions.GetAuthenticationInstructions.ResponseV1.Builder {
        self.authorizationUrl = value
        return self
      }
      public func clearAuthorizationUrl() -> Services.User.Actions.GetAuthenticationInstructions.ResponseV1.Builder{
           builderResult.hasAuthorizationUrl = false
           builderResult.authorizationUrl = ""
           return self
      }
      override public var internalGetResult:GeneratedMessage {
           get {
              return builderResult
           }
      }
      public override func clear() -> Services.User.Actions.GetAuthenticationInstructions.ResponseV1.Builder {
        builderResult = Services.User.Actions.GetAuthenticationInstructions.ResponseV1()
        return self
      }
      public override func clone() throws -> Services.User.Actions.GetAuthenticationInstructions.ResponseV1.Builder {
        return try Services.User.Actions.GetAuthenticationInstructions.ResponseV1.builderWithPrototype(builderResult)
      }
      public override func build() throws -> Services.User.Actions.GetAuthenticationInstructions.ResponseV1 {
           try checkInitialized()
           return buildPartial()
      }
      public func buildPartial() -> Services.User.Actions.GetAuthenticationInstructions.ResponseV1 {
        let returnMe:Services.User.Actions.GetAuthenticationInstructions.ResponseV1 = builderResult
        return returnMe
      }
      public func mergeFrom(other:Services.User.Actions.GetAuthenticationInstructions.ResponseV1) throws -> Services.User.Actions.GetAuthenticationInstructions.ResponseV1.Builder {
        if other == Services.User.Actions.GetAuthenticationInstructions.ResponseV1() {
         return self
        }
        if other.hasVersion {
             version = other.version
        }
        if other.hasBackend {
             backend = other.backend
        }
        if other.hasUserExists {
             userExists = other.userExists
        }
        if other.hasAuthorizationUrl {
             authorizationUrl = other.authorizationUrl
        }
        try mergeUnknownFields(other.unknownFields)
        return self
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream) throws -> Services.User.Actions.GetAuthenticationInstructions.ResponseV1.Builder {
           return try mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.User.Actions.GetAuthenticationInstructions.ResponseV1.Builder {
        let unknownFieldsBuilder:UnknownFieldSet.Builder = try UnknownFieldSet.builderWithUnknownFields(self.unknownFields)
        while (true) {
          let tag = try input.readTag()
          switch tag {
          case 0: 
            self.unknownFields = try unknownFieldsBuilder.build()
            return self

          case 8 :
            version = try input.readUInt32()

          case 16 :
            let valueIntbackend = try input.readEnum()
            if let enumsbackend = Services.User.Actions.AuthenticateUser.RequestV1.AuthBackendV1(rawValue:valueIntbackend){
                 backend = enumsbackend
            } else {
                 try unknownFieldsBuilder.mergeVarintField(2, value:Int64(valueIntbackend))
            }

          case 24 :
            userExists = try input.readBool()

          case 34 :
            authorizationUrl = try input.readString()

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
