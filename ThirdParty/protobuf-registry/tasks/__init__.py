from invoke import (
    Collection,
    task,
)

from . import (
    python,
    release,
    swift,
)


@task(post=[python.compile, swift.compile])
def compile():
    print 'compiling protobufs...'


ns = Collection()
ns.add_collection(python)
ns.add_collection(release)
ns.add_collection(swift)

ns.add_task(compile)
