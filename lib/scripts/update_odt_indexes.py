#!/usr/bin/env python3
"""Update all document indexes (TOC) in an ODT file using LibreOffice UNO."""

import os
import subprocess
import sys
import time
import tempfile

# UNO imports
import uno
from com.sun.star.beans import PropertyValue
from com.sun.star.connection import NoConnectException


def start_soffice_listener(port=2002):
    """Start soffice in headless listener mode."""
    accept_arg = (
        f'--accept=socket,host=localhost,port={port};'
        'urp;StarOffice.ServiceManager'
    )
    proc = subprocess.Popen(
        ['soffice', '--headless', accept_arg],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
    # Wait for the listener to be ready
    time.sleep(2)
    return proc


def connect_to_soffice(port=2002):
    """Connect to a running soffice instance via UNO."""
    local_context = uno.getComponentContext()
    resolver = local_context.ServiceManager.createInstanceWithContext(
        'com.sun.star.bridge.UnoUrlResolver', local_context
    )
    url = (
        f'unosocket://localhost:{port};'
        'urp;StarOffice.ComponentContext'
    )
    retry = 0
    max_retries = 10
    while retry < max_retries:
        try:
            ctx = resolver.resolve(
                f'com.sun.star.bridge.UnoUrlResolver'
                f'unosocket://localhost:{port};'
                'urp;StarOffice.ComponentContext'
            )
            # Actually the correct url format is:
            return ctx
        except NoConnectException:
            retry += 1
            time.sleep(0.5)
    raise RuntimeError('Could not connect to soffice listener')


def update_indexes(input_path, output_path, port=2002):
    """Open an ODT, update all indexes, and save to output_path."""
    proc = start_soffice_listener(port)
    try:
        # Connect via UNO
        local_context = uno.getComponentContext()
        resolver = local_context.ServiceManager.createInstanceWithContext(
            'com.sun.star.bridge.UnoUrlResolver', local_context
        )

        url = (
            'uno:socket,host=localhost,port=%d;'
            'urp;StarOffice.ComponentContext' % port
        )

        retry = 0
        max_retries = 20
        ctx = None
        while retry < max_retries:
            try:
                ctx = resolver.resolve(url)
                break
            except Exception:
                retry += 1
                time.sleep(0.5)

        if ctx is None:
            raise RuntimeError('Could not connect to soffice')

        smgr = ctx.ServiceManager
        desktop = smgr.createInstanceWithContext('com.sun.star.frame.Desktop', ctx)

        # Open the document
        file_url = uno.systemPathToFileUrl(os.path.abspath(input_path))
        props = (
            PropertyValue('Hidden', 0, True, 0),
        )
        doc = desktop.loadComponentFromURL(file_url, '_blank', 0, props)

        if doc is None:
            raise RuntimeError(f'Could not open document: {input_path}')

        # Update all indexes
        indexes = doc.getDocumentIndexes()
        for i in range(indexes.getCount()):
            index = indexes.getByIndex(i)
            index.update()

        # Save to output
        output_url = uno.systemPathToFileUrl(os.path.abspath(output_path))
        store_props = (
            PropertyValue('FilterName', 0, 'writer8', 0),
            PropertyValue('Overwrite', 0, True, 0),
        )
        doc.storeToURL(output_url, store_props)

        # Close document
        doc.close(True)

    finally:
        # Terminate soffice
        try:
            if 'desktop' in dir():
                desktop.terminate()
        except Exception:
            pass
        proc.terminate()
        try:
            proc.wait(timeout=5)
        except subprocess.TimeoutExpired:
            proc.kill()
            proc.wait()


def main():
    if len(sys.argv) != 3:
        print('Usage: update_odt_indexes.py <input.odt> <output.odt>')
        sys.exit(1)

    input_path = sys.argv[1]
    output_path = sys.argv[2]
    update_indexes(input_path, output_path)
    print(f'Updated indexes: {output_path}')


if __name__ == '__main__':
    main()
