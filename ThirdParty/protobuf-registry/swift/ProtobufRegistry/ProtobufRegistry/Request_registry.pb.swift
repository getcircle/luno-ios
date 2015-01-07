// Generated by the protocol buffer compiler.  DO NOT EDIT!

import Foundation

public var UserServiceRequests_create_user:ConcreateExtensionField {
   get {
       return RequestRegistryRoot.sharedInstance.UserServiceRequests_create_userStatic
   }
}
public var UserServiceRequests_valid_user:ConcreateExtensionField {
   get {
       return RequestRegistryRoot.sharedInstance.UserServiceRequests_valid_userStatic
   }
}
public var UserServiceRequests_authenticate_user:ConcreateExtensionField {
   get {
       return RequestRegistryRoot.sharedInstance.UserServiceRequests_authenticate_userStatic
   }
}
public var OrganizationServiceRequests_create_organization:ConcreateExtensionField {
   get {
       return RequestRegistryRoot.sharedInstance.OrganizationServiceRequests_create_organizationStatic
   }
}
public var OrganizationServiceRequests_create_team:ConcreateExtensionField {
   get {
       return RequestRegistryRoot.sharedInstance.OrganizationServiceRequests_create_teamStatic
   }
}
public var OrganizationServiceRequests_create_address:ConcreateExtensionField {
   get {
       return RequestRegistryRoot.sharedInstance.OrganizationServiceRequests_create_addressStatic
   }
}
public var OrganizationServiceRequests_delete_address:ConcreateExtensionField {
   get {
       return RequestRegistryRoot.sharedInstance.OrganizationServiceRequests_delete_addressStatic
   }
}
public var OrganizationServiceRequests_get_address:ConcreateExtensionField {
   get {
       return RequestRegistryRoot.sharedInstance.OrganizationServiceRequests_get_addressStatic
   }
}
public var OrganizationServiceRequests_get_team:ConcreateExtensionField {
   get {
       return RequestRegistryRoot.sharedInstance.OrganizationServiceRequests_get_teamStatic
   }
}
public var OrganizationServiceRequests_get_organization:ConcreateExtensionField {
   get {
       return RequestRegistryRoot.sharedInstance.OrganizationServiceRequests_get_organizationStatic
   }
}
public var OrganizationServiceRequests_get_teams:ConcreateExtensionField {
   get {
       return RequestRegistryRoot.sharedInstance.OrganizationServiceRequests_get_teamsStatic
   }
}
public var OrganizationServiceRequests_get_addresses:ConcreateExtensionField {
   get {
       return RequestRegistryRoot.sharedInstance.OrganizationServiceRequests_get_addressesStatic
   }
}
public var ProfileServiceRequests_create_profile:ConcreateExtensionField {
   get {
       return RequestRegistryRoot.sharedInstance.ProfileServiceRequests_create_profileStatic
   }
}
public var ProfileServiceRequests_get_extended_profile:ConcreateExtensionField {
   get {
       return RequestRegistryRoot.sharedInstance.ProfileServiceRequests_get_extended_profileStatic
   }
}
public var ProfileServiceRequests_get_profile:ConcreateExtensionField {
   get {
       return RequestRegistryRoot.sharedInstance.ProfileServiceRequests_get_profileStatic
   }
}
public var ProfileServiceRequests_create_tags:ConcreateExtensionField {
   get {
       return RequestRegistryRoot.sharedInstance.ProfileServiceRequests_create_tagsStatic
   }
}
public var ProfileServiceRequests_get_tags:ConcreateExtensionField {
   get {
       return RequestRegistryRoot.sharedInstance.ProfileServiceRequests_get_tagsStatic
   }
}
public var ProfileServiceRequests_add_tags:ConcreateExtensionField {
   get {
       return RequestRegistryRoot.sharedInstance.ProfileServiceRequests_add_tagsStatic
   }
}
public var ProfileServiceRequests_update_profile:ConcreateExtensionField {
   get {
       return RequestRegistryRoot.sharedInstance.ProfileServiceRequests_update_profileStatic
   }
}
public var ProfileServiceRequests_get_profiles:ConcreateExtensionField {
   get {
       return RequestRegistryRoot.sharedInstance.ProfileServiceRequests_get_profilesStatic
   }
}
public struct RequestRegistryRoot {
  public static var sharedInstance : RequestRegistryRoot {
   struct Static {
       static let instance : RequestRegistryRoot = RequestRegistryRoot()
   }
   return Static.instance
  }
  var UserServiceRequests_create_userStatic:ConcreateExtensionField
  var UserServiceRequests_valid_userStatic:ConcreateExtensionField
  var UserServiceRequests_authenticate_userStatic:ConcreateExtensionField
  var OrganizationServiceRequests_create_organizationStatic:ConcreateExtensionField
  var OrganizationServiceRequests_create_teamStatic:ConcreateExtensionField
  var OrganizationServiceRequests_create_addressStatic:ConcreateExtensionField
  var OrganizationServiceRequests_delete_addressStatic:ConcreateExtensionField
  var OrganizationServiceRequests_get_addressStatic:ConcreateExtensionField
  var OrganizationServiceRequests_get_teamStatic:ConcreateExtensionField
  var OrganizationServiceRequests_get_organizationStatic:ConcreateExtensionField
  var OrganizationServiceRequests_get_teamsStatic:ConcreateExtensionField
  var OrganizationServiceRequests_get_addressesStatic:ConcreateExtensionField
  var ProfileServiceRequests_create_profileStatic:ConcreateExtensionField
  var ProfileServiceRequests_get_extended_profileStatic:ConcreateExtensionField
  var ProfileServiceRequests_get_profileStatic:ConcreateExtensionField
  var ProfileServiceRequests_create_tagsStatic:ConcreateExtensionField
  var ProfileServiceRequests_get_tagsStatic:ConcreateExtensionField
  var ProfileServiceRequests_add_tagsStatic:ConcreateExtensionField
  var ProfileServiceRequests_update_profileStatic:ConcreateExtensionField
  var ProfileServiceRequests_get_profilesStatic:ConcreateExtensionField
  public var extensionRegistry:ExtensionRegistry

  init() {
    UserServiceRequests_create_userStatic = ConcreateExtensionField(type:ExtensionType.ExtensionTypeMessage, extendedClass:ActionRequestParams.self, fieldNumber: 100, defaultValue:UserService.CreateUser.Request(), messageOrGroupClass:UserService.CreateUser.Request.self, isRepeated:false, isPacked:false, isMessageSetWireFormat:false)
    UserServiceRequests_valid_userStatic = ConcreateExtensionField(type:ExtensionType.ExtensionTypeMessage, extendedClass:ActionRequestParams.self, fieldNumber: 101, defaultValue:UserService.ValidUser.Request(), messageOrGroupClass:UserService.ValidUser.Request.self, isRepeated:false, isPacked:false, isMessageSetWireFormat:false)
    UserServiceRequests_authenticate_userStatic = ConcreateExtensionField(type:ExtensionType.ExtensionTypeMessage, extendedClass:ActionRequestParams.self, fieldNumber: 102, defaultValue:UserService.AuthenticateUser.Request(), messageOrGroupClass:UserService.AuthenticateUser.Request.self, isRepeated:false, isPacked:false, isMessageSetWireFormat:false)
    OrganizationServiceRequests_create_organizationStatic = ConcreateExtensionField(type:ExtensionType.ExtensionTypeMessage, extendedClass:ActionRequestParams.self, fieldNumber: 200, defaultValue:OrganizationService.CreateOrganization.Request(), messageOrGroupClass:OrganizationService.CreateOrganization.Request.self, isRepeated:false, isPacked:false, isMessageSetWireFormat:false)
    OrganizationServiceRequests_create_teamStatic = ConcreateExtensionField(type:ExtensionType.ExtensionTypeMessage, extendedClass:ActionRequestParams.self, fieldNumber: 201, defaultValue:OrganizationService.CreateTeam.Request(), messageOrGroupClass:OrganizationService.CreateTeam.Request.self, isRepeated:false, isPacked:false, isMessageSetWireFormat:false)
    OrganizationServiceRequests_create_addressStatic = ConcreateExtensionField(type:ExtensionType.ExtensionTypeMessage, extendedClass:ActionRequestParams.self, fieldNumber: 202, defaultValue:OrganizationService.CreateAddress.Request(), messageOrGroupClass:OrganizationService.CreateAddress.Request.self, isRepeated:false, isPacked:false, isMessageSetWireFormat:false)
    OrganizationServiceRequests_delete_addressStatic = ConcreateExtensionField(type:ExtensionType.ExtensionTypeMessage, extendedClass:ActionRequestParams.self, fieldNumber: 203, defaultValue:OrganizationService.DeleteAddress.Request(), messageOrGroupClass:OrganizationService.DeleteAddress.Request.self, isRepeated:false, isPacked:false, isMessageSetWireFormat:false)
    OrganizationServiceRequests_get_addressStatic = ConcreateExtensionField(type:ExtensionType.ExtensionTypeMessage, extendedClass:ActionRequestParams.self, fieldNumber: 204, defaultValue:OrganizationService.GetAddress.Request(), messageOrGroupClass:OrganizationService.GetAddress.Request.self, isRepeated:false, isPacked:false, isMessageSetWireFormat:false)
    OrganizationServiceRequests_get_teamStatic = ConcreateExtensionField(type:ExtensionType.ExtensionTypeMessage, extendedClass:ActionRequestParams.self, fieldNumber: 205, defaultValue:OrganizationService.GetTeam.Request(), messageOrGroupClass:OrganizationService.GetTeam.Request.self, isRepeated:false, isPacked:false, isMessageSetWireFormat:false)
    OrganizationServiceRequests_get_organizationStatic = ConcreateExtensionField(type:ExtensionType.ExtensionTypeMessage, extendedClass:ActionRequestParams.self, fieldNumber: 206, defaultValue:OrganizationService.GetOrganization.Request(), messageOrGroupClass:OrganizationService.GetOrganization.Request.self, isRepeated:false, isPacked:false, isMessageSetWireFormat:false)
    OrganizationServiceRequests_get_teamsStatic = ConcreateExtensionField(type:ExtensionType.ExtensionTypeMessage, extendedClass:ActionRequestParams.self, fieldNumber: 207, defaultValue:OrganizationService.GetTeams.Request(), messageOrGroupClass:OrganizationService.GetTeams.Request.self, isRepeated:false, isPacked:false, isMessageSetWireFormat:false)
    OrganizationServiceRequests_get_addressesStatic = ConcreateExtensionField(type:ExtensionType.ExtensionTypeMessage, extendedClass:ActionRequestParams.self, fieldNumber: 208, defaultValue:OrganizationService.GetAddresses.Request(), messageOrGroupClass:OrganizationService.GetAddresses.Request.self, isRepeated:false, isPacked:false, isMessageSetWireFormat:false)
    ProfileServiceRequests_create_profileStatic = ConcreateExtensionField(type:ExtensionType.ExtensionTypeMessage, extendedClass:ActionRequestParams.self, fieldNumber: 300, defaultValue:ProfileService.CreateProfile.Request(), messageOrGroupClass:ProfileService.CreateProfile.Request.self, isRepeated:false, isPacked:false, isMessageSetWireFormat:false)
    ProfileServiceRequests_get_extended_profileStatic = ConcreateExtensionField(type:ExtensionType.ExtensionTypeMessage, extendedClass:ActionRequestParams.self, fieldNumber: 301, defaultValue:ProfileService.GetExtendedProfile.Request(), messageOrGroupClass:ProfileService.GetExtendedProfile.Request.self, isRepeated:false, isPacked:false, isMessageSetWireFormat:false)
    ProfileServiceRequests_get_profileStatic = ConcreateExtensionField(type:ExtensionType.ExtensionTypeMessage, extendedClass:ActionRequestParams.self, fieldNumber: 302, defaultValue:ProfileService.GetProfile.Request(), messageOrGroupClass:ProfileService.GetProfile.Request.self, isRepeated:false, isPacked:false, isMessageSetWireFormat:false)
    ProfileServiceRequests_create_tagsStatic = ConcreateExtensionField(type:ExtensionType.ExtensionTypeMessage, extendedClass:ActionRequestParams.self, fieldNumber: 303, defaultValue:ProfileService.CreateTags.Request(), messageOrGroupClass:ProfileService.CreateTags.Request.self, isRepeated:false, isPacked:false, isMessageSetWireFormat:false)
    ProfileServiceRequests_get_tagsStatic = ConcreateExtensionField(type:ExtensionType.ExtensionTypeMessage, extendedClass:ActionRequestParams.self, fieldNumber: 304, defaultValue:ProfileService.GetTags.Request(), messageOrGroupClass:ProfileService.GetTags.Request.self, isRepeated:false, isPacked:false, isMessageSetWireFormat:false)
    ProfileServiceRequests_add_tagsStatic = ConcreateExtensionField(type:ExtensionType.ExtensionTypeMessage, extendedClass:ActionRequestParams.self, fieldNumber: 305, defaultValue:ProfileService.AddTags.Request(), messageOrGroupClass:ProfileService.AddTags.Request.self, isRepeated:false, isPacked:false, isMessageSetWireFormat:false)
    ProfileServiceRequests_update_profileStatic = ConcreateExtensionField(type:ExtensionType.ExtensionTypeMessage, extendedClass:ActionRequestParams.self, fieldNumber: 306, defaultValue:ProfileService.UpdateProfile.Request(), messageOrGroupClass:ProfileService.UpdateProfile.Request.self, isRepeated:false, isPacked:false, isMessageSetWireFormat:false)
    ProfileServiceRequests_get_profilesStatic = ConcreateExtensionField(type:ExtensionType.ExtensionTypeMessage, extendedClass:ActionRequestParams.self, fieldNumber: 307, defaultValue:ProfileService.GetProfiles.Request(), messageOrGroupClass:ProfileService.GetProfiles.Request.self, isRepeated:false, isPacked:false, isMessageSetWireFormat:false)
    extensionRegistry = ExtensionRegistry()
    registerAllExtensions(extensionRegistry)
    SoaRoot.sharedInstance.registerAllExtensions(extensionRegistry)
    OrganizationServiceRoot.sharedInstance.registerAllExtensions(extensionRegistry)
    ProfileServiceRoot.sharedInstance.registerAllExtensions(extensionRegistry)
    UserServiceRoot.sharedInstance.registerAllExtensions(extensionRegistry)
  }
  public func registerAllExtensions(registry:ExtensionRegistry) {
    registry.addExtension(UserServiceRequests_create_userStatic)
    registry.addExtension(UserServiceRequests_valid_userStatic)
    registry.addExtension(UserServiceRequests_authenticate_userStatic)
    registry.addExtension(OrganizationServiceRequests_create_organizationStatic)
    registry.addExtension(OrganizationServiceRequests_create_teamStatic)
    registry.addExtension(OrganizationServiceRequests_create_addressStatic)
    registry.addExtension(OrganizationServiceRequests_delete_addressStatic)
    registry.addExtension(OrganizationServiceRequests_get_addressStatic)
    registry.addExtension(OrganizationServiceRequests_get_teamStatic)
    registry.addExtension(OrganizationServiceRequests_get_organizationStatic)
    registry.addExtension(OrganizationServiceRequests_get_teamsStatic)
    registry.addExtension(OrganizationServiceRequests_get_addressesStatic)
    registry.addExtension(ProfileServiceRequests_create_profileStatic)
    registry.addExtension(ProfileServiceRequests_get_extended_profileStatic)
    registry.addExtension(ProfileServiceRequests_get_profileStatic)
    registry.addExtension(ProfileServiceRequests_create_tagsStatic)
    registry.addExtension(ProfileServiceRequests_get_tagsStatic)
    registry.addExtension(ProfileServiceRequests_add_tagsStatic)
    registry.addExtension(ProfileServiceRequests_update_profileStatic)
    registry.addExtension(ProfileServiceRequests_get_profilesStatic)
  }
}

public func == (lhs: UserServiceRequests, rhs: UserServiceRequests) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  return (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
}

public func == (lhs: OrganizationServiceRequests, rhs: OrganizationServiceRequests) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  return (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
}

public func == (lhs: ProfileServiceRequests, rhs: ProfileServiceRequests) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  return (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
}

final public class UserServiceRequests : GeneratedMessage {
  public subscript(key: String) -> AnyObject? {
         switch key {
         default: return nil
         }
  }

  public class func create_user() -> ConcreateExtensionField {
       return UserServiceRequests_create_user
  }
  public class func valid_user() -> ConcreateExtensionField {
       return UserServiceRequests_valid_user
  }
  public class func authenticate_user() -> ConcreateExtensionField {
       return UserServiceRequests_authenticate_user
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
  public class func parseFromData(data:[Byte]) -> UserServiceRequests {
    return UserServiceRequests.builder().mergeFromData(data).build()
  }
  public class func parseFromData(data:[Byte], extensionRegistry:ExtensionRegistry) -> UserServiceRequests {
    return UserServiceRequests.builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
  }
  public class func parseFromInputStream(input:NSInputStream) -> UserServiceRequests {
    return UserServiceRequests.builder().mergeFromInputStream(input).build()
  }
  public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) ->UserServiceRequests {
    return UserServiceRequests.builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
  }
  public class func parseFromCodedInputStream(input:CodedInputStream) -> UserServiceRequests {
    return UserServiceRequests.builder().mergeFromCodedInputStream(input).build()
  }
  public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> UserServiceRequests {
    return UserServiceRequests.builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
  }
  public class func builder() -> UserServiceRequestsBuilder {
    return UserServiceRequests.classBuilder() as UserServiceRequestsBuilder
  }
  public func builder() -> UserServiceRequestsBuilder {
    return classBuilder() as UserServiceRequestsBuilder
  }
  public override class func classBuilder() -> MessageBuilder {
    return UserServiceRequestsBuilder()
  }
  public override func classBuilder() -> MessageBuilder {
    return UserServiceRequests.builder()
  }
  public func toBuilder() -> UserServiceRequestsBuilder {
    return UserServiceRequests.builderWithPrototype(self)
  }
  public class func builderWithPrototype(prototype:UserServiceRequests) -> UserServiceRequestsBuilder {
    return UserServiceRequests.builder().mergeFrom(prototype)
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
      return "UserServiceRequests"
  }
  override public func className() -> String {
      return "UserServiceRequests"
  }
  override public func classMetaType() -> GeneratedMessage.Type {
      return UserServiceRequests.self
  }


  //Meta information declaration end

}

final public class UserServiceRequestsBuilder : GeneratedMessageBuilder {
  private var builderResult:UserServiceRequests

  required override public init () {
     builderResult = UserServiceRequests()
     super.init()
  }
  override public var internalGetResult:GeneratedMessage {
       get {
          return builderResult
       }
  }
  public override func clear() -> UserServiceRequestsBuilder {
    builderResult = UserServiceRequests()
    return self
  }
  public override func clone() -> UserServiceRequestsBuilder {
    return UserServiceRequests.builderWithPrototype(builderResult)
  }
  public override func build() -> UserServiceRequests {
       checkInitialized()
       return buildPartial()
  }
  public func buildPartial() -> UserServiceRequests {
    var returnMe:UserServiceRequests = builderResult
    return returnMe
  }
  public func mergeFrom(other:UserServiceRequests) -> UserServiceRequestsBuilder {
    if (other == UserServiceRequests()) {
     return self
    }
    mergeUnknownFields(other.unknownFields)
    return self
  }
  public override func mergeFromCodedInputStream(input:CodedInputStream) ->UserServiceRequestsBuilder {
       return mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
  }
  public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> UserServiceRequestsBuilder {
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

final public class OrganizationServiceRequests : GeneratedMessage {
  public subscript(key: String) -> AnyObject? {
         switch key {
         default: return nil
         }
  }

  public class func create_organization() -> ConcreateExtensionField {
       return OrganizationServiceRequests_create_organization
  }
  public class func create_team() -> ConcreateExtensionField {
       return OrganizationServiceRequests_create_team
  }
  public class func create_address() -> ConcreateExtensionField {
       return OrganizationServiceRequests_create_address
  }
  public class func delete_address() -> ConcreateExtensionField {
       return OrganizationServiceRequests_delete_address
  }
  public class func get_address() -> ConcreateExtensionField {
       return OrganizationServiceRequests_get_address
  }
  public class func get_team() -> ConcreateExtensionField {
       return OrganizationServiceRequests_get_team
  }
  public class func get_organization() -> ConcreateExtensionField {
       return OrganizationServiceRequests_get_organization
  }
  public class func get_teams() -> ConcreateExtensionField {
       return OrganizationServiceRequests_get_teams
  }
  public class func get_addresses() -> ConcreateExtensionField {
       return OrganizationServiceRequests_get_addresses
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
  public class func parseFromData(data:[Byte]) -> OrganizationServiceRequests {
    return OrganizationServiceRequests.builder().mergeFromData(data).build()
  }
  public class func parseFromData(data:[Byte], extensionRegistry:ExtensionRegistry) -> OrganizationServiceRequests {
    return OrganizationServiceRequests.builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
  }
  public class func parseFromInputStream(input:NSInputStream) -> OrganizationServiceRequests {
    return OrganizationServiceRequests.builder().mergeFromInputStream(input).build()
  }
  public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) ->OrganizationServiceRequests {
    return OrganizationServiceRequests.builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
  }
  public class func parseFromCodedInputStream(input:CodedInputStream) -> OrganizationServiceRequests {
    return OrganizationServiceRequests.builder().mergeFromCodedInputStream(input).build()
  }
  public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> OrganizationServiceRequests {
    return OrganizationServiceRequests.builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
  }
  public class func builder() -> OrganizationServiceRequestsBuilder {
    return OrganizationServiceRequests.classBuilder() as OrganizationServiceRequestsBuilder
  }
  public func builder() -> OrganizationServiceRequestsBuilder {
    return classBuilder() as OrganizationServiceRequestsBuilder
  }
  public override class func classBuilder() -> MessageBuilder {
    return OrganizationServiceRequestsBuilder()
  }
  public override func classBuilder() -> MessageBuilder {
    return OrganizationServiceRequests.builder()
  }
  public func toBuilder() -> OrganizationServiceRequestsBuilder {
    return OrganizationServiceRequests.builderWithPrototype(self)
  }
  public class func builderWithPrototype(prototype:OrganizationServiceRequests) -> OrganizationServiceRequestsBuilder {
    return OrganizationServiceRequests.builder().mergeFrom(prototype)
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
      return "OrganizationServiceRequests"
  }
  override public func className() -> String {
      return "OrganizationServiceRequests"
  }
  override public func classMetaType() -> GeneratedMessage.Type {
      return OrganizationServiceRequests.self
  }


  //Meta information declaration end

}

final public class OrganizationServiceRequestsBuilder : GeneratedMessageBuilder {
  private var builderResult:OrganizationServiceRequests

  required override public init () {
     builderResult = OrganizationServiceRequests()
     super.init()
  }
  override public var internalGetResult:GeneratedMessage {
       get {
          return builderResult
       }
  }
  public override func clear() -> OrganizationServiceRequestsBuilder {
    builderResult = OrganizationServiceRequests()
    return self
  }
  public override func clone() -> OrganizationServiceRequestsBuilder {
    return OrganizationServiceRequests.builderWithPrototype(builderResult)
  }
  public override func build() -> OrganizationServiceRequests {
       checkInitialized()
       return buildPartial()
  }
  public func buildPartial() -> OrganizationServiceRequests {
    var returnMe:OrganizationServiceRequests = builderResult
    return returnMe
  }
  public func mergeFrom(other:OrganizationServiceRequests) -> OrganizationServiceRequestsBuilder {
    if (other == OrganizationServiceRequests()) {
     return self
    }
    mergeUnknownFields(other.unknownFields)
    return self
  }
  public override func mergeFromCodedInputStream(input:CodedInputStream) ->OrganizationServiceRequestsBuilder {
       return mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
  }
  public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> OrganizationServiceRequestsBuilder {
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

final public class ProfileServiceRequests : GeneratedMessage {
  public subscript(key: String) -> AnyObject? {
         switch key {
         default: return nil
         }
  }

  public class func create_profile() -> ConcreateExtensionField {
       return ProfileServiceRequests_create_profile
  }
  public class func get_extended_profile() -> ConcreateExtensionField {
       return ProfileServiceRequests_get_extended_profile
  }
  public class func get_profile() -> ConcreateExtensionField {
       return ProfileServiceRequests_get_profile
  }
  public class func create_tags() -> ConcreateExtensionField {
       return ProfileServiceRequests_create_tags
  }
  public class func get_tags() -> ConcreateExtensionField {
       return ProfileServiceRequests_get_tags
  }
  public class func add_tags() -> ConcreateExtensionField {
       return ProfileServiceRequests_add_tags
  }
  public class func update_profile() -> ConcreateExtensionField {
       return ProfileServiceRequests_update_profile
  }
  public class func get_profiles() -> ConcreateExtensionField {
       return ProfileServiceRequests_get_profiles
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
  public class func parseFromData(data:[Byte]) -> ProfileServiceRequests {
    return ProfileServiceRequests.builder().mergeFromData(data).build()
  }
  public class func parseFromData(data:[Byte], extensionRegistry:ExtensionRegistry) -> ProfileServiceRequests {
    return ProfileServiceRequests.builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
  }
  public class func parseFromInputStream(input:NSInputStream) -> ProfileServiceRequests {
    return ProfileServiceRequests.builder().mergeFromInputStream(input).build()
  }
  public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) ->ProfileServiceRequests {
    return ProfileServiceRequests.builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
  }
  public class func parseFromCodedInputStream(input:CodedInputStream) -> ProfileServiceRequests {
    return ProfileServiceRequests.builder().mergeFromCodedInputStream(input).build()
  }
  public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> ProfileServiceRequests {
    return ProfileServiceRequests.builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
  }
  public class func builder() -> ProfileServiceRequestsBuilder {
    return ProfileServiceRequests.classBuilder() as ProfileServiceRequestsBuilder
  }
  public func builder() -> ProfileServiceRequestsBuilder {
    return classBuilder() as ProfileServiceRequestsBuilder
  }
  public override class func classBuilder() -> MessageBuilder {
    return ProfileServiceRequestsBuilder()
  }
  public override func classBuilder() -> MessageBuilder {
    return ProfileServiceRequests.builder()
  }
  public func toBuilder() -> ProfileServiceRequestsBuilder {
    return ProfileServiceRequests.builderWithPrototype(self)
  }
  public class func builderWithPrototype(prototype:ProfileServiceRequests) -> ProfileServiceRequestsBuilder {
    return ProfileServiceRequests.builder().mergeFrom(prototype)
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
      return "ProfileServiceRequests"
  }
  override public func className() -> String {
      return "ProfileServiceRequests"
  }
  override public func classMetaType() -> GeneratedMessage.Type {
      return ProfileServiceRequests.self
  }


  //Meta information declaration end

}

final public class ProfileServiceRequestsBuilder : GeneratedMessageBuilder {
  private var builderResult:ProfileServiceRequests

  required override public init () {
     builderResult = ProfileServiceRequests()
     super.init()
  }
  override public var internalGetResult:GeneratedMessage {
       get {
          return builderResult
       }
  }
  public override func clear() -> ProfileServiceRequestsBuilder {
    builderResult = ProfileServiceRequests()
    return self
  }
  public override func clone() -> ProfileServiceRequestsBuilder {
    return ProfileServiceRequests.builderWithPrototype(builderResult)
  }
  public override func build() -> ProfileServiceRequests {
       checkInitialized()
       return buildPartial()
  }
  public func buildPartial() -> ProfileServiceRequests {
    var returnMe:ProfileServiceRequests = builderResult
    return returnMe
  }
  public func mergeFrom(other:ProfileServiceRequests) -> ProfileServiceRequestsBuilder {
    if (other == ProfileServiceRequests()) {
     return self
    }
    mergeUnknownFields(other.unknownFields)
    return self
  }
  public override func mergeFromCodedInputStream(input:CodedInputStream) ->ProfileServiceRequestsBuilder {
       return mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
  }
  public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> ProfileServiceRequestsBuilder {
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


public extension UserServiceRequests {
    class func parseFromNSData(data:NSData) -> UserServiceRequests {
        var bytes = [Byte](count: data.length, repeatedValue: 0)
        data.getBytes(&bytes)
        return UserServiceRequests.builder().mergeFromData(bytes).build()
    }
    class func parseFromNSData(data:NSData, extensionRegistry:ExtensionRegistry) -> UserServiceRequests {
        var bytes = [Byte](count: data.length, repeatedValue: 0)
        data.getBytes(&bytes)
        return UserServiceRequests.builder().mergeFromData(bytes, extensionRegistry:extensionRegistry).build()
    }
}
public extension OrganizationServiceRequests {
    class func parseFromNSData(data:NSData) -> OrganizationServiceRequests {
        var bytes = [Byte](count: data.length, repeatedValue: 0)
        data.getBytes(&bytes)
        return OrganizationServiceRequests.builder().mergeFromData(bytes).build()
    }
    class func parseFromNSData(data:NSData, extensionRegistry:ExtensionRegistry) -> OrganizationServiceRequests {
        var bytes = [Byte](count: data.length, repeatedValue: 0)
        data.getBytes(&bytes)
        return OrganizationServiceRequests.builder().mergeFromData(bytes, extensionRegistry:extensionRegistry).build()
    }
}
public extension ProfileServiceRequests {
    class func parseFromNSData(data:NSData) -> ProfileServiceRequests {
        var bytes = [Byte](count: data.length, repeatedValue: 0)
        data.getBytes(&bytes)
        return ProfileServiceRequests.builder().mergeFromData(bytes).build()
    }
    class func parseFromNSData(data:NSData, extensionRegistry:ExtensionRegistry) -> ProfileServiceRequests {
        var bytes = [Byte](count: data.length, repeatedValue: 0)
        data.getBytes(&bytes)
        return ProfileServiceRequests.builder().mergeFromData(bytes, extensionRegistry:extensionRegistry).build()
    }
}

// @@protoc_insertion_point(global_scope)
