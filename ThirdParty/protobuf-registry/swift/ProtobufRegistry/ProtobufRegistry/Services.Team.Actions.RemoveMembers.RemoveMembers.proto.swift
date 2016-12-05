// Generated by the protocol buffer compiler.  DO NOT EDIT!
// Source file remove_members.proto

import Foundation

public extension Services.Team.Actions{ public struct RemoveMembers { }}

public func == (lhs: Services.Team.Actions.RemoveMembers.RequestV1, rhs: Services.Team.Actions.RemoveMembers.RequestV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasTeamId == rhs.hasTeamId) && (!lhs.hasTeamId || lhs.teamId == rhs.teamId)
  fieldCheck = fieldCheck && (lhs.profileIds == rhs.profileIds)
  fieldCheck = (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
  return fieldCheck
}

public func == (lhs: Services.Team.Actions.RemoveMembers.ResponseV1, rhs: Services.Team.Actions.RemoveMembers.ResponseV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
  return fieldCheck
}

public extension Services.Team.Actions.RemoveMembers {
  public struct RemoveMembersRoot {
    public static var sharedInstance : RemoveMembersRoot {
     struct Static {
         static let instance : RemoveMembersRoot = RemoveMembersRoot()
     }
     return Static.instance
    }
    public var extensionRegistry:ExtensionRegistry

    init() {
      extensionRegistry = ExtensionRegistry()
      registerAllExtensions(extensionRegistry)
    }
    public func registerAllExtensions(registry:ExtensionRegistry) {
    }
  }

  final public class RequestV1 : GeneratedMessage, GeneratedMessageProtocol {
    public private(set) var hasTeamId:Bool = false
    public private(set) var teamId:String = ""

    public private(set) var profileIds:Array<String> = Array<String>()
    required public init() {
         super.init()
    }
    override public func isInitialized() -> Bool {
     return true
    }
    override public func writeToCodedOutputStream(output:CodedOutputStream) throws {
      if hasTeamId {
        try output.writeString(1, value:teamId)
      }
      if !profileIds.isEmpty {
        for oneValueprofileIds in profileIds {
          try output.writeString(2, value:oneValueprofileIds)
        }
      }
      try unknownFields.writeToCodedOutputStream(output)
    }
    override public func serializedSize() -> Int32 {
      var serialize_size:Int32 = memoizedSerializedSize
      if serialize_size != -1 {
       return serialize_size
      }

      serialize_size = 0
      if hasTeamId {
        serialize_size += teamId.computeStringSize(1)
      }
      var dataSizeProfileIds:Int32 = 0
      for oneValueprofileIds in profileIds {
          dataSizeProfileIds += oneValueprofileIds.computeStringSizeNoTag()
      }
      serialize_size += dataSizeProfileIds
      serialize_size += 1 * Int32(profileIds.count)
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseArrayDelimitedFromInputStream(input:NSInputStream) throws -> Array<Services.Team.Actions.RemoveMembers.RequestV1> {
      var mergedArray = Array<Services.Team.Actions.RemoveMembers.RequestV1>()
      while let value = try parseFromDelimitedFromInputStream(input) {
        mergedArray += [value]
      }
      return mergedArray
    }
    public class func parseFromDelimitedFromInputStream(input:NSInputStream) throws -> Services.Team.Actions.RemoveMembers.RequestV1? {
      return try Services.Team.Actions.RemoveMembers.RequestV1.Builder().mergeDelimitedFromInputStream(input)?.build()
    }
    public class func parseFromData(data:NSData) throws -> Services.Team.Actions.RemoveMembers.RequestV1 {
      return try Services.Team.Actions.RemoveMembers.RequestV1.Builder().mergeFromData(data, extensionRegistry:Services.Team.Actions.RemoveMembers.RemoveMembersRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) throws -> Services.Team.Actions.RemoveMembers.RequestV1 {
      return try Services.Team.Actions.RemoveMembers.RequestV1.Builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) throws -> Services.Team.Actions.RemoveMembers.RequestV1 {
      return try Services.Team.Actions.RemoveMembers.RequestV1.Builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Team.Actions.RemoveMembers.RequestV1 {
      return try Services.Team.Actions.RemoveMembers.RequestV1.Builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) throws -> Services.Team.Actions.RemoveMembers.RequestV1 {
      return try Services.Team.Actions.RemoveMembers.RequestV1.Builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Team.Actions.RemoveMembers.RequestV1 {
      return try Services.Team.Actions.RemoveMembers.RequestV1.Builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func getBuilder() -> Services.Team.Actions.RemoveMembers.RequestV1.Builder {
      return Services.Team.Actions.RemoveMembers.RequestV1.classBuilder() as! Services.Team.Actions.RemoveMembers.RequestV1.Builder
    }
    public func getBuilder() -> Services.Team.Actions.RemoveMembers.RequestV1.Builder {
      return classBuilder() as! Services.Team.Actions.RemoveMembers.RequestV1.Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.Team.Actions.RemoveMembers.RequestV1.Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.Team.Actions.RemoveMembers.RequestV1.Builder()
    }
    public func toBuilder() throws -> Services.Team.Actions.RemoveMembers.RequestV1.Builder {
      return try Services.Team.Actions.RemoveMembers.RequestV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.Team.Actions.RemoveMembers.RequestV1) throws -> Services.Team.Actions.RemoveMembers.RequestV1.Builder {
      return try Services.Team.Actions.RemoveMembers.RequestV1.Builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) throws {
      if hasTeamId {
        output += "\(indent) teamId: \(teamId) \n"
      }
      var profileIdsElementIndex:Int = 0
      for oneValueprofileIds in profileIds  {
          output += "\(indent) profileIds[\(profileIdsElementIndex)]: \(oneValueprofileIds)\n"
          profileIdsElementIndex++
      }
      unknownFields.writeDescriptionTo(&output, indent:indent)
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            if hasTeamId {
               hashCode = (hashCode &* 31) &+ teamId.hashValue
            }
            for oneValueprofileIds in profileIds {
                hashCode = (hashCode &* 31) &+ oneValueprofileIds.hashValue
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.Team.Actions.RemoveMembers.RequestV1"
    }
    override public func className() -> String {
        return "Services.Team.Actions.RemoveMembers.RequestV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.Team.Actions.RemoveMembers.RequestV1.self
    }
    //Meta information declaration end

    final public class Builder : GeneratedMessageBuilder {
      private var builderResult:Services.Team.Actions.RemoveMembers.RequestV1 = Services.Team.Actions.RemoveMembers.RequestV1()
      public func getMessage() -> Services.Team.Actions.RemoveMembers.RequestV1 {
          return builderResult
      }

      required override public init () {
         super.init()
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
      public func setTeamId(value:String) -> Services.Team.Actions.RemoveMembers.RequestV1.Builder {
        self.teamId = value
        return self
      }
      public func clearTeamId() -> Services.Team.Actions.RemoveMembers.RequestV1.Builder{
           builderResult.hasTeamId = false
           builderResult.teamId = ""
           return self
      }
      public var profileIds:Array<String> {
           get {
               return builderResult.profileIds
           }
           set (array) {
               builderResult.profileIds = array
           }
      }
      public func setProfileIds(value:Array<String>) -> Services.Team.Actions.RemoveMembers.RequestV1.Builder {
        self.profileIds = value
        return self
      }
      public func clearProfileIds() -> Services.Team.Actions.RemoveMembers.RequestV1.Builder {
         builderResult.profileIds.removeAll(keepCapacity: false)
         return self
      }
      override public var internalGetResult:GeneratedMessage {
           get {
              return builderResult
           }
      }
      public override func clear() -> Services.Team.Actions.RemoveMembers.RequestV1.Builder {
        builderResult = Services.Team.Actions.RemoveMembers.RequestV1()
        return self
      }
      public override func clone() throws -> Services.Team.Actions.RemoveMembers.RequestV1.Builder {
        return try Services.Team.Actions.RemoveMembers.RequestV1.builderWithPrototype(builderResult)
      }
      public override func build() throws -> Services.Team.Actions.RemoveMembers.RequestV1 {
           try checkInitialized()
           return buildPartial()
      }
      public func buildPartial() -> Services.Team.Actions.RemoveMembers.RequestV1 {
        let returnMe:Services.Team.Actions.RemoveMembers.RequestV1 = builderResult
        return returnMe
      }
      public func mergeFrom(other:Services.Team.Actions.RemoveMembers.RequestV1) throws -> Services.Team.Actions.RemoveMembers.RequestV1.Builder {
        if other == Services.Team.Actions.RemoveMembers.RequestV1() {
         return self
        }
        if other.hasTeamId {
             teamId = other.teamId
        }
        if !other.profileIds.isEmpty {
            builderResult.profileIds += other.profileIds
        }
        try mergeUnknownFields(other.unknownFields)
        return self
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream) throws -> Services.Team.Actions.RemoveMembers.RequestV1.Builder {
           return try mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Team.Actions.RemoveMembers.RequestV1.Builder {
        let unknownFieldsBuilder:UnknownFieldSet.Builder = try UnknownFieldSet.builderWithUnknownFields(self.unknownFields)
        while (true) {
          let tag = try input.readTag()
          switch tag {
          case 0: 
            self.unknownFields = try unknownFieldsBuilder.build()
            return self

          case 10 :
            teamId = try input.readString()

          case 18 :
            profileIds += [try input.readString()]

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
    required public init() {
         super.init()
    }
    override public func isInitialized() -> Bool {
     return true
    }
    override public func writeToCodedOutputStream(output:CodedOutputStream) throws {
      try unknownFields.writeToCodedOutputStream(output)
    }
    override public func serializedSize() -> Int32 {
      var serialize_size:Int32 = memoizedSerializedSize
      if serialize_size != -1 {
       return serialize_size
      }

      serialize_size = 0
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseArrayDelimitedFromInputStream(input:NSInputStream) throws -> Array<Services.Team.Actions.RemoveMembers.ResponseV1> {
      var mergedArray = Array<Services.Team.Actions.RemoveMembers.ResponseV1>()
      while let value = try parseFromDelimitedFromInputStream(input) {
        mergedArray += [value]
      }
      return mergedArray
    }
    public class func parseFromDelimitedFromInputStream(input:NSInputStream) throws -> Services.Team.Actions.RemoveMembers.ResponseV1? {
      return try Services.Team.Actions.RemoveMembers.ResponseV1.Builder().mergeDelimitedFromInputStream(input)?.build()
    }
    public class func parseFromData(data:NSData) throws -> Services.Team.Actions.RemoveMembers.ResponseV1 {
      return try Services.Team.Actions.RemoveMembers.ResponseV1.Builder().mergeFromData(data, extensionRegistry:Services.Team.Actions.RemoveMembers.RemoveMembersRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) throws -> Services.Team.Actions.RemoveMembers.ResponseV1 {
      return try Services.Team.Actions.RemoveMembers.ResponseV1.Builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) throws -> Services.Team.Actions.RemoveMembers.ResponseV1 {
      return try Services.Team.Actions.RemoveMembers.ResponseV1.Builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Team.Actions.RemoveMembers.ResponseV1 {
      return try Services.Team.Actions.RemoveMembers.ResponseV1.Builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) throws -> Services.Team.Actions.RemoveMembers.ResponseV1 {
      return try Services.Team.Actions.RemoveMembers.ResponseV1.Builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Team.Actions.RemoveMembers.ResponseV1 {
      return try Services.Team.Actions.RemoveMembers.ResponseV1.Builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func getBuilder() -> Services.Team.Actions.RemoveMembers.ResponseV1.Builder {
      return Services.Team.Actions.RemoveMembers.ResponseV1.classBuilder() as! Services.Team.Actions.RemoveMembers.ResponseV1.Builder
    }
    public func getBuilder() -> Services.Team.Actions.RemoveMembers.ResponseV1.Builder {
      return classBuilder() as! Services.Team.Actions.RemoveMembers.ResponseV1.Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.Team.Actions.RemoveMembers.ResponseV1.Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.Team.Actions.RemoveMembers.ResponseV1.Builder()
    }
    public func toBuilder() throws -> Services.Team.Actions.RemoveMembers.ResponseV1.Builder {
      return try Services.Team.Actions.RemoveMembers.ResponseV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.Team.Actions.RemoveMembers.ResponseV1) throws -> Services.Team.Actions.RemoveMembers.ResponseV1.Builder {
      return try Services.Team.Actions.RemoveMembers.ResponseV1.Builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) throws {
      unknownFields.writeDescriptionTo(&output, indent:indent)
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.Team.Actions.RemoveMembers.ResponseV1"
    }
    override public func className() -> String {
        return "Services.Team.Actions.RemoveMembers.ResponseV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.Team.Actions.RemoveMembers.ResponseV1.self
    }
    //Meta information declaration end

    final public class Builder : GeneratedMessageBuilder {
      private var builderResult:Services.Team.Actions.RemoveMembers.ResponseV1 = Services.Team.Actions.RemoveMembers.ResponseV1()
      public func getMessage() -> Services.Team.Actions.RemoveMembers.ResponseV1 {
          return builderResult
      }

      required override public init () {
         super.init()
      }
      override public var internalGetResult:GeneratedMessage {
           get {
              return builderResult
           }
      }
      public override func clear() -> Services.Team.Actions.RemoveMembers.ResponseV1.Builder {
        builderResult = Services.Team.Actions.RemoveMembers.ResponseV1()
        return self
      }
      public override func clone() throws -> Services.Team.Actions.RemoveMembers.ResponseV1.Builder {
        return try Services.Team.Actions.RemoveMembers.ResponseV1.builderWithPrototype(builderResult)
      }
      public override func build() throws -> Services.Team.Actions.RemoveMembers.ResponseV1 {
           try checkInitialized()
           return buildPartial()
      }
      public func buildPartial() -> Services.Team.Actions.RemoveMembers.ResponseV1 {
        let returnMe:Services.Team.Actions.RemoveMembers.ResponseV1 = builderResult
        return returnMe
      }
      public func mergeFrom(other:Services.Team.Actions.RemoveMembers.ResponseV1) throws -> Services.Team.Actions.RemoveMembers.ResponseV1.Builder {
        if other == Services.Team.Actions.RemoveMembers.ResponseV1() {
         return self
        }
        try mergeUnknownFields(other.unknownFields)
        return self
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream) throws -> Services.Team.Actions.RemoveMembers.ResponseV1.Builder {
           return try mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Team.Actions.RemoveMembers.ResponseV1.Builder {
        let unknownFieldsBuilder:UnknownFieldSet.Builder = try UnknownFieldSet.builderWithUnknownFields(self.unknownFields)
        while (true) {
          let tag = try input.readTag()
          switch tag {
          case 0: 
            self.unknownFields = try unknownFieldsBuilder.build()
            return self

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