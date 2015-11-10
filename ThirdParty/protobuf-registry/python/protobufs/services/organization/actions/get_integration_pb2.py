# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: protobufs/services/organization/actions/get_integration.proto

import sys
_b=sys.version_info[0]<3 and (lambda x:x) or (lambda x:x.encode('latin1'))
from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import symbol_database as _symbol_database
from google.protobuf import descriptor_pb2
# @@protoc_insertion_point(imports)

_sym_db = _symbol_database.Default()


from protobufs.services.organization.containers import integration_pb2 as protobufs_dot_services_dot_organization_dot_containers_dot_integration__pb2


DESCRIPTOR = _descriptor.FileDescriptor(
  name='protobufs/services/organization/actions/get_integration.proto',
  package='services.organization.actions.get_integration',
  syntax='proto2',
  serialized_pb=_b('\n=protobufs/services/organization/actions/get_integration.proto\x12-services.organization.actions.get_integration\x1a<protobufs/services/organization/containers/integration.proto\"\x90\x01\n\tRequestV1\x12\x12\n\x07version\x18\x01 \x01(\r:\x01\x31\x12Y\n\x10integration_type\x18\x02 \x01(\x0e\x32?.services.organization.containers.integration.IntegrationTypeV1\x12\x14\n\x0cprovider_uid\x18\x03 \x01(\t\"r\n\nResponseV1\x12\x12\n\x07version\x18\x01 \x01(\r:\x01\x31\x12P\n\x0bintegration\x18\x02 \x01(\x0b\x32;.services.organization.containers.integration.IntegrationV1BD\nBcom.rhlabs.protobufs.services.organization.actions.get_integration')
  ,
  dependencies=[protobufs_dot_services_dot_organization_dot_containers_dot_integration__pb2.DESCRIPTOR,])
_sym_db.RegisterFileDescriptor(DESCRIPTOR)




_REQUESTV1 = _descriptor.Descriptor(
  name='RequestV1',
  full_name='services.organization.actions.get_integration.RequestV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='version', full_name='services.organization.actions.get_integration.RequestV1.version', index=0,
      number=1, type=13, cpp_type=3, label=1,
      has_default_value=True, default_value=1,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='integration_type', full_name='services.organization.actions.get_integration.RequestV1.integration_type', index=1,
      number=2, type=14, cpp_type=8, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='provider_uid', full_name='services.organization.actions.get_integration.RequestV1.provider_uid', index=2,
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
  syntax='proto2',
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=175,
  serialized_end=319,
)


_RESPONSEV1 = _descriptor.Descriptor(
  name='ResponseV1',
  full_name='services.organization.actions.get_integration.ResponseV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='version', full_name='services.organization.actions.get_integration.ResponseV1.version', index=0,
      number=1, type=13, cpp_type=3, label=1,
      has_default_value=True, default_value=1,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='integration', full_name='services.organization.actions.get_integration.ResponseV1.integration', index=1,
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
  serialized_start=321,
  serialized_end=435,
)

_REQUESTV1.fields_by_name['integration_type'].enum_type = protobufs_dot_services_dot_organization_dot_containers_dot_integration__pb2._INTEGRATIONTYPEV1
_RESPONSEV1.fields_by_name['integration'].message_type = protobufs_dot_services_dot_organization_dot_containers_dot_integration__pb2._INTEGRATIONV1
DESCRIPTOR.message_types_by_name['RequestV1'] = _REQUESTV1
DESCRIPTOR.message_types_by_name['ResponseV1'] = _RESPONSEV1

RequestV1 = _reflection.GeneratedProtocolMessageType('RequestV1', (_message.Message,), dict(
  DESCRIPTOR = _REQUESTV1,
  __module__ = 'protobufs.services.organization.actions.get_integration_pb2'
  # @@protoc_insertion_point(class_scope:services.organization.actions.get_integration.RequestV1)
  ))
_sym_db.RegisterMessage(RequestV1)

ResponseV1 = _reflection.GeneratedProtocolMessageType('ResponseV1', (_message.Message,), dict(
  DESCRIPTOR = _RESPONSEV1,
  __module__ = 'protobufs.services.organization.actions.get_integration_pb2'
  # @@protoc_insertion_point(class_scope:services.organization.actions.get_integration.ResponseV1)
  ))
_sym_db.RegisterMessage(ResponseV1)


DESCRIPTOR.has_options = True
DESCRIPTOR._options = _descriptor._ParseOptions(descriptor_pb2.FileOptions(), _b('\nBcom.rhlabs.protobufs.services.organization.actions.get_integration'))
# @@protoc_insertion_point(module_scope)
