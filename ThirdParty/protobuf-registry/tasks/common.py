from contextlib import contextmanager
import os

from invoke import run


@contextmanager
def base_directory(language=None):
    current_path = os.getcwd()
    target_path = os.path.join(
        os.path.dirname(os.path.abspath(os.path.join(__file__, '../'))),
    )
    if language:
        target_path = os.path.join(language)

    os.chdir(target_path)
    yield
    os.chdir(current_path)


def compile(
        out_prefix,
        out_directory,
        extra='',
        filters='',
    ):
    command = (
        "find src -type f -name '*.proto' | %s xargs protoc --proto_path"
        " ./src/ --%s %s %s" % (
            filters,
            out_prefix,
            out_directory,
            extra,
        )
    )
    print command
    run(command)
