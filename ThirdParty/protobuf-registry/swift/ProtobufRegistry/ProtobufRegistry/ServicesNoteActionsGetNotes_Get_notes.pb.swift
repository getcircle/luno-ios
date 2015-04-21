// Generated by the protocol buffer compiler.  DO NOT EDIT!

import Foundation
public extension Services.Note.Actions{ public struct GetNotes { }}

public func == (lhs: Services.Note.Actions.GetNotes.RequestV1, rhs: Services.Note.Actions.GetNotes.RequestV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasVersion == rhs.hasVersion) && (!lhs.hasVersion || lhs.version == rhs.version)
  fieldCheck = fieldCheck && (lhs.hasOwnerProfileId == rhs.hasOwnerProfileId) && (!lhs.hasOwnerProfileId || lhs.ownerProfileId == rhs.ownerProfileId)
  fieldCheck = fieldCheck && (lhs.hasForProfileId == rhs.hasForProfileId) && (!lhs.hasForProfileId || lhs.forProfileId == rhs.forProfileId)
  return (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
}

public func == (lhs: Services.Note.Actions.GetNotes.ResponseV1, rhs: Services.Note.Actions.GetNotes.ResponseV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasVersion == rhs.hasVersion) && (!lhs.hasVersion || lhs.version == rhs.version)
  fieldCheck = fieldCheck && (lhs.notes == rhs.notes)
  return (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
}

public extension Services.Note.Actions.GetNotes {
  public struct GetNotesRoot {
    public static var sharedInstance : GetNotesRoot {
     struct Static {
         static let instance : GetNotesRoot = GetNotesRoot()
     }
     return Static.instance
    }
    public var extensionRegistry:ExtensionRegistry

    init() {
      extensionRegistry = ExtensionRegistry()
      registerAllExtensions(extensionRegistry)
      Services.Note.Containers.ContainersRoot.sharedInstance.registerAllExtensions(extensionRegistry)
    }
    public func registerAllExtensions(registry:ExtensionRegistry) {
    }
  }

  final public class RequestV1 : GeneratedMessage, GeneratedMessageProtocol {
    override public subscript(key: String) -> Any? {
           switch key {
           case "version": return version
           case "ownerProfileId": return ownerProfileId
           case "forProfileId": return forProfileId
           default: return nil
           }
    }

    public private(set) var hasVersion:Bool = false
    public private(set) var version:UInt32 = UInt32(1)

    public private(set) var hasOwnerProfileId:Bool = false
    public private(set) var ownerProfileId:String = ""

    public private(set) var hasForProfileId:Bool = false
    public private(set) var forProfileId:String = ""

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
      if hasOwnerProfileId {
        output.writeString(2, value:ownerProfileId)
      }
      if hasForProfileId {
        output.writeString(3, value:forProfileId)
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
      if hasOwnerProfileId {
        serialize_size += ownerProfileId.computeStringSize(2)
      }
      if hasForProfileId {
        serialize_size += forProfileId.computeStringSize(3)
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseFromData(data:NSData) -> Services.Note.Actions.GetNotes.RequestV1 {
      return Services.Note.Actions.GetNotes.RequestV1.builder().mergeFromData(data, extensionRegistry:Services.Note.Actions.GetNotes.GetNotesRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) -> Services.Note.Actions.GetNotes.RequestV1 {
      return Services.Note.Actions.GetNotes.RequestV1.builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) -> Services.Note.Actions.GetNotes.RequestV1 {
      return Services.Note.Actions.GetNotes.RequestV1.builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) ->Services.Note.Actions.GetNotes.RequestV1 {
      return Services.Note.Actions.GetNotes.RequestV1.builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) -> Services.Note.Actions.GetNotes.RequestV1 {
      return Services.Note.Actions.GetNotes.RequestV1.builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.Note.Actions.GetNotes.RequestV1 {
      return Services.Note.Actions.GetNotes.RequestV1.builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func builder() -> Services.Note.Actions.GetNotes.RequestV1Builder {
      return Services.Note.Actions.GetNotes.RequestV1.classBuilder() as! Services.Note.Actions.GetNotes.RequestV1Builder
    }
    public func builder() -> Services.Note.Actions.GetNotes.RequestV1Builder {
      return classBuilder() as! Services.Note.Actions.GetNotes.RequestV1Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.Note.Actions.GetNotes.RequestV1Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.Note.Actions.GetNotes.RequestV1.builder()
    }
    public func toBuilder() -> Services.Note.Actions.GetNotes.RequestV1Builder {
      return Services.Note.Actions.GetNotes.RequestV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.Note.Actions.GetNotes.RequestV1) -> Services.Note.Actions.GetNotes.RequestV1Builder {
      return Services.Note.Actions.GetNotes.RequestV1.builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) {
      if hasVersion {
        output += "\(indent) version: \(version) \n"
      }
      if hasOwnerProfileId {
        output += "\(indent) ownerProfileId: \(ownerProfileId) \n"
      }
      if hasForProfileId {
        output += "\(indent) forProfileId: \(forProfileId) \n"
      }
      unknownFields.writeDescriptionTo(&output, indent:indent)
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            if hasVersion {
               hashCode = (hashCode &* 31) &+ version.hashValue
            }
            if hasOwnerProfileId {
               hashCode = (hashCode &* 31) &+ ownerProfileId.hashValue
            }
            if hasForProfileId {
               hashCode = (hashCode &* 31) &+ forProfileId.hashValue
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.Note.Actions.GetNotes.RequestV1"
    }
    override public func className() -> String {
        return "Services.Note.Actions.GetNotes.RequestV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.Note.Actions.GetNotes.RequestV1.self
    }
    //Meta information declaration end

  }

  final public class RequestV1Builder : GeneratedMessageBuilder {
    private var builderResult:Services.Note.Actions.GetNotes.RequestV1

    required override public init () {
       builderResult = Services.Note.Actions.GetNotes.RequestV1()
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
    public func setVersion(value:UInt32)-> Services.Note.Actions.GetNotes.RequestV1Builder {
      self.version = value
      return self
    }
    public func clearVersion() -> Services.Note.Actions.GetNotes.RequestV1Builder{
         builderResult.hasVersion = false
         builderResult.version = UInt32(1)
         return self
    }
    public var hasOwnerProfileId:Bool {
         get {
              return builderResult.hasOwnerProfileId
         }
    }
    public var ownerProfileId:String {
         get {
              return builderResult.ownerProfileId
         }
         set (value) {
             builderResult.hasOwnerProfileId = true
             builderResult.ownerProfileId = value
         }
    }
    public func setOwnerProfileId(value:String)-> Services.Note.Actions.GetNotes.RequestV1Builder {
      self.ownerProfileId = value
      return self
    }
    public func clearOwnerProfileId() -> Services.Note.Actions.GetNotes.RequestV1Builder{
         builderResult.hasOwnerProfileId = false
         builderResult.ownerProfileId = ""
         return self
    }
    public var hasForProfileId:Bool {
         get {
              return builderResult.hasForProfileId
         }
    }
    public var forProfileId:String {
         get {
              return builderResult.forProfileId
         }
         set (value) {
             builderResult.hasForProfileId = true
             builderResult.forProfileId = value
         }
    }
    public func setForProfileId(value:String)-> Services.Note.Actions.GetNotes.RequestV1Builder {
      self.forProfileId = value
      return self
    }
    public func clearForProfileId() -> Services.Note.Actions.GetNotes.RequestV1Builder{
         builderResult.hasForProfileId = false
         builderResult.forProfileId = ""
         return self
    }
    override public var internalGetResult:GeneratedMessage {
         get {
            return builderResult
         }
    }
    public override func clear() -> Services.Note.Actions.GetNotes.RequestV1Builder {
      builderResult = Services.Note.Actions.GetNotes.RequestV1()
      return self
    }
    public override func clone() -> Services.Note.Actions.GetNotes.RequestV1Builder {
      return Services.Note.Actions.GetNotes.RequestV1.builderWithPrototype(builderResult)
    }
    public override func build() -> Services.Note.Actions.GetNotes.RequestV1 {
         checkInitialized()
         return buildPartial()
    }
    public func buildPartial() -> Services.Note.Actions.GetNotes.RequestV1 {
      var returnMe:Services.Note.Actions.GetNotes.RequestV1 = builderResult
      return returnMe
    }
    public func mergeFrom(other:Services.Note.Actions.GetNotes.RequestV1) -> Services.Note.Actions.GetNotes.RequestV1Builder {
      if (other == Services.Note.Actions.GetNotes.RequestV1()) {
       return self
      }
      if other.hasVersion {
           version = other.version
      }
      if other.hasOwnerProfileId {
           ownerProfileId = other.ownerProfileId
      }
      if other.hasForProfileId {
           forProfileId = other.forProfileId
      }
      mergeUnknownFields(other.unknownFields)
      return self
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream) ->Services.Note.Actions.GetNotes.RequestV1Builder {
         return mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.Note.Actions.GetNotes.RequestV1Builder {
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
          ownerProfileId = input.readString()

        case 26 :
          forProfileId = input.readString()

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

    public private(set) var notes:Array<Services.Note.Containers.NoteV1>  = Array<Services.Note.Containers.NoteV1>()
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
      for oneElementnotes in notes {
          output.writeMessage(2, value:oneElementnotes)
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
      for oneElementnotes in notes {
          serialize_size += oneElementnotes.computeMessageSize(2)
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseFromData(data:NSData) -> Services.Note.Actions.GetNotes.ResponseV1 {
      return Services.Note.Actions.GetNotes.ResponseV1.builder().mergeFromData(data, extensionRegistry:Services.Note.Actions.GetNotes.GetNotesRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) -> Services.Note.Actions.GetNotes.ResponseV1 {
      return Services.Note.Actions.GetNotes.ResponseV1.builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) -> Services.Note.Actions.GetNotes.ResponseV1 {
      return Services.Note.Actions.GetNotes.ResponseV1.builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) ->Services.Note.Actions.GetNotes.ResponseV1 {
      return Services.Note.Actions.GetNotes.ResponseV1.builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) -> Services.Note.Actions.GetNotes.ResponseV1 {
      return Services.Note.Actions.GetNotes.ResponseV1.builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.Note.Actions.GetNotes.ResponseV1 {
      return Services.Note.Actions.GetNotes.ResponseV1.builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func builder() -> Services.Note.Actions.GetNotes.ResponseV1Builder {
      return Services.Note.Actions.GetNotes.ResponseV1.classBuilder() as! Services.Note.Actions.GetNotes.ResponseV1Builder
    }
    public func builder() -> Services.Note.Actions.GetNotes.ResponseV1Builder {
      return classBuilder() as! Services.Note.Actions.GetNotes.ResponseV1Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.Note.Actions.GetNotes.ResponseV1Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.Note.Actions.GetNotes.ResponseV1.builder()
    }
    public func toBuilder() -> Services.Note.Actions.GetNotes.ResponseV1Builder {
      return Services.Note.Actions.GetNotes.ResponseV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.Note.Actions.GetNotes.ResponseV1) -> Services.Note.Actions.GetNotes.ResponseV1Builder {
      return Services.Note.Actions.GetNotes.ResponseV1.builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) {
      if hasVersion {
        output += "\(indent) version: \(version) \n"
      }
      var notesElementIndex:Int = 0
      for oneElementnotes in notes {
          output += "\(indent) notes[\(notesElementIndex)] {\n"
          oneElementnotes.writeDescriptionTo(&output, indent:"\(indent)  ")
          output += "\(indent)}\n"
          notesElementIndex++
      }
      unknownFields.writeDescriptionTo(&output, indent:indent)
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            if hasVersion {
               hashCode = (hashCode &* 31) &+ version.hashValue
            }
            for oneElementnotes in notes {
                hashCode = (hashCode &* 31) &+ oneElementnotes.hashValue
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.Note.Actions.GetNotes.ResponseV1"
    }
    override public func className() -> String {
        return "Services.Note.Actions.GetNotes.ResponseV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.Note.Actions.GetNotes.ResponseV1.self
    }
    //Meta information declaration end

  }

  final public class ResponseV1Builder : GeneratedMessageBuilder {
    private var builderResult:Services.Note.Actions.GetNotes.ResponseV1

    required override public init () {
       builderResult = Services.Note.Actions.GetNotes.ResponseV1()
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
    public func setVersion(value:UInt32)-> Services.Note.Actions.GetNotes.ResponseV1Builder {
      self.version = value
      return self
    }
    public func clearVersion() -> Services.Note.Actions.GetNotes.ResponseV1Builder{
         builderResult.hasVersion = false
         builderResult.version = UInt32(1)
         return self
    }
    public var notes:Array<Services.Note.Containers.NoteV1> {
         get {
             return builderResult.notes
         }
         set (value) {
             builderResult.notes = value
         }
    }
    public func setNotes(value:Array<Services.Note.Containers.NoteV1>)-> Services.Note.Actions.GetNotes.ResponseV1Builder {
      self.notes = value
      return self
    }
    public func clearNotes() -> Services.Note.Actions.GetNotes.ResponseV1Builder {
      builderResult.notes.removeAll(keepCapacity: false)
      return self
    }
    override public var internalGetResult:GeneratedMessage {
         get {
            return builderResult
         }
    }
    public override func clear() -> Services.Note.Actions.GetNotes.ResponseV1Builder {
      builderResult = Services.Note.Actions.GetNotes.ResponseV1()
      return self
    }
    public override func clone() -> Services.Note.Actions.GetNotes.ResponseV1Builder {
      return Services.Note.Actions.GetNotes.ResponseV1.builderWithPrototype(builderResult)
    }
    public override func build() -> Services.Note.Actions.GetNotes.ResponseV1 {
         checkInitialized()
         return buildPartial()
    }
    public func buildPartial() -> Services.Note.Actions.GetNotes.ResponseV1 {
      var returnMe:Services.Note.Actions.GetNotes.ResponseV1 = builderResult
      return returnMe
    }
    public func mergeFrom(other:Services.Note.Actions.GetNotes.ResponseV1) -> Services.Note.Actions.GetNotes.ResponseV1Builder {
      if (other == Services.Note.Actions.GetNotes.ResponseV1()) {
       return self
      }
      if other.hasVersion {
           version = other.version
      }
      if !other.notes.isEmpty  {
         builderResult.notes += other.notes
      }
      mergeUnknownFields(other.unknownFields)
      return self
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream) ->Services.Note.Actions.GetNotes.ResponseV1Builder {
         return mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.Note.Actions.GetNotes.ResponseV1Builder {
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
          var subBuilder = Services.Note.Containers.NoteV1.builder()
          input.readMessage(subBuilder,extensionRegistry:extensionRegistry)
          notes += [subBuilder.buildPartial()]

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