# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: protobufs/services/profile/actions/get_extended_profile.proto

import sys
_b=sys.version_info[0]<3 and (lambda x:x) or (lambda x:x.encode('latin1'))
from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import symbol_database as _symbol_database
from google.protobuf import descriptor_pb2
# @@protoc_insertion_point(imports)

_sym_db = _symbol_database.Default()


import protobufs.services.note.containers_pb2
import protobufs.services.organization.containers_pb2
import protobufs.services.profile.containers_pb2
import protobufs.services.resume.containers_pb2
import protobufs.services.user.containers_pb2


DESCRIPTOR = _descriptor.FileDescriptor(
  name='protobufs/services/profile/actions/get_extended_profile.proto',
  package='services.profile.actions.get_extended_profile',
  serialized_pb=_b('\n=protobufs/services/profile/actions/get_extended_profile.proto\x12-services.profile.actions.get_extended_profile\x1a(protobufs/services/note/containers.proto\x1a\x30protobufs/services/organization/containers.proto\x1a+protobufs/services/profile/containers.proto\x1a*protobufs/services/resume/containers.proto\x1a(protobufs/services/user/containers.proto\"D\n\tRequestV1\x12\x12\n\x07version\x18\x01 \x01(\r:\x01\x31\x12\x12\n\nprofile_id\x18\x02 \x01(\t\x12\x0f\n\x07user_id\x18\x03 \x01(\t\"\x94\x05\n\nResponseV1\x12\x12\n\x07version\x18\x01 \x01(\r:\x01\x31\x12\x37\n\x07profile\x18\x02 \x01(\x0b\x32&.services.profile.containers.ProfileV1\x12<\n\x07\x61\x64\x64ress\x18\x03 \x01(\x0b\x32+.services.organization.containers.AddressV1\x12\x37\n\x07manager\x18\x04 \x01(\x0b\x32&.services.profile.containers.ProfileV1\x12\x36\n\x04team\x18\x05 \x01(\x0b\x32(.services.organization.containers.TeamV1\x12/\n\x05notes\x18\x06 \x03(\x0b\x32 .services.note.containers.NoteV1\x12\x38\n\nidentities\x18\x07 \x03(\x0b\x32$.services.user.containers.IdentityV1\x12>\n\x0e\x64irect_reports\x18\x08 \x03(\x0b\x32&.services.profile.containers.ProfileV1\x12\x34\n\x06resume\x18\t \x01(\x0b\x32$.services.resume.containers.ResumeV1\x12>\n\x08location\x18\n \x01(\x0b\x32,.services.organization.containers.LocationV1\x12\x35\n\tinterests\x18\x0b \x03(\x0b\x32\".services.profile.containers.TagV1\x12\x32\n\x06skills\x18\x0c \x03(\x0b\x32\".services.profile.containers.TagV1BD\nBcom.rhlabs.protobufs.services.profile.actions.get_extended_profile')
  ,
  dependencies=[protobufs.services.note.containers_pb2.DESCRIPTOR,protobufs.services.organization.containers_pb2.DESCRIPTOR,protobufs.services.profile.containers_pb2.DESCRIPTOR,protobufs.services.resume.containers_pb2.DESCRIPTOR,protobufs.services.user.containers_pb2.DESCRIPTOR,])
_sym_db.RegisterFileDescriptor(DESCRIPTOR)




_REQUESTV1 = _descriptor.Descriptor(
  name='RequestV1',
  full_name='services.profile.actions.get_extended_profile.RequestV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='version', full_name='services.profile.actions.get_extended_profile.RequestV1.version', index=0,
      number=1, type=13, cpp_type=3, label=1,
      has_default_value=True, default_value=1,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='profile_id', full_name='services.profile.actions.get_extended_profile.RequestV1.profile_id', index=1,
      number=2, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='user_id', full_name='services.profile.actions.get_extended_profile.RequestV1.user_id', index=2,
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
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=335,
  serialized_end=403,
)


_RESPONSEV1 = _descriptor.Descriptor(
  name='ResponseV1',
  full_name='services.profile.actions.get_extended_profile.ResponseV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='version', full_name='services.profile.actions.get_extended_profile.ResponseV1.version', index=0,
      number=1, type=13, cpp_type=3, label=1,
      has_default_value=True, default_value=1,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='profile', full_name='services.profile.actions.get_extended_profile.ResponseV1.profile', index=1,
      number=2, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='address', full_name='services.profile.actions.get_extended_profile.ResponseV1.address', index=2,
      number=3, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='manager', full_name='services.profile.actions.get_extended_profile.ResponseV1.manager', index=3,
      number=4, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='team', full_name='services.profile.actions.get_extended_profile.ResponseV1.team', index=4,
      number=5, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='notes', full_name='services.profile.actions.get_extended_profile.ResponseV1.notes', index=5,
      number=6, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='identities', full_name='services.profile.actions.get_extended_profile.ResponseV1.identities', index=6,
      number=7, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='direct_reports', full_name='services.profile.actions.get_extended_profile.ResponseV1.direct_reports', index=7,
      number=8, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='resume', full_name='services.profile.actions.get_extended_profile.ResponseV1.resume', index=8,
      number=9, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='location', full_name='services.profile.actions.get_extended_profile.ResponseV1.location', index=9,
      number=10, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='interests', full_name='services.profile.actions.get_extended_profile.ResponseV1.interests', index=10,
      number=11, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='skills', full_name='services.profile.actions.get_extended_profile.ResponseV1.skills', index=11,
      number=12, type=11, cpp_type=10, label=3,
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
  serialized_start=406,
  serialized_end=1066,
)

_RESPONSEV1.fields_by_name['profile'].message_type = protobufs.services.profile.containers_pb2._PROFILEV1
_RESPONSEV1.fields_by_name['address'].message_type = protobufs.services.organization.containers_pb2._ADDRESSV1
_RESPONSEV1.fields_by_name['manager'].message_type = protobufs.services.profile.containers_pb2._PROFILEV1
_RESPONSEV1.fields_by_name['team'].message_type = protobufs.services.organization.containers_pb2._TEAMV1
_RESPONSEV1.fields_by_name['notes'].message_type = protobufs.services.note.containers_pb2._NOTEV1
_RESPONSEV1.fields_by_name['identities'].message_type = protobufs.services.user.containers_pb2._IDENTITYV1
_RESPONSEV1.fields_by_name['direct_reports'].message_type = protobufs.services.profile.containers_pb2._PROFILEV1
_RESPONSEV1.fields_by_name['resume'].message_type = protobufs.services.resume.containers_pb2._RESUMEV1
_RESPONSEV1.fields_by_name['location'].message_type = protobufs.services.organization.containers_pb2._LOCATIONV1
_RESPONSEV1.fields_by_name['interests'].message_type = protobufs.services.profile.containers_pb2._TAGV1
_RESPONSEV1.fields_by_name['skills'].message_type = protobufs.services.profile.containers_pb2._TAGV1
DESCRIPTOR.message_types_by_name['RequestV1'] = _REQUESTV1
DESCRIPTOR.message_types_by_name['ResponseV1'] = _RESPONSEV1

RequestV1 = _reflection.GeneratedProtocolMessageType('RequestV1', (_message.Message,), dict(
  DESCRIPTOR = _REQUESTV1,
  __module__ = 'protobufs.services.profile.actions.get_extended_profile_pb2'
  # @@protoc_insertion_point(class_scope:services.profile.actions.get_extended_profile.RequestV1)
  ))
_sym_db.RegisterMessage(RequestV1)

ResponseV1 = _reflection.GeneratedProtocolMessageType('ResponseV1', (_message.Message,), dict(
  DESCRIPTOR = _RESPONSEV1,
  __module__ = 'protobufs.services.profile.actions.get_extended_profile_pb2'
  # @@protoc_insertion_point(class_scope:services.profile.actions.get_extended_profile.ResponseV1)
  ))
_sym_db.RegisterMessage(ResponseV1)


DESCRIPTOR.has_options = True
DESCRIPTOR._options = _descriptor._ParseOptions(descriptor_pb2.FileOptions(), _b('\nBcom.rhlabs.protobufs.services.profile.actions.get_extended_profile'))
# @@protoc_insertion_point(module_scope)
