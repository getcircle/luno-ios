// Generated by the protocol buffer compiler.  DO NOT EDIT!

import Foundation
public extension Services{ public struct Feed { public struct Actions { public struct GetOrganizationFeed { }}}}

public func == (lhs: Services.Feed.Actions.GetOrganizationFeed.RequestV1, rhs: Services.Feed.Actions.GetOrganizationFeed.RequestV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasVersion == rhs.hasVersion) && (!lhs.hasVersion || lhs.version == rhs.version)
  fieldCheck = fieldCheck && (lhs.hasOrganizationId == rhs.hasOrganizationId) && (!lhs.hasOrganizationId || lhs.organizationId == rhs.organizationId)
  return (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
}

public func == (lhs: Services.Feed.Actions.GetOrganizationFeed.ResponseV1, rhs: Services.Feed.Actions.GetOrganizationFeed.ResponseV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasVersion == rhs.hasVersion) && (!lhs.hasVersion || lhs.version == rhs.version)
  fieldCheck = fieldCheck && (lhs.categories == rhs.categories)
  fieldCheck = fieldCheck && (lhs.hasOwner == rhs.hasOwner) && (!lhs.hasOwner || lhs.owner == rhs.owner)
  fieldCheck = fieldCheck && (lhs.hasOrganization == rhs.hasOrganization) && (!lhs.hasOrganization || lhs.organization == rhs.organization)
  return (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
}

public extension Services.Feed.Actions.GetOrganizationFeed {
  public struct GetOrganizationFeedRoot {
    public static var sharedInstance : GetOrganizationFeedRoot {
     struct Static {
         static let instance : GetOrganizationFeedRoot = GetOrganizationFeedRoot()
     }
     return Static.instance
    }
    public var extensionRegistry:ExtensionRegistry

    init() {
      extensionRegistry = ExtensionRegistry()
      registerAllExtensions(extensionRegistry)
      Services.Feed.Containers.ContainersRoot.sharedInstance.registerAllExtensions(extensionRegistry)
      Services.Organization.Containers.ContainersRoot.sharedInstance.registerAllExtensions(extensionRegistry)
      Services.Profile.Containers.ContainersRoot.sharedInstance.registerAllExtensions(extensionRegistry)
    }
    public func registerAllExtensions(registry:ExtensionRegistry) {
    }
  }

  final public class RequestV1 : GeneratedMessage, GeneratedMessageProtocol {
    public subscript(key: String) -> Any? {
           switch key {
           case "version": return version
           case "organizationId": return organizationId
           default: return nil
           }
    }

    public private(set) var hasVersion:Bool = false
    public private(set) var version:UInt32 = UInt32(1)

    public private(set) var hasOrganizationId:Bool = false
    public private(set) var organizationId:String = ""

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
      if hasOrganizationId {
        output.writeString(2, value:organizationId)
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
      if hasOrganizationId {
        serialize_size += organizationId.computeStringSize(2)
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseFromData(data:NSData) -> Services.Feed.Actions.GetOrganizationFeed.RequestV1 {
      return Services.Feed.Actions.GetOrganizationFeed.RequestV1.builder().mergeFromData(data, extensionRegistry:Services.Feed.Actions.GetOrganizationFeed.GetOrganizationFeedRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) -> Services.Feed.Actions.GetOrganizationFeed.RequestV1 {
      return Services.Feed.Actions.GetOrganizationFeed.RequestV1.builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) -> Services.Feed.Actions.GetOrganizationFeed.RequestV1 {
      return Services.Feed.Actions.GetOrganizationFeed.RequestV1.builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) ->Services.Feed.Actions.GetOrganizationFeed.RequestV1 {
      return Services.Feed.Actions.GetOrganizationFeed.RequestV1.builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) -> Services.Feed.Actions.GetOrganizationFeed.RequestV1 {
      return Services.Feed.Actions.GetOrganizationFeed.RequestV1.builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.Feed.Actions.GetOrganizationFeed.RequestV1 {
      return Services.Feed.Actions.GetOrganizationFeed.RequestV1.builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func builder() -> Services.Feed.Actions.GetOrganizationFeed.RequestV1Builder {
      return Services.Feed.Actions.GetOrganizationFeed.RequestV1.classBuilder() as! Services.Feed.Actions.GetOrganizationFeed.RequestV1Builder
    }
    public func builder() -> Services.Feed.Actions.GetOrganizationFeed.RequestV1Builder {
      return classBuilder() as! Services.Feed.Actions.GetOrganizationFeed.RequestV1Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.Feed.Actions.GetOrganizationFeed.RequestV1Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.Feed.Actions.GetOrganizationFeed.RequestV1.builder()
    }
    public func toBuilder() -> Services.Feed.Actions.GetOrganizationFeed.RequestV1Builder {
      return Services.Feed.Actions.GetOrganizationFeed.RequestV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.Feed.Actions.GetOrganizationFeed.RequestV1) -> Services.Feed.Actions.GetOrganizationFeed.RequestV1Builder {
      return Services.Feed.Actions.GetOrganizationFeed.RequestV1.builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) {
      if hasVersion {
        output += "\(indent) version: \(version) \n"
      }
      if hasOrganizationId {
        output += "\(indent) organizationId: \(organizationId) \n"
      }
      unknownFields.writeDescriptionTo(&output, indent:indent)
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            if hasVersion {
               hashCode = (hashCode &* 31) &+ version.hashValue
            }
            if hasOrganizationId {
               hashCode = (hashCode &* 31) &+ organizationId.hashValue
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.Feed.Actions.GetOrganizationFeed.RequestV1"
    }
    override public func className() -> String {
        return "Services.Feed.Actions.GetOrganizationFeed.RequestV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.Feed.Actions.GetOrganizationFeed.RequestV1.self
    }
    //Meta information declaration end

  }

  final public class RequestV1Builder : GeneratedMessageBuilder {
    private var builderResult:Services.Feed.Actions.GetOrganizationFeed.RequestV1

    required override public init () {
       builderResult = Services.Feed.Actions.GetOrganizationFeed.RequestV1()
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
    public func setVersion(value:UInt32)-> Services.Feed.Actions.GetOrganizationFeed.RequestV1Builder {
      self.version = value
      return self
    }
    public func clearVersion() -> Services.Feed.Actions.GetOrganizationFeed.RequestV1Builder{
         builderResult.hasVersion = false
         builderResult.version = UInt32(1)
         return self
    }
    public var hasOrganizationId:Bool {
         get {
              return builderResult.hasOrganizationId
         }
    }
    public var organizationId:String {
         get {
              return builderResult.organizationId
         }
         set (value) {
             builderResult.hasOrganizationId = true
             builderResult.organizationId = value
         }
    }
    public func setOrganizationId(value:String)-> Services.Feed.Actions.GetOrganizationFeed.RequestV1Builder {
      self.organizationId = value
      return self
    }
    public func clearOrganizationId() -> Services.Feed.Actions.GetOrganizationFeed.RequestV1Builder{
         builderResult.hasOrganizationId = false
         builderResult.organizationId = ""
         return self
    }
    override public var internalGetResult:GeneratedMessage {
         get {
            return builderResult
         }
    }
    public override func clear() -> Services.Feed.Actions.GetOrganizationFeed.RequestV1Builder {
      builderResult = Services.Feed.Actions.GetOrganizationFeed.RequestV1()
      return self
    }
    public override func clone() -> Services.Feed.Actions.GetOrganizationFeed.RequestV1Builder {
      return Services.Feed.Actions.GetOrganizationFeed.RequestV1.builderWithPrototype(builderResult)
    }
    public override func build() -> Services.Feed.Actions.GetOrganizationFeed.RequestV1 {
         checkInitialized()
         return buildPartial()
    }
    public func buildPartial() -> Services.Feed.Actions.GetOrganizationFeed.RequestV1 {
      var returnMe:Services.Feed.Actions.GetOrganizationFeed.RequestV1 = builderResult
      return returnMe
    }
    public func mergeFrom(other:Services.Feed.Actions.GetOrganizationFeed.RequestV1) -> Services.Feed.Actions.GetOrganizationFeed.RequestV1Builder {
      if (other == Services.Feed.Actions.GetOrganizationFeed.RequestV1()) {
       return self
      }
      if other.hasVersion {
           version = other.version
      }
      if other.hasOrganizationId {
           organizationId = other.organizationId
      }
      mergeUnknownFields(other.unknownFields)
      return self
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream) ->Services.Feed.Actions.GetOrganizationFeed.RequestV1Builder {
         return mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.Feed.Actions.GetOrganizationFeed.RequestV1Builder {
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
          organizationId = input.readString()

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
    public subscript(key: String) -> Any? {
           switch key {
           case "version": return version
           case "owner": return owner
           case "organization": return organization
           default: return nil
           }
    }

    public private(set) var hasVersion:Bool = false
    public private(set) var version:UInt32 = UInt32(1)

    public private(set) var hasOwner:Bool = false
    public private(set) var owner:Services.Profile.Containers.ProfileV1!
    public private(set) var hasOrganization:Bool = false
    public private(set) var organization:Services.Organization.Containers.OrganizationV1!
    public private(set) var categories:Array<Services.Feed.Containers.CategoryV1>  = Array<Services.Feed.Containers.CategoryV1>()
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
      for oneElementcategories in categories {
          output.writeMessage(2, value:oneElementcategories)
      }
      if hasOwner {
        output.writeMessage(3, value:owner)
      }
      if hasOrganization {
        output.writeMessage(4, value:organization)
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
      for oneElementcategories in categories {
          serialize_size += oneElementcategories.computeMessageSize(2)
      }
      if hasOwner {
          if let varSizeowner = owner?.computeMessageSize(3) {
              serialize_size += varSizeowner
          }
      }
      if hasOrganization {
          if let varSizeorganization = organization?.computeMessageSize(4) {
              serialize_size += varSizeorganization
          }
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseFromData(data:NSData) -> Services.Feed.Actions.GetOrganizationFeed.ResponseV1 {
      return Services.Feed.Actions.GetOrganizationFeed.ResponseV1.builder().mergeFromData(data, extensionRegistry:Services.Feed.Actions.GetOrganizationFeed.GetOrganizationFeedRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) -> Services.Feed.Actions.GetOrganizationFeed.ResponseV1 {
      return Services.Feed.Actions.GetOrganizationFeed.ResponseV1.builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) -> Services.Feed.Actions.GetOrganizationFeed.ResponseV1 {
      return Services.Feed.Actions.GetOrganizationFeed.ResponseV1.builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) ->Services.Feed.Actions.GetOrganizationFeed.ResponseV1 {
      return Services.Feed.Actions.GetOrganizationFeed.ResponseV1.builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) -> Services.Feed.Actions.GetOrganizationFeed.ResponseV1 {
      return Services.Feed.Actions.GetOrganizationFeed.ResponseV1.builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.Feed.Actions.GetOrganizationFeed.ResponseV1 {
      return Services.Feed.Actions.GetOrganizationFeed.ResponseV1.builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func builder() -> Services.Feed.Actions.GetOrganizationFeed.ResponseV1Builder {
      return Services.Feed.Actions.GetOrganizationFeed.ResponseV1.classBuilder() as! Services.Feed.Actions.GetOrganizationFeed.ResponseV1Builder
    }
    public func builder() -> Services.Feed.Actions.GetOrganizationFeed.ResponseV1Builder {
      return classBuilder() as! Services.Feed.Actions.GetOrganizationFeed.ResponseV1Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.Feed.Actions.GetOrganizationFeed.ResponseV1Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.Feed.Actions.GetOrganizationFeed.ResponseV1.builder()
    }
    public func toBuilder() -> Services.Feed.Actions.GetOrganizationFeed.ResponseV1Builder {
      return Services.Feed.Actions.GetOrganizationFeed.ResponseV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.Feed.Actions.GetOrganizationFeed.ResponseV1) -> Services.Feed.Actions.GetOrganizationFeed.ResponseV1Builder {
      return Services.Feed.Actions.GetOrganizationFeed.ResponseV1.builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) {
      if hasVersion {
        output += "\(indent) version: \(version) \n"
      }
      var categoriesElementIndex:Int = 0
      for oneElementcategories in categories {
          output += "\(indent) categories[\(categoriesElementIndex)] {\n"
          oneElementcategories.writeDescriptionTo(&output, indent:"\(indent)  ")
          output += "\(indent)}\n"
          categoriesElementIndex++
      }
      if hasOwner {
        output += "\(indent) owner {\n"
        owner?.writeDescriptionTo(&output, indent:"\(indent)  ")
        output += "\(indent) }\n"
      }
      if hasOrganization {
        output += "\(indent) organization {\n"
        organization?.writeDescriptionTo(&output, indent:"\(indent)  ")
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
            for oneElementcategories in categories {
                hashCode = (hashCode &* 31) &+ oneElementcategories.hashValue
            }
            if hasOwner {
                if let hashValueowner = owner?.hashValue {
                    hashCode = (hashCode &* 31) &+ hashValueowner
                }
            }
            if hasOrganization {
                if let hashValueorganization = organization?.hashValue {
                    hashCode = (hashCode &* 31) &+ hashValueorganization
                }
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.Feed.Actions.GetOrganizationFeed.ResponseV1"
    }
    override public func className() -> String {
        return "Services.Feed.Actions.GetOrganizationFeed.ResponseV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.Feed.Actions.GetOrganizationFeed.ResponseV1.self
    }
    //Meta information declaration end

  }

  final public class ResponseV1Builder : GeneratedMessageBuilder {
    private var builderResult:Services.Feed.Actions.GetOrganizationFeed.ResponseV1

    required override public init () {
       builderResult = Services.Feed.Actions.GetOrganizationFeed.ResponseV1()
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
    public func setVersion(value:UInt32)-> Services.Feed.Actions.GetOrganizationFeed.ResponseV1Builder {
      self.version = value
      return self
    }
    public func clearVersion() -> Services.Feed.Actions.GetOrganizationFeed.ResponseV1Builder{
         builderResult.hasVersion = false
         builderResult.version = UInt32(1)
         return self
    }
    public var categories:Array<Services.Feed.Containers.CategoryV1> {
         get {
             return builderResult.categories
         }
         set (value) {
             builderResult.categories = value
         }
    }
    public func setCategories(value:Array<Services.Feed.Containers.CategoryV1>)-> Services.Feed.Actions.GetOrganizationFeed.ResponseV1Builder {
      self.categories = value
      return self
    }
    public func clearCategories() -> Services.Feed.Actions.GetOrganizationFeed.ResponseV1Builder {
      builderResult.categories.removeAll(keepCapacity: false)
      return self
    }
    public var hasOwner:Bool {
         get {
             return builderResult.hasOwner
         }
    }
    public var owner:Services.Profile.Containers.ProfileV1! {
         get {
             return builderResult.owner
         }
         set (value) {
             builderResult.hasOwner = true
             builderResult.owner = value
         }
    }
    public func setOwner(value:Services.Profile.Containers.ProfileV1!)-> Services.Feed.Actions.GetOrganizationFeed.ResponseV1Builder {
      self.owner = value
      return self
    }
    public func mergeOwner(value:Services.Profile.Containers.ProfileV1) -> Services.Feed.Actions.GetOrganizationFeed.ResponseV1Builder {
      if (builderResult.hasOwner) {
        builderResult.owner = Services.Profile.Containers.ProfileV1.builderWithPrototype(builderResult.owner).mergeFrom(value).buildPartial()
      } else {
        builderResult.owner = value
      }
      builderResult.hasOwner = true
      return self
    }
    public func clearOwner() -> Services.Feed.Actions.GetOrganizationFeed.ResponseV1Builder {
      builderResult.hasOwner = false
      builderResult.owner = nil
      return self
    }
    public var hasOrganization:Bool {
         get {
             return builderResult.hasOrganization
         }
    }
    public var organization:Services.Organization.Containers.OrganizationV1! {
         get {
             return builderResult.organization
         }
         set (value) {
             builderResult.hasOrganization = true
             builderResult.organization = value
         }
    }
    public func setOrganization(value:Services.Organization.Containers.OrganizationV1!)-> Services.Feed.Actions.GetOrganizationFeed.ResponseV1Builder {
      self.organization = value
      return self
    }
    public func mergeOrganization(value:Services.Organization.Containers.OrganizationV1) -> Services.Feed.Actions.GetOrganizationFeed.ResponseV1Builder {
      if (builderResult.hasOrganization) {
        builderResult.organization = Services.Organization.Containers.OrganizationV1.builderWithPrototype(builderResult.organization).mergeFrom(value).buildPartial()
      } else {
        builderResult.organization = value
      }
      builderResult.hasOrganization = true
      return self
    }
    public func clearOrganization() -> Services.Feed.Actions.GetOrganizationFeed.ResponseV1Builder {
      builderResult.hasOrganization = false
      builderResult.organization = nil
      return self
    }
    override public var internalGetResult:GeneratedMessage {
         get {
            return builderResult
         }
    }
    public override func clear() -> Services.Feed.Actions.GetOrganizationFeed.ResponseV1Builder {
      builderResult = Services.Feed.Actions.GetOrganizationFeed.ResponseV1()
      return self
    }
    public override func clone() -> Services.Feed.Actions.GetOrganizationFeed.ResponseV1Builder {
      return Services.Feed.Actions.GetOrganizationFeed.ResponseV1.builderWithPrototype(builderResult)
    }
    public override func build() -> Services.Feed.Actions.GetOrganizationFeed.ResponseV1 {
         checkInitialized()
         return buildPartial()
    }
    public func buildPartial() -> Services.Feed.Actions.GetOrganizationFeed.ResponseV1 {
      var returnMe:Services.Feed.Actions.GetOrganizationFeed.ResponseV1 = builderResult
      return returnMe
    }
    public func mergeFrom(other:Services.Feed.Actions.GetOrganizationFeed.ResponseV1) -> Services.Feed.Actions.GetOrganizationFeed.ResponseV1Builder {
      if (other == Services.Feed.Actions.GetOrganizationFeed.ResponseV1()) {
       return self
      }
      if other.hasVersion {
           version = other.version
      }
      if !other.categories.isEmpty  {
         builderResult.categories += other.categories
      }
      if (other.hasOwner) {
          mergeOwner(other.owner)
      }
      if (other.hasOrganization) {
          mergeOrganization(other.organization)
      }
      mergeUnknownFields(other.unknownFields)
      return self
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream) ->Services.Feed.Actions.GetOrganizationFeed.ResponseV1Builder {
         return mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.Feed.Actions.GetOrganizationFeed.ResponseV1Builder {
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
          var subBuilder = Services.Feed.Containers.CategoryV1.builder()
          input.readMessage(subBuilder,extensionRegistry:extensionRegistry)
          categories += [subBuilder.buildPartial()]

        case 26 :
          var subBuilder:Services.Profile.Containers.ProfileV1Builder = Services.Profile.Containers.ProfileV1.builder()
          if hasOwner {
            subBuilder.mergeFrom(owner)
          }
          input.readMessage(subBuilder, extensionRegistry:extensionRegistry)
          owner = subBuilder.buildPartial()

        case 34 :
          var subBuilder:Services.Organization.Containers.OrganizationV1Builder = Services.Organization.Containers.OrganizationV1.builder()
          if hasOrganization {
            subBuilder.mergeFrom(organization)
          }
          input.readMessage(subBuilder, extensionRegistry:extensionRegistry)
          organization = subBuilder.buildPartial()

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
