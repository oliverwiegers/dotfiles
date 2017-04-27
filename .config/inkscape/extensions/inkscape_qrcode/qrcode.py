#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Inkscape QR Code
# Copyright (C) 2016 - 2017 Lars Heuer
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of version 2 of the GNU General Public
# License as published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
#  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#
"""\
Inkscape extension which uses Segno to generate QR Codes.
"""
from __future__ import absolute_import, unicode_literals
import inkex
try:
    from ._segno import encoder, utils
except (ImportError, ValueError):
    from _segno import encoder, utils
try:
    from simpletransform import computePointInNode
except ImportError:
    def computePointInNode(pt, node):
        return pt

__version__ = '0.1.4'


class InkscapeQRCode(inkex.Effect):
    """\
    This class mediates between Inkscape and Segno.
    """
    def __init__(self):
        inkex.Effect.__init__(self)
        self.OptionParser.add_option('--data', action='store',
                                     dest='data', type='string')
        self.OptionParser.add_option('--version', action='store',
                                     dest='version', type='string')
        self.OptionParser.add_option('--scale', action='store',
                                     dest='scale', type='float', default=1.0)
        self.OptionParser.add_option('--error', action='store',
                                     dest='error', type='string', default='m')
        # Actually these are booleans but we keep them as str
        self.OptionParser.add_option('--background', action='store',
                                     dest='background', type='string',
                                     default='false')
        self.OptionParser.add_option('--allow_micro', action='store',
                                     dest='micro', type='string',
                                     default='false')
        self.OptionParser.add_option('--boost_error', action='store',
                                     dest='boost_error', type='string',
                                     default='false')
        
    def effect(self):
        opts = self.options
        version, error = opts.version, opts.error
        if version.upper() == 'M1' and error:
            error = None
        if version == '-':
            version = None
        micro = None if opts.micro == 'true' else False
        boost_error = opts.boost_error == 'true'
        want_background = opts.background == 'true'
        
        qr = encoder.encode(opts.data, version=version, error=error,
                            micro=micro, boost_error=boost_error)

        border = utils.get_default_border_size(qr.version)

        # Create path data
        x, y = border, border + .5  # .5 == stroke-width / 2
        line_iter = utils.matrix_to_lines(qr.matrix, x, y)
        # 1st coord is absolute
        (x1, y1), (x2, y2) = next(line_iter)
        coord = ['M{0} {1}h{2}'.format(x1, y1, x2 - x1)]
        append_coord = coord.append
        x, y = x2, y2
        for (x1, y1), (x2, y2) in line_iter:
            append_coord('m{0} {1}h{2}'.format(x1 - x, int(y1 - y), x2 - x1))
            x, y = x2, y2
        path_data = ''.join(coord)

        centre = tuple(computePointInNode(list(self.view_center), self.current_layer))

        grp_transform = 'translate' + str(centre)
        if opts.scale != 1:
            grp_transform += ' scale(%f)' % opts.scale
        grp = inkex.etree.SubElement(self.current_layer, inkex.addNS('g', 'svg'),
                                     transform=grp_transform)
        if want_background:
            width, height = utils.get_symbol_size(qr.version, border=border)
            inkex.etree.SubElement(grp, inkex.addNS('rect', 'svg'),
                                   width=str(width), height=str(height),
                                   fill='#FFF')
        inkex.etree.SubElement(grp, inkex.addNS('path', 'svg'),
                               d=path_data, stroke='#000')
        

if __name__ == '__main__':
    e = InkscapeQRCode()
    e.affect()
