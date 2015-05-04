import os
import re

from invoke import task
import yaml
from . import common

PACKAGE_RE = re.compile('^package ([^;]+)')
OPTION_RE = re.compile('^option ([^;]+)')


@task
def options():
    print 'rewriting options...'
    with common.base_directory():
        with open('options.yml') as options_file:
            options = yaml.load(options_file)

        for path, directories, files in os.walk('src/protobufs'):
            for file_name in files:
                body = []
                header = []
                current_options = {}
                package = None
                package_line = None
                file_path = os.path.join(path, file_name)
                print 'writing options for %s' % (file_path,)
                with open(file_path, 'r') as read_file:
                    for line in read_file.readlines():
                        add_to_body = True
                        package_match = PACKAGE_RE.search(line)
                        option_match = OPTION_RE.search(line)
                        if package_match:
                            package = package_match.groups()[0]
                            package_line = line
                            add_to_body = False
                        elif option_match:
                            current_options[option_match.groups()[0]] = line
                            add_to_body = False
                        elif line.startswith('// GENERATED OPTIONS FOR:'):
                            add_to_body = False

                        if add_to_body:
                            body.append(line)

                if not package:
                    print 'no package found for: %s, exiting' % (file_path,)
                    exit(1)

                camel_case_container = ''.join(
                    x.capitalize() for x in package.rsplit('.', 1)[-1].split('_')
                )
                option_format_args = {
                    'package': package,
                    'camel_case_container': camel_case_container,
                }
                header.append(package_line)
                for language, language_options in options.iteritems():
                    header_added = False
                    for option in language_options:
                        if isinstance(option, dict):
                            if not re.search(option.values()[0]['file_regex'], file_path):
                                continue
                            else:
                                option = '%s = "%s"' % (
                                    option.keys()[0],
                                    option.values()[0]['option'],
                                )

                        if not header_added:
                            header.append('\n')
                            header.append('// GENERATED OPTIONS FOR: %s\n' % (language.upper(),))
                            header_added = True

                        formatted_option = option % option_format_args
                        option_output = 'option %s;\n' % (formatted_option,)
                        existing_option = current_options.pop(formatted_option, None)
                        if existing_option and existing_option != option_output:
                            print 'existing option mismatch. existing: %s, new: %s' % (existing_option, option_output)
                            exit(1)
                        else:
                            header.append(option_output)

                # for the moment, lets require all options to be defined in the options.yml
                #if current_options:
                    #header.append('\n')
                    #header.append('// GENERATED GENERAL OPTIONS\n')
                    #for option, line in current_options.iteritems():
                        #header.append(line)

                encountered_text = False
                while not encountered_text:
                    if not body[0].strip():
                        body.pop(0)
                    else:
                        encountered_text = True

                output = header + ['\n'] + body
                with open(file_path, 'w') as write_file:
                    write_file.writelines(output)
