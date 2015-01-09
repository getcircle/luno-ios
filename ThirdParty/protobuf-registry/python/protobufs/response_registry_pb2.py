# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: protobufs/response_registry.proto

import sys
_b=sys.version_info[0]<3 and (lambda x:x) or (lambda x:x.encode('latin1'))
from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import symbol_database as _symbol_database
from google.protobuf import descriptor_pb2
# @@protoc_insertion_point(imports)

_sym_db = _symbol_database.Default()


import service_protobufs.soa_pb2
import protobufs.landing_service_pb2
import protobufs.organization_service_pb2
import protobufs.profile_service_pb2
import protobufs.search_service_pb2
import protobufs.user_service_pb2


DESCRIPTOR = _descriptor.FileDescriptor(
  name='protobufs/response_registry.proto',
  package='main.responses',
  serialized_pb=_b('\n!protobufs/response_registry.proto\x12\x0emain.responses\x1a\x1bservice_protobufs/soa.proto\x1a\x1fprotobufs/landing_service.proto\x1a$protobufs/organization_service.proto\x1a\x1fprotobufs/profile_service.proto\x1a\x1eprotobufs/search_service.proto\x1a\x1cprotobufs/user_service.proto\"\xaa\x03\n\x14UserServiceResponses2b\n\x0b\x63reate_user\x12\x19.soa.ActionResponseResult\x18\x64 \x01(\x0b\x32\x32.main.user_service.UserService.CreateUser.Response2`\n\nvalid_user\x12\x19.soa.ActionResponseResult\x18\x65 \x01(\x0b\x32\x31.main.user_service.UserService.ValidUser.Response2n\n\x11\x61uthenticate_user\x12\x19.soa.ActionResponseResult\x18\x66 \x01(\x0b\x32\x38.main.user_service.UserService.AuthenticateUser.Response2\\\n\x08get_user\x12\x19.soa.ActionResponseResult\x18g \x01(\x0b\x32/.main.user_service.UserService.GetUser.Response\"\xdc\t\n\x1cOrganizationServiceResponses2\x83\x01\n\x13\x63reate_organization\x12\x19.soa.ActionResponseResult\x18\xc8\x01 \x01(\x0b\x32J.main.organization_service.OrganizationService.CreateOrganization.Response2s\n\x0b\x63reate_team\x12\x19.soa.ActionResponseResult\x18\xc9\x01 \x01(\x0b\x32\x42.main.organization_service.OrganizationService.CreateTeam.Response2y\n\x0e\x63reate_address\x12\x19.soa.ActionResponseResult\x18\xca\x01 \x01(\x0b\x32\x45.main.organization_service.OrganizationService.CreateAddress.Response2y\n\x0e\x64\x65lete_address\x12\x19.soa.ActionResponseResult\x18\xcb\x01 \x01(\x0b\x32\x45.main.organization_service.OrganizationService.DeleteAddress.Response2s\n\x0bget_address\x12\x19.soa.ActionResponseResult\x18\xcc\x01 \x01(\x0b\x32\x42.main.organization_service.OrganizationService.GetAddress.Response2m\n\x08get_team\x12\x19.soa.ActionResponseResult\x18\xcd\x01 \x01(\x0b\x32?.main.organization_service.OrganizationService.GetTeam.Response2}\n\x10get_organization\x12\x19.soa.ActionResponseResult\x18\xce\x01 \x01(\x0b\x32G.main.organization_service.OrganizationService.GetOrganization.Response2o\n\tget_teams\x12\x19.soa.ActionResponseResult\x18\xcf\x01 \x01(\x0b\x32@.main.organization_service.OrganizationService.GetTeams.Response2w\n\rget_addresses\x12\x19.soa.ActionResponseResult\x18\xd0\x01 \x01(\x0b\x32\x44.main.organization_service.OrganizationService.GetAddresses.Response2~\n\x11get_team_children\x12\x19.soa.ActionResponseResult\x18\xd1\x01 \x01(\x0b\x32G.main.organization_service.OrganizationService.GetTeamChildren.Response\"\xe2\n\n\x17ProfileServiceResponses2o\n\x0e\x63reate_profile\x12\x19.soa.ActionResponseResult\x18\xac\x02 \x01(\x0b\x32;.main.profile_service.ProfileService.CreateProfile.Response2z\n\x14get_extended_profile\x12\x19.soa.ActionResponseResult\x18\xad\x02 \x01(\x0b\x32@.main.profile_service.ProfileService.GetExtendedProfile.Response2i\n\x0bget_profile\x12\x19.soa.ActionResponseResult\x18\xae\x02 \x01(\x0b\x32\x38.main.profile_service.ProfileService.GetProfile.Response2i\n\x0b\x63reate_tags\x12\x19.soa.ActionResponseResult\x18\xaf\x02 \x01(\x0b\x32\x38.main.profile_service.ProfileService.CreateTags.Response2c\n\x08get_tags\x12\x19.soa.ActionResponseResult\x18\xb0\x02 \x01(\x0b\x32\x35.main.profile_service.ProfileService.GetTags.Response2c\n\x08\x61\x64\x64_tags\x12\x19.soa.ActionResponseResult\x18\xb1\x02 \x01(\x0b\x32\x35.main.profile_service.ProfileService.AddTags.Response2o\n\x0eupdate_profile\x12\x19.soa.ActionResponseResult\x18\xb2\x02 \x01(\x0b\x32;.main.profile_service.ProfileService.UpdateProfile.Response2k\n\x0cget_profiles\x12\x19.soa.ActionResponseResult\x18\xb3\x02 \x01(\x0b\x32\x39.main.profile_service.ProfileService.GetProfiles.Response2v\n\x12get_direct_reports\x12\x19.soa.ActionResponseResult\x18\xb4\x02 \x01(\x0b\x32>.main.profile_service.ProfileService.GetDirectReports.Response2e\n\tget_peers\x12\x19.soa.ActionResponseResult\x18\xb5\x02 \x01(\x0b\x32\x36.main.profile_service.ProfileService.GetPeers.Response2t\n\x11get_profile_stats\x12\x19.soa.ActionResponseResult\x18\xb6\x02 \x01(\x0b\x32=.main.profile_service.ProfileService.GetProfileStats.Response2\x86\x01\n\x1aget_upcoming_anniversaries\x12\x19.soa.ActionResponseResult\x18\xb7\x02 \x01(\x0b\x32\x46.main.profile_service.ProfileService.GetUpcomingAnniversaries.Response\"x\n\x16SearchServiceResponses2^\n\x06search\x12\x19.soa.ActionResponseResult\x18\x90\x03 \x01(\x0b\x32\x32.main.search_service.SearchService.Search.Response\"\x8a\x01\n\x17LandingServiceResponses2o\n\x0eget_categories\x12\x19.soa.ActionResponseResult\x18\xf4\x03 \x01(\x0b\x32;.main.landing_service.LandingService.GetCategories.Response')
  ,
  dependencies=[service_protobufs.soa_pb2.DESCRIPTOR,protobufs.landing_service_pb2.DESCRIPTOR,protobufs.organization_service_pb2.DESCRIPTOR,protobufs.profile_service_pb2.DESCRIPTOR,protobufs.search_service_pb2.DESCRIPTOR,protobufs.user_service_pb2.DESCRIPTOR,])
_sym_db.RegisterFileDescriptor(DESCRIPTOR)




_USERSERVICERESPONSES = _descriptor.Descriptor(
  name='UserServiceResponses',
  full_name='main.responses.UserServiceResponses',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
  ],
  extensions=[
    _descriptor.FieldDescriptor(
      name='create_user', full_name='main.responses.UserServiceResponses.create_user', index=0,
      number=100, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=True, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='valid_user', full_name='main.responses.UserServiceResponses.valid_user', index=1,
      number=101, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=True, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='authenticate_user', full_name='main.responses.UserServiceResponses.authenticate_user', index=2,
      number=102, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=True, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='get_user', full_name='main.responses.UserServiceResponses.get_user', index=3,
      number=103, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=True, extension_scope=None,
      options=None),
  ],
  nested_types=[],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=249,
  serialized_end=675,
)


_ORGANIZATIONSERVICERESPONSES = _descriptor.Descriptor(
  name='OrganizationServiceResponses',
  full_name='main.responses.OrganizationServiceResponses',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
  ],
  extensions=[
    _descriptor.FieldDescriptor(
      name='create_organization', full_name='main.responses.OrganizationServiceResponses.create_organization', index=0,
      number=200, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=True, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='create_team', full_name='main.responses.OrganizationServiceResponses.create_team', index=1,
      number=201, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=True, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='create_address', full_name='main.responses.OrganizationServiceResponses.create_address', index=2,
      number=202, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=True, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='delete_address', full_name='main.responses.OrganizationServiceResponses.delete_address', index=3,
      number=203, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=True, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='get_address', full_name='main.responses.OrganizationServiceResponses.get_address', index=4,
      number=204, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=True, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='get_team', full_name='main.responses.OrganizationServiceResponses.get_team', index=5,
      number=205, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=True, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='get_organization', full_name='main.responses.OrganizationServiceResponses.get_organization', index=6,
      number=206, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=True, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='get_teams', full_name='main.responses.OrganizationServiceResponses.get_teams', index=7,
      number=207, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=True, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='get_addresses', full_name='main.responses.OrganizationServiceResponses.get_addresses', index=8,
      number=208, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=True, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='get_team_children', full_name='main.responses.OrganizationServiceResponses.get_team_children', index=9,
      number=209, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=True, extension_scope=None,
      options=None),
  ],
  nested_types=[],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=678,
  serialized_end=1922,
)


_PROFILESERVICERESPONSES = _descriptor.Descriptor(
  name='ProfileServiceResponses',
  full_name='main.responses.ProfileServiceResponses',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
  ],
  extensions=[
    _descriptor.FieldDescriptor(
      name='create_profile', full_name='main.responses.ProfileServiceResponses.create_profile', index=0,
      number=300, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=True, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='get_extended_profile', full_name='main.responses.ProfileServiceResponses.get_extended_profile', index=1,
      number=301, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=True, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='get_profile', full_name='main.responses.ProfileServiceResponses.get_profile', index=2,
      number=302, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=True, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='create_tags', full_name='main.responses.ProfileServiceResponses.create_tags', index=3,
      number=303, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=True, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='get_tags', full_name='main.responses.ProfileServiceResponses.get_tags', index=4,
      number=304, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=True, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='add_tags', full_name='main.responses.ProfileServiceResponses.add_tags', index=5,
      number=305, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=True, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='update_profile', full_name='main.responses.ProfileServiceResponses.update_profile', index=6,
      number=306, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=True, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='get_profiles', full_name='main.responses.ProfileServiceResponses.get_profiles', index=7,
      number=307, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=True, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='get_direct_reports', full_name='main.responses.ProfileServiceResponses.get_direct_reports', index=8,
      number=308, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=True, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='get_peers', full_name='main.responses.ProfileServiceResponses.get_peers', index=9,
      number=309, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=True, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='get_profile_stats', full_name='main.responses.ProfileServiceResponses.get_profile_stats', index=10,
      number=310, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=True, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='get_upcoming_anniversaries', full_name='main.responses.ProfileServiceResponses.get_upcoming_anniversaries', index=11,
      number=311, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=True, extension_scope=None,
      options=None),
  ],
  nested_types=[],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=1925,
  serialized_end=3303,
)


_SEARCHSERVICERESPONSES = _descriptor.Descriptor(
  name='SearchServiceResponses',
  full_name='main.responses.SearchServiceResponses',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
  ],
  extensions=[
    _descriptor.FieldDescriptor(
      name='search', full_name='main.responses.SearchServiceResponses.search', index=0,
      number=400, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=True, extension_scope=None,
      options=None),
  ],
  nested_types=[],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=3305,
  serialized_end=3425,
)


_LANDINGSERVICERESPONSES = _descriptor.Descriptor(
  name='LandingServiceResponses',
  full_name='main.responses.LandingServiceResponses',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
  ],
  extensions=[
    _descriptor.FieldDescriptor(
      name='get_categories', full_name='main.responses.LandingServiceResponses.get_categories', index=0,
      number=500, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=True, extension_scope=None,
      options=None),
  ],
  nested_types=[],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=3428,
  serialized_end=3566,
)

DESCRIPTOR.message_types_by_name['UserServiceResponses'] = _USERSERVICERESPONSES
DESCRIPTOR.message_types_by_name['OrganizationServiceResponses'] = _ORGANIZATIONSERVICERESPONSES
DESCRIPTOR.message_types_by_name['ProfileServiceResponses'] = _PROFILESERVICERESPONSES
DESCRIPTOR.message_types_by_name['SearchServiceResponses'] = _SEARCHSERVICERESPONSES
DESCRIPTOR.message_types_by_name['LandingServiceResponses'] = _LANDINGSERVICERESPONSES

UserServiceResponses = _reflection.GeneratedProtocolMessageType('UserServiceResponses', (_message.Message,), dict(
  DESCRIPTOR = _USERSERVICERESPONSES,
  __module__ = 'protobufs.response_registry_pb2'
  # @@protoc_insertion_point(class_scope:main.responses.UserServiceResponses)
  ))
_sym_db.RegisterMessage(UserServiceResponses)

OrganizationServiceResponses = _reflection.GeneratedProtocolMessageType('OrganizationServiceResponses', (_message.Message,), dict(
  DESCRIPTOR = _ORGANIZATIONSERVICERESPONSES,
  __module__ = 'protobufs.response_registry_pb2'
  # @@protoc_insertion_point(class_scope:main.responses.OrganizationServiceResponses)
  ))
_sym_db.RegisterMessage(OrganizationServiceResponses)

ProfileServiceResponses = _reflection.GeneratedProtocolMessageType('ProfileServiceResponses', (_message.Message,), dict(
  DESCRIPTOR = _PROFILESERVICERESPONSES,
  __module__ = 'protobufs.response_registry_pb2'
  # @@protoc_insertion_point(class_scope:main.responses.ProfileServiceResponses)
  ))
_sym_db.RegisterMessage(ProfileServiceResponses)

SearchServiceResponses = _reflection.GeneratedProtocolMessageType('SearchServiceResponses', (_message.Message,), dict(
  DESCRIPTOR = _SEARCHSERVICERESPONSES,
  __module__ = 'protobufs.response_registry_pb2'
  # @@protoc_insertion_point(class_scope:main.responses.SearchServiceResponses)
  ))
_sym_db.RegisterMessage(SearchServiceResponses)

LandingServiceResponses = _reflection.GeneratedProtocolMessageType('LandingServiceResponses', (_message.Message,), dict(
  DESCRIPTOR = _LANDINGSERVICERESPONSES,
  __module__ = 'protobufs.response_registry_pb2'
  # @@protoc_insertion_point(class_scope:main.responses.LandingServiceResponses)
  ))
_sym_db.RegisterMessage(LandingServiceResponses)

_USERSERVICERESPONSES.extensions_by_name['create_user'].message_type = protobufs.user_service_pb2._USERSERVICE_CREATEUSER_RESPONSE
service_protobufs.soa_pb2.ActionResponseResult.RegisterExtension(_USERSERVICERESPONSES.extensions_by_name['create_user'])
_USERSERVICERESPONSES.extensions_by_name['valid_user'].message_type = protobufs.user_service_pb2._USERSERVICE_VALIDUSER_RESPONSE
service_protobufs.soa_pb2.ActionResponseResult.RegisterExtension(_USERSERVICERESPONSES.extensions_by_name['valid_user'])
_USERSERVICERESPONSES.extensions_by_name['authenticate_user'].message_type = protobufs.user_service_pb2._USERSERVICE_AUTHENTICATEUSER_RESPONSE
service_protobufs.soa_pb2.ActionResponseResult.RegisterExtension(_USERSERVICERESPONSES.extensions_by_name['authenticate_user'])
_USERSERVICERESPONSES.extensions_by_name['get_user'].message_type = protobufs.user_service_pb2._USERSERVICE_GETUSER_RESPONSE
service_protobufs.soa_pb2.ActionResponseResult.RegisterExtension(_USERSERVICERESPONSES.extensions_by_name['get_user'])
_ORGANIZATIONSERVICERESPONSES.extensions_by_name['create_organization'].message_type = protobufs.organization_service_pb2._ORGANIZATIONSERVICE_CREATEORGANIZATION_RESPONSE
service_protobufs.soa_pb2.ActionResponseResult.RegisterExtension(_ORGANIZATIONSERVICERESPONSES.extensions_by_name['create_organization'])
_ORGANIZATIONSERVICERESPONSES.extensions_by_name['create_team'].message_type = protobufs.organization_service_pb2._ORGANIZATIONSERVICE_CREATETEAM_RESPONSE
service_protobufs.soa_pb2.ActionResponseResult.RegisterExtension(_ORGANIZATIONSERVICERESPONSES.extensions_by_name['create_team'])
_ORGANIZATIONSERVICERESPONSES.extensions_by_name['create_address'].message_type = protobufs.organization_service_pb2._ORGANIZATIONSERVICE_CREATEADDRESS_RESPONSE
service_protobufs.soa_pb2.ActionResponseResult.RegisterExtension(_ORGANIZATIONSERVICERESPONSES.extensions_by_name['create_address'])
_ORGANIZATIONSERVICERESPONSES.extensions_by_name['delete_address'].message_type = protobufs.organization_service_pb2._ORGANIZATIONSERVICE_DELETEADDRESS_RESPONSE
service_protobufs.soa_pb2.ActionResponseResult.RegisterExtension(_ORGANIZATIONSERVICERESPONSES.extensions_by_name['delete_address'])
_ORGANIZATIONSERVICERESPONSES.extensions_by_name['get_address'].message_type = protobufs.organization_service_pb2._ORGANIZATIONSERVICE_GETADDRESS_RESPONSE
service_protobufs.soa_pb2.ActionResponseResult.RegisterExtension(_ORGANIZATIONSERVICERESPONSES.extensions_by_name['get_address'])
_ORGANIZATIONSERVICERESPONSES.extensions_by_name['get_team'].message_type = protobufs.organization_service_pb2._ORGANIZATIONSERVICE_GETTEAM_RESPONSE
service_protobufs.soa_pb2.ActionResponseResult.RegisterExtension(_ORGANIZATIONSERVICERESPONSES.extensions_by_name['get_team'])
_ORGANIZATIONSERVICERESPONSES.extensions_by_name['get_organization'].message_type = protobufs.organization_service_pb2._ORGANIZATIONSERVICE_GETORGANIZATION_RESPONSE
service_protobufs.soa_pb2.ActionResponseResult.RegisterExtension(_ORGANIZATIONSERVICERESPONSES.extensions_by_name['get_organization'])
_ORGANIZATIONSERVICERESPONSES.extensions_by_name['get_teams'].message_type = protobufs.organization_service_pb2._ORGANIZATIONSERVICE_GETTEAMS_RESPONSE
service_protobufs.soa_pb2.ActionResponseResult.RegisterExtension(_ORGANIZATIONSERVICERESPONSES.extensions_by_name['get_teams'])
_ORGANIZATIONSERVICERESPONSES.extensions_by_name['get_addresses'].message_type = protobufs.organization_service_pb2._ORGANIZATIONSERVICE_GETADDRESSES_RESPONSE
service_protobufs.soa_pb2.ActionResponseResult.RegisterExtension(_ORGANIZATIONSERVICERESPONSES.extensions_by_name['get_addresses'])
_ORGANIZATIONSERVICERESPONSES.extensions_by_name['get_team_children'].message_type = protobufs.organization_service_pb2._ORGANIZATIONSERVICE_GETTEAMCHILDREN_RESPONSE
service_protobufs.soa_pb2.ActionResponseResult.RegisterExtension(_ORGANIZATIONSERVICERESPONSES.extensions_by_name['get_team_children'])
_PROFILESERVICERESPONSES.extensions_by_name['create_profile'].message_type = protobufs.profile_service_pb2._PROFILESERVICE_CREATEPROFILE_RESPONSE
service_protobufs.soa_pb2.ActionResponseResult.RegisterExtension(_PROFILESERVICERESPONSES.extensions_by_name['create_profile'])
_PROFILESERVICERESPONSES.extensions_by_name['get_extended_profile'].message_type = protobufs.profile_service_pb2._PROFILESERVICE_GETEXTENDEDPROFILE_RESPONSE
service_protobufs.soa_pb2.ActionResponseResult.RegisterExtension(_PROFILESERVICERESPONSES.extensions_by_name['get_extended_profile'])
_PROFILESERVICERESPONSES.extensions_by_name['get_profile'].message_type = protobufs.profile_service_pb2._PROFILESERVICE_GETPROFILE_RESPONSE
service_protobufs.soa_pb2.ActionResponseResult.RegisterExtension(_PROFILESERVICERESPONSES.extensions_by_name['get_profile'])
_PROFILESERVICERESPONSES.extensions_by_name['create_tags'].message_type = protobufs.profile_service_pb2._PROFILESERVICE_CREATETAGS_RESPONSE
service_protobufs.soa_pb2.ActionResponseResult.RegisterExtension(_PROFILESERVICERESPONSES.extensions_by_name['create_tags'])
_PROFILESERVICERESPONSES.extensions_by_name['get_tags'].message_type = protobufs.profile_service_pb2._PROFILESERVICE_GETTAGS_RESPONSE
service_protobufs.soa_pb2.ActionResponseResult.RegisterExtension(_PROFILESERVICERESPONSES.extensions_by_name['get_tags'])
_PROFILESERVICERESPONSES.extensions_by_name['add_tags'].message_type = protobufs.profile_service_pb2._PROFILESERVICE_ADDTAGS_RESPONSE
service_protobufs.soa_pb2.ActionResponseResult.RegisterExtension(_PROFILESERVICERESPONSES.extensions_by_name['add_tags'])
_PROFILESERVICERESPONSES.extensions_by_name['update_profile'].message_type = protobufs.profile_service_pb2._PROFILESERVICE_UPDATEPROFILE_RESPONSE
service_protobufs.soa_pb2.ActionResponseResult.RegisterExtension(_PROFILESERVICERESPONSES.extensions_by_name['update_profile'])
_PROFILESERVICERESPONSES.extensions_by_name['get_profiles'].message_type = protobufs.profile_service_pb2._PROFILESERVICE_GETPROFILES_RESPONSE
service_protobufs.soa_pb2.ActionResponseResult.RegisterExtension(_PROFILESERVICERESPONSES.extensions_by_name['get_profiles'])
_PROFILESERVICERESPONSES.extensions_by_name['get_direct_reports'].message_type = protobufs.profile_service_pb2._PROFILESERVICE_GETDIRECTREPORTS_RESPONSE
service_protobufs.soa_pb2.ActionResponseResult.RegisterExtension(_PROFILESERVICERESPONSES.extensions_by_name['get_direct_reports'])
_PROFILESERVICERESPONSES.extensions_by_name['get_peers'].message_type = protobufs.profile_service_pb2._PROFILESERVICE_GETPEERS_RESPONSE
service_protobufs.soa_pb2.ActionResponseResult.RegisterExtension(_PROFILESERVICERESPONSES.extensions_by_name['get_peers'])
_PROFILESERVICERESPONSES.extensions_by_name['get_profile_stats'].message_type = protobufs.profile_service_pb2._PROFILESERVICE_GETPROFILESTATS_RESPONSE
service_protobufs.soa_pb2.ActionResponseResult.RegisterExtension(_PROFILESERVICERESPONSES.extensions_by_name['get_profile_stats'])
_PROFILESERVICERESPONSES.extensions_by_name['get_upcoming_anniversaries'].message_type = protobufs.profile_service_pb2._PROFILESERVICE_GETUPCOMINGANNIVERSARIES_RESPONSE
service_protobufs.soa_pb2.ActionResponseResult.RegisterExtension(_PROFILESERVICERESPONSES.extensions_by_name['get_upcoming_anniversaries'])
_SEARCHSERVICERESPONSES.extensions_by_name['search'].message_type = protobufs.search_service_pb2._SEARCHSERVICE_SEARCH_RESPONSE
service_protobufs.soa_pb2.ActionResponseResult.RegisterExtension(_SEARCHSERVICERESPONSES.extensions_by_name['search'])
_LANDINGSERVICERESPONSES.extensions_by_name['get_categories'].message_type = protobufs.landing_service_pb2._LANDINGSERVICE_GETCATEGORIES_RESPONSE
service_protobufs.soa_pb2.ActionResponseResult.RegisterExtension(_LANDINGSERVICERESPONSES.extensions_by_name['get_categories'])

# @@protoc_insertion_point(module_scope)
