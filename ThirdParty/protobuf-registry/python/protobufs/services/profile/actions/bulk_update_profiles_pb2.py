# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: protobufs/services/profile/actions/bulk_update_profiles.proto

import sys
_b=sys.version_info[0]<3 and (lambda x:x) or (lambda x:x.encode('latin1'))
from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import symbol_database as _symbol_database
from google.protobuf import descriptor_pb2
# @@protoc_insertion_point(imports)

_sym_db = _symbol_database.Default()


import protobufs.services.profile.containers_pb2


DESCRIPTOR = _descriptor.FileDescriptor(
  name='protobufs/services/profile/actions/bulk_update_profiles.proto',
  package='services.profile.actions.bulk_update_profiles',
  serialized_pb=_b('\n=protobufs/services/profile/actions/bulk_update_profiles.proto\x12-services.profile.actions.bulk_update_profiles\x1a+protobufs/services/profile/containers.proto\"Y\n\tRequestV1\x12\x12\n\x07version\x18\x01 \x01(\r:\x01\x31\x12\x38\n\x08profiles\x18\x02 \x03(\x0b\x32&.services.profile.containers.ProfileV1\"Z\n\nResponseV1\x12\x12\n\x07version\x18\x01 \x01(\r:\x01\x31\x12\x38\n\x08profiles\x18\x02 \x03(\x0b\x32&.services.profile.containers.ProfileV1BD\nBcom.rhlabs.protobufs.services.profile.actions.bulk_update_profiles')
  ,
  dependencies=[protobufs.services.profile.containers_pb2.DESCRIPTOR,])
_sym_db.RegisterFileDescriptor(DESCRIPTOR)




_REQUESTV1 = _descriptor.Descriptor(
  name='RequestV1',
  full_name='services.profile.actions.bulk_update_profiles.RequestV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='version', full_name='services.profile.actions.bulk_update_profiles.RequestV1.version', index=0,
      number=1, type=13, cpp_type=3, label=1,
      has_default_value=True, default_value=1,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='profiles', full_name='services.profile.actions.bulk_update_profiles.RequestV1.profiles', index=1,
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
  serialized_start=157,
  serialized_end=246,
)


_RESPONSEV1 = _descriptor.Descriptor(
  name='ResponseV1',
  full_name='services.profile.actions.bulk_update_profiles.ResponseV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='version', full_name='services.profile.actions.bulk_update_profiles.ResponseV1.version', index=0,
      number=1, type=13, cpp_type=3, label=1,
      has_default_value=True, default_value=1,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='profiles', full_name='services.profile.actions.bulk_update_profiles.ResponseV1.profiles', index=1,
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
  serialized_start=248,
  serialized_end=338,
)

_REQUESTV1.fields_by_name['profiles'].message_type = protobufs.services.profile.containers_pb2._PROFILEV1
_RESPONSEV1.fields_by_name['profiles'].message_type = protobufs.services.profile.containers_pb2._PROFILEV1
DESCRIPTOR.message_types_by_name['RequestV1'] = _REQUESTV1
DESCRIPTOR.message_types_by_name['ResponseV1'] = _RESPONSEV1

RequestV1 = _reflection.GeneratedProtocolMessageType('RequestV1', (_message.Message,), dict(
  DESCRIPTOR = _REQUESTV1,
  __module__ = 'protobufs.services.profile.actions.bulk_update_profiles_pb2'
  # @@protoc_insertion_point(class_scope:services.profile.actions.bulk_update_profiles.RequestV1)
  ))
_sym_db.RegisterMessage(RequestV1)

ResponseV1 = _reflection.GeneratedProtocolMessageType('ResponseV1', (_message.Message,), dict(
  DESCRIPTOR = _RESPONSEV1,
  __module__ = 'protobufs.services.profile.actions.bulk_update_profiles_pb2'
  # @@protoc_insertion_point(class_scope:services.profile.actions.bulk_update_profiles.ResponseV1)
  ))
_sym_db.RegisterMessage(ResponseV1)


DESCRIPTOR.has_options = True
DESCRIPTOR._options = _descriptor._ParseOptions(descriptor_pb2.FileOptions(), _b('\nBcom.rhlabs.protobufs.services.profile.actions.bulk_update_profiles'))
# @@protoc_insertion_point(module_scope)
