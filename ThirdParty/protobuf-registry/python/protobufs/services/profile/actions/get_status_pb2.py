# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: protobufs/services/profile/actions/get_status.proto

import sys
_b=sys.version_info[0]<3 and (lambda x:x) or (lambda x:x.encode('latin1'))
from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import symbol_database as _symbol_database
from google.protobuf import descriptor_pb2
# @@protoc_insertion_point(imports)

_sym_db = _symbol_database.Default()


from protobufs.services.profile import containers_pb2 as protobufs_dot_services_dot_profile_dot_containers__pb2


DESCRIPTOR = _descriptor.FileDescriptor(
  name='protobufs/services/profile/actions/get_status.proto',
  package='services.profile.actions.get_status',
  syntax='proto2',
  serialized_pb=_b('\n3protobufs/services/profile/actions/get_status.proto\x12#services.profile.actions.get_status\x1a+protobufs/services/profile/containers.proto\"+\n\tRequestV1\x12\x12\n\x07version\x18\x01 \x01(\r:\x01\x31\x12\n\n\x02id\x18\x02 \x01(\t\"^\n\nResponseV1\x12\x12\n\x07version\x18\x01 \x01(\r:\x01\x31\x12<\n\x06status\x18\x02 \x01(\x0b\x32,.services.profile.containers.ProfileStatusV1')
  ,
  dependencies=[protobufs_dot_services_dot_profile_dot_containers__pb2.DESCRIPTOR,])
_sym_db.RegisterFileDescriptor(DESCRIPTOR)




_REQUESTV1 = _descriptor.Descriptor(
  name='RequestV1',
  full_name='services.profile.actions.get_status.RequestV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='version', full_name='services.profile.actions.get_status.RequestV1.version', index=0,
      number=1, type=13, cpp_type=3, label=1,
      has_default_value=True, default_value=1,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='id', full_name='services.profile.actions.get_status.RequestV1.id', index=1,
      number=2, type=9, cpp_type=9, label=1,
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
  serialized_start=137,
  serialized_end=180,
)


_RESPONSEV1 = _descriptor.Descriptor(
  name='ResponseV1',
  full_name='services.profile.actions.get_status.ResponseV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='version', full_name='services.profile.actions.get_status.ResponseV1.version', index=0,
      number=1, type=13, cpp_type=3, label=1,
      has_default_value=True, default_value=1,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='status', full_name='services.profile.actions.get_status.ResponseV1.status', index=1,
      number=2, type=11, cpp_type=10, label=1,
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
  syntax='proto2',
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=182,
  serialized_end=276,
)

_RESPONSEV1.fields_by_name['status'].message_type = protobufs_dot_services_dot_profile_dot_containers__pb2._PROFILESTATUSV1
DESCRIPTOR.message_types_by_name['RequestV1'] = _REQUESTV1
DESCRIPTOR.message_types_by_name['ResponseV1'] = _RESPONSEV1

RequestV1 = _reflection.GeneratedProtocolMessageType('RequestV1', (_message.Message,), dict(
  DESCRIPTOR = _REQUESTV1,
  __module__ = 'protobufs.services.profile.actions.get_status_pb2'
  # @@protoc_insertion_point(class_scope:services.profile.actions.get_status.RequestV1)
  ))
_sym_db.RegisterMessage(RequestV1)

ResponseV1 = _reflection.GeneratedProtocolMessageType('ResponseV1', (_message.Message,), dict(
  DESCRIPTOR = _RESPONSEV1,
  __module__ = 'protobufs.services.profile.actions.get_status_pb2'
  # @@protoc_insertion_point(class_scope:services.profile.actions.get_status.ResponseV1)
  ))
_sym_db.RegisterMessage(ResponseV1)


# @@protoc_insertion_point(module_scope)
