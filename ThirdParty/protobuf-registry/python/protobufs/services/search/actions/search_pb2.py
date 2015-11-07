# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: protobufs/services/search/actions/search.proto

import sys
_b=sys.version_info[0]<3 and (lambda x:x) or (lambda x:x.encode('latin1'))
from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import symbol_database as _symbol_database
from google.protobuf import descriptor_pb2
# @@protoc_insertion_point(imports)

_sym_db = _symbol_database.Default()


from protobufs.services.search import containers_pb2 as protobufs_dot_services_dot_search_dot_containers__pb2
from protobufs.services.search.containers import search_pb2 as protobufs_dot_services_dot_search_dot_containers_dot_search__pb2


DESCRIPTOR = _descriptor.FileDescriptor(
  name='protobufs/services/search/actions/search.proto',
  package='services.search.actions.search',
  syntax='proto2',
  serialized_pb=_b('\n.protobufs/services/search/actions/search.proto\x12\x1eservices.search.actions.search\x1a*protobufs/services/search/containers.proto\x1a\x31protobufs/services/search/containers/search.proto\"\xcb\x01\n\tRequestV1\x12\x12\n\x07version\x18\x01 \x01(\r:\x01\x31\x12\r\n\x05query\x18\x02 \x01(\t\x12?\n\x08\x63\x61tegory\x18\x03 \x01(\x0e\x32-.services.search.containers.search.CategoryV1\x12\x41\n\tattribute\x18\x04 \x01(\x0e\x32..services.search.containers.search.AttributeV1\x12\x17\n\x0f\x61ttribute_value\x18\x05 \x01(\t\"]\n\nResponseV1\x12\x12\n\x07version\x18\x01 \x01(\r:\x01\x31\x12;\n\x07results\x18\x02 \x03(\x0b\x32*.services.search.containers.SearchResultV1\"o\n\tRequestV2\x12\x12\n\x07version\x18\x01 \x01(\r:\x01\x32\x12\r\n\x05query\x18\x02 \x01(\t\x12?\n\x08\x63\x61tegory\x18\x03 \x01(\x0e\x32-.services.search.containers.search.CategoryV1\"]\n\nResponseV2\x12\x12\n\x07version\x18\x01 \x01(\r:\x01\x32\x12;\n\x07results\x18\x02 \x03(\x0b\x32*.services.search.containers.SearchResultV1B5\n3com.rhlabs.protobufs.services.search.actions.search')
  ,
  dependencies=[protobufs_dot_services_dot_search_dot_containers__pb2.DESCRIPTOR,protobufs_dot_services_dot_search_dot_containers_dot_search__pb2.DESCRIPTOR,])
_sym_db.RegisterFileDescriptor(DESCRIPTOR)




_REQUESTV1 = _descriptor.Descriptor(
  name='RequestV1',
  full_name='services.search.actions.search.RequestV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='version', full_name='services.search.actions.search.RequestV1.version', index=0,
      number=1, type=13, cpp_type=3, label=1,
      has_default_value=True, default_value=1,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='query', full_name='services.search.actions.search.RequestV1.query', index=1,
      number=2, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='category', full_name='services.search.actions.search.RequestV1.category', index=2,
      number=3, type=14, cpp_type=8, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='attribute', full_name='services.search.actions.search.RequestV1.attribute', index=3,
      number=4, type=14, cpp_type=8, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='attribute_value', full_name='services.search.actions.search.RequestV1.attribute_value', index=4,
      number=5, type=9, cpp_type=9, label=1,
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
  syntax='proto2',
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=178,
  serialized_end=381,
)


_RESPONSEV1 = _descriptor.Descriptor(
  name='ResponseV1',
  full_name='services.search.actions.search.ResponseV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='version', full_name='services.search.actions.search.ResponseV1.version', index=0,
      number=1, type=13, cpp_type=3, label=1,
      has_default_value=True, default_value=1,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='results', full_name='services.search.actions.search.ResponseV1.results', index=1,
      number=2, type=11, cpp_type=10, label=3,
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
  syntax='proto2',
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=383,
  serialized_end=476,
)


_REQUESTV2 = _descriptor.Descriptor(
  name='RequestV2',
  full_name='services.search.actions.search.RequestV2',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='version', full_name='services.search.actions.search.RequestV2.version', index=0,
      number=1, type=13, cpp_type=3, label=1,
      has_default_value=True, default_value=2,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='query', full_name='services.search.actions.search.RequestV2.query', index=1,
      number=2, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='category', full_name='services.search.actions.search.RequestV2.category', index=2,
      number=3, type=14, cpp_type=8, label=1,
      has_default_value=False, default_value=0,
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
  syntax='proto2',
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=478,
  serialized_end=589,
)


_RESPONSEV2 = _descriptor.Descriptor(
  name='ResponseV2',
  full_name='services.search.actions.search.ResponseV2',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='version', full_name='services.search.actions.search.ResponseV2.version', index=0,
      number=1, type=13, cpp_type=3, label=1,
      has_default_value=True, default_value=2,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='results', full_name='services.search.actions.search.ResponseV2.results', index=1,
      number=2, type=11, cpp_type=10, label=3,
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
  syntax='proto2',
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=591,
  serialized_end=684,
)

_REQUESTV1.fields_by_name['category'].enum_type = protobufs_dot_services_dot_search_dot_containers_dot_search__pb2._CATEGORYV1
_REQUESTV1.fields_by_name['attribute'].enum_type = protobufs_dot_services_dot_search_dot_containers_dot_search__pb2._ATTRIBUTEV1
_RESPONSEV1.fields_by_name['results'].message_type = protobufs_dot_services_dot_search_dot_containers__pb2._SEARCHRESULTV1
_REQUESTV2.fields_by_name['category'].enum_type = protobufs_dot_services_dot_search_dot_containers_dot_search__pb2._CATEGORYV1
_RESPONSEV2.fields_by_name['results'].message_type = protobufs_dot_services_dot_search_dot_containers__pb2._SEARCHRESULTV1
DESCRIPTOR.message_types_by_name['RequestV1'] = _REQUESTV1
DESCRIPTOR.message_types_by_name['ResponseV1'] = _RESPONSEV1
DESCRIPTOR.message_types_by_name['RequestV2'] = _REQUESTV2
DESCRIPTOR.message_types_by_name['ResponseV2'] = _RESPONSEV2

RequestV1 = _reflection.GeneratedProtocolMessageType('RequestV1', (_message.Message,), dict(
  DESCRIPTOR = _REQUESTV1,
  __module__ = 'protobufs.services.search.actions.search_pb2'
  # @@protoc_insertion_point(class_scope:services.search.actions.search.RequestV1)
  ))
_sym_db.RegisterMessage(RequestV1)

ResponseV1 = _reflection.GeneratedProtocolMessageType('ResponseV1', (_message.Message,), dict(
  DESCRIPTOR = _RESPONSEV1,
  __module__ = 'protobufs.services.search.actions.search_pb2'
  # @@protoc_insertion_point(class_scope:services.search.actions.search.ResponseV1)
  ))
_sym_db.RegisterMessage(ResponseV1)

RequestV2 = _reflection.GeneratedProtocolMessageType('RequestV2', (_message.Message,), dict(
  DESCRIPTOR = _REQUESTV2,
  __module__ = 'protobufs.services.search.actions.search_pb2'
  # @@protoc_insertion_point(class_scope:services.search.actions.search.RequestV2)
  ))
_sym_db.RegisterMessage(RequestV2)

ResponseV2 = _reflection.GeneratedProtocolMessageType('ResponseV2', (_message.Message,), dict(
  DESCRIPTOR = _RESPONSEV2,
  __module__ = 'protobufs.services.search.actions.search_pb2'
  # @@protoc_insertion_point(class_scope:services.search.actions.search.ResponseV2)
  ))
_sym_db.RegisterMessage(ResponseV2)


DESCRIPTOR.has_options = True
DESCRIPTOR._options = _descriptor._ParseOptions(descriptor_pb2.FileOptions(), _b('\n3com.rhlabs.protobufs.services.search.actions.search'))
# @@protoc_insertion_point(module_scope)
