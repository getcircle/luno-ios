# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: protobufs/services/search/containers.proto

import sys
_b=sys.version_info[0]<3 and (lambda x:x) or (lambda x:x.encode('latin1'))
from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import symbol_database as _symbol_database
from google.protobuf import descriptor_pb2
# @@protoc_insertion_point(imports)

_sym_db = _symbol_database.Default()


import protobufs.services.group.containers_pb2
import protobufs.services.organization.containers_pb2
import protobufs.services.profile.containers_pb2
import protobufs.services.search.containers.search_pb2


DESCRIPTOR = _descriptor.FileDescriptor(
  name='protobufs/services/search/containers.proto',
  package='services.search.containers',
  serialized_pb=_b('\n*protobufs/services/search/containers.proto\x12\x1aservices.search.containers\x1a)protobufs/services/group/containers.proto\x1a\x30protobufs/services/organization/containers.proto\x1a+protobufs/services/profile/containers.proto\x1a\x31protobufs/services/search/containers/search.proto\"\x80\x03\n\x0fSearchResultsV1\x12\x12\n\x07version\x18\x01 \x01(\r:\x01\x31\x12?\n\x08\x63\x61tegory\x18\x02 \x01(\x0e\x32-.services.search.containers.search.CategoryV1\x12\x38\n\x08profiles\x18\x03 \x03(\x0b\x32&.services.profile.containers.ProfileV1\x12\x37\n\x05teams\x18\x04 \x03(\x0b\x32(.services.organization.containers.TeamV1\x12?\n\tlocations\x18\x05 \x03(\x0b\x32,.services.organization.containers.LocationV1\x12\x30\n\x04tags\x18\x06 \x03(\x0b\x32\".services.profile.containers.TagV1\x12\x32\n\x06groups\x18\x07 \x03(\x0b\x32\".services.group.containers.GroupV1')
  ,
  dependencies=[protobufs.services.group.containers_pb2.DESCRIPTOR,protobufs.services.organization.containers_pb2.DESCRIPTOR,protobufs.services.profile.containers_pb2.DESCRIPTOR,protobufs.services.search.containers.search_pb2.DESCRIPTOR,])
_sym_db.RegisterFileDescriptor(DESCRIPTOR)




_SEARCHRESULTSV1 = _descriptor.Descriptor(
  name='SearchResultsV1',
  full_name='services.search.containers.SearchResultsV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='version', full_name='services.search.containers.SearchResultsV1.version', index=0,
      number=1, type=13, cpp_type=3, label=1,
      has_default_value=True, default_value=1,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='category', full_name='services.search.containers.SearchResultsV1.category', index=1,
      number=2, type=14, cpp_type=8, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='profiles', full_name='services.search.containers.SearchResultsV1.profiles', index=2,
      number=3, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='teams', full_name='services.search.containers.SearchResultsV1.teams', index=3,
      number=4, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='locations', full_name='services.search.containers.SearchResultsV1.locations', index=4,
      number=5, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='tags', full_name='services.search.containers.SearchResultsV1.tags', index=5,
      number=6, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='groups', full_name='services.search.containers.SearchResultsV1.groups', index=6,
      number=7, type=11, cpp_type=10, label=3,
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
  serialized_start=264,
  serialized_end=648,
)

_SEARCHRESULTSV1.fields_by_name['category'].enum_type = protobufs.services.search.containers.search_pb2._CATEGORYV1
_SEARCHRESULTSV1.fields_by_name['profiles'].message_type = protobufs.services.profile.containers_pb2._PROFILEV1
_SEARCHRESULTSV1.fields_by_name['teams'].message_type = protobufs.services.organization.containers_pb2._TEAMV1
_SEARCHRESULTSV1.fields_by_name['locations'].message_type = protobufs.services.organization.containers_pb2._LOCATIONV1
_SEARCHRESULTSV1.fields_by_name['tags'].message_type = protobufs.services.profile.containers_pb2._TAGV1
_SEARCHRESULTSV1.fields_by_name['groups'].message_type = protobufs.services.group.containers_pb2._GROUPV1
DESCRIPTOR.message_types_by_name['SearchResultsV1'] = _SEARCHRESULTSV1

SearchResultsV1 = _reflection.GeneratedProtocolMessageType('SearchResultsV1', (_message.Message,), dict(
  DESCRIPTOR = _SEARCHRESULTSV1,
  __module__ = 'protobufs.services.search.containers_pb2'
  # @@protoc_insertion_point(class_scope:services.search.containers.SearchResultsV1)
  ))
_sym_db.RegisterMessage(SearchResultsV1)


# @@protoc_insertion_point(module_scope)