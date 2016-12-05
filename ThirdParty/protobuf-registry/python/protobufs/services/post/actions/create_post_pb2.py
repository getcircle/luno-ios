# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: protobufs/services/post/actions/create_post.proto

from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import symbol_database as _symbol_database
from google.protobuf import descriptor_pb2
# @@protoc_insertion_point(imports)

_sym_db = _symbol_database.Default()


from protobufs.services.post import containers_pb2 as protobufs_dot_services_dot_post_dot_containers__pb2


DESCRIPTOR = _descriptor.FileDescriptor(
  name='protobufs/services/post/actions/create_post.proto',
  package='services.post.actions.create_post',
  syntax='proto3',
  serialized_pb=b'\n1protobufs/services/post/actions/create_post.proto\x12!services.post.actions.create_post\x1a(protobufs/services/post/containers.proto\";\n\tRequestV1\x12.\n\x04post\x18\x01 \x01(\x0b\x32 .services.post.containers.PostV1\"<\n\nResponseV1\x12.\n\x04post\x18\x01 \x01(\x0b\x32 .services.post.containers.PostV1b\x06proto3'
  ,
  dependencies=[protobufs_dot_services_dot_post_dot_containers__pb2.DESCRIPTOR,])
_sym_db.RegisterFileDescriptor(DESCRIPTOR)




_REQUESTV1 = _descriptor.Descriptor(
  name='RequestV1',
  full_name='services.post.actions.create_post.RequestV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='post', full_name='services.post.actions.create_post.RequestV1.post', index=0,
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
  serialized_start=130,
  serialized_end=189,
)


_RESPONSEV1 = _descriptor.Descriptor(
  name='ResponseV1',
  full_name='services.post.actions.create_post.ResponseV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='post', full_name='services.post.actions.create_post.ResponseV1.post', index=0,
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
  serialized_start=191,
  serialized_end=251,
)

_REQUESTV1.fields_by_name['post'].message_type = protobufs_dot_services_dot_post_dot_containers__pb2._POSTV1
_RESPONSEV1.fields_by_name['post'].message_type = protobufs_dot_services_dot_post_dot_containers__pb2._POSTV1
DESCRIPTOR.message_types_by_name['RequestV1'] = _REQUESTV1
DESCRIPTOR.message_types_by_name['ResponseV1'] = _RESPONSEV1

RequestV1 = _reflection.GeneratedProtocolMessageType('RequestV1', (_message.Message,), dict(
  DESCRIPTOR = _REQUESTV1,
  __module__ = 'protobufs.services.post.actions.create_post_pb2'
  # @@protoc_insertion_point(class_scope:services.post.actions.create_post.RequestV1)
  ))
_sym_db.RegisterMessage(RequestV1)

ResponseV1 = _reflection.GeneratedProtocolMessageType('ResponseV1', (_message.Message,), dict(
  DESCRIPTOR = _RESPONSEV1,
  __module__ = 'protobufs.services.post.actions.create_post_pb2'
  # @@protoc_insertion_point(class_scope:services.post.actions.create_post.ResponseV1)
  ))
_sym_db.RegisterMessage(ResponseV1)


# @@protoc_insertion_point(module_scope)
