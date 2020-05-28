"""
    Plugin for Launching programs
"""

# -*- coding: UTF-8 -*-
# main imports
import sys
import os
import xbmc
import xbmcgui
import xbmcaddon

# plugin constants
__plugin__ = "retrosmc-launcher"
__author__ = "jcnventura/mcobit/bousqi"
__url__ = "http://blog.petrockblock.com/retropie/"
__git_url__ = "https://github.com/bousqi/retrosmc/"
__credits__ = "bousqi"
__version__ = "0.0.3"

dialog = xbmcgui.Dialog()
addon = xbmcaddon.Addon(id='plugin.program.retrosmc-launcher')

output=os.popen("~/RetroPie/scripts/retropie.sh").read()
#dialog.ok("Starting RetroPie",output)
#print output
