#! /usr/bin/env python

from pprint import pprint as pp
import sys


def parse(line):
    for kv in line.split(';')[1:]:
        yield kv.split('=')


if __name__ == '__main__':
    # TODO handle ctrl-c
    while 1:
        line = sys.stdin.readline()
        if not line:
            continue

        print(line)
        pp({k: v for k, v in parse(line)}, indent=4)
        # FIXME for some reason it doesn't work piping to `jq`
        # import json
        # sys.stdout.write(json.dumps({k: v for k, v in parse(line)}))
        # sys.stdout.write('\n')
