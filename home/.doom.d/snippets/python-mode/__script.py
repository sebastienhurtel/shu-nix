import argparse
import logging
import logging.handlers
import os
import sys

logger = logging.getLogger(os.path.splitext(os.path.basename(sys.argv[0]))[0])

class CustomFormatter(argparse.RawDescriptionHelpFormatter,
                      argparse.ArgumentDefaultsHelpFormatter):
    pass


def parse_args(args=sys.argv[1:]):
    """Parse arguments."""
    parser = argparse.ArgumentParser(
        description=sys.modules[__name__].__doc__,
        formatter_class=CustomFormatter)

    g = parser.add_mutually_exclusive_group()
    g.add_argument("--debug", "-d", action="store_true",
                   default=False,
                   help="enable debugging")
    g.add_argument("--silent", "-s", action="store_true",
                   default=False,
                   help="don't log")

    # TODO: modify these options
    ...

    return parser.parse_args(args)


def setup_logging(options):
    """Configure logging."""
    root = logging.getLogger("")
    root.setLevel(logging.WARNING)
    logger.setLevel(options.debug and logging.DEBUG or logging.INFO)
    if not options.silent:
        if not sys.stderr.isatty():
            facility = logging.handlers.SysLogHandler.LOG_DAEMON
            sh = logging.handlers.SysLogHandler(address='/dev/log',
                                                facility=facility)
            sh.setFormatter(logging.Formatter(
                "{0}[{1}]: %(message)s".format(
                    logger.name,
                    os.getpid())))
            root.addHandler(sh)
        else:
            ch = logging.StreamHandler()
            ch.setFormatter(logging.Formatter(
                "%(levelname)s[%(name)s] %(message)s"))
            root.addHandler(ch)


def main(options):
    ...


if __name__ == "__main__":
    options = parse_args()
    setup_logging(options)

    try:
        print("\n".join(main(options)))
    except Exception as e:
        logger.exception("%s", e)
        sys.exit(1)
    sys.exit(0)


# Unit tests
import pytest                   # noqa: E402
import shlex                    # noqa: E402


@pytest.mark.parametrize("args, expected", [...])

def test_main(args, expected):
    options = parse_args(shlex.split(args))
    assert main(options) == expected