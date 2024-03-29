# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: protobufs/services/organization/actions/create_organization.proto

from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import symbol_database as _symbol_database
from google.protobuf import descriptor_pb2
# @@protoc_insertion_point(imports)

_sym_db = _symbol_database.Default()


from protobufs.services.organization import containers_pb2 as protobufs_dot_services_dot_organization_dot_containers__pb2


DESCRIPTOR = _descriptor.FileDescriptor(
  name='protobufs/services/organization/actions/create_organization.proto',
  package='services.organization.actions.create_organization',
  syntax='proto3',
  serialized_pb=b'\nAprotobufs/services/organization/actions/create_organization.proto\x12\x31services.organization.actions.create_organization\x1a\x30protobufs/services/organization/containers.proto\"S\n\tRequestV1\x12\x46\n\x0corganization\x18\x01 \x01(\x0b\x32\x30.services.organization.containers.OrganizationV1\"T\n\nResponseV1\x12\x46\n\x0corganization\x18\x01 \x01(\x0b\x32\x30.services.organization.containers.OrganizationV1b\x06proto3'
  ,
  dependencies=[protobufs_dot_services_dot_organization_dot_containers__pb2.DESCRIPTOR,])
_sym_db.RegisterFileDescriptor(DESCRIPTOR)




_REQUESTV1 = _descriptor.Descriptor(
  name='RequestV1',
  full_name='services.organization.actions.create_organization.RequestV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='organization', full_name='services.organization.actions.create_organization.RequestV1.organization', index=0,
      number=1, type=11, cpp_type=10, label=1,
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
  ],
  serialized_start=170,
  serialized_end=253,
)


_RESPONSEV1 = _descriptor.Descriptor(
  name='ResponseV1',
  full_name='services.organization.actions.create_organization.ResponseV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='organization', full_name='services.organization.actions.create_organization.ResponseV1.organization', index=0,
      number=1, type=11, cpp_type=10, label=1,
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
  ],
  serialized_start=255,
  serialized_end=339,
)

_REQUESTV1.fields_by_name['organization'].message_type = protobufs_dot_services_dot_organization_dot_containers__pb2._ORGANIZATIONV1
_RESPONSEV1.fields_by_name['organization'].message_type = protobufs_dot_services_dot_organization_dot_containers__pb2._ORGANIZATIONV1
DESCRIPTOR.message_types_by_name['RequestV1'] = _REQUESTV1
DESCRIPTOR.message_types_by_name['ResponseV1'] = _RESPONSEV1

RequestV1 = _reflection.GeneratedProtocolMessageType('RequestV1', (_message.Message,), dict(
  DESCRIPTOR = _REQUESTV1,
  __module__ = 'protobufs.services.organization.actions.create_organization_pb2'
  # @@protoc_insertion_point(class_scope:services.organization.actions.create_organization.RequestV1)
  ))
_sym_db.RegisterMessage(RequestV1)

ResponseV1 = _reflection.GeneratedProtocolMessageType('ResponseV1', (_message.Message,), dict(
  DESCRIPTOR = _RESPONSEV1,
  __module__ = 'protobufs.services.organization.actions.create_organization_pb2'
  # @@protoc_insertion_point(class_scope:services.organization.actions.create_organization.ResponseV1)
  ))
_sym_db.RegisterMessage(ResponseV1)


# @@protoc_insertion_point(module_scope)
