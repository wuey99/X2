#-----------------------------------------------------------------------------
from os import walk
from tempfile import mkstemp
from shutil import move
from os import remove, close
import re

#-----------------------------------------------------------------------------
class Update(object):

	def __init__(self):
		self.new_license = \
"// Copyright (C) 2014 Jimmy Huey\n" + \
"//\n" + \
"// Some Rights Reserved.\n" + \
"//\n" + \
"// The \"X-Engine\" is licensed under a Creative Commons\n" + \
"// Attribution-NonCommerical-ShareAlike 3.0 Unported License.\n" + \
"// (CC BY-NC-SA 3.0)\n" + \
"//\n" + \
"// You are free to:\n" + \
"//\n" + \
"//      SHARE - to copy, distribute, display and perform the work.\n" + \
"//      ADAPT - remix, transform build upon this material.\n" + \
"//\n" + \
"//      The licensor cannot revoke these freedoms as long as you follow the license terms.\n" + \
"//\n" + \
"// Under the following terms:\n" + \
"//\n" + \
"//      ATTRIBUTION -\n" + \
"//          You must give appropriate credit, provide a link to the license, and\n" + \
"//          indicate if changes were made.  You may do so in any reasonable manner,\n" + \
"//          but not in any way that suggests the licensor endorses you or your use.\n" + \
"//\n" + \
"//      SHAREALIKE -\n" + \
"//          If you remix, transform, or build upon the material, you must\n" + \
"//          distribute your contributions under the same license as the original.\n" + \
"//\n" + \
"//      NONCOMMERICIAL -\n" + \
"//          You may not use the material for commercial purposes.\n" + \
"//\n" + \
"// No additional restrictions - You may not apply legal terms or technological measures\n" + \
"// that legally restrict others from doing anything the license permits.\n" + \
"//\n" + \
"// The full summary can be located at:\n" + \
"// http://creativecommons.org/licenses/by-nc-sa/3.0/\n" + \
"//\n" + \
"// The human-readable summary of the Legal Code can be located at:\n" + \
"// http://creativecommons.org/licenses/by-nc-sa/3.0/legalcode\n" + \
"//\n" + \
"// The \"X-Engine\" is free for non-commerical use.\n" + \
"// For commercial use, you will need to provide proper credits.\n"  \
"// Please contact me @ wuey99[dot]gmail[dot]com for more details.\n"
	#-----------------------------------------------------------------------------
	def replace(self, file_path):
		f = open (file_path)
		file = f.read ()
		f.close ()

		begin = file.find("<$begin$/>")
		end = file.find("<$end$/>")

		if begin != -1 and end != -1:
			file = file[:begin + len("<$begin$/>")] + "\n" + self.new_license + "// " + file[end:]

			f = open (file_path, "w")
			f.write (file)
			f.close ()

	#-----------------------------------------------------------------------------
	def process(self, paths):

	#-----------------------------------------------------------------------------
		for i in xrange(len(paths)):
			path = paths[i]

	#-----------------------------------------------------------------------------
			for (dirpath, dirnames, filenames) in walk(path):
				for j in xrange(len(filenames)):
					if filenames[j].endswith(".as") or filenames[j].endswith(".h"):
						file_path = path + "\\" + filenames[j]

						print ": filename: ", file_path

						self.replace(file_path)

				for j in xrange(len(dirnames)):
					dirnames[j] = path + "\\" + dirnames[j]

				if len(dirnames):
					self.process(dirnames)

#-----------------------------------------------------------------------------
o = Update()
o.process(["X"])

