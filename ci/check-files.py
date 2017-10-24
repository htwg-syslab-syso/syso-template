#!/usr/bin/env python2
from __future__ import print_function

from os import listdir, readlink
from os.path import abspath, basename, dirname, isfile, join, isdir

import argparse
import subprocess

ROOT_DIR = join(dirname(__file__), '..')
FILES_FOLDER = join(ROOT_DIR, 'ci', 'files')


def get_file_lists(fdir):
    if not isdir(fdir):
        print("! no file lists found")
        return {}

    list_files = [f for f in listdir(fdir) if isfile(join(fdir, f))]
    file_lists = {}

    for list_file in list_files:
        file_lists[list_file] = get_file_list(join(fdir, list_file))

    return file_lists


def get_file_list(list_file):
    with open(list_file) as lf:
        return [f.strip() for f in lf.readlines() if len(f.strip()) > 0]



def check_files(hw_dir, file_list):
    optional_folders = []
    errors = 0

    for f in file_list:
        # optional file type match
        if ': ' in f:
            f, dst_ftypes = f.split(': ')
        else:
            dst_ftypes = None

        # optional dir
        if f.startswith('?'):
            optional_folders.append(f[1:].strip())
        # symlink
        elif ' -> ' in f:
            src, dst = f.split(' -> ')

            if readlink(join(hw_dir, src)) != dst:
                print("! '{}' does not symlink to '{}'".format(src, dst))
                errors += 1
        # else not a file -> error
        elif not isfile(join(hw_dir, f)):
            # ignore if path starts with optional folder path
            if len(filter(lambda x: f.startswith(x), optional_folders)) > 0:
                continue

            print("! '{}' is missing".format(f))
            errors += 1
        # check file type (optional)
        elif dst_ftypes:
            ftype = subprocess.Popen(['/usr/bin/env', 'file', join(hw_dir, f)], stdout=subprocess.PIPE).stdout.read().strip()

            for dst_ftype in dst_ftypes.split(','):
                dst_ftype = dst_ftype.strip()

                if not dst_ftype in ftype:
                    print("! '{}' (file type) does not contain '{}'".format(ftype, dst_ftype))
                    errors += 1

    if errors == 0:
        print(" -> All Files found.")

    return errors


def main():
    parser = argparse.ArgumentParser(description='Check assignment files.')
    parser.add_argument('check', metavar='file/folder', nargs='?', help='File (or folder with multiple) file list(s)')
    args = parser.parse_args()

    if args.check:
        if isdir(args.check):
            file_lists = get_file_lists(args.check)
        elif isfile(args.check):
            file_lists = {args.check: get_file_list(args.check)}
        else:
            print("'{}' not found.".format(args.check))
            exit(-1)
    else:
        file_lists = get_file_lists(FILES_FOLDER)

    errors = 0
    print(abspath(ROOT_DIR))

    for f, file_list in file_lists.items():
        hw_dir = join(ROOT_DIR, basename(f[:-4]))
        print('{}: ({})'.format(basename(hw_dir), f))

        if isdir(hw_dir):
            errors += check_files(hw_dir, file_list)
        else:
            print(' -> Not found, skipping.')

    exit(errors)


if __name__ == '__main__':
    main()
