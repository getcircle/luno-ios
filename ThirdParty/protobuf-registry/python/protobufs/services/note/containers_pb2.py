# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: protobufs/services/note/containers.proto

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
  name='protobufs/services/note/containers.proto',
  package='services.note.containers',
  serialized_pb=_b('\n(protobufs/services/note/containers.proto\x12\x18services.note.containers\"\x8d\x01\n\x06NoteV1\x12\x12\n\x07version\x18\x01 \x01(\r:\x01\x31\x12\n\n\x02id\x18\x02 \x01(\t\x12\x16\n\x0e\x66or_profile_id\x18\x03 \x01(\t\x12\x18\n\x10owner_profile_id\x18\x04 \x01(\t\x12\x0f\n\x07\x63ontent\x18\x05 \x01(\t\x12\x0f\n\x07\x63reated\x18\x06 \x01(\t\x12\x0f\n\x07\x63hanged\x18\x07 \x01(\t')
)
_sym_db.RegisterFileDescriptor(DESCRIPTOR)




_NOTEV1 = _descriptor.Descriptor(
  name='NoteV1',
  full_name='services.note.containers.NoteV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='version', full_name='services.note.containers.NoteV1.version', index=0,
      number=1, type=13, cpp_type=3, label=1,
      has_default_value=True, default_value=1,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='id', full_name='services.note.containers.NoteV1.id', index=1,
      number=2, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='for_profile_id', full_name='services.note.containers.NoteV1.for_profile_id', index=2,
      number=3, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='owner_profile_id', full_name='services.note.containers.NoteV1.owner_profile_id', index=3,
      number=4, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='content', full_name='services.note.containers.NoteV1.content', index=4,
      number=5, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='created', full_name='services.note.containers.NoteV1.created', index=5,
      number=6, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='changed', full_name='services.note.containers.NoteV1.changed', index=6,
      number=7, type=9, cpp_type=9, label=1,
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
  serialized_start=71,
  serialized_end=212,
)

DESCRIPTOR.message_types_by_name['NoteV1'] = _NOTEV1

NoteV1 = _reflection.GeneratedProtocolMessageType('NoteV1', (_message.Message,), dict(
  DESCRIPTOR = _NOTEV1,
  __module__ = 'protobufs.services.note.containers_pb2'
  # @@protoc_insertion_point(class_scope:services.note.containers.NoteV1)
  ))
_sym_db.RegisterMessage(NoteV1)


# @@protoc_insertion_point(module_scope)
