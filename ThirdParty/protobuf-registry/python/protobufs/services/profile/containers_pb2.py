# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: protobufs/services/profile/containers.proto

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
  name='protobufs/services/profile/containers.proto',
  package='services.profile.containers',
  serialized_pb=_b('\n+protobufs/services/profile/containers.proto\x12\x1bservices.profile.containers\"\x9a\x02\n\x0f\x43ontactMethodV1\x12\x12\n\x07version\x18\x01 \x01(\r:\x01\x31\x12\n\n\x02id\x18\x02 \x01(\t\x12\r\n\x05label\x18\x03 \x01(\t\x12\r\n\x05value\x18\x04 \x01(\t\x12N\n\x04type\x18\x05 \x01(\x0e\x32@.services.profile.containers.ContactMethodV1.ContactMethodTypeV1\"y\n\x13\x43ontactMethodTypeV1\x12\x0e\n\nCELL_PHONE\x10\x00\x12\t\n\x05PHONE\x10\x01\x12\t\n\x05\x45MAIL\x10\x02\x12\t\n\x05SLACK\x10\x03\x12\x0b\n\x07TWITTER\x10\x04\x12\x0b\n\x07HIPCHAT\x10\x05\x12\x0c\n\x08\x46\x41\x43\x45\x42OOK\x10\x06\x12\t\n\x05SKYPE\x10\x07\"\xec\x03\n\tProfileV1\x12\x12\n\x07version\x18\x01 \x01(\r:\x01\x31\x12\n\n\x02id\x18\x02 \x01(\t\x12\x17\n\x0forganization_id\x18\x03 \x01(\t\x12\x0f\n\x07user_id\x18\x04 \x01(\t\x12\x12\n\naddress_id\x18\x05 \x01(\t\x12\r\n\x05title\x18\x06 \x01(\t\x12\x12\n\nfirst_name\x18\x07 \x01(\t\x12\x11\n\tlast_name\x18\x08 \x01(\t\x12\x11\n\timage_url\x18\t \x01(\t\x12\x0f\n\x07team_id\x18\n \x01(\t\x12\x11\n\tfull_name\x18\x0b \x01(\t\x12\x12\n\nbirth_date\x18\x0c \x01(\t\x12\x11\n\thire_date\x18\r \x01(\t\x12\x10\n\x08verified\x18\x0e \x01(\x08\x12\x39\n\x05items\x18\x0f \x03(\x0b\x32*.services.profile.containers.ProfileItemV1\x12\r\n\x05\x61\x62out\x18\x10 \x01(\t\x12\x13\n\x0blocation_id\x18\x11 \x01(\t\x12\x10\n\x08nickname\x18\x12 \x01(\t\x12\x45\n\x0f\x63ontact_methods\x18\x13 \x03(\x0b\x32,.services.profile.containers.ContactMethodV1\x12\x14\n\x0cseating_info\x18\x14 \x01(\t\x12\r\n\x05\x65mail\x18\x15 \x01(\t\"<\n\rProfileItemV1\x12\x0f\n\x07version\x18\x01 \x01(\r\x12\x0b\n\x03key\x18\x02 \x01(\t\x12\r\n\x05value\x18\x03 \x01(\t\">\n\x0b\x41ttributeV1\x12\x12\n\x07version\x18\x01 \x01(\r:\x01\x31\x12\x0c\n\x04name\x18\x02 \x01(\t\x12\r\n\x05value\x18\x03 \x01(\t\"7\n\x06StatV1\x12\x12\n\x07version\x18\x01 \x01(\r:\x01\x31\x12\n\n\x02id\x18\x02 \x01(\t\x12\r\n\x05\x63ount\x18\x03 \x01(\r\"\xb2\x01\n\x05TagV1\x12\x12\n\x07version\x18\x01 \x01(\r:\x01\x31\x12\n\n\x02id\x18\x02 \x01(\t\x12\x0c\n\x04name\x18\x03 \x01(\t\x12:\n\x04type\x18\x04 \x01(\x0e\x32,.services.profile.containers.TagV1.TagTypeV1\"?\n\tTagTypeV1\x12\t\n\x05SKILL\x10\x00\x12\x0c\n\x08INTEREST\x10\x01\x12\x0c\n\x08LANGUAGE\x10\x02\x12\x0b\n\x07PROJECT\x10\x03')
)
_sym_db.RegisterFileDescriptor(DESCRIPTOR)



_CONTACTMETHODV1_CONTACTMETHODTYPEV1 = _descriptor.EnumDescriptor(
  name='ContactMethodTypeV1',
  full_name='services.profile.containers.ContactMethodV1.ContactMethodTypeV1',
  filename=None,
  file=DESCRIPTOR,
  values=[
    _descriptor.EnumValueDescriptor(
      name='CELL_PHONE', index=0, number=0,
      options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='PHONE', index=1, number=1,
      options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='EMAIL', index=2, number=2,
      options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='SLACK', index=3, number=3,
      options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='TWITTER', index=4, number=4,
      options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='HIPCHAT', index=5, number=5,
      options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='FACEBOOK', index=6, number=6,
      options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='SKYPE', index=7, number=7,
      options=None,
      type=None),
  ],
  containing_type=None,
  options=None,
  serialized_start=238,
  serialized_end=359,
)
_sym_db.RegisterEnumDescriptor(_CONTACTMETHODV1_CONTACTMETHODTYPEV1)

_TAGV1_TAGTYPEV1 = _descriptor.EnumDescriptor(
  name='TagTypeV1',
  full_name='services.profile.containers.TagV1.TagTypeV1',
  filename=None,
  file=DESCRIPTOR,
  values=[
    _descriptor.EnumValueDescriptor(
      name='SKILL', index=0, number=0,
      options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='INTEREST', index=1, number=1,
      options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='LANGUAGE', index=2, number=2,
      options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='PROJECT', index=3, number=3,
      options=None,
      type=None),
  ],
  containing_type=None,
  options=None,
  serialized_start=1155,
  serialized_end=1218,
)
_sym_db.RegisterEnumDescriptor(_TAGV1_TAGTYPEV1)


_CONTACTMETHODV1 = _descriptor.Descriptor(
  name='ContactMethodV1',
  full_name='services.profile.containers.ContactMethodV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='version', full_name='services.profile.containers.ContactMethodV1.version', index=0,
      number=1, type=13, cpp_type=3, label=1,
      has_default_value=True, default_value=1,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='id', full_name='services.profile.containers.ContactMethodV1.id', index=1,
      number=2, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='label', full_name='services.profile.containers.ContactMethodV1.label', index=2,
      number=3, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='value', full_name='services.profile.containers.ContactMethodV1.value', index=3,
      number=4, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='type', full_name='services.profile.containers.ContactMethodV1.type', index=4,
      number=5, type=14, cpp_type=8, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
    _CONTACTMETHODV1_CONTACTMETHODTYPEV1,
  ],
  options=None,
  is_extendable=False,
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=77,
  serialized_end=359,
)


_PROFILEV1 = _descriptor.Descriptor(
  name='ProfileV1',
  full_name='services.profile.containers.ProfileV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='version', full_name='services.profile.containers.ProfileV1.version', index=0,
      number=1, type=13, cpp_type=3, label=1,
      has_default_value=True, default_value=1,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='id', full_name='services.profile.containers.ProfileV1.id', index=1,
      number=2, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='organization_id', full_name='services.profile.containers.ProfileV1.organization_id', index=2,
      number=3, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='user_id', full_name='services.profile.containers.ProfileV1.user_id', index=3,
      number=4, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='address_id', full_name='services.profile.containers.ProfileV1.address_id', index=4,
      number=5, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='title', full_name='services.profile.containers.ProfileV1.title', index=5,
      number=6, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='first_name', full_name='services.profile.containers.ProfileV1.first_name', index=6,
      number=7, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='last_name', full_name='services.profile.containers.ProfileV1.last_name', index=7,
      number=8, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='image_url', full_name='services.profile.containers.ProfileV1.image_url', index=8,
      number=9, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='team_id', full_name='services.profile.containers.ProfileV1.team_id', index=9,
      number=10, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='full_name', full_name='services.profile.containers.ProfileV1.full_name', index=10,
      number=11, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='birth_date', full_name='services.profile.containers.ProfileV1.birth_date', index=11,
      number=12, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='hire_date', full_name='services.profile.containers.ProfileV1.hire_date', index=12,
      number=13, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='verified', full_name='services.profile.containers.ProfileV1.verified', index=13,
      number=14, type=8, cpp_type=7, label=1,
      has_default_value=False, default_value=False,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='items', full_name='services.profile.containers.ProfileV1.items', index=14,
      number=15, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='about', full_name='services.profile.containers.ProfileV1.about', index=15,
      number=16, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='location_id', full_name='services.profile.containers.ProfileV1.location_id', index=16,
      number=17, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='nickname', full_name='services.profile.containers.ProfileV1.nickname', index=17,
      number=18, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='contact_methods', full_name='services.profile.containers.ProfileV1.contact_methods', index=18,
      number=19, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='seating_info', full_name='services.profile.containers.ProfileV1.seating_info', index=19,
      number=20, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='email', full_name='services.profile.containers.ProfileV1.email', index=20,
      number=21, type=9, cpp_type=9, label=1,
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
  serialized_start=362,
  serialized_end=854,
)


_PROFILEITEMV1 = _descriptor.Descriptor(
  name='ProfileItemV1',
  full_name='services.profile.containers.ProfileItemV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='version', full_name='services.profile.containers.ProfileItemV1.version', index=0,
      number=1, type=13, cpp_type=3, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='key', full_name='services.profile.containers.ProfileItemV1.key', index=1,
      number=2, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='value', full_name='services.profile.containers.ProfileItemV1.value', index=2,
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
  serialized_start=856,
  serialized_end=916,
)


_ATTRIBUTEV1 = _descriptor.Descriptor(
  name='AttributeV1',
  full_name='services.profile.containers.AttributeV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='version', full_name='services.profile.containers.AttributeV1.version', index=0,
      number=1, type=13, cpp_type=3, label=1,
      has_default_value=True, default_value=1,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='name', full_name='services.profile.containers.AttributeV1.name', index=1,
      number=2, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='value', full_name='services.profile.containers.AttributeV1.value', index=2,
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
  serialized_start=918,
  serialized_end=980,
)


_STATV1 = _descriptor.Descriptor(
  name='StatV1',
  full_name='services.profile.containers.StatV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='version', full_name='services.profile.containers.StatV1.version', index=0,
      number=1, type=13, cpp_type=3, label=1,
      has_default_value=True, default_value=1,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='id', full_name='services.profile.containers.StatV1.id', index=1,
      number=2, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='count', full_name='services.profile.containers.StatV1.count', index=2,
      number=3, type=13, cpp_type=3, label=1,
      has_default_value=False, default_value=0,
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
  serialized_start=982,
  serialized_end=1037,
)


_TAGV1 = _descriptor.Descriptor(
  name='TagV1',
  full_name='services.profile.containers.TagV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='version', full_name='services.profile.containers.TagV1.version', index=0,
      number=1, type=13, cpp_type=3, label=1,
      has_default_value=True, default_value=1,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='id', full_name='services.profile.containers.TagV1.id', index=1,
      number=2, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='name', full_name='services.profile.containers.TagV1.name', index=2,
      number=3, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='type', full_name='services.profile.containers.TagV1.type', index=3,
      number=4, type=14, cpp_type=8, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
    _TAGV1_TAGTYPEV1,
  ],
  options=None,
  is_extendable=False,
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=1040,
  serialized_end=1218,
)

_CONTACTMETHODV1.fields_by_name['type'].enum_type = _CONTACTMETHODV1_CONTACTMETHODTYPEV1
_CONTACTMETHODV1_CONTACTMETHODTYPEV1.containing_type = _CONTACTMETHODV1
_PROFILEV1.fields_by_name['items'].message_type = _PROFILEITEMV1
_PROFILEV1.fields_by_name['contact_methods'].message_type = _CONTACTMETHODV1
_TAGV1.fields_by_name['type'].enum_type = _TAGV1_TAGTYPEV1
_TAGV1_TAGTYPEV1.containing_type = _TAGV1
DESCRIPTOR.message_types_by_name['ContactMethodV1'] = _CONTACTMETHODV1
DESCRIPTOR.message_types_by_name['ProfileV1'] = _PROFILEV1
DESCRIPTOR.message_types_by_name['ProfileItemV1'] = _PROFILEITEMV1
DESCRIPTOR.message_types_by_name['AttributeV1'] = _ATTRIBUTEV1
DESCRIPTOR.message_types_by_name['StatV1'] = _STATV1
DESCRIPTOR.message_types_by_name['TagV1'] = _TAGV1

ContactMethodV1 = _reflection.GeneratedProtocolMessageType('ContactMethodV1', (_message.Message,), dict(
  DESCRIPTOR = _CONTACTMETHODV1,
  __module__ = 'protobufs.services.profile.containers_pb2'
  # @@protoc_insertion_point(class_scope:services.profile.containers.ContactMethodV1)
  ))
_sym_db.RegisterMessage(ContactMethodV1)

ProfileV1 = _reflection.GeneratedProtocolMessageType('ProfileV1', (_message.Message,), dict(
  DESCRIPTOR = _PROFILEV1,
  __module__ = 'protobufs.services.profile.containers_pb2'
  # @@protoc_insertion_point(class_scope:services.profile.containers.ProfileV1)
  ))
_sym_db.RegisterMessage(ProfileV1)

ProfileItemV1 = _reflection.GeneratedProtocolMessageType('ProfileItemV1', (_message.Message,), dict(
  DESCRIPTOR = _PROFILEITEMV1,
  __module__ = 'protobufs.services.profile.containers_pb2'
  # @@protoc_insertion_point(class_scope:services.profile.containers.ProfileItemV1)
  ))
_sym_db.RegisterMessage(ProfileItemV1)

AttributeV1 = _reflection.GeneratedProtocolMessageType('AttributeV1', (_message.Message,), dict(
  DESCRIPTOR = _ATTRIBUTEV1,
  __module__ = 'protobufs.services.profile.containers_pb2'
  # @@protoc_insertion_point(class_scope:services.profile.containers.AttributeV1)
  ))
_sym_db.RegisterMessage(AttributeV1)

StatV1 = _reflection.GeneratedProtocolMessageType('StatV1', (_message.Message,), dict(
  DESCRIPTOR = _STATV1,
  __module__ = 'protobufs.services.profile.containers_pb2'
  # @@protoc_insertion_point(class_scope:services.profile.containers.StatV1)
  ))
_sym_db.RegisterMessage(StatV1)

TagV1 = _reflection.GeneratedProtocolMessageType('TagV1', (_message.Message,), dict(
  DESCRIPTOR = _TAGV1,
  __module__ = 'protobufs.services.profile.containers_pb2'
  # @@protoc_insertion_point(class_scope:services.profile.containers.TagV1)
  ))
_sym_db.RegisterMessage(TagV1)


# @@protoc_insertion_point(module_scope)
