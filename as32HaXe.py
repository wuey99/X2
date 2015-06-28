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
	# convert as3 XDict's and Array's using comment-based annotations
	# 
	# i.e.:
	#
	# XDict; // <Int>		-->: Map<Int>
	#-----------------------------------------------------------------------------
	def convertArrayOrMap (self, line, src, dst):
		i = line.find(src)
		 
		if i == -1:
			return line
		
		j = line.find("//");
		if j == -1:
			j = line.find("/*")
		if j == -1:
			return line
			
		begin = line[j:].find("<")
		end = line[j:].find(">")
			
		type = line[j+begin:j+end+1]
		
		line = line[0:i] + dst + type + line[i + len(src):]
			
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
	def convertBreaks(self, line):
		line = line.replace("break;", "// break;")
		
		return line
	
	#-----------------------------------------------------------------------------
	def convertClass(self, line):
		i = line.find("public class")
		if i == -1:
			return line
			
		classNameBegin = i + len("public class") + 1
		classNameEnd = classNameBegin + line[classNameBegin:].find(" ")
		self._className = line[classNameBegin:classNameEnd]
		print ": className: ", classNameBegin, classNameEnd, self._className
		
		line = line.replace("public class", "class")
		
		return line
	
	#-----------------------------------------------------------------------------
	def convertConstructor(self, line):
		line = line.replace("public function " + self._className + " (", "public function new (")
		
		return line
					
	#-----------------------------------------------------------------------------
	def processLine(self, line, dst):
		line = self.convertArraysAndMaps(line)
		line = self.convertBreaks(line)
		line = self.convertClass(line)
		line = self.convertConstructor(line)
		
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
		
		self._className = ""
		
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

