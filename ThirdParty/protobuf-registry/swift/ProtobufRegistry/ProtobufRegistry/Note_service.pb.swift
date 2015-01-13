// Generated by the protocol buffer compiler.  DO NOT EDIT!

import Foundation

public struct NoteServiceRoot {
  public static var sharedInstance : NoteServiceRoot {
   struct Static {
       static let instance : NoteServiceRoot = NoteServiceRoot()
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

public func == (lhs: NoteService.Containers, rhs: NoteService.Containers) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  return (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
}

public func == (lhs: NoteService, rhs: NoteService) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  return (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
}

final public class NoteService : GeneratedMessage {


  //Nested type declaration start

    final public class Containers : GeneratedMessage {


      //Nested type declaration start

        final public class Note : GeneratedMessage {
          public subscript(key: String) -> AnyObject? {
                 switch key {
                 case "id": return id
                 case "for_user_id": return for_user_id
                 case "user_id": return user_id
                 case "content": return content
                 default: return nil
                 }
          }

          public private(set) var hasId:Bool = false
          public private(set) var id:String = ""

          public private(set) var hasForUserId:Bool = false
          public private(set) var for_user_id:String = ""

          public private(set) var hasUserId:Bool = false
          public private(set) var user_id:String = ""

          public private(set) var hasContent:Bool = false
          public private(set) var content:String = ""

          required public init() {
               super.init()
          }
          override public func isInitialized() -> Bool {
           return true
          }
          override public func writeToCodedOutputStream(output:CodedOutputStream) {
            if hasId {
              output.writeString(1, value:id)
            }
            if hasForUserId {
              output.writeString(2, value:for_user_id)
            }
            if hasUserId {
              output.writeString(3, value:user_id)
            }
            if hasContent {
              output.writeString(4, value:content)
            }
            unknownFields.writeToCodedOutputStream(output)
          }
          override public func serializedSize() -> Int32 {
            var size:Int32 = memoizedSerializedSize
            if size != -1 {
             return size
            }

            size = 0
            if hasId {
              size += WireFormat.computeStringSize(1, value:id)
            }
            if hasForUserId {
              size += WireFormat.computeStringSize(2, value:for_user_id)
            }
            if hasUserId {
              size += WireFormat.computeStringSize(3, value:user_id)
            }
            if hasContent {
              size += WireFormat.computeStringSize(4, value:content)
            }
            size += unknownFields.serializedSize()
            memoizedSerializedSize = size
            return size
          }
          public class func parseFromData(data:[Byte]) -> NoteService.Containers.Note {
            return NoteService.Containers.Note.builder().mergeFromData(data).build()
          }
          public class func parseFromData(data:[Byte], extensionRegistry:ExtensionRegistry) -> NoteService.Containers.Note {
            return NoteService.Containers.Note.builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
          }
          public class func parseFromInputStream(input:NSInputStream) -> NoteService.Containers.Note {
            return NoteService.Containers.Note.builder().mergeFromInputStream(input).build()
          }
          public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) ->NoteService.Containers.Note {
            return NoteService.Containers.Note.builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
          }
          public class func parseFromCodedInputStream(input:CodedInputStream) -> NoteService.Containers.Note {
            return NoteService.Containers.Note.builder().mergeFromCodedInputStream(input).build()
          }
          public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> NoteService.Containers.Note {
            return NoteService.Containers.Note.builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
          }
          public class func builder() -> NoteService.Containers.NoteBuilder {
            return NoteService.Containers.Note.classBuilder() as NoteService.Containers.NoteBuilder
          }
          public func builder() -> NoteService.Containers.NoteBuilder {
            return classBuilder() as NoteService.Containers.NoteBuilder
          }
          public override class func classBuilder() -> MessageBuilder {
            return NoteService.Containers.NoteBuilder()
          }
          public override func classBuilder() -> MessageBuilder {
            return NoteService.Containers.Note.builder()
          }
          public func toBuilder() -> NoteService.Containers.NoteBuilder {
            return NoteService.Containers.Note.builderWithPrototype(self)
          }
          public class func builderWithPrototype(prototype:NoteService.Containers.Note) -> NoteService.Containers.NoteBuilder {
            return NoteService.Containers.Note.builder().mergeFrom(prototype)
          }
          override public func writeDescriptionTo(inout output:String, indent:String) {
            if hasId {
              output += "\(indent) id: \(id) \n"
            }
            if hasForUserId {
              output += "\(indent) for_user_id: \(for_user_id) \n"
            }
            if hasUserId {
              output += "\(indent) user_id: \(user_id) \n"
            }
            if hasContent {
              output += "\(indent) content: \(content) \n"
            }
            unknownFields.writeDescriptionTo(&output, indent:indent)
          }
          override public var hashValue:Int {
              get {
                  var hashCode:Int = 7
                  if hasId {
                     hashCode = (hashCode &* 31) &+ id.hashValue
                  }
                  if hasForUserId {
                     hashCode = (hashCode &* 31) &+ for_user_id.hashValue
                  }
                  if hasUserId {
                     hashCode = (hashCode &* 31) &+ user_id.hashValue
                  }
                  if hasContent {
                     hashCode = (hashCode &* 31) &+ content.hashValue
                  }
                  hashCode = (hashCode &* 31) &+  unknownFields.hashValue
                  return hashCode
              }
          }


          //Meta information declaration start

          override public class func className() -> String {
              return "NoteService.Containers.Note"
          }
          override public func className() -> String {
              return "NoteService.Containers.Note"
          }
          override public func classMetaType() -> GeneratedMessage.Type {
              return NoteService.Containers.Note.self
          }


          //Meta information declaration end

        }

        final public class NoteBuilder : GeneratedMessageBuilder {
          private var builderResult:NoteService.Containers.Note

          required override public init () {
             builderResult = NoteService.Containers.Note()
             super.init()
          }
          public var hasId:Bool {
               get {
                    return builderResult.hasId
               }
          }
          public var id:String {
               get {
                    return builderResult.id
               }
               set (value) {
                   builderResult.hasId = true
                   builderResult.id = value
               }
          }
          public func clearId() -> NoteService.Containers.NoteBuilder{
               builderResult.hasId = false
               builderResult.id = ""
               return self
          }
          public var hasForUserId:Bool {
               get {
                    return builderResult.hasForUserId
               }
          }
          public var for_user_id:String {
               get {
                    return builderResult.for_user_id
               }
               set (value) {
                   builderResult.hasForUserId = true
                   builderResult.for_user_id = value
               }
          }
          public func clearForUserId() -> NoteService.Containers.NoteBuilder{
               builderResult.hasForUserId = false
               builderResult.for_user_id = ""
               return self
          }
          public var hasUserId:Bool {
               get {
                    return builderResult.hasUserId
               }
          }
          public var user_id:String {
               get {
                    return builderResult.user_id
               }
               set (value) {
                   builderResult.hasUserId = true
                   builderResult.user_id = value
               }
          }
          public func clearUserId() -> NoteService.Containers.NoteBuilder{
               builderResult.hasUserId = false
               builderResult.user_id = ""
               return self
          }
          public var hasContent:Bool {
               get {
                    return builderResult.hasContent
               }
          }
          public var content:String {
               get {
                    return builderResult.content
               }
               set (value) {
                   builderResult.hasContent = true
                   builderResult.content = value
               }
          }
          public func clearContent() -> NoteService.Containers.NoteBuilder{
               builderResult.hasContent = false
               builderResult.content = ""
               return self
          }
          override public var internalGetResult:GeneratedMessage {
               get {
                  return builderResult
               }
          }
          public override func clear() -> NoteService.Containers.NoteBuilder {
            builderResult = NoteService.Containers.Note()
            return self
          }
          public override func clone() -> NoteService.Containers.NoteBuilder {
            return NoteService.Containers.Note.builderWithPrototype(builderResult)
          }
          public override func build() -> NoteService.Containers.Note {
               checkInitialized()
               return buildPartial()
          }
          public func buildPartial() -> NoteService.Containers.Note {
            var returnMe:NoteService.Containers.Note = builderResult
            return returnMe
          }
          public func mergeFrom(other:NoteService.Containers.Note) -> NoteService.Containers.NoteBuilder {
            if other.hasId {
                 id = other.id
            }
            if other.hasForUserId {
                 for_user_id = other.for_user_id
            }
            if other.hasUserId {
                 user_id = other.user_id
            }
            if other.hasContent {
                 content = other.content
            }
            mergeUnknownFields(other.unknownFields)
            return self
          }
          public override func mergeFromCodedInputStream(input:CodedInputStream) ->NoteService.Containers.NoteBuilder {
               return mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
          }
          public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> NoteService.Containers.NoteBuilder {
            var unknownFieldsBuilder:UnknownFieldSetBuilder = UnknownFieldSet.builderWithUnknownFields(self.unknownFields)
            while (true) {
              var tag = input.readTag()
              switch tag {
              case 0: 
                self.unknownFields = unknownFieldsBuilder.build()
                return self

              case 10 :
                id = input.readString()

              case 18 :
                for_user_id = input.readString()

              case 26 :
                user_id = input.readString()

              case 34 :
                content = input.readString()

              default:
                if (!parseUnknownField(input,unknownFields:unknownFieldsBuilder, extensionRegistry:extensionRegistry, tag:tag)) {
                   unknownFields = unknownFieldsBuilder.build()
                   return self
                }
              }
            }
          }
        }



      //Nested type declaration end

      public subscript(key: String) -> AnyObject? {
             switch key {
             default: return nil
             }
      }

      required public init() {
           super.init()
      }
      override public func isInitialized() -> Bool {
       return true
      }
      override public func writeToCodedOutputStream(output:CodedOutputStream) {
        unknownFields.writeToCodedOutputStream(output)
      }
      override public func serializedSize() -> Int32 {
        var size:Int32 = memoizedSerializedSize
        if size != -1 {
         return size
        }

        size = 0
        size += unknownFields.serializedSize()
        memoizedSerializedSize = size
        return size
      }
      public class func parseFromData(data:[Byte]) -> NoteService.Containers {
        return NoteService.Containers.builder().mergeFromData(data).build()
      }
      public class func parseFromData(data:[Byte], extensionRegistry:ExtensionRegistry) -> NoteService.Containers {
        return NoteService.Containers.builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
      }
      public class func parseFromInputStream(input:NSInputStream) -> NoteService.Containers {
        return NoteService.Containers.builder().mergeFromInputStream(input).build()
      }
      public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) ->NoteService.Containers {
        return NoteService.Containers.builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
      }
      public class func parseFromCodedInputStream(input:CodedInputStream) -> NoteService.Containers {
        return NoteService.Containers.builder().mergeFromCodedInputStream(input).build()
      }
      public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> NoteService.Containers {
        return NoteService.Containers.builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
      }
      public class func builder() -> NoteService.ContainersBuilder {
        return NoteService.Containers.classBuilder() as NoteService.ContainersBuilder
      }
      public func builder() -> NoteService.ContainersBuilder {
        return classBuilder() as NoteService.ContainersBuilder
      }
      public override class func classBuilder() -> MessageBuilder {
        return NoteService.ContainersBuilder()
      }
      public override func classBuilder() -> MessageBuilder {
        return NoteService.Containers.builder()
      }
      public func toBuilder() -> NoteService.ContainersBuilder {
        return NoteService.Containers.builderWithPrototype(self)
      }
      public class func builderWithPrototype(prototype:NoteService.Containers) -> NoteService.ContainersBuilder {
        return NoteService.Containers.builder().mergeFrom(prototype)
      }
      override public func writeDescriptionTo(inout output:String, indent:String) {
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
          return "NoteService.Containers"
      }
      override public func className() -> String {
          return "NoteService.Containers"
      }
      override public func classMetaType() -> GeneratedMessage.Type {
          return NoteService.Containers.self
      }


      //Meta information declaration end

    }

    final public class ContainersBuilder : GeneratedMessageBuilder {
      private var builderResult:NoteService.Containers

      required override public init () {
         builderResult = NoteService.Containers()
         super.init()
      }
      override public var internalGetResult:GeneratedMessage {
           get {
              return builderResult
           }
      }
      public override func clear() -> NoteService.ContainersBuilder {
        builderResult = NoteService.Containers()
        return self
      }
      public override func clone() -> NoteService.ContainersBuilder {
        return NoteService.Containers.builderWithPrototype(builderResult)
      }
      public override func build() -> NoteService.Containers {
           checkInitialized()
           return buildPartial()
      }
      public func buildPartial() -> NoteService.Containers {
        var returnMe:NoteService.Containers = builderResult
        return returnMe
      }
      public func mergeFrom(other:NoteService.Containers) -> NoteService.ContainersBuilder {
        mergeUnknownFields(other.unknownFields)
        return self
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream) ->NoteService.ContainersBuilder {
           return mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> NoteService.ContainersBuilder {
        var unknownFieldsBuilder:UnknownFieldSetBuilder = UnknownFieldSet.builderWithUnknownFields(self.unknownFields)
        while (true) {
          var tag = input.readTag()
          switch tag {
          case 0: 
            self.unknownFields = unknownFieldsBuilder.build()
            return self

          default:
            if (!parseUnknownField(input,unknownFields:unknownFieldsBuilder, extensionRegistry:extensionRegistry, tag:tag)) {
               unknownFields = unknownFieldsBuilder.build()
               return self
            }
          }
        }
      }
    }



  //Nested type declaration end

  public subscript(key: String) -> AnyObject? {
         switch key {
         default: return nil
         }
  }

  required public init() {
       super.init()
  }
  override public func isInitialized() -> Bool {
   return true
  }
  override public func writeToCodedOutputStream(output:CodedOutputStream) {
    unknownFields.writeToCodedOutputStream(output)
  }
  override public func serializedSize() -> Int32 {
    var size:Int32 = memoizedSerializedSize
    if size != -1 {
     return size
    }

    size = 0
    size += unknownFields.serializedSize()
    memoizedSerializedSize = size
    return size
  }
  public class func parseFromData(data:[Byte]) -> NoteService {
    return NoteService.builder().mergeFromData(data).build()
  }
  public class func parseFromData(data:[Byte], extensionRegistry:ExtensionRegistry) -> NoteService {
    return NoteService.builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
  }
  public class func parseFromInputStream(input:NSInputStream) -> NoteService {
    return NoteService.builder().mergeFromInputStream(input).build()
  }
  public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) ->NoteService {
    return NoteService.builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
  }
  public class func parseFromCodedInputStream(input:CodedInputStream) -> NoteService {
    return NoteService.builder().mergeFromCodedInputStream(input).build()
  }
  public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> NoteService {
    return NoteService.builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
  }
  public class func builder() -> NoteServiceBuilder {
    return NoteService.classBuilder() as NoteServiceBuilder
  }
  public func builder() -> NoteServiceBuilder {
    return classBuilder() as NoteServiceBuilder
  }
  public override class func classBuilder() -> MessageBuilder {
    return NoteServiceBuilder()
  }
  public override func classBuilder() -> MessageBuilder {
    return NoteService.builder()
  }
  public func toBuilder() -> NoteServiceBuilder {
    return NoteService.builderWithPrototype(self)
  }
  public class func builderWithPrototype(prototype:NoteService) -> NoteServiceBuilder {
    return NoteService.builder().mergeFrom(prototype)
  }
  override public func writeDescriptionTo(inout output:String, indent:String) {
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
      return "NoteService"
  }
  override public func className() -> String {
      return "NoteService"
  }
  override public func classMetaType() -> GeneratedMessage.Type {
      return NoteService.self
  }


  //Meta information declaration end

}

final public class NoteServiceBuilder : GeneratedMessageBuilder {
  private var builderResult:NoteService

  required override public init () {
     builderResult = NoteService()
     super.init()
  }
  override public var internalGetResult:GeneratedMessage {
       get {
          return builderResult
       }
  }
  public override func clear() -> NoteServiceBuilder {
    builderResult = NoteService()
    return self
  }
  public override func clone() -> NoteServiceBuilder {
    return NoteService.builderWithPrototype(builderResult)
  }
  public override func build() -> NoteService {
       checkInitialized()
       return buildPartial()
  }
  public func buildPartial() -> NoteService {
    var returnMe:NoteService = builderResult
    return returnMe
  }
  public func mergeFrom(other:NoteService) -> NoteServiceBuilder {
    mergeUnknownFields(other.unknownFields)
    return self
  }
  public override func mergeFromCodedInputStream(input:CodedInputStream) ->NoteServiceBuilder {
       return mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
  }
  public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> NoteServiceBuilder {
    var unknownFieldsBuilder:UnknownFieldSetBuilder = UnknownFieldSet.builderWithUnknownFields(self.unknownFields)
    while (true) {
      var tag = input.readTag()
      switch tag {
      case 0: 
        self.unknownFields = unknownFieldsBuilder.build()
        return self

      default:
        if (!parseUnknownField(input,unknownFields:unknownFieldsBuilder, extensionRegistry:extensionRegistry, tag:tag)) {
           unknownFields = unknownFieldsBuilder.build()
           return self
        }
      }
    }
  }
}

//Class extensions: NSData


public extension NoteService.Containers.Note {
    class func parseFromNSData(data:NSData) -> NoteService.Containers.Note {
        var bytes = [Byte](count: data.length, repeatedValue: 0)
        data.getBytes(&bytes)
        return NoteService.Containers.Note.builder().mergeFromData(bytes).build()
    }
    class func parseFromNSData(data:NSData, extensionRegistry:ExtensionRegistry) -> NoteService.Containers.Note {
        var bytes = [Byte](count: data.length, repeatedValue: 0)
        data.getBytes(&bytes)
        return NoteService.Containers.Note.builder().mergeFromData(bytes, extensionRegistry:extensionRegistry).build()
    }
}
public extension NoteService.Containers {
    class func parseFromNSData(data:NSData) -> NoteService.Containers {
        var bytes = [Byte](count: data.length, repeatedValue: 0)
        data.getBytes(&bytes)
        return NoteService.Containers.builder().mergeFromData(bytes).build()
    }
    class func parseFromNSData(data:NSData, extensionRegistry:ExtensionRegistry) -> NoteService.Containers {
        var bytes = [Byte](count: data.length, repeatedValue: 0)
        data.getBytes(&bytes)
        return NoteService.Containers.builder().mergeFromData(bytes, extensionRegistry:extensionRegistry).build()
    }
}
public extension NoteService {
    class func parseFromNSData(data:NSData) -> NoteService {
        var bytes = [Byte](count: data.length, repeatedValue: 0)
        data.getBytes(&bytes)
        return NoteService.builder().mergeFromData(bytes).build()
    }
    class func parseFromNSData(data:NSData, extensionRegistry:ExtensionRegistry) -> NoteService {
        var bytes = [Byte](count: data.length, repeatedValue: 0)
        data.getBytes(&bytes)
        return NoteService.builder().mergeFromData(bytes, extensionRegistry:extensionRegistry).build()
    }
}

// @@protoc_insertion_point(global_scope)
