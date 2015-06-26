#-----------------------------------------------------------------------------
from os import walk
from tempfile import mkstemp
from shutil import move
from os import remove, close
import os
import re
import shutil

#-----------------------------------------------------------------------------
class Update(object):

	def __init__(self):
		pass

	#-----------------------------------------------------------------------------
	def splitFolderAndFilename(self, fullPath):
		for i in xrange (len(fullPath) - 1, 0, -1):
			if fullPath[i] == os.path.sep and i != len(fullPath) - 1:
				return fullPath[0: i], fullPath[i + 1: len(fullPath)]

		return None, None

	#-----------------------------------------------------------------------------
	def convertArrayOrMap (self, line, src, dst):
		i = line.find(src)
		 
		if i == -1:
			return line
			
		line = line[0:i] + dst + line[i + len(src):]
			
		return line
		
	#-----------------------------------------------------------------------------
	# convert XDicts and Arrays to their respective HaXe types (Maps and Arrays w/ typing)
	#-----------------------------------------------------------------------------	
	def convertArraysAndMaps (self, line):

# XDict (); // <key, type>
#    --> Map ()<key, type>;
		converted = self.convertArrayOrMap (line, "XDict ()", "Map ()");
			
		if converted != line:
			return converted
			
# XDict; // <key, type>
#    --> Map<key, type>;			
# XDict /* <key, type> */
#    --> Map<key, type>
		converted = self.convertArrayOrMap (line, "XDict", "Map");
		
		if converted != line:
			return converted
			
# Array (); // <type>
#    --> Array ()<type>;
		converted = self.convertArrayOrMap (line, "Array ()", "Array ()");
		
		if converted != line:
			return converted
			
# Array; // <type>
#    --> Array<type>;
# Array /* <type> */
#    --> Array<type>
		converted = self.convertArrayOrMap (line, "Array", "Array");
		
		if converted != line:
			return converted

		return line
		
	#-----------------------------------------------------------------------------
	def processLine(self, line, dst):
		line = self.convertArraysAndMaps(line)
		
		dst.write(line)

	#-----------------------------------------------------------------------------
	def processFile(self, src_file_path):
		dst_file_path = "Y" + src_file_path[src_file_path.find(os.path.sep):]

		print ": src: ", src_file_path
		print ": dst: ", dst_file_path

		folder, fileName = self.splitFolderAndFilename(dst_file_path);

		print ": folder, name: ", folder, fileName, os.getcwd()

		src = open(src_file_path)

		if not os.path.exists(folder):
			os.mkdir(folder)

		dst = open(dst_file_path, "w")
		
		for line in src:
			self.processLine(line, dst)

		src.close ()
		dst.close ()

	#-----------------------------------------------------------------------------
	def processDirectory(self, paths):

	#-----------------------------------------------------------------------------
		for i in xrange(len(paths)):
			path = paths[i]

	#-----------------------------------------------------------------------------
			for (dirpath, dirnames, filenames) in walk(path):
				for j in xrange(len(filenames)):
					if filenames[j].endswith(".as") or filenames[j].endswith(".h"):
						file_path = path + os.path.sep + filenames[j]

						self.processFile (file_path)

				for j in xrange(len(dirnames)):
					dirnames[j] = path + os.path.sep + dirnames[j]

				if len(dirnames):
					self.processDirectory(dirnames)

#-----------------------------------------------------------------------------
o = Update()
o.processDirectory(["X"])

