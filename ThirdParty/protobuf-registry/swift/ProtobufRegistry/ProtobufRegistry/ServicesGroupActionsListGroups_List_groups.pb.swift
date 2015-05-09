// Generated by the protocol buffer compiler.  DO NOT EDIT!

import Foundation
public extension Services.Group.Actions{ public struct ListGroups { }}

public func == (lhs: Services.Group.Actions.ListGroups.RequestV1, rhs: Services.Group.Actions.ListGroups.RequestV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasVersion == rhs.hasVersion) && (!lhs.hasVersion || lhs.version == rhs.version)
  fieldCheck = fieldCheck && (lhs.hasProfileId == rhs.hasProfileId) && (!lhs.hasProfileId || lhs.profileId == rhs.profileId)
  fieldCheck = fieldCheck && (lhs.hasProvider == rhs.hasProvider) && (!lhs.hasProvider || lhs.provider == rhs.provider)
  return (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
}

public func == (lhs: Services.Group.Actions.ListGroups.ResponseV1, rhs: Services.Group.Actions.ListGroups.ResponseV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasVersion == rhs.hasVersion) && (!lhs.hasVersion || lhs.version == rhs.version)
  fieldCheck = fieldCheck && (lhs.groups == rhs.groups)
  return (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
}

public extension Services.Group.Actions.ListGroups {
  public struct ListGroupsRoot {
    public static var sharedInstance : ListGroupsRoot {
     struct Static {
         static let instance : ListGroupsRoot = ListGroupsRoot()
     }
     return Static.instance
    }
    public var extensionRegistry:ExtensionRegistry

    init() {
      extensionRegistry = ExtensionRegistry()
      registerAllExtensions(extensionRegistry)
      Services.Group.Containers.ContainersRoot.sharedInstance.registerAllExtensions(extensionRegistry)
    }
    public func registerAllExtensions(registry:ExtensionRegistry) {
    }
  }

  final public class RequestV1 : GeneratedMessage, GeneratedMessageProtocol {
    override public subscript(key: String) -> Any? {
           switch key {
           case "version": return version
           case "profileId": return profileId
           case "provider": return self.provider
           default: return nil
           }
    }

    public private(set) var hasVersion:Bool = false
    public private(set) var version:UInt32 = UInt32(1)

    public private(set) var hasProfileId:Bool = false
    public private(set) var profileId:String = ""

    public private(set) var provider:Services.Group.Containers.GroupProviderV1 = Services.Group.Containers.GroupProviderV1.Google
    public private(set) var hasProvider:Bool = false
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
      if hasProfileId {
        output.writeString(2, value:profileId)
      }
      if hasProvider {
        output.writeEnum(3, value:provider.rawValue)
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
      if hasProfileId {
        serialize_size += profileId.computeStringSize(2)
      }
      if (hasProvider) {
        serialize_size += provider.rawValue.computeEnumSize(3)
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseFromData(data:NSData) -> Services.Group.Actions.ListGroups.RequestV1 {
      return Services.Group.Actions.ListGroups.RequestV1.builder().mergeFromData(data, extensionRegistry:Services.Group.Actions.ListGroups.ListGroupsRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) -> Services.Group.Actions.ListGroups.RequestV1 {
      return Services.Group.Actions.ListGroups.RequestV1.builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) -> Services.Group.Actions.ListGroups.RequestV1 {
      return Services.Group.Actions.ListGroups.RequestV1.builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) ->Services.Group.Actions.ListGroups.RequestV1 {
      return Services.Group.Actions.ListGroups.RequestV1.builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) -> Services.Group.Actions.ListGroups.RequestV1 {
      return Services.Group.Actions.ListGroups.RequestV1.builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.Group.Actions.ListGroups.RequestV1 {
      return Services.Group.Actions.ListGroups.RequestV1.builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func builder() -> Services.Group.Actions.ListGroups.RequestV1Builder {
      return Services.Group.Actions.ListGroups.RequestV1.classBuilder() as! Services.Group.Actions.ListGroups.RequestV1Builder
    }
    public func builder() -> Services.Group.Actions.ListGroups.RequestV1Builder {
      return classBuilder() as! Services.Group.Actions.ListGroups.RequestV1Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.Group.Actions.ListGroups.RequestV1Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.Group.Actions.ListGroups.RequestV1.builder()
    }
    public func toBuilder() -> Services.Group.Actions.ListGroups.RequestV1Builder {
      return Services.Group.Actions.ListGroups.RequestV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.Group.Actions.ListGroups.RequestV1) -> Services.Group.Actions.ListGroups.RequestV1Builder {
      return Services.Group.Actions.ListGroups.RequestV1.builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) {
      if hasVersion {
        output += "\(indent) version: \(version) \n"
      }
      if hasProfileId {
        output += "\(indent) profileId: \(profileId) \n"
      }
      if (hasProvider) {
        output += "\(indent) provider: \(provider.rawValue)\n"
      }
      unknownFields.writeDescriptionTo(&output, indent:indent)
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            if hasVersion {
               hashCode = (hashCode &* 31) &+ version.hashValue
            }
            if hasProfileId {
               hashCode = (hashCode &* 31) &+ profileId.hashValue
            }
            if hasProvider {
               hashCode = (hashCode &* 31) &+ Int(provider.rawValue)
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.Group.Actions.ListGroups.RequestV1"
    }
    override public func className() -> String {
        return "Services.Group.Actions.ListGroups.RequestV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.Group.Actions.ListGroups.RequestV1.self
    }
    //Meta information declaration end

  }

  final public class RequestV1Builder : GeneratedMessageBuilder {
    private var builderResult:Services.Group.Actions.ListGroups.RequestV1

    required override public init () {
       builderResult = Services.Group.Actions.ListGroups.RequestV1()
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
    public func setVersion(value:UInt32)-> Services.Group.Actions.ListGroups.RequestV1Builder {
      self.version = value
      return self
    }
    public func clearVersion() -> Services.Group.Actions.ListGroups.RequestV1Builder{
         builderResult.hasVersion = false
         builderResult.version = UInt32(1)
         return self
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
    public func setProfileId(value:String)-> Services.Group.Actions.ListGroups.RequestV1Builder {
      self.profileId = value
      return self
    }
    public func clearProfileId() -> Services.Group.Actions.ListGroups.RequestV1Builder{
         builderResult.hasProfileId = false
         builderResult.profileId = ""
         return self
    }
      public var hasProvider:Bool{
          get {
              return builderResult.hasProvider
          }
      }
      public var provider:Services.Group.Containers.GroupProviderV1 {
          get {
              return builderResult.provider
          }
          set (value) {
              builderResult.hasProvider = true
              builderResult.provider = value
          }
      }
      public func setProvider(value:Services.Group.Containers.GroupProviderV1)-> Services.Group.Actions.ListGroups.RequestV1Builder {
        self.provider = value
        return self
      }
      public func clearProvider() -> Services.Group.Actions.ListGroups.RequestV1Builder {
         builderResult.hasProvider = false
         builderResult.provider = .Google
         return self
      }
    override public var internalGetResult:GeneratedMessage {
         get {
            return builderResult
         }
    }
    public override func clear() -> Services.Group.Actions.ListGroups.RequestV1Builder {
      builderResult = Services.Group.Actions.ListGroups.RequestV1()
      return self
    }
    public override func clone() -> Services.Group.Actions.ListGroups.RequestV1Builder {
      return Services.Group.Actions.ListGroups.RequestV1.builderWithPrototype(builderResult)
    }
    public override func build() -> Services.Group.Actions.ListGroups.RequestV1 {
         checkInitialized()
         return buildPartial()
    }
    public func buildPartial() -> Services.Group.Actions.ListGroups.RequestV1 {
      var returnMe:Services.Group.Actions.ListGroups.RequestV1 = builderResult
      return returnMe
    }
    public func mergeFrom(other:Services.Group.Actions.ListGroups.RequestV1) -> Services.Group.Actions.ListGroups.RequestV1Builder {
      if (other == Services.Group.Actions.ListGroups.RequestV1()) {
       return self
      }
      if other.hasVersion {
           version = other.version
      }
      if other.hasProfileId {
           profileId = other.profileId
      }
      if other.hasProvider {
           provider = other.provider
      }
      mergeUnknownFields(other.unknownFields)
      return self
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream) ->Services.Group.Actions.ListGroups.RequestV1Builder {
         return mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.Group.Actions.ListGroups.RequestV1Builder {
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
          profileId = input.readString()

        case 24 :
          let valueIntprovider = input.readEnum()
          if let enumsprovider = Services.Group.Containers.GroupProviderV1(rawValue:valueIntprovider){
               provider = enumsprovider
          } else {
               unknownFieldsBuilder.mergeVarintField(3, value:Int64(valueIntprovider))
          }

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
           default: return nil
           }
    }

    public private(set) var hasVersion:Bool = false
    public private(set) var version:UInt32 = UInt32(1)

    public private(set) var groups:Array<Services.Group.Containers.GroupV1>  = Array<Services.Group.Containers.GroupV1>()
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
      for oneElementgroups in groups {
          output.writeMessage(2, value:oneElementgroups)
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
      for oneElementgroups in groups {
          serialize_size += oneElementgroups.computeMessageSize(2)
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseFromData(data:NSData) -> Services.Group.Actions.ListGroups.ResponseV1 {
      return Services.Group.Actions.ListGroups.ResponseV1.builder().mergeFromData(data, extensionRegistry:Services.Group.Actions.ListGroups.ListGroupsRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) -> Services.Group.Actions.ListGroups.ResponseV1 {
      return Services.Group.Actions.ListGroups.ResponseV1.builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) -> Services.Group.Actions.ListGroups.ResponseV1 {
      return Services.Group.Actions.ListGroups.ResponseV1.builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) ->Services.Group.Actions.ListGroups.ResponseV1 {
      return Services.Group.Actions.ListGroups.ResponseV1.builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) -> Services.Group.Actions.ListGroups.ResponseV1 {
      return Services.Group.Actions.ListGroups.ResponseV1.builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.Group.Actions.ListGroups.ResponseV1 {
      return Services.Group.Actions.ListGroups.ResponseV1.builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func builder() -> Services.Group.Actions.ListGroups.ResponseV1Builder {
      return Services.Group.Actions.ListGroups.ResponseV1.classBuilder() as! Services.Group.Actions.ListGroups.ResponseV1Builder
    }
    public func builder() -> Services.Group.Actions.ListGroups.ResponseV1Builder {
      return classBuilder() as! Services.Group.Actions.ListGroups.ResponseV1Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.Group.Actions.ListGroups.ResponseV1Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.Group.Actions.ListGroups.ResponseV1.builder()
    }
    public func toBuilder() -> Services.Group.Actions.ListGroups.ResponseV1Builder {
      return Services.Group.Actions.ListGroups.ResponseV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.Group.Actions.ListGroups.ResponseV1) -> Services.Group.Actions.ListGroups.ResponseV1Builder {
      return Services.Group.Actions.ListGroups.ResponseV1.builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) {
      if hasVersion {
        output += "\(indent) version: \(version) \n"
      }
      var groupsElementIndex:Int = 0
      for oneElementgroups in groups {
          output += "\(indent) groups[\(groupsElementIndex)] {\n"
          oneElementgroups.writeDescriptionTo(&output, indent:"\(indent)  ")
          output += "\(indent)}\n"
          groupsElementIndex++
      }
      unknownFields.writeDescriptionTo(&output, indent:indent)
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            if hasVersion {
               hashCode = (hashCode &* 31) &+ version.hashValue
            }
            for oneElementgroups in groups {
                hashCode = (hashCode &* 31) &+ oneElementgroups.hashValue
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.Group.Actions.ListGroups.ResponseV1"
    }
    override public func className() -> String {
        return "Services.Group.Actions.ListGroups.ResponseV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.Group.Actions.ListGroups.ResponseV1.self
    }
    //Meta information declaration end

  }

  final public class ResponseV1Builder : GeneratedMessageBuilder {
    private var builderResult:Services.Group.Actions.ListGroups.ResponseV1

    required override public init () {
       builderResult = Services.Group.Actions.ListGroups.ResponseV1()
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
    public func setVersion(value:UInt32)-> Services.Group.Actions.ListGroups.ResponseV1Builder {
      self.version = value
      return self
    }
    public func clearVersion() -> Services.Group.Actions.ListGroups.ResponseV1Builder{
         builderResult.hasVersion = false
         builderResult.version = UInt32(1)
         return self
    }
    public var groups:Array<Services.Group.Containers.GroupV1> {
         get {
             return builderResult.groups
         }
         set (value) {
             builderResult.groups = value
         }
    }
    public func setGroups(value:Array<Services.Group.Containers.GroupV1>)-> Services.Group.Actions.ListGroups.ResponseV1Builder {
      self.groups = value
      return self
    }
    public func clearGroups() -> Services.Group.Actions.ListGroups.ResponseV1Builder {
      builderResult.groups.removeAll(keepCapacity: false)
      return self
    }
    override public var internalGetResult:GeneratedMessage {
         get {
            return builderResult
         }
    }
    public override func clear() -> Services.Group.Actions.ListGroups.ResponseV1Builder {
      builderResult = Services.Group.Actions.ListGroups.ResponseV1()
      return self
    }
    public override func clone() -> Services.Group.Actions.ListGroups.ResponseV1Builder {
      return Services.Group.Actions.ListGroups.ResponseV1.builderWithPrototype(builderResult)
    }
    public override func build() -> Services.Group.Actions.ListGroups.ResponseV1 {
         checkInitialized()
         return buildPartial()
    }
    public func buildPartial() -> Services.Group.Actions.ListGroups.ResponseV1 {
      var returnMe:Services.Group.Actions.ListGroups.ResponseV1 = builderResult
      return returnMe
    }
    public func mergeFrom(other:Services.Group.Actions.ListGroups.ResponseV1) -> Services.Group.Actions.ListGroups.ResponseV1Builder {
      if (other == Services.Group.Actions.ListGroups.ResponseV1()) {
       return self
      }
      if other.hasVersion {
           version = other.version
      }
      if !other.groups.isEmpty  {
         builderResult.groups += other.groups
      }
      mergeUnknownFields(other.unknownFields)
      return self
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream) ->Services.Group.Actions.ListGroups.ResponseV1Builder {
         return mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.Group.Actions.ListGroups.ResponseV1Builder {
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
          var subBuilder = Services.Group.Containers.GroupV1.builder()
          input.readMessage(subBuilder,extensionRegistry:extensionRegistry)
          groups += [subBuilder.buildPartial()]

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