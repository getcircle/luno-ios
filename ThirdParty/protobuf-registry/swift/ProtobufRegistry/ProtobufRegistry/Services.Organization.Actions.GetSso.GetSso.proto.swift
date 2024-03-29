// Generated by the protocol buffer compiler.  DO NOT EDIT!
// Source file get_sso.proto

import Foundation

public extension Services.Organization.Actions{ public struct GetSso { }}

public func == (lhs: Services.Organization.Actions.GetSso.RequestV1, rhs: Services.Organization.Actions.GetSso.RequestV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasOrganizationDomain == rhs.hasOrganizationDomain) && (!lhs.hasOrganizationDomain || lhs.organizationDomain == rhs.organizationDomain)
  fieldCheck = (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
  return fieldCheck
}

public func == (lhs: Services.Organization.Actions.GetSso.ResponseV1, rhs: Services.Organization.Actions.GetSso.ResponseV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasSso == rhs.hasSso) && (!lhs.hasSso || lhs.sso == rhs.sso)
  fieldCheck = (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
  return fieldCheck
}

public extension Services.Organization.Actions.GetSso {
  public struct GetSsoRoot {
    public static var sharedInstance : GetSsoRoot {
     struct Static {
         static let instance : GetSsoRoot = GetSsoRoot()
     }
     return Static.instance
    }
    public var extensionRegistry:ExtensionRegistry

    init() {
      extensionRegistry = ExtensionRegistry()
      registerAllExtensions(extensionRegistry)
      Services.Organization.Containers.Sso.SsoRoot.sharedInstance.registerAllExtensions(extensionRegistry)
    }
    public func registerAllExtensions(registry:ExtensionRegistry) {
    }
  }

  final public class RequestV1 : GeneratedMessage, GeneratedMessageProtocol {
    public private(set) var hasOrganizationDomain:Bool = false
    public private(set) var organizationDomain:String = ""

    required public init() {
         super.init()
    }
    override public func isInitialized() -> Bool {
     return true
    }
    override public func writeToCodedOutputStream(output:CodedOutputStream) throws {
      if hasOrganizationDomain {
        try output.writeString(1, value:organizationDomain)
      }
      try unknownFields.writeToCodedOutputStream(output)
    }
    override public func serializedSize() -> Int32 {
      var serialize_size:Int32 = memoizedSerializedSize
      if serialize_size != -1 {
       return serialize_size
      }

      serialize_size = 0
      if hasOrganizationDomain {
        serialize_size += organizationDomain.computeStringSize(1)
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseArrayDelimitedFromInputStream(input:NSInputStream) throws -> Array<Services.Organization.Actions.GetSso.RequestV1> {
      var mergedArray = Array<Services.Organization.Actions.GetSso.RequestV1>()
      while let value = try parseFromDelimitedFromInputStream(input) {
        mergedArray += [value]
      }
      return mergedArray
    }
    public class func parseFromDelimitedFromInputStream(input:NSInputStream) throws -> Services.Organization.Actions.GetSso.RequestV1? {
      return try Services.Organization.Actions.GetSso.RequestV1.Builder().mergeDelimitedFromInputStream(input)?.build()
    }
    public class func parseFromData(data:NSData) throws -> Services.Organization.Actions.GetSso.RequestV1 {
      return try Services.Organization.Actions.GetSso.RequestV1.Builder().mergeFromData(data, extensionRegistry:Services.Organization.Actions.GetSso.GetSsoRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) throws -> Services.Organization.Actions.GetSso.RequestV1 {
      return try Services.Organization.Actions.GetSso.RequestV1.Builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) throws -> Services.Organization.Actions.GetSso.RequestV1 {
      return try Services.Organization.Actions.GetSso.RequestV1.Builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Organization.Actions.GetSso.RequestV1 {
      return try Services.Organization.Actions.GetSso.RequestV1.Builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) throws -> Services.Organization.Actions.GetSso.RequestV1 {
      return try Services.Organization.Actions.GetSso.RequestV1.Builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Organization.Actions.GetSso.RequestV1 {
      return try Services.Organization.Actions.GetSso.RequestV1.Builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func getBuilder() -> Services.Organization.Actions.GetSso.RequestV1.Builder {
      return Services.Organization.Actions.GetSso.RequestV1.classBuilder() as! Services.Organization.Actions.GetSso.RequestV1.Builder
    }
    public func getBuilder() -> Services.Organization.Actions.GetSso.RequestV1.Builder {
      return classBuilder() as! Services.Organization.Actions.GetSso.RequestV1.Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.Organization.Actions.GetSso.RequestV1.Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.Organization.Actions.GetSso.RequestV1.Builder()
    }
    public func toBuilder() throws -> Services.Organization.Actions.GetSso.RequestV1.Builder {
      return try Services.Organization.Actions.GetSso.RequestV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.Organization.Actions.GetSso.RequestV1) throws -> Services.Organization.Actions.GetSso.RequestV1.Builder {
      return try Services.Organization.Actions.GetSso.RequestV1.Builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) throws {
      if hasOrganizationDomain {
        output += "\(indent) organizationDomain: \(organizationDomain) \n"
      }
      unknownFields.writeDescriptionTo(&output, indent:indent)
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            if hasOrganizationDomain {
               hashCode = (hashCode &* 31) &+ organizationDomain.hashValue
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.Organization.Actions.GetSso.RequestV1"
    }
    override public func className() -> String {
        return "Services.Organization.Actions.GetSso.RequestV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.Organization.Actions.GetSso.RequestV1.self
    }
    //Meta information declaration end

    final public class Builder : GeneratedMessageBuilder {
      private var builderResult:Services.Organization.Actions.GetSso.RequestV1 = Services.Organization.Actions.GetSso.RequestV1()
      public func getMessage() -> Services.Organization.Actions.GetSso.RequestV1 {
          return builderResult
      }

      required override public init () {
         super.init()
      }
      public var hasOrganizationDomain:Bool {
           get {
                return builderResult.hasOrganizationDomain
           }
      }
      public var organizationDomain:String {
           get {
                return builderResult.organizationDomain
           }
           set (value) {
               builderResult.hasOrganizationDomain = true
               builderResult.organizationDomain = value
           }
      }
      public func setOrganizationDomain(value:String) -> Services.Organization.Actions.GetSso.RequestV1.Builder {
        self.organizationDomain = value
        return self
      }
      public func clearOrganizationDomain() -> Services.Organization.Actions.GetSso.RequestV1.Builder{
           builderResult.hasOrganizationDomain = false
           builderResult.organizationDomain = ""
           return self
      }
      override public var internalGetResult:GeneratedMessage {
           get {
              return builderResult
           }
      }
      public override func clear() -> Services.Organization.Actions.GetSso.RequestV1.Builder {
        builderResult = Services.Organization.Actions.GetSso.RequestV1()
        return self
      }
      public override func clone() throws -> Services.Organization.Actions.GetSso.RequestV1.Builder {
        return try Services.Organization.Actions.GetSso.RequestV1.builderWithPrototype(builderResult)
      }
      public override func build() throws -> Services.Organization.Actions.GetSso.RequestV1 {
           try checkInitialized()
           return buildPartial()
      }
      public func buildPartial() -> Services.Organization.Actions.GetSso.RequestV1 {
        let returnMe:Services.Organization.Actions.GetSso.RequestV1 = builderResult
        return returnMe
      }
      public func mergeFrom(other:Services.Organization.Actions.GetSso.RequestV1) throws -> Services.Organization.Actions.GetSso.RequestV1.Builder {
        if other == Services.Organization.Actions.GetSso.RequestV1() {
         return self
        }
        if other.hasOrganizationDomain {
             organizationDomain = other.organizationDomain
        }
        try mergeUnknownFields(other.unknownFields)
        return self
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream) throws -> Services.Organization.Actions.GetSso.RequestV1.Builder {
           return try mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Organization.Actions.GetSso.RequestV1.Builder {
        let unknownFieldsBuilder:UnknownFieldSet.Builder = try UnknownFieldSet.builderWithUnknownFields(self.unknownFields)
        while (true) {
          let tag = try input.readTag()
          switch tag {
          case 0: 
            self.unknownFields = try unknownFieldsBuilder.build()
            return self

          case 10 :
            organizationDomain = try input.readString()

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
    public private(set) var hasSso:Bool = false
    public private(set) var sso:Services.Organization.Containers.Sso.SSOV1!
    required public init() {
         super.init()
    }
    override public func isInitialized() -> Bool {
     return true
    }
    override public func writeToCodedOutputStream(output:CodedOutputStream) throws {
      if hasSso {
        try output.writeMessage(1, value:sso)
      }
      try unknownFields.writeToCodedOutputStream(output)
    }
    override public func serializedSize() -> Int32 {
      var serialize_size:Int32 = memoizedSerializedSize
      if serialize_size != -1 {
       return serialize_size
      }

      serialize_size = 0
      if hasSso {
          if let varSizesso = sso?.computeMessageSize(1) {
              serialize_size += varSizesso
          }
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseArrayDelimitedFromInputStream(input:NSInputStream) throws -> Array<Services.Organization.Actions.GetSso.ResponseV1> {
      var mergedArray = Array<Services.Organization.Actions.GetSso.ResponseV1>()
      while let value = try parseFromDelimitedFromInputStream(input) {
        mergedArray += [value]
      }
      return mergedArray
    }
    public class func parseFromDelimitedFromInputStream(input:NSInputStream) throws -> Services.Organization.Actions.GetSso.ResponseV1? {
      return try Services.Organization.Actions.GetSso.ResponseV1.Builder().mergeDelimitedFromInputStream(input)?.build()
    }
    public class func parseFromData(data:NSData) throws -> Services.Organization.Actions.GetSso.ResponseV1 {
      return try Services.Organization.Actions.GetSso.ResponseV1.Builder().mergeFromData(data, extensionRegistry:Services.Organization.Actions.GetSso.GetSsoRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) throws -> Services.Organization.Actions.GetSso.ResponseV1 {
      return try Services.Organization.Actions.GetSso.ResponseV1.Builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) throws -> Services.Organization.Actions.GetSso.ResponseV1 {
      return try Services.Organization.Actions.GetSso.ResponseV1.Builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Organization.Actions.GetSso.ResponseV1 {
      return try Services.Organization.Actions.GetSso.ResponseV1.Builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) throws -> Services.Organization.Actions.GetSso.ResponseV1 {
      return try Services.Organization.Actions.GetSso.ResponseV1.Builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Organization.Actions.GetSso.ResponseV1 {
      return try Services.Organization.Actions.GetSso.ResponseV1.Builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func getBuilder() -> Services.Organization.Actions.GetSso.ResponseV1.Builder {
      return Services.Organization.Actions.GetSso.ResponseV1.classBuilder() as! Services.Organization.Actions.GetSso.ResponseV1.Builder
    }
    public func getBuilder() -> Services.Organization.Actions.GetSso.ResponseV1.Builder {
      return classBuilder() as! Services.Organization.Actions.GetSso.ResponseV1.Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.Organization.Actions.GetSso.ResponseV1.Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.Organization.Actions.GetSso.ResponseV1.Builder()
    }
    public func toBuilder() throws -> Services.Organization.Actions.GetSso.ResponseV1.Builder {
      return try Services.Organization.Actions.GetSso.ResponseV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.Organization.Actions.GetSso.ResponseV1) throws -> Services.Organization.Actions.GetSso.ResponseV1.Builder {
      return try Services.Organization.Actions.GetSso.ResponseV1.Builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) throws {
      if hasSso {
        output += "\(indent) sso {\n"
        try sso?.writeDescriptionTo(&output, indent:"\(indent)  ")
        output += "\(indent) }\n"
      }
      unknownFields.writeDescriptionTo(&output, indent:indent)
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            if hasSso {
                if let hashValuesso = sso?.hashValue {
                    hashCode = (hashCode &* 31) &+ hashValuesso
                }
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.Organization.Actions.GetSso.ResponseV1"
    }
    override public func className() -> String {
        return "Services.Organization.Actions.GetSso.ResponseV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.Organization.Actions.GetSso.ResponseV1.self
    }
    //Meta information declaration end

    final public class Builder : GeneratedMessageBuilder {
      private var builderResult:Services.Organization.Actions.GetSso.ResponseV1 = Services.Organization.Actions.GetSso.ResponseV1()
      public func getMessage() -> Services.Organization.Actions.GetSso.ResponseV1 {
          return builderResult
      }

      required override public init () {
         super.init()
      }
      public var hasSso:Bool {
           get {
               return builderResult.hasSso
           }
      }
      public var sso:Services.Organization.Containers.Sso.SSOV1! {
           get {
               if ssoBuilder_ != nil {
                  builderResult.sso = ssoBuilder_.getMessage()
               }
               return builderResult.sso
           }
           set (value) {
               builderResult.hasSso = true
               builderResult.sso = value
           }
      }
      private var ssoBuilder_:Services.Organization.Containers.Sso.SSOV1.Builder! {
           didSet {
              builderResult.hasSso = true
           }
      }
      public func getSsoBuilder() -> Services.Organization.Containers.Sso.SSOV1.Builder {
        if ssoBuilder_ == nil {
           ssoBuilder_ = Services.Organization.Containers.Sso.SSOV1.Builder()
           builderResult.sso = ssoBuilder_.getMessage()
           if sso != nil {
              try! ssoBuilder_.mergeFrom(sso)
           }
        }
        return ssoBuilder_
      }
      public func setSso(value:Services.Organization.Containers.Sso.SSOV1!) -> Services.Organization.Actions.GetSso.ResponseV1.Builder {
        self.sso = value
        return self
      }
      public func mergeSso(value:Services.Organization.Containers.Sso.SSOV1) throws -> Services.Organization.Actions.GetSso.ResponseV1.Builder {
        if builderResult.hasSso {
          builderResult.sso = try Services.Organization.Containers.Sso.SSOV1.builderWithPrototype(builderResult.sso).mergeFrom(value).buildPartial()
        } else {
          builderResult.sso = value
        }
        builderResult.hasSso = true
        return self
      }
      public func clearSso() -> Services.Organization.Actions.GetSso.ResponseV1.Builder {
        ssoBuilder_ = nil
        builderResult.hasSso = false
        builderResult.sso = nil
        return self
      }
      override public var internalGetResult:GeneratedMessage {
           get {
              return builderResult
           }
      }
      public override func clear() -> Services.Organization.Actions.GetSso.ResponseV1.Builder {
        builderResult = Services.Organization.Actions.GetSso.ResponseV1()
        return self
      }
      public override func clone() throws -> Services.Organization.Actions.GetSso.ResponseV1.Builder {
        return try Services.Organization.Actions.GetSso.ResponseV1.builderWithPrototype(builderResult)
      }
      public override func build() throws -> Services.Organization.Actions.GetSso.ResponseV1 {
           try checkInitialized()
           return buildPartial()
      }
      public func buildPartial() -> Services.Organization.Actions.GetSso.ResponseV1 {
        let returnMe:Services.Organization.Actions.GetSso.ResponseV1 = builderResult
        return returnMe
      }
      public func mergeFrom(other:Services.Organization.Actions.GetSso.ResponseV1) throws -> Services.Organization.Actions.GetSso.ResponseV1.Builder {
        if other == Services.Organization.Actions.GetSso.ResponseV1() {
         return self
        }
        if (other.hasSso) {
            try mergeSso(other.sso)
        }
        try mergeUnknownFields(other.unknownFields)
        return self
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream) throws -> Services.Organization.Actions.GetSso.ResponseV1.Builder {
           return try mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Organization.Actions.GetSso.ResponseV1.Builder {
        let unknownFieldsBuilder:UnknownFieldSet.Builder = try UnknownFieldSet.builderWithUnknownFields(self.unknownFields)
        while (true) {
          let tag = try input.readTag()
          switch tag {
          case 0: 
            self.unknownFields = try unknownFieldsBuilder.build()
            return self

          case 10 :
            let subBuilder:Services.Organization.Containers.Sso.SSOV1.Builder = Services.Organization.Containers.Sso.SSOV1.Builder()
            if hasSso {
              try subBuilder.mergeFrom(sso)
            }
            try input.readMessage(subBuilder, extensionRegistry:extensionRegistry)
            sso = subBuilder.buildPartial()

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
