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
	# determines if the line is a // comment
	#-----------------------------------------------------------------------------
	def isComment(self, line):
		if line.startswith("//"):
			return True
			
		for i in xrange(0, len(line)):
			if line[i] != " " and line [i] != "\t":
				break
		
		if line[i:].startswith("//"):
			return True
			
		return False
			
	#-----------------------------------------------------------------------------
	# convert as3 XDict's and Array's using comment-based annotations
	# 
	# i.e.:
	#
	# XDict; // <Int>
	# -->
	# Map<Int>
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
	#
	# XDict (); // <key, type>
	#    --> Map ()<key, type>;
	#
	# XDict; // <key, type>	
	#    --> Map<key, type>;			
	# XDict /* <key, type> */
	#    --> Map<key, type>
	#
	# Array (); // <type>
	#    --> Array ()<type>;
	#
	# Array; // <type>
	#    --> Array<type>;
	# Array /* <type> */
	#    --> Array<type>		
	#-----------------------------------------------------------------------------	
	def convertArraysAndMaps (self, line):
		if self.isComment(line):
			return line
			
		"""
# XDict (); // <key, type>
#    --> Map ()<key, type>;
		converted = self.convertArrayOrMap (line, "XDict ()", "Map ()");
			
		if converted != line:
			return converted
		"""
		
# XDict; // <key, type>
#    --> Map<key, type>;			
# XDict /* <key, type> */
#    --> Map<key, type>
		converted = self.convertArrayOrMap (line, "XDict", "Map");
		
		if converted != line:
			return converted
			
		"""
# Array (); // <type>
#    --> Array ()<type>;
		converted = self.convertArrayOrMap (line, "Array ()", "Array ()");
		
		if converted != line:
			return converted
		"""
		
# Array; // <type>
#    --> Array<type>;
# Array /* <type> */
#    --> Array<type>
		converted = self.convertArrayOrMap (line, "Array", "Array");
		
		if converted != line:
			return converted

		return line

	#-----------------------------------------------------------------------------
	# break;
	#     --> // break;
	#-----------------------------------------------------------------------------
	def convertBreaks(self, line):
		if self.isComment(line):
			return line
			
		line = line.replace("break;", "// break;")
		
		return line
	
	#-----------------------------------------------------------------------------
	# public <className>
	#     --> <className>
	#
	# save <className> for use in convertConstructor
	#-----------------------------------------------------------------------------
	def convertClass(self, line):
		if self.isComment(line):
			return line
			
		i = line.find("public class")
		if i == -1:
			return self.convertConstructor(line);
			
		classNameBegin = i + len("public class") + 1
		classNameEnd = classNameBegin + line[classNameBegin:].find(" ")
		self._className = line[classNameBegin:classNameEnd]
		print ": className: ", classNameBegin, classNameEnd, self._className
		
		line = line.replace("public class", "class")
		
		return line
	
	#-----------------------------------------------------------------------------
	# public function <className> () {
	#     --> public function new () {
	#-----------------------------------------------------------------------------
	def convertConstructor(self, line):
		if self.isComment(line):
			return line
			
		line = line.replace("public function " + self._className + " (", "public function new (")
		
		return line
	
	#-----------------------------------------------------------------------------
	# // <HAXE>
	# /* --
	#	haxe code
	# -- */
	# // </HAXE>
	# // <AS3>
	#   as3 code
	# // </AS3>
	#-----------------------------------------------------------------------------
	def convertHaXeBlock(self, line):
		if self._haXeBlock:
			if line.find("/* --") != -1 or line.find("-- */") != -1:
				self._skipLine = True
		
			if line.find("<AS3>") != -1:
				self._haXeBlock = False
				self._as3Block = True
					
				self._skipLine = True
			
			if line.find("</HAXE>") != -1:
				self._skipLine = True
								
		if self._as3Block:
			if line.find("</AS3>") != -1:
				self._haXeBlock = False
				self._as3Block = False
				
			self._skipLine = True
			
		if line.find("<HAXE>") != -1:
			self._haXeBlock = True
			
			self._skipLine = True
			
		return line
	
	#-----------------------------------------------------------------------------
	def isType(self, line, typeName):	
		if line.find(":" + typeName + ";") >= 0 \
		or line.find(":" + typeName + " ") >= 0 \
		or line.find(":" + typeName + ")") >= 0 \
		or line.find(":" + typeName + ",") >= 0 \
		or line.find(":" + typeName + "\n") >= 0:
			return True
		else:
			return False				

	#-----------------------------------------------------------------------------
	def isNewOrExtends(self, line, typeName):
		if line.find("extends " + typeName + " ") >= 0 \
		or line.find("new " + typeName + " (") >= 0 \
		or line.find("new " + typeName + "(") >= 0:
			return True
		else:
			return False
			
	#-----------------------------------------------------------------------------
	# :Function
	#    --> :Dynamic
	#-----------------------------------------------------------------------------
	def convertFunction(self, line):
		if self.isType(line, "Function"):
			line = line.replace(":Function", ":Dynamic /* Function */")
		
		if self.isNewOrExtends(line, "Function"):
			line = line.replace(" Function", " Dynamic /* Function */")
			
		return line
	
	#-----------------------------------------------------------------------------
	# :Boolean
	#    --> :Bool
	#-----------------------------------------------------------------------------
	def convertBoolean(self, line):
		if self.isType(line, "Boolean"):
			line = line.replace(":Boolean", ":Bool")

		if self.isNewOrExtends(line, "Boolean"):
			line = line.replace(" Boolean", " Bool")
					
		return line
		
	#-----------------------------------------------------------------------------
	# :int
	#    --> :Int
	#-----------------------------------------------------------------------------
	def convertInt(self, line):
		if self.isType(line, "int"):
			line = line.replace(":Boolean", ":Int")

		if self.isNewOrExtends(line, "int"):
			line = line.replace(" int", " Int")
					
		return line
		
	#-----------------------------------------------------------------------------
	# :Number
	#    --> :Float
	#-----------------------------------------------------------------------------
	def convertNumber(self, line):
		if self.isType(line, "Number"):
			line = line.replace(":Number", ":Float")
		
		if self.isNewOrExtends(line, "Number"):
			line = line.replace(" Number", " Float")
			
		return line
		
	#-----------------------------------------------------------------------------
	# :Object
	#    --> :Dynamic /* Object */
	#-----------------------------------------------------------------------------
	def convertObject(self, line):
		if self.isType(line, "Object"):
			line = line.replace(":Object", ":Dynamic /* Object */")
		
		if self.isNewOrExtends(line, "Object"):
			line = line.replace(" Object", " Dynamic /* Object */")
			
		if self.isType(line, "*"):
			line = line.replace(":*", ":Dynamic /* */")
			
		return line
		
	#-----------------------------------------------------------------------------
	# :void
	#    --> :void
	#-----------------------------------------------------------------------------
	def convertVoid(self, line):
		if self.isType(line, "void"):
			line = line.replace(":void", ":Void")
		
		if self.isNewOrExtends(line, "void"):
			line = line.replace(" void", " Void")
			
		return line
		
	#-----------------------------------------------------------------------------
	# :Vector
	#    --> :Array
	#-----------------------------------------------------------------------------
	def convertVector(self, line):
		if self.isType(line, "Vector"):
			line = line.replace(":Vector", ":Array /* Vector */")
			
		return line
		
	#-----------------------------------------------------------------------------
	# :Boolean
	#    --> :Bool
	# :int
	#    --> :Int
	# :Number
	#    --> :Float
	# :Object
	#    --> :Dynamic /* Object */
	# :void
	#    --> :Void
	# :Vector
	#    --> :Array /* Vector */
	# :Function
	#    --> :Dynamic /* Function */
	#-----------------------------------------------------------------------------
	def convertTypes(self, line):
		if self.isComment(line):
			return line
			
		line = self.convertBoolean(line)
		line = self.convertInt(line)
		line = self.convertNumber(line)
		line = self.convertObject(line)
		line = self.convertVoid(line)
		line = self.convertVector(line)
		line = self.convertFunction(line)
		
		return line
	
	#-----------------------------------------------------------------------------
	# package <packageName> {
	#    --> package <packageName;
	#-----------------------------------------------------------------------------
	def convertPackage(self, line):
		if self.isComment(line):
			return line
			
		if line.find("}") >= 0 and self._lineNumber == self._numLines:
			line = line.replace ("}", "// }")
			
		if line.find("package ") >= 0 and line.endswith(" {\n"):
			line = line.replace(" {\n", ";\n")
			
		return line
	
	#-----------------------------------------------------------------------------
	# attempt an automated translation as much as possible, but if the
	# comment annotation /* @:cast */ is found skip the automatic translation
	#
	# = <value> as String;
	#    --> = cast <value>; /* as String */
	#
	# ) as <String>;
	#    -->; /* as <String> */
	#
	# /* @:cast */
	#    --> cast
	#
	# /* @:safe_cast(type) */
	#    --> cast(label, type)
	#-----------------------------------------------------------------------------
	def convertCasts(self, line):
		if self.isComment(line):
			return line
			
		def commentAs(line, as_token):
			for i in xrange (as_token + 4, len(line)):
				if line[i] == ")" or line[i] == ";" or line[i] == " " or line[i] == ",":
					line = line.replace(line[as_token:i], " /*" + line[as_token:i] + " */")
					
					return line
					
			return line
				
		def findLabel(line, cast):
			i = line[cast + 3:].find(" as ")
			
			return line[cast + 3: cast + 3 + i]
			
# look /* @:cast */		
		if line.find("/* @:cast */") > 0:
			line = line.replace ("/* @:cast */", "cast")
			
			as_token = line.find(" as ")
			if as_token < 0:
				return line
			
			line = commentAs(line, as_token)
			
			return line
			
# look for /* @safe_cast */
		i = line.find("/* @:safe_cast")
		
		if i > 0:
			def extract_type(i):
				begin = line[i:].find(" as ") + i
				for i in xrange (begin+4, len(line)):
					if line[i] == ")" or line[i] == "," or line[i] == ";":
						return line[begin+4:i]
				
				return ""

			j = line[i:].find ("*/ ") + i
		
			label = findLabel(line, j)
			type = extract_type(i)
									
			print ": ----------->: ", label, type, line
			
			cast = "cast(" + label + ", " + type + ")"
			line = line.replace ("/* @:safe_cast */", cast)			
			
			remove = label + " as " + type
			line = line.replace(remove, "") 
			
			return line
			
# look for " as "
		as_token = line.find(" as ")
		if as_token < 0:
			return line
			
# = <value> as <type>;			
		equals_token = line.find(" = ")
		if equals_token >= 0 and equals_token < as_token:
			line = line[:equals_token + 3] + "cast " + line[equals_token + 3:as_token] + "; /*" + line[as_token:-2] + " */\n"
			
			return line
	
# ) as <type>;
		right_paren = line.find(")")
		if right_paren >0 and right_paren < as_token:
			line = line[:right_paren + 1] + "; /* " + line[as_token:-2] + " */\n"
			
			return line
			 
		return line
	
	#-----------------------------------------------------------------------------
	#
	#-----------------------------------------------------------------------------
	def convertIs(self, line):
		def stripSpacesAndTabs():
			for i in xrange(0, len(line)):
				if line[i] != "" and line[i] != "\t":
					return line[i:]
			
			return line
			
		i = line.find(" is ")
		if i < 0:
			return line
			
		line0 = stripSpacesAndTabs()
		if not line0.startswith("if ("):
			return line
		
		begin = line0.find("(") + 1
		end = line0.find(" is ")
		label = line0[begin:end]
		typePos = line0[end + 4:].find(")") + end + 4
		type = line0[end + 4: typePos]
		
		line = line.replace("if (" + label + " is " + type + ")", "if (Std.is (" + label + ", " + type + "))")
		
		return line
			
	#-----------------------------------------------------------------------------
	#
	#-----------------------------------------------------------------------------
	def convertLoops(self, line):
		return line
	
	#-----------------------------------------------------------------------------
	#
	#-----------------------------------------------------------------------------
	def convertGettersAndSetters(self, line):
		return line
				
	#-----------------------------------------------------------------------------
	def processLine(self, line, dst):
		self._lineNumber += 1
		self._skipLine = False
		
		line = self.convertArraysAndMaps(line)
		line = self.convertBreaks(line)
		line = self.convertClass(line)
		line = self.convertTypes(line)
		line = self.convertCasts(line)
		line = self.convertIs(line)
		line = self.convertGettersAndSetters(line)
		line = self.convertLoops(line)
		line = self.convertHaXeBlock(line)
		line = self.convertPackage(line)		

		if not self._skipLine:	
			dst.write(line)

	#-----------------------------------------------------------------------------
	def processFile(self, src_file_path):
		dst_file_path = "Y" + src_file_path[src_file_path.find(os.path.sep):]

		print ": src: ", src_file_path
		print ": dst: ", dst_file_path

		folder, fileName = self.splitFolderAndFilename(dst_file_path);

		print ": folder, name: ", folder, fileName, os.getcwd()

		src = open(src_file_path)
		self._numLines = 0
		for line in src:
			self._numLines += 1
		src.close()
		src = open(src_file_path)
		
		if not os.path.exists(folder):
			os.mkdir(folder)

		dst = open(dst_file_path, "w")
		
		self._className = ""
		self._haXeBlock = False
		self._as3Block = False
						
		self._lineNumber = 0
		for line in src:
			self.processLine(line, dst)

		print ": ", self._numLines
		
		src.close()
		dst.close()

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

