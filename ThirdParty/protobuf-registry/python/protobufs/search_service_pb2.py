# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: protobufs/search_service.proto

import sys
_b=sys.version_info[0]<3 and (lambda x:x) or (lambda x:x.encode('latin1'))
from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import symbol_database as _symbol_database
from google.protobuf import descriptor_pb2
# @@protoc_insertion_point(imports)

_sym_db = _symbol_database.Default()


import protobufs.organization_service_pb2
import protobufs.profile_service_pb2


DESCRIPTOR = _descriptor.FileDescriptor(
  name='protobufs/search_service.proto',
  package='main.search_service',
  serialized_pb=_b('\n\x1eprotobufs/search_service.proto\x12\x13main.search_service\x1a$protobufs/organization_service.proto\x1a\x1fprotobufs/profile_service.proto\"\xb1\x02\n\rSearchService\x1a\x9f\x02\n\x06Search\x1a\x18\n\x07Request\x12\r\n\x05query\x18\x01 \x01(\t\x1a\xfa\x01\n\x08Response\x12I\n\x08profiles\x18\x01 \x03(\x0b\x32\x37.main.profile_service.ProfileService.Containers.Profile\x12M\n\x05teams\x18\x02 \x03(\x0b\x32>.main.organization_service.OrganizationService.Containers.Team\x12T\n\taddresses\x18\x03 \x03(\x0b\x32\x41.main.organization_service.OrganizationService.Containers.Address')
  ,
  dependencies=[protobufs.organization_service_pb2.DESCRIPTOR,protobufs.profile_service_pb2.DESCRIPTOR,])
_sym_db.RegisterFileDescriptor(DESCRIPTOR)




_SEARCHSERVICE_SEARCH_REQUEST = _descriptor.Descriptor(
  name='Request',
  full_name='main.search_service.SearchService.Search.Request',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='query', full_name='main.search_service.SearchService.Search.Request.query', index=0,
      number=1, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=155,
  serialized_end=179,
)

_SEARCHSERVICE_SEARCH_RESPONSE = _descriptor.Descriptor(
  name='Response',
  full_name='main.search_service.SearchService.Search.Response',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='profiles', full_name='main.search_service.SearchService.Search.Response.profiles', index=0,
      number=1, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='teams', full_name='main.search_service.SearchService.Search.Response.teams', index=1,
      number=2, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='addresses', full_name='main.search_service.SearchService.Search.Response.addresses', index=2,
      number=3, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=182,
  serialized_end=432,
)

_SEARCHSERVICE_SEARCH = _descriptor.Descriptor(
  name='Search',
  full_name='main.search_service.SearchService.Search',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
  ],
  extensions=[
  ],
  nested_types=[_SEARCHSERVICE_SEARCH_REQUEST, _SEARCHSERVICE_SEARCH_RESPONSE, ],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=145,
  serialized_end=432,
)

_SEARCHSERVICE = _descriptor.Descriptor(
  name='SearchService',
  full_name='main.search_service.SearchService',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
  ],
  extensions=[
  ],
  nested_types=[_SEARCHSERVICE_SEARCH, ],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=127,
  serialized_end=432,
)

_SEARCHSERVICE_SEARCH_REQUEST.containing_type = _SEARCHSERVICE_SEARCH
_SEARCHSERVICE_SEARCH_RESPONSE.fields_by_name['profiles'].message_type = protobufs.profile_service_pb2._PROFILESERVICE_CONTAINERS_PROFILE
_SEARCHSERVICE_SEARCH_RESPONSE.fields_by_name['teams'].message_type = protobufs.organization_service_pb2._ORGANIZATIONSERVICE_CONTAINERS_TEAM
_SEARCHSERVICE_SEARCH_RESPONSE.fields_by_name['addresses'].message_type = protobufs.organization_service_pb2._ORGANIZATIONSERVICE_CONTAINERS_ADDRESS
_SEARCHSERVICE_SEARCH_RESPONSE.containing_type = _SEARCHSERVICE_SEARCH
_SEARCHSERVICE_SEARCH.containing_type = _SEARCHSERVICE
DESCRIPTOR.message_types_by_name['SearchService'] = _SEARCHSERVICE

SearchService = _reflection.GeneratedProtocolMessageType('SearchService', (_message.Message,), dict(

  Search = _reflection.GeneratedProtocolMessageType('Search', (_message.Message,), dict(

    Request = _reflection.GeneratedProtocolMessageType('Request', (_message.Message,), dict(
      DESCRIPTOR = _SEARCHSERVICE_SEARCH_REQUEST,
      __module__ = 'protobufs.search_service_pb2'
      # @@protoc_insertion_point(class_scope:main.search_service.SearchService.Search.Request)
      ))
    ,

    Response = _reflection.GeneratedProtocolMessageType('Response', (_message.Message,), dict(
      DESCRIPTOR = _SEARCHSERVICE_SEARCH_RESPONSE,
      __module__ = 'protobufs.search_service_pb2'
      # @@protoc_insertion_point(class_scope:main.search_service.SearchService.Search.Response)
      ))
    ,
    DESCRIPTOR = _SEARCHSERVICE_SEARCH,
    __module__ = 'protobufs.search_service_pb2'
    # @@protoc_insertion_point(class_scope:main.search_service.SearchService.Search)
    ))
  ,
  DESCRIPTOR = _SEARCHSERVICE,
  __module__ = 'protobufs.search_service_pb2'
  # @@protoc_insertion_point(class_scope:main.search_service.SearchService)
  ))
_sym_db.RegisterMessage(SearchService)
_sym_db.RegisterMessage(SearchService.Search)
_sym_db.RegisterMessage(SearchService.Search.Request)
_sym_db.RegisterMessage(SearchService.Search.Response)


# @@protoc_insertion_point(module_scope)