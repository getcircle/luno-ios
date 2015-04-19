from invoke import (
    run,
    task,
)

from . import common

LANGUAGE = 'java'


@task
def clean():
    print 'cleaning %s...' % (LANGUAGE,)
    with common.base_directory():
        run("rm -rf %(language)s && mkdir %(language)s" % {'language': LANGUAGE})


@task(default=True)
def compile():
    print 'compiling %s...' % (LANGUAGE,)
    with common.base_directory():
        common.compile('java_out', LANGUAGE)
