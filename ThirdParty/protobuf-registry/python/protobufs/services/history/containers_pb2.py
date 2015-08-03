# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: protobufs/services/history/containers.proto

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
  name='protobufs/services/history/containers.proto',
  package='services.history.containers',
  serialized_pb=_b('\n+protobufs/services/history/containers.proto\x12\x1bservices.history.containers\"\xc0\x02\n\x08\x41\x63tionV1\x12\x12\n\x07version\x18\x01 \x01(\r:\x01\x31\x12\n\n\x02id\x18\x02 \x01(\t\x12\x13\n\x0b\x63olumn_name\x18\x03 \x01(\t\x12\x11\n\tdata_type\x18\x04 \x01(\t\x12\x11\n\told_value\x18\x05 \x01(\t\x12\x11\n\tnew_value\x18\x06 \x01(\t\x12>\n\x0b\x61\x63tion_type\x18\x07 \x01(\x0e\x32).services.history.containers.ActionTypeV1\x12>\n\x0bmethod_type\x18\x08 \x01(\x0e\x32).services.history.containers.MethodTypeV1\x12\x17\n\x0forganization_id\x18\t \x01(\t\x12\x16\n\x0e\x63orrelation_id\x18\n \x01(\t\x12\x15\n\rby_profile_id\x18\x0b \x01(\t*&\n\x0c\x41\x63tionTypeV1\x12\x16\n\x12UPDATE_DESCRIPTION\x10\x00*&\n\x0cMethodTypeV1\x12\n\n\x06UPDATE\x10\x00\x12\n\n\x06\x44\x45LETE\x10\x01')
)
_sym_db.RegisterFileDescriptor(DESCRIPTOR)

_ACTIONTYPEV1 = _descriptor.EnumDescriptor(
  name='ActionTypeV1',
  full_name='services.history.containers.ActionTypeV1',
  filename=None,
  file=DESCRIPTOR,
  values=[
    _descriptor.EnumValueDescriptor(
      name='UPDATE_DESCRIPTION', index=0, number=0,
      options=None,
      type=None),
  ],
  containing_type=None,
  options=None,
  serialized_start=399,
  serialized_end=437,
)
_sym_db.RegisterEnumDescriptor(_ACTIONTYPEV1)

ActionTypeV1 = enum_type_wrapper.EnumTypeWrapper(_ACTIONTYPEV1)
_METHODTYPEV1 = _descriptor.EnumDescriptor(
  name='MethodTypeV1',
  full_name='services.history.containers.MethodTypeV1',
  filename=None,
  file=DESCRIPTOR,
  values=[
    _descriptor.EnumValueDescriptor(
      name='UPDATE', index=0, number=0,
      options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='DELETE', index=1, number=1,
      options=None,
      type=None),
  ],
  containing_type=None,
  options=None,
  serialized_start=439,
  serialized_end=477,
)
_sym_db.RegisterEnumDescriptor(_METHODTYPEV1)

MethodTypeV1 = enum_type_wrapper.EnumTypeWrapper(_METHODTYPEV1)
UPDATE_DESCRIPTION = 0
UPDATE = 0
DELETE = 1



_ACTIONV1 = _descriptor.Descriptor(
  name='ActionV1',
  full_name='services.history.containers.ActionV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='version', full_name='services.history.containers.ActionV1.version', index=0,
      number=1, type=13, cpp_type=3, label=1,
      has_default_value=True, default_value=1,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='id', full_name='services.history.containers.ActionV1.id', index=1,
      number=2, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='column_name', full_name='services.history.containers.ActionV1.column_name', index=2,
      number=3, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='data_type', full_name='services.history.containers.ActionV1.data_type', index=3,
      number=4, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='old_value', full_name='services.history.containers.ActionV1.old_value', index=4,
      number=5, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='new_value', full_name='services.history.containers.ActionV1.new_value', index=5,
      number=6, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='action_type', full_name='services.history.containers.ActionV1.action_type', index=6,
      number=7, type=14, cpp_type=8, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='method_type', full_name='services.history.containers.ActionV1.method_type', index=7,
      number=8, type=14, cpp_type=8, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='organization_id', full_name='services.history.containers.ActionV1.organization_id', index=8,
      number=9, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='correlation_id', full_name='services.history.containers.ActionV1.correlation_id', index=9,
      number=10, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='by_profile_id', full_name='services.history.containers.ActionV1.by_profile_id', index=10,
      number=11, type=9, cpp_type=9, label=1,
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
  serialized_start=77,
  serialized_end=397,
)

_ACTIONV1.fields_by_name['action_type'].enum_type = _ACTIONTYPEV1
_ACTIONV1.fields_by_name['method_type'].enum_type = _METHODTYPEV1
DESCRIPTOR.message_types_by_name['ActionV1'] = _ACTIONV1
DESCRIPTOR.enum_types_by_name['ActionTypeV1'] = _ACTIONTYPEV1
DESCRIPTOR.enum_types_by_name['MethodTypeV1'] = _METHODTYPEV1

ActionV1 = _reflection.GeneratedProtocolMessageType('ActionV1', (_message.Message,), dict(
  DESCRIPTOR = _ACTIONV1,
  __module__ = 'protobufs.services.history.containers_pb2'
  # @@protoc_insertion_point(class_scope:services.history.containers.ActionV1)
  ))
_sym_db.RegisterMessage(ActionV1)


# @@protoc_insertion_point(module_scope)
