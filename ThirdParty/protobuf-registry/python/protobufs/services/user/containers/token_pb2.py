# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: protobufs/services/user/containers/token.proto

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
  name='protobufs/services/user/containers/token.proto',
  package='services.user.containers.token',
  serialized_pb=_b('\n.protobufs/services/user/containers/token.proto\x12\x1eservices.user.containers.token*6\n\x0c\x43lientTypeV1\x12\x07\n\x03IOS\x10\x00\x12\x0b\n\x07\x41NDROID\x10\x01\x12\x07\n\x03WEB\x10\x02\x12\x07\n\x03\x41PI\x10\x03\x42\x35\n3com.rhlabs.protobufs.services.user.containers.token')
)
_sym_db.RegisterFileDescriptor(DESCRIPTOR)

_CLIENTTYPEV1 = _descriptor.EnumDescriptor(
  name='ClientTypeV1',
  full_name='services.user.containers.token.ClientTypeV1',
  filename=None,
  file=DESCRIPTOR,
  values=[
    _descriptor.EnumValueDescriptor(
      name='IOS', index=0, number=0,
      options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='ANDROID', index=1, number=1,
      options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='WEB', index=2, number=2,
      options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='API', index=3, number=3,
      options=None,
      type=None),
  ],
  containing_type=None,
  options=None,
  serialized_start=82,
  serialized_end=136,
)
_sym_db.RegisterEnumDescriptor(_CLIENTTYPEV1)

ClientTypeV1 = enum_type_wrapper.EnumTypeWrapper(_CLIENTTYPEV1)
IOS = 0
ANDROID = 1
WEB = 2
API = 3


DESCRIPTOR.enum_types_by_name['ClientTypeV1'] = _CLIENTTYPEV1


DESCRIPTOR.has_options = True
DESCRIPTOR._options = _descriptor._ParseOptions(descriptor_pb2.FileOptions(), _b('\n3com.rhlabs.protobufs.services.user.containers.token'))
# @@protoc_insertion_point(module_scope)
