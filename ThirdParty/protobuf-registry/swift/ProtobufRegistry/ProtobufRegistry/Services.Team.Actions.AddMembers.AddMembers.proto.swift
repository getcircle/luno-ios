// Generated by the protocol buffer compiler.  DO NOT EDIT!
// Source file add_members.proto

import Foundation

public extension Services{ public struct Team { public struct Actions { public struct AddMembers { }}}}

public func == (lhs: Services.Team.Actions.AddMembers.RequestV1, rhs: Services.Team.Actions.AddMembers.RequestV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasTeamId == rhs.hasTeamId) && (!lhs.hasTeamId || lhs.teamId == rhs.teamId)
  fieldCheck = fieldCheck && (lhs.members == rhs.members)
  fieldCheck = (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
  return fieldCheck
}

public func == (lhs: Services.Team.Actions.AddMembers.ResponseV1, rhs: Services.Team.Actions.AddMembers.ResponseV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
  return fieldCheck
}

public extension Services.Team.Actions.AddMembers {
  public struct AddMembersRoot {
    public static var sharedInstance : AddMembersRoot {
     struct Static {
         static let instance : AddMembersRoot = AddMembersRoot()
     }
     return Static.instance
    }
    public var extensionRegistry:ExtensionRegistry

    init() {
      extensionRegistry = ExtensionRegistry()
      registerAllExtensions(extensionRegistry)
      Services.Team.Containers.ContainersRoot.sharedInstance.registerAllExtensions(extensionRegistry)
    }
    public func registerAllExtensions(registry:ExtensionRegistry) {
    }
  }

  final public class RequestV1 : GeneratedMessage, GeneratedMessageProtocol {
    public private(set) var hasTeamId:Bool = false
    public private(set) var teamId:String = ""

    public private(set) var members:Array<Services.Team.Containers.TeamMemberV1>  = Array<Services.Team.Containers.TeamMemberV1>()
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
      for oneElementmembers in members {
          try output.writeMessage(2, value:oneElementmembers)
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
      for oneElementmembers in members {
          serialize_size += oneElementmembers.computeMessageSize(2)
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseArrayDelimitedFromInputStream(input:NSInputStream) throws -> Array<Services.Team.Actions.AddMembers.RequestV1> {
      var mergedArray = Array<Services.Team.Actions.AddMembers.RequestV1>()
      while let value = try parseFromDelimitedFromInputStream(input) {
        mergedArray += [value]
      }
      return mergedArray
    }
    public class func parseFromDelimitedFromInputStream(input:NSInputStream) throws -> Services.Team.Actions.AddMembers.RequestV1? {
      return try Services.Team.Actions.AddMembers.RequestV1.Builder().mergeDelimitedFromInputStream(input)?.build()
    }
    public class func parseFromData(data:NSData) throws -> Services.Team.Actions.AddMembers.RequestV1 {
      return try Services.Team.Actions.AddMembers.RequestV1.Builder().mergeFromData(data, extensionRegistry:Services.Team.Actions.AddMembers.AddMembersRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) throws -> Services.Team.Actions.AddMembers.RequestV1 {
      return try Services.Team.Actions.AddMembers.RequestV1.Builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) throws -> Services.Team.Actions.AddMembers.RequestV1 {
      return try Services.Team.Actions.AddMembers.RequestV1.Builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Team.Actions.AddMembers.RequestV1 {
      return try Services.Team.Actions.AddMembers.RequestV1.Builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) throws -> Services.Team.Actions.AddMembers.RequestV1 {
      return try Services.Team.Actions.AddMembers.RequestV1.Builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Team.Actions.AddMembers.RequestV1 {
      return try Services.Team.Actions.AddMembers.RequestV1.Builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func getBuilder() -> Services.Team.Actions.AddMembers.RequestV1.Builder {
      return Services.Team.Actions.AddMembers.RequestV1.classBuilder() as! Services.Team.Actions.AddMembers.RequestV1.Builder
    }
    public func getBuilder() -> Services.Team.Actions.AddMembers.RequestV1.Builder {
      return classBuilder() as! Services.Team.Actions.AddMembers.RequestV1.Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.Team.Actions.AddMembers.RequestV1.Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.Team.Actions.AddMembers.RequestV1.Builder()
    }
    public func toBuilder() throws -> Services.Team.Actions.AddMembers.RequestV1.Builder {
      return try Services.Team.Actions.AddMembers.RequestV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.Team.Actions.AddMembers.RequestV1) throws -> Services.Team.Actions.AddMembers.RequestV1.Builder {
      return try Services.Team.Actions.AddMembers.RequestV1.Builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) throws {
      if hasTeamId {
        output += "\(indent) teamId: \(teamId) \n"
      }
      var membersElementIndex:Int = 0
      for oneElementmembers in members {
          output += "\(indent) members[\(membersElementIndex)] {\n"
          try oneElementmembers.writeDescriptionTo(&output, indent:"\(indent)  ")
          output += "\(indent)}\n"
          membersElementIndex++
      }
      unknownFields.writeDescriptionTo(&output, indent:indent)
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            if hasTeamId {
               hashCode = (hashCode &* 31) &+ teamId.hashValue
            }
            for oneElementmembers in members {
                hashCode = (hashCode &* 31) &+ oneElementmembers.hashValue
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.Team.Actions.AddMembers.RequestV1"
    }
    override public func className() -> String {
        return "Services.Team.Actions.AddMembers.RequestV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.Team.Actions.AddMembers.RequestV1.self
    }
    //Meta information declaration end

    final public class Builder : GeneratedMessageBuilder {
      private var builderResult:Services.Team.Actions.AddMembers.RequestV1 = Services.Team.Actions.AddMembers.RequestV1()
      public func getMessage() -> Services.Team.Actions.AddMembers.RequestV1 {
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
      public func setTeamId(value:String) -> Services.Team.Actions.AddMembers.RequestV1.Builder {
        self.teamId = value
        return self
      }
      public func clearTeamId() -> Services.Team.Actions.AddMembers.RequestV1.Builder{
           builderResult.hasTeamId = false
           builderResult.teamId = ""
           return self
      }
      public var members:Array<Services.Team.Containers.TeamMemberV1> {
           get {
               return builderResult.members
           }
           set (value) {
               builderResult.members = value
           }
      }
      public func setMembers(value:Array<Services.Team.Containers.TeamMemberV1>) -> Services.Team.Actions.AddMembers.RequestV1.Builder {
        self.members = value
        return self
      }
      public func clearMembers() -> Services.Team.Actions.AddMembers.RequestV1.Builder {
        builderResult.members.removeAll(keepCapacity: false)
        return self
      }
      override public var internalGetResult:GeneratedMessage {
           get {
              return builderResult
           }
      }
      public override func clear() -> Services.Team.Actions.AddMembers.RequestV1.Builder {
        builderResult = Services.Team.Actions.AddMembers.RequestV1()
        return self
      }
      public override func clone() throws -> Services.Team.Actions.AddMembers.RequestV1.Builder {
        return try Services.Team.Actions.AddMembers.RequestV1.builderWithPrototype(builderResult)
      }
      public override func build() throws -> Services.Team.Actions.AddMembers.RequestV1 {
           try checkInitialized()
           return buildPartial()
      }
      public func buildPartial() -> Services.Team.Actions.AddMembers.RequestV1 {
        let returnMe:Services.Team.Actions.AddMembers.RequestV1 = builderResult
        return returnMe
      }
      public func mergeFrom(other:Services.Team.Actions.AddMembers.RequestV1) throws -> Services.Team.Actions.AddMembers.RequestV1.Builder {
        if other == Services.Team.Actions.AddMembers.RequestV1() {
         return self
        }
        if other.hasTeamId {
             teamId = other.teamId
        }
        if !other.members.isEmpty  {
           builderResult.members += other.members
        }
        try mergeUnknownFields(other.unknownFields)
        return self
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream) throws -> Services.Team.Actions.AddMembers.RequestV1.Builder {
           return try mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Team.Actions.AddMembers.RequestV1.Builder {
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
            let subBuilder = Services.Team.Containers.TeamMemberV1.Builder()
            try input.readMessage(subBuilder,extensionRegistry:extensionRegistry)
            members += [subBuilder.buildPartial()]

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
    public class func parseArrayDelimitedFromInputStream(input:NSInputStream) throws -> Array<Services.Team.Actions.AddMembers.ResponseV1> {
      var mergedArray = Array<Services.Team.Actions.AddMembers.ResponseV1>()
      while let value = try parseFromDelimitedFromInputStream(input) {
        mergedArray += [value]
      }
      return mergedArray
    }
    public class func parseFromDelimitedFromInputStream(input:NSInputStream) throws -> Services.Team.Actions.AddMembers.ResponseV1? {
      return try Services.Team.Actions.AddMembers.ResponseV1.Builder().mergeDelimitedFromInputStream(input)?.build()
    }
    public class func parseFromData(data:NSData) throws -> Services.Team.Actions.AddMembers.ResponseV1 {
      return try Services.Team.Actions.AddMembers.ResponseV1.Builder().mergeFromData(data, extensionRegistry:Services.Team.Actions.AddMembers.AddMembersRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) throws -> Services.Team.Actions.AddMembers.ResponseV1 {
      return try Services.Team.Actions.AddMembers.ResponseV1.Builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) throws -> Services.Team.Actions.AddMembers.ResponseV1 {
      return try Services.Team.Actions.AddMembers.ResponseV1.Builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Team.Actions.AddMembers.ResponseV1 {
      return try Services.Team.Actions.AddMembers.ResponseV1.Builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) throws -> Services.Team.Actions.AddMembers.ResponseV1 {
      return try Services.Team.Actions.AddMembers.ResponseV1.Builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Team.Actions.AddMembers.ResponseV1 {
      return try Services.Team.Actions.AddMembers.ResponseV1.Builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func getBuilder() -> Services.Team.Actions.AddMembers.ResponseV1.Builder {
      return Services.Team.Actions.AddMembers.ResponseV1.classBuilder() as! Services.Team.Actions.AddMembers.ResponseV1.Builder
    }
    public func getBuilder() -> Services.Team.Actions.AddMembers.ResponseV1.Builder {
      return classBuilder() as! Services.Team.Actions.AddMembers.ResponseV1.Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.Team.Actions.AddMembers.ResponseV1.Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.Team.Actions.AddMembers.ResponseV1.Builder()
    }
    public func toBuilder() throws -> Services.Team.Actions.AddMembers.ResponseV1.Builder {
      return try Services.Team.Actions.AddMembers.ResponseV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.Team.Actions.AddMembers.ResponseV1) throws -> Services.Team.Actions.AddMembers.ResponseV1.Builder {
      return try Services.Team.Actions.AddMembers.ResponseV1.Builder().mergeFrom(prototype)
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
        return "Services.Team.Actions.AddMembers.ResponseV1"
    }
    override public func className() -> String {
        return "Services.Team.Actions.AddMembers.ResponseV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.Team.Actions.AddMembers.ResponseV1.self
    }
    //Meta information declaration end

    final public class Builder : GeneratedMessageBuilder {
      private var builderResult:Services.Team.Actions.AddMembers.ResponseV1 = Services.Team.Actions.AddMembers.ResponseV1()
      public func getMessage() -> Services.Team.Actions.AddMembers.ResponseV1 {
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
      public override func clear() -> Services.Team.Actions.AddMembers.ResponseV1.Builder {
        builderResult = Services.Team.Actions.AddMembers.ResponseV1()
        return self
      }
      public override func clone() throws -> Services.Team.Actions.AddMembers.ResponseV1.Builder {
        return try Services.Team.Actions.AddMembers.ResponseV1.builderWithPrototype(builderResult)
      }
      public override func build() throws -> Services.Team.Actions.AddMembers.ResponseV1 {
           try checkInitialized()
           return buildPartial()
      }
      public func buildPartial() -> Services.Team.Actions.AddMembers.ResponseV1 {
        let returnMe:Services.Team.Actions.AddMembers.ResponseV1 = builderResult
        return returnMe
      }
      public func mergeFrom(other:Services.Team.Actions.AddMembers.ResponseV1) throws -> Services.Team.Actions.AddMembers.ResponseV1.Builder {
        if other == Services.Team.Actions.AddMembers.ResponseV1() {
         return self
        }
        try mergeUnknownFields(other.unknownFields)
        return self
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream) throws -> Services.Team.Actions.AddMembers.ResponseV1.Builder {
           return try mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Team.Actions.AddMembers.ResponseV1.Builder {
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