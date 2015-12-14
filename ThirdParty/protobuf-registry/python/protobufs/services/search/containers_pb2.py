# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: protobufs/services/search/containers.proto

from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import symbol_database as _symbol_database
from google.protobuf import descriptor_pb2
# @@protoc_insertion_point(imports)

_sym_db = _symbol_database.Default()


from protobufs.services.group import containers_pb2 as protobufs_dot_services_dot_group_dot_containers__pb2
from protobufs.services.organization import containers_pb2 as protobufs_dot_services_dot_organization_dot_containers__pb2
from protobufs.services.post import containers_pb2 as protobufs_dot_services_dot_post_dot_containers__pb2
from protobufs.services.profile import containers_pb2 as protobufs_dot_services_dot_profile_dot_containers__pb2
from protobufs.services.search.containers import search_pb2 as protobufs_dot_services_dot_search_dot_containers_dot_search__pb2


DESCRIPTOR = _descriptor.FileDescriptor(
  name='protobufs/services/search/containers.proto',
  package='services.search.containers',
  syntax='proto3',
  serialized_pb=b'\n*protobufs/services/search/containers.proto\x12\x1aservices.search.containers\x1a)protobufs/services/group/containers.proto\x1a\x30protobufs/services/organization/containers.proto\x1a(protobufs/services/post/containers.proto\x1a+protobufs/services/profile/containers.proto\x1a\x31protobufs/services/search/containers/search.proto\"?\n\x11TrackingDetailsV1\x12\x13\n\x0b\x64ocument_id\x18\x01 \x01(\t\x12\x15\n\rdocument_type\x18\x02 \x01(\t\"\x97\x04\n\x0eSearchResultV1\x12\x39\n\x07profile\x18\x02 \x01(\x0b\x32&.services.profile.containers.ProfileV1H\x00\x12\x38\n\x04team\x18\x03 \x01(\x0b\x32(.services.organization.containers.TeamV1H\x00\x12@\n\x08location\x18\x04 \x01(\x0b\x32,.services.organization.containers.LocationV1H\x00\x12\x33\n\x05group\x18\x05 \x01(\x0b\x32\".services.group.containers.GroupV1H\x00\x12\x30\n\x04post\x18\t \x01(\x0b\x32 .services.post.containers.PostV1H\x00\x12\r\n\x05score\x18\x08 \x01(\x02\x12L\n\thighlight\x18\n \x03(\x0b\x32\x39.services.search.containers.SearchResultV1.HighlightEntry\x12G\n\x10tracking_details\x18\x0b \x01(\x0b\x32-.services.search.containers.TrackingDetailsV1\x1a\x30\n\x0eHighlightEntry\x12\x0b\n\x03key\x18\x01 \x01(\t\x12\r\n\x05value\x18\x02 \x01(\t:\x02\x38\x01\x42\x0f\n\rresult_object\"\xbf\x02\n\x0eRecentResultV1\x12\x39\n\x07profile\x18\x01 \x01(\x0b\x32&.services.profile.containers.ProfileV1H\x00\x12\x38\n\x04team\x18\x02 \x01(\x0b\x32(.services.organization.containers.TeamV1H\x00\x12@\n\x08location\x18\x03 \x01(\x0b\x32,.services.organization.containers.LocationV1H\x00\x12\x33\n\x05group\x18\x04 \x01(\x0b\x32\".services.group.containers.GroupV1H\x00\x12\x30\n\x04post\x18\x05 \x01(\x0b\x32 .services.post.containers.PostV1H\x00\x42\x0f\n\rresult_objectB1\n/com.rhlabs.protobufs.services.search.containersb\x06proto3'
  ,
  dependencies=[protobufs_dot_services_dot_group_dot_containers__pb2.DESCRIPTOR,protobufs_dot_services_dot_organization_dot_containers__pb2.DESCRIPTOR,protobufs_dot_services_dot_post_dot_containers__pb2.DESCRIPTOR,protobufs_dot_services_dot_profile_dot_containers__pb2.DESCRIPTOR,protobufs_dot_services_dot_search_dot_containers_dot_search__pb2.DESCRIPTOR,])
_sym_db.RegisterFileDescriptor(DESCRIPTOR)




_TRACKINGDETAILSV1 = _descriptor.Descriptor(
  name='TrackingDetailsV1',
  full_name='services.search.containers.TrackingDetailsV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='document_id', full_name='services.search.containers.TrackingDetailsV1.document_id', index=0,
      number=1, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=b"".decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='document_type', full_name='services.search.containers.TrackingDetailsV1.document_type', index=1,
      number=2, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=b"".decode('utf-8'),
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
  syntax='proto3',
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=305,
  serialized_end=368,
)


_SEARCHRESULTV1_HIGHLIGHTENTRY = _descriptor.Descriptor(
  name='HighlightEntry',
  full_name='services.search.containers.SearchResultV1.HighlightEntry',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='key', full_name='services.search.containers.SearchResultV1.HighlightEntry.key', index=0,
      number=1, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=b"".decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='value', full_name='services.search.containers.SearchResultV1.HighlightEntry.value', index=1,
      number=2, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=b"".decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  options=_descriptor._ParseOptions(descriptor_pb2.MessageOptions(), b'8\001'),
  is_extendable=False,
  syntax='proto3',
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=841,
  serialized_end=889,
)

_SEARCHRESULTV1 = _descriptor.Descriptor(
  name='SearchResultV1',
  full_name='services.search.containers.SearchResultV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='profile', full_name='services.search.containers.SearchResultV1.profile', index=0,
      number=2, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='team', full_name='services.search.containers.SearchResultV1.team', index=1,
      number=3, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='location', full_name='services.search.containers.SearchResultV1.location', index=2,
      number=4, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='group', full_name='services.search.containers.SearchResultV1.group', index=3,
      number=5, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='post', full_name='services.search.containers.SearchResultV1.post', index=4,
      number=9, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='score', full_name='services.search.containers.SearchResultV1.score', index=5,
      number=8, type=2, cpp_type=6, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='highlight', full_name='services.search.containers.SearchResultV1.highlight', index=6,
      number=10, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='tracking_details', full_name='services.search.containers.SearchResultV1.tracking_details', index=7,
      number=11, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
  ],
  extensions=[
  ],
  nested_types=[_SEARCHRESULTV1_HIGHLIGHTENTRY, ],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  syntax='proto3',
  extension_ranges=[],
  oneofs=[
    _descriptor.OneofDescriptor(
      name='result_object', full_name='services.search.containers.SearchResultV1.result_object',
      index=0, containing_type=None, fields=[]),
  ],
  serialized_start=371,
  serialized_end=906,
)


_RECENTRESULTV1 = _descriptor.Descriptor(
  name='RecentResultV1',
  full_name='services.search.containers.RecentResultV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='profile', full_name='services.search.containers.RecentResultV1.profile', index=0,
      number=1, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='team', full_name='services.search.containers.RecentResultV1.team', index=1,
      number=2, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='location', full_name='services.search.containers.RecentResultV1.location', index=2,
      number=3, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='group', full_name='services.search.containers.RecentResultV1.group', index=3,
      number=4, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='post', full_name='services.search.containers.RecentResultV1.post', index=4,
      number=5, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
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
  syntax='proto3',
  extension_ranges=[],
  oneofs=[
    _descriptor.OneofDescriptor(
      name='result_object', full_name='services.search.containers.RecentResultV1.result_object',
      index=0, containing_type=None, fields=[]),
  ],
  serialized_start=909,
  serialized_end=1228,
)

_SEARCHRESULTV1_HIGHLIGHTENTRY.containing_type = _SEARCHRESULTV1
_SEARCHRESULTV1.fields_by_name['profile'].message_type = protobufs_dot_services_dot_profile_dot_containers__pb2._PROFILEV1
_SEARCHRESULTV1.fields_by_name['team'].message_type = protobufs_dot_services_dot_organization_dot_containers__pb2._TEAMV1
_SEARCHRESULTV1.fields_by_name['location'].message_type = protobufs_dot_services_dot_organization_dot_containers__pb2._LOCATIONV1
_SEARCHRESULTV1.fields_by_name['group'].message_type = protobufs_dot_services_dot_group_dot_containers__pb2._GROUPV1
_SEARCHRESULTV1.fields_by_name['post'].message_type = protobufs_dot_services_dot_post_dot_containers__pb2._POSTV1
_SEARCHRESULTV1.fields_by_name['highlight'].message_type = _SEARCHRESULTV1_HIGHLIGHTENTRY
_SEARCHRESULTV1.fields_by_name['tracking_details'].message_type = _TRACKINGDETAILSV1
_SEARCHRESULTV1.oneofs_by_name['result_object'].fields.append(
  _SEARCHRESULTV1.fields_by_name['profile'])
_SEARCHRESULTV1.fields_by_name['profile'].containing_oneof = _SEARCHRESULTV1.oneofs_by_name['result_object']
_SEARCHRESULTV1.oneofs_by_name['result_object'].fields.append(
  _SEARCHRESULTV1.fields_by_name['team'])
_SEARCHRESULTV1.fields_by_name['team'].containing_oneof = _SEARCHRESULTV1.oneofs_by_name['result_object']
_SEARCHRESULTV1.oneofs_by_name['result_object'].fields.append(
  _SEARCHRESULTV1.fields_by_name['location'])
_SEARCHRESULTV1.fields_by_name['location'].containing_oneof = _SEARCHRESULTV1.oneofs_by_name['result_object']
_SEARCHRESULTV1.oneofs_by_name['result_object'].fields.append(
  _SEARCHRESULTV1.fields_by_name['group'])
_SEARCHRESULTV1.fields_by_name['group'].containing_oneof = _SEARCHRESULTV1.oneofs_by_name['result_object']
_SEARCHRESULTV1.oneofs_by_name['result_object'].fields.append(
  _SEARCHRESULTV1.fields_by_name['post'])
_SEARCHRESULTV1.fields_by_name['post'].containing_oneof = _SEARCHRESULTV1.oneofs_by_name['result_object']
_RECENTRESULTV1.fields_by_name['profile'].message_type = protobufs_dot_services_dot_profile_dot_containers__pb2._PROFILEV1
_RECENTRESULTV1.fields_by_name['team'].message_type = protobufs_dot_services_dot_organization_dot_containers__pb2._TEAMV1
_RECENTRESULTV1.fields_by_name['location'].message_type = protobufs_dot_services_dot_organization_dot_containers__pb2._LOCATIONV1
_RECENTRESULTV1.fields_by_name['group'].message_type = protobufs_dot_services_dot_group_dot_containers__pb2._GROUPV1
_RECENTRESULTV1.fields_by_name['post'].message_type = protobufs_dot_services_dot_post_dot_containers__pb2._POSTV1
_RECENTRESULTV1.oneofs_by_name['result_object'].fields.append(
  _RECENTRESULTV1.fields_by_name['profile'])
_RECENTRESULTV1.fields_by_name['profile'].containing_oneof = _RECENTRESULTV1.oneofs_by_name['result_object']
_RECENTRESULTV1.oneofs_by_name['result_object'].fields.append(
  _RECENTRESULTV1.fields_by_name['team'])
_RECENTRESULTV1.fields_by_name['team'].containing_oneof = _RECENTRESULTV1.oneofs_by_name['result_object']
_RECENTRESULTV1.oneofs_by_name['result_object'].fields.append(
  _RECENTRESULTV1.fields_by_name['location'])
_RECENTRESULTV1.fields_by_name['location'].containing_oneof = _RECENTRESULTV1.oneofs_by_name['result_object']
_RECENTRESULTV1.oneofs_by_name['result_object'].fields.append(
  _RECENTRESULTV1.fields_by_name['group'])
_RECENTRESULTV1.fields_by_name['group'].containing_oneof = _RECENTRESULTV1.oneofs_by_name['result_object']
_RECENTRESULTV1.oneofs_by_name['result_object'].fields.append(
  _RECENTRESULTV1.fields_by_name['post'])
_RECENTRESULTV1.fields_by_name['post'].containing_oneof = _RECENTRESULTV1.oneofs_by_name['result_object']
DESCRIPTOR.message_types_by_name['TrackingDetailsV1'] = _TRACKINGDETAILSV1
DESCRIPTOR.message_types_by_name['SearchResultV1'] = _SEARCHRESULTV1
DESCRIPTOR.message_types_by_name['RecentResultV1'] = _RECENTRESULTV1

TrackingDetailsV1 = _reflection.GeneratedProtocolMessageType('TrackingDetailsV1', (_message.Message,), dict(
  DESCRIPTOR = _TRACKINGDETAILSV1,
  __module__ = 'protobufs.services.search.containers_pb2'
  # @@protoc_insertion_point(class_scope:services.search.containers.TrackingDetailsV1)
  ))
_sym_db.RegisterMessage(TrackingDetailsV1)

SearchResultV1 = _reflection.GeneratedProtocolMessageType('SearchResultV1', (_message.Message,), dict(

  HighlightEntry = _reflection.GeneratedProtocolMessageType('HighlightEntry', (_message.Message,), dict(
    DESCRIPTOR = _SEARCHRESULTV1_HIGHLIGHTENTRY,
    __module__ = 'protobufs.services.search.containers_pb2'
    # @@protoc_insertion_point(class_scope:services.search.containers.SearchResultV1.HighlightEntry)
    ))
  ,
  DESCRIPTOR = _SEARCHRESULTV1,
  __module__ = 'protobufs.services.search.containers_pb2'
  # @@protoc_insertion_point(class_scope:services.search.containers.SearchResultV1)
  ))
_sym_db.RegisterMessage(SearchResultV1)
_sym_db.RegisterMessage(SearchResultV1.HighlightEntry)

RecentResultV1 = _reflection.GeneratedProtocolMessageType('RecentResultV1', (_message.Message,), dict(
  DESCRIPTOR = _RECENTRESULTV1,
  __module__ = 'protobufs.services.search.containers_pb2'
  # @@protoc_insertion_point(class_scope:services.search.containers.RecentResultV1)
  ))
_sym_db.RegisterMessage(RecentResultV1)


DESCRIPTOR.has_options = True
DESCRIPTOR._options = _descriptor._ParseOptions(descriptor_pb2.FileOptions(), b'\n/com.rhlabs.protobufs.services.search.containers')
_SEARCHRESULTV1_HIGHLIGHTENTRY.has_options = True
_SEARCHRESULTV1_HIGHLIGHTENTRY._options = _descriptor._ParseOptions(descriptor_pb2.MessageOptions(), b'8\001')
# @@protoc_insertion_point(module_scope)
