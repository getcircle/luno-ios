# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: protobufs/services/registry/all.proto

import sys
_b=sys.version_info[0]<3 and (lambda x:x) or (lambda x:x.encode('latin1'))
from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import symbol_database as _symbol_database
from google.protobuf import descriptor_pb2
# @@protoc_insertion_point(imports)

_sym_db = _symbol_database.Default()


from protobufs.services.registry import requests_pb2 as protobufs_dot_services_dot_registry_dot_requests__pb2
from protobufs.services.registry import responses_pb2 as protobufs_dot_services_dot_registry_dot_responses__pb2


DESCRIPTOR = _descriptor.FileDescriptor(
  name='protobufs/services/registry/all.proto',
  package='services.registry',
  syntax='proto2',
  serialized_pb=_b('\n%protobufs/services/registry/all.proto\x12\x11services.registry\x1a*protobufs/services/registry/requests.proto\x1a+protobufs/services/registry/responses.protoB(\n&com.rhlabs.protobufs.services.registry')
  ,
  dependencies=[protobufs_dot_services_dot_registry_dot_requests__pb2.DESCRIPTOR,protobufs_dot_services_dot_registry_dot_responses__pb2.DESCRIPTOR,])
_sym_db.RegisterFileDescriptor(DESCRIPTOR)





DESCRIPTOR.has_options = True
DESCRIPTOR._options = _descriptor._ParseOptions(descriptor_pb2.FileOptions(), _b('\n&com.rhlabs.protobufs.services.registry'))
# @@protoc_insertion_point(module_scope)
