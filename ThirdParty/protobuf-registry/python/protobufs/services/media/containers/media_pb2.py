# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: protobufs/services/media/containers/media.proto

import sys
_b=sys.version_info[0]<3 and (lambda x:x) or (lambda x:x.encode('latin1'))
from google.protobuf.internal import enum_type_wrapper
from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import symbol_database as _symbol_database
from google.protobuf import descriptor_pb2
# @@protoc_insertion_point(imports)

_sym_db = _symbol_database.Default()




DESCRIPTOR = _descriptor.FileDescriptor(
  name='protobufs/services/media/containers/media.proto',
  package='services.media.containers.media',
  serialized_pb=_b('\n/protobufs/services/media/containers/media.proto\x12\x1fservices.media.containers.media*\x1a\n\x0bMediaTypeV1\x12\x0b\n\x07PROFILE\x10\x01')
)
_sym_db.RegisterFileDescriptor(DESCRIPTOR)

_MEDIATYPEV1 = _descriptor.EnumDescriptor(
  name='MediaTypeV1',
  full_name='services.media.containers.media.MediaTypeV1',
  filename=None,
  file=DESCRIPTOR,
  values=[
    _descriptor.EnumValueDescriptor(
      name='PROFILE', index=0, number=1,
      options=None,
      type=None),
  ],
  containing_type=None,
  options=None,
  serialized_start=84,
  serialized_end=110,
)
_sym_db.RegisterEnumDescriptor(_MEDIATYPEV1)

MediaTypeV1 = enum_type_wrapper.EnumTypeWrapper(_MEDIATYPEV1)
PROFILE = 1


DESCRIPTOR.enum_types_by_name['MediaTypeV1'] = _MEDIATYPEV1


# @@protoc_insertion_point(module_scope)