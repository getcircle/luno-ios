# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: protobufs/services/media/actions/complete_image_upload.proto

import sys
_b=sys.version_info[0]<3 and (lambda x:x) or (lambda x:x.encode('latin1'))
from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import symbol_database as _symbol_database
from google.protobuf import descriptor_pb2
# @@protoc_insertion_point(imports)

_sym_db = _symbol_database.Default()


import protobufs.services.media.containers.media_pb2


DESCRIPTOR = _descriptor.FileDescriptor(
  name='protobufs/services/media/actions/complete_image_upload.proto',
  package='services.media.actions.complete_image_upload',
  serialized_pb=_b('\n<protobufs/services/media/actions/complete_image_upload.proto\x12,services.media.actions.complete_image_upload\x1a/protobufs/services/media/containers/media.proto\"\x9b\x01\n\tRequestV1\x12\x12\n\x07version\x18\x01 \x01(\r:\x01\x31\x12@\n\nmedia_type\x18\x02 \x01(\x0e\x32,.services.media.containers.media.MediaTypeV1\x12\x11\n\tmedia_key\x18\x03 \x01(\t\x12\x12\n\nupload_key\x18\x04 \x01(\t\x12\x11\n\tupload_id\x18\x05 \x01(\t\"3\n\nResponseV1\x12\x12\n\x07version\x18\x01 \x01(\r:\x01\x31\x12\x11\n\tmedia_url\x18\x02 \x01(\t')
  ,
  dependencies=[protobufs.services.media.containers.media_pb2.DESCRIPTOR,])
_sym_db.RegisterFileDescriptor(DESCRIPTOR)




_REQUESTV1 = _descriptor.Descriptor(
  name='RequestV1',
  full_name='services.media.actions.complete_image_upload.RequestV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='version', full_name='services.media.actions.complete_image_upload.RequestV1.version', index=0,
      number=1, type=13, cpp_type=3, label=1,
      has_default_value=True, default_value=1,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='media_type', full_name='services.media.actions.complete_image_upload.RequestV1.media_type', index=1,
      number=2, type=14, cpp_type=8, label=1,
      has_default_value=False, default_value=1,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='media_key', full_name='services.media.actions.complete_image_upload.RequestV1.media_key', index=2,
      number=3, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='upload_key', full_name='services.media.actions.complete_image_upload.RequestV1.upload_key', index=3,
      number=4, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='upload_id', full_name='services.media.actions.complete_image_upload.RequestV1.upload_id', index=4,
      number=5, type=9, cpp_type=9, label=1,
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
  serialized_start=160,
  serialized_end=315,
)


_RESPONSEV1 = _descriptor.Descriptor(
  name='ResponseV1',
  full_name='services.media.actions.complete_image_upload.ResponseV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='version', full_name='services.media.actions.complete_image_upload.ResponseV1.version', index=0,
      number=1, type=13, cpp_type=3, label=1,
      has_default_value=True, default_value=1,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='media_url', full_name='services.media.actions.complete_image_upload.ResponseV1.media_url', index=1,
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
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=317,
  serialized_end=368,
)

_REQUESTV1.fields_by_name['media_type'].enum_type = protobufs.services.media.containers.media_pb2._MEDIATYPEV1
DESCRIPTOR.message_types_by_name['RequestV1'] = _REQUESTV1
DESCRIPTOR.message_types_by_name['ResponseV1'] = _RESPONSEV1

RequestV1 = _reflection.GeneratedProtocolMessageType('RequestV1', (_message.Message,), dict(
  DESCRIPTOR = _REQUESTV1,
  __module__ = 'protobufs.services.media.actions.complete_image_upload_pb2'
  # @@protoc_insertion_point(class_scope:services.media.actions.complete_image_upload.RequestV1)
  ))
_sym_db.RegisterMessage(RequestV1)

ResponseV1 = _reflection.GeneratedProtocolMessageType('ResponseV1', (_message.Message,), dict(
  DESCRIPTOR = _RESPONSEV1,
  __module__ = 'protobufs.services.media.actions.complete_image_upload_pb2'
  # @@protoc_insertion_point(class_scope:services.media.actions.complete_image_upload.ResponseV1)
  ))
_sym_db.RegisterMessage(ResponseV1)


# @@protoc_insertion_point(module_scope)