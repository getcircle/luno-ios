# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: protobufs/services/group/actions/respond_to_membership_request.proto

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
  name='protobufs/services/group/actions/respond_to_membership_request.proto',
  package='services.group.actions.respond_to_membership_request',
  serialized_pb=_b('\nDprotobufs/services/group/actions/respond_to_membership_request.proto\x12\x34services.group.actions.respond_to_membership_request\"\xd1\x01\n\tRequestV1\x12\x12\n\x07version\x18\x01 \x01(\r:\x01\x31\x12\x12\n\nrequest_id\x18\x02 \x01(\t\x12`\n\x06\x61\x63tion\x18\x03 \x01(\x0e\x32P.services.group.actions.respond_to_membership_request.RequestV1.ResponseActionV1\x12\x0f\n\x07message\x18\x04 \x01(\t\")\n\x10ResponseActionV1\x12\x0b\n\x07\x41PPROVE\x10\x00\x12\x08\n\x04\x44\x45NY\x10\x01\" \n\nResponseV1\x12\x12\n\x07version\x18\x01 \x01(\r:\x01\x31\x42K\nIcom.rhlabs.protobufs.services.group.actions.respond_to_membership_request')
)
_sym_db.RegisterFileDescriptor(DESCRIPTOR)



_REQUESTV1_RESPONSEACTIONV1 = _descriptor.EnumDescriptor(
  name='ResponseActionV1',
  full_name='services.group.actions.respond_to_membership_request.RequestV1.ResponseActionV1',
  filename=None,
  file=DESCRIPTOR,
  values=[
    _descriptor.EnumValueDescriptor(
      name='APPROVE', index=0, number=0,
      options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='DENY', index=1, number=1,
      options=None,
      type=None),
  ],
  containing_type=None,
  options=None,
  serialized_start=295,
  serialized_end=336,
)
_sym_db.RegisterEnumDescriptor(_REQUESTV1_RESPONSEACTIONV1)


_REQUESTV1 = _descriptor.Descriptor(
  name='RequestV1',
  full_name='services.group.actions.respond_to_membership_request.RequestV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='version', full_name='services.group.actions.respond_to_membership_request.RequestV1.version', index=0,
      number=1, type=13, cpp_type=3, label=1,
      has_default_value=True, default_value=1,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='request_id', full_name='services.group.actions.respond_to_membership_request.RequestV1.request_id', index=1,
      number=2, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='action', full_name='services.group.actions.respond_to_membership_request.RequestV1.action', index=2,
      number=3, type=14, cpp_type=8, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='message', full_name='services.group.actions.respond_to_membership_request.RequestV1.message', index=3,
      number=4, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
    _REQUESTV1_RESPONSEACTIONV1,
  ],
  options=None,
  is_extendable=False,
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=127,
  serialized_end=336,
)


_RESPONSEV1 = _descriptor.Descriptor(
  name='ResponseV1',
  full_name='services.group.actions.respond_to_membership_request.ResponseV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='version', full_name='services.group.actions.respond_to_membership_request.ResponseV1.version', index=0,
      number=1, type=13, cpp_type=3, label=1,
      has_default_value=True, default_value=1,
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
  serialized_start=338,
  serialized_end=370,
)

_REQUESTV1.fields_by_name['action'].enum_type = _REQUESTV1_RESPONSEACTIONV1
_REQUESTV1_RESPONSEACTIONV1.containing_type = _REQUESTV1
DESCRIPTOR.message_types_by_name['RequestV1'] = _REQUESTV1
DESCRIPTOR.message_types_by_name['ResponseV1'] = _RESPONSEV1

RequestV1 = _reflection.GeneratedProtocolMessageType('RequestV1', (_message.Message,), dict(
  DESCRIPTOR = _REQUESTV1,
  __module__ = 'protobufs.services.group.actions.respond_to_membership_request_pb2'
  # @@protoc_insertion_point(class_scope:services.group.actions.respond_to_membership_request.RequestV1)
  ))
_sym_db.RegisterMessage(RequestV1)

ResponseV1 = _reflection.GeneratedProtocolMessageType('ResponseV1', (_message.Message,), dict(
  DESCRIPTOR = _RESPONSEV1,
  __module__ = 'protobufs.services.group.actions.respond_to_membership_request_pb2'
  # @@protoc_insertion_point(class_scope:services.group.actions.respond_to_membership_request.ResponseV1)
  ))
_sym_db.RegisterMessage(ResponseV1)


DESCRIPTOR.has_options = True
DESCRIPTOR._options = _descriptor._ParseOptions(descriptor_pb2.FileOptions(), _b('\nIcom.rhlabs.protobufs.services.group.actions.respond_to_membership_request'))
# @@protoc_insertion_point(module_scope)