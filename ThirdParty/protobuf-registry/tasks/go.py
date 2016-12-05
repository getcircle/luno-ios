from invoke import (
    run,
    task,
)

from . import common

LANGUAGE = 'go'


@task
def clean():
    print 'cleaning %s...' % (LANGUAGE,)
    with common.base_directory():
        run("rm -rf %(language)s && mkdir %(language)s" % {'language': LANGUAGE})


@task(default=True)
def compile():
    print 'compiling %s...' % (LANGUAGE,)
    with common.base_directory():
        common.compile('go_out', LANGUAGE)
