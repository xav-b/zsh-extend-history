#! /usr/bin/env python

from pprint import pprint as pp
import sys


def parse(line):
    for kv in line.split(';')[1:]:
        yield kv.split('=')


def cant_die(func):
    def _inner(*args, **kwargs):
        try:
            return func(*args, **kwargs)
        except Exception as e:
            print('failed to parse line: {}'.format(e))
    return _inner


@cant_die
def process_history(line):
    print('\n===  New command  ===')
    print(line)
    pp({k: v for k, v in parse(line)}, indent=4)
    # FIXME for some reason it doesn't work piping to `jq`
    # import json
    # sys.stdout.write(json.dumps({k: v for k, v in parse(line)}))
    # sys.stdout.write('\r\n')


if __name__ == '__main__':
    # TODO handle ctrl-c
    while 1:
        line = sys.stdin.readline()
        if not line:
            continue

        process_history(line)
