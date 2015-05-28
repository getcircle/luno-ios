# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: protobufs/services/common/containers.proto

import sys
_b=sys.version_info[0]<3 and (lambda x:x) or (lambda x:x.encode('latin1'))
from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import symbol_database as _symbol_database
from google.protobuf import descriptor_pb2
# @@protoc_insertion_point(imports)

_sym_db = _symbol_database.Default()




DESCRIPTOR = _descriptor.FileDescriptor(
  name='protobufs/services/common/containers.proto',
  package='services.common.containers',
  serialized_pb=_b('\n*protobufs/services/common/containers.proto\x12\x1aservices.common.containers\"<\n\nKeyValueV1\x12\x12\n\x07version\x18\x01 \x01(\r:\x01\x31\x12\x0b\n\x03key\x18\x02 \x01(\t\x12\r\n\x05value\x18\x03 \x01(\t\"T\n\x05MapV1\x12\x12\n\x07version\x18\x01 \x01(\r:\x01\x31\x12\x37\n\x07\x63ontent\x18\x02 \x03(\x0b\x32&.services.common.containers.KeyValueV1B1\n/com.rhlabs.protobufs.services.common.containers')
)
_sym_db.RegisterFileDescriptor(DESCRIPTOR)




_KEYVALUEV1 = _descriptor.Descriptor(
  name='KeyValueV1',
  full_name='services.common.containers.KeyValueV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='version', full_name='services.common.containers.KeyValueV1.version', index=0,
      number=1, type=13, cpp_type=3, label=1,
      has_default_value=True, default_value=1,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='key', full_name='services.common.containers.KeyValueV1.key', index=1,
      number=2, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='value', full_name='services.common.containers.KeyValueV1.value', index=2,
      number=3, type=9, cpp_type=9, label=1,
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
  serialized_start=74,
  serialized_end=134,
)


_MAPV1 = _descriptor.Descriptor(
  name='MapV1',
  full_name='services.common.containers.MapV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='version', full_name='services.common.containers.MapV1.version', index=0,
      number=1, type=13, cpp_type=3, label=1,
      has_default_value=True, default_value=1,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='content', full_name='services.common.containers.MapV1.content', index=1,
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
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=136,
  serialized_end=220,
)

_MAPV1.fields_by_name['content'].message_type = _KEYVALUEV1
DESCRIPTOR.message_types_by_name['KeyValueV1'] = _KEYVALUEV1
DESCRIPTOR.message_types_by_name['MapV1'] = _MAPV1

KeyValueV1 = _reflection.GeneratedProtocolMessageType('KeyValueV1', (_message.Message,), dict(
  DESCRIPTOR = _KEYVALUEV1,
  __module__ = 'protobufs.services.common.containers_pb2'
  # @@protoc_insertion_point(class_scope:services.common.containers.KeyValueV1)
  ))
_sym_db.RegisterMessage(KeyValueV1)

MapV1 = _reflection.GeneratedProtocolMessageType('MapV1', (_message.Message,), dict(
  DESCRIPTOR = _MAPV1,
  __module__ = 'protobufs.services.common.containers_pb2'
  # @@protoc_insertion_point(class_scope:services.common.containers.MapV1)
  ))
_sym_db.RegisterMessage(MapV1)


DESCRIPTOR.has_options = True
DESCRIPTOR._options = _descriptor._ParseOptions(descriptor_pb2.FileOptions(), _b('\n/com.rhlabs.protobufs.services.common.containers'))
# @@protoc_insertion_point(module_scope)