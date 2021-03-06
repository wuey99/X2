#-----------------------------------------------------------------------------
from os import walk
from tempfile import mkstemp
from shutil import move
from os import remove, close
import os
import re
import shutil
import sys

#-----------------------------------------------------------------------------
class Update(object):

	def __init__(self, skipAssets):
		self._src_folder = ""
		self._src_fileName = ""
		self._skipAssets = skipAssets

	#-----------------------------------------------------------------------------
	def mkdir(self, folder):
		paths = folder.split("\\")

		for i in xrange (0, len(paths)):
			path = ""
			for j in xrange (0, i + 1):
				path += paths[j] + "\\"

				try:
					os.mkdir(path)
				except Exception:
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
	def convertArrayOrMap (self, line, src, dst, ext=""):
		i = line.find(" " + src)
		 
		if i == -1:
			i = line.find(":" + src)
			
		if i == -1:
			return line
			
		i += 1
		
		if line[i:].find(src + "<") >= 0:
			return line
			
		j = line[i:].find("//");
		if j == -1:
			j = line[i:].find("/*")
		if j == -1:
			return line

		j += i
		
		begin = line[j:].find("<")
		end = line[j:].find("*/")
		if end >= 0:
			end -= 2
		else:
			end = line[j:].find("\n")-1
			
		type = line[j+begin:j+end+1]
		
		line = line[0:i] + dst + type + ext + line[i + len(src):]

		return line
		
	#-----------------------------------------------------------------------------
	# convert XDicts and Arrays to their respective HaXe types (Maps and Arrays w/ typing)
	#
	# XDict (); // <key, type>
	#    --> Map<key, type> ();
	#
	# XDict; // <key, type>	
	#    --> Map<key, type>;			
	# XDict /* <key, type> */
	#    --> Map<key, type>
	#
	# Array (); // <type>
	#    --> Array<type> ();
	#
	# Array; // <type>
	#    --> Array<type>;
	# Array /* <type> */
	#    --> Array<type>		
	#
	# Class; // <type>
	#    --> Class<type>;
	# Class /* <type> */
	#    --> Class<type>
	#-----------------------------------------------------------------------------	
	def convertArraysAndMaps (self, line):
		if self.isComment(line):
			return line
			
		line = line.replace ("XDict ()", "__X$Dict__ ()")
		line = line.replace ("Array ()", "__A$rray__ ()")
		
# XDict (); // <key, type>
#    --> Map<key, type> ();
		converted = self.convertArrayOrMap (line, "__X$Dict__ ()", "__M$ap1__", " ()");
			
		line = converted
		
# XDict; // <key, type>
#    --> Map<key, type>;			
# XDict /* <key, type> */
#    --> Map<key, type>
		converted = self.convertArrayOrMap (line, "XDict", "__M$ap2__");
		
		line = converted
			
# Array (); // <type>
#    --> Array<type> ();
		converted = self.convertArrayOrMap (line, "__A$rray__ ()", "__A$rray__", " ()");
		
		line = converted
				
# Array; // <type>
#    --> Array<type>;
# Array /* <type> */
#    --> Array<type>
		converted = self.convertArrayOrMap (line, "Array", "Array");
		
		line = converted

# Class; // <type>
#    --> Class<type>;
# Class /* <type> */
#    --> Class<type>
		converted = self.convertArrayOrMap (line, "Class", "Class");

		line = converted

		line = line.replace("__M$ap1__", "__MAP__")
		line = line.replace("__M$ap2__", "__MAP__")
		
		if line.find("__MAP__") >= 0:
			if line.find("<Class<Dynamic>,") >= 0:
				line = line.replace("__MAP__<Class<Dynamic>", "Map<ClassKey")
			elif line.find("<Dynamic,") >= 0:
				line = line.replace("__MAP__<Dynamic", "Map<{}")
			else:
				line = line.replace("__MAP__", "Map")
				
		line = line.replace("__A$rray__", "Array")
		
		return line

	#-----------------------------------------------------------------------------
	# break;
	#     --> // break;
	#-----------------------------------------------------------------------------
	def convertBreaks(self, line):
		if self.isComment(line):
			return line

		if line.find("/* loop */") < 0:
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
		if classNameEnd < 0:
			classNameEnd = classNameBegin + line[classNameBegin:].find("{")
		if classNameEnd < 0:
			classNameEnd = classNameBegin + line[classNameBegin:].find("\n")
		self._className = line[classNameBegin:classNameEnd]
		print ": className: ", classNameBegin, classNameEnd, self._className
		
		line = line.replace("public class", "class")
		
		return line
	
	#-----------------------------------------------------------------------------
	# public <interfaceName>
	#     --> <interfaceName>
	#-----------------------------------------------------------------------------
	def convertInterface(self, line):
		if self.isComment(line):
			return line
			
		if line.find("public interface") < 0:
			return line
			
		line = line.replace("public interface", "interface")
		
		return line
		
	#-----------------------------------------------------------------------------
	# public function <className> () {
	#     --> public function new () {
	#-----------------------------------------------------------------------------
	def convertConstructor(self, line):
		if self.isComment(line):
			return line
			
		line = line.replace("function " + self._className + " (", "function new (")
		line = line.replace("function " + self._className + "(", "function new (")

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
		or line.find(":" + typeName + "=") >= 0 \
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
	def isIsOrAs(self, line, typeName):
		if line.find(" is " + typeName) >= 0 \
		or line.find(" as " + typeName) >= 0:
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
			
		if self.isIsOrAs(line, "Function"):
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
	# = String (
	#    --> = Std.string (
	#-----------------------------------------------------------------------------
	def convertString(self, line):
		if line.find("= String (") >= 0:
			line = line.replace("= String (", "= Std.string (")
			
		if line.find("= String(") >= 0:
			line = line.replace("= String(", "= Std.string (")
			
		return line
				
	#-----------------------------------------------------------------------------
	# :int
	#    --> :Int
	#-----------------------------------------------------------------------------
	def convertInt(self, line):
		if self.isType(line, "int"):
			line = line.replace(":int", ":Int")

		if self.isNewOrExtends(line, "int"):
			line = line.replace(" int", " Int")
			
		if line.find(" as int") >= 0:
			line = line.replace(" as int", " as Int")
			
		if line.find("= int (") >= 0:
			line = line.replace("= int (", "= Std.int (")
			
		if line.find("= int(") >= 0:
			line = line.replace("= int(", "= Std.int (")
			
		if line.find("(int (") >= 0:
			line = line.replace("(int (", "(Std.int (")
			
		if line.find(", int (") >= 0:
			line = line.replace(", int (", ", Std.int (")
			
		if line.find("<int>") >= 0:
			line = line.replace("<int>", "<Int>")
					
		return line
		
	#-----------------------------------------------------------------------------
	# :uint
	#    --> :UInt
	#-----------------------------------------------------------------------------
	def convertUInt(self, line):
		if self.isType(line, "uint"):
			line = line.replace(":uint", ":UInt")

		if self.isNewOrExtends(line, "uint"):
			line = line.replace(" uint", " UInt")
			
		if line.find("= uint (") >= 0:
			line = line.replace("= uint (", "= Std.int (")
			
		if line.find("= uint(") >= 0:
			line = line.replace("= uint(", "= Std.int (")
					
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
		
		if line.find("= Number (") >= 0:
			line = line.replace("= Number (", "= (")
			
		if line.find("= Number(") >= 0:
			line = line.replace("= Number(", "= (")
			
		line = line.replace ("is Number", "is Float")	
		line = line.replace ("as Number", "as Float")
		
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
	# :Vector.
	#    --> :Array
	#
	# <Vector.
	#    --> <Array
	#
	# new Vector.
	#    --> new Array
	#-----------------------------------------------------------------------------
	def convertVector(self, line):
		if line.find(":Vector.<Array>") >= 0:
			line = line.replace(":Vector.<Array>", ":Array<Array<Dynamic>>")

		if line.find("new Vector.<Array>") >= 0:
			line = line.replace("new Vector.<Array>", "new Array<Array<Dynamic>>")

		#-----------------------------------------------------------------------------
		if line.find(":Vector.") >= 0:
			line = line.replace(":Vector.", ":Array")

		if line.find("<Vector.") >= 0:
			line = line.replace("<Vector.", "<Array")

		if line.find("new Vector.") >= 0:
			line = line.replace("new Vector.", "new Array")

		return line
		
	#-----------------------------------------------------------------------------
	# ...args
	#    --> args:Array<Dynamic>
	#-----------------------------------------------------------------------------
	def convertRestParameters(self, line):
		if line.find("...args"):
			line = line.replace("...args", "args:Array<Dynamic>")
			
		return line
		
	#-----------------------------------------------------------------------------
	def convertIncludes(self, line, dst):
		if line.find("include \"") >= 0:
			begin = line.find("\"") + 1
			end = line[begin:].find("\"") + begin

			includeFile = line[begin:end]
			includePath = os.path.join(self._src_folder, includeFile)
			includePath = os.path.normpath(includePath)
			
			print ": include ===============================>: ", includeFile, includePath

			dst.write(line.replace("include", "// begin include"))
			
			o = Update(self._skipAssets)
			o.processFile2(includePath, dst)
			dst.write("\n")
			
			dst.write(line.replace("include", "// end include"))
			
			line = ""
			
		return line
		
	#-----------------------------------------------------------------------------
	# :Boolean
	#    --> :Bool
	# :int
	#    --> :Int
	# :uint
	#    --> :UInt
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
		line = self.convertString(line)
		line = self.convertInt(line)
		line = self.convertUInt(line)
		line = self.convertNumber(line)
		line = self.convertObject(line)
		line = self.convertVoid(line)
		line = self.convertVector(line)
		line = self.convertFunction(line)
		line = self.convertRestParameters(line)

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

		if line.find("__logicObject.xxx.getXLogicManager ().initXLogicObject") >= 0:
			line = line.replace("__logicObject.xxx.getXLogicManager ().initXLogicObject", "cast __logicObject.xxx.getXLogicManager ().initXLogicObject")

			return line

		if line.find("xxx.getXLogicManager ().initXLogicObject") >= 0:
			line = line.replace("xxx.getXLogicManager ().initXLogicObject", "cast xxx.getXLogicManager ().initXLogicObject")

			return line

		if line.find("xxx.XLogicManager ().createXLogicObject") >= 0:
			line = line.replace("xxx.getXLogicManager ().createXLogicObject", "cast xxx.getXLogicManager ().createXLogicObject")

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
		line = line.rstrip() + "\n"
		print ": OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO: "
		print ": ", line, len(line)
		right_paren = line.find(")")
		if right_paren >0 and right_paren < as_token:
			line = line[:right_paren + 1] + " /*" + line[as_token:-2] + " */" + line[-2:]

        		print ": ", line

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
	#  for (var i:int = 0; i < 10; i++) 
	#    --> for (i in 0...10)
	#-----------------------------------------------------------------------------
	def convertForLoops(self, line):
	
		def getValue(index):
			for i in range(index, len(line)):
				if line[i] != " ":
					break;
					
			end = len(line)-i
			
			j = line[i:].find(";")
			if j >= 0:
				end = min(end, j)
						
			return line[i:i+end]
			
		def getLabel(index):
			for i in range(index, len(line)):
				if line[i] != " ":
					break;
				
			end = len(line)-i
			
			j = line[i:].find(" ")
			if j >= 0:
				end = min(end, j)
			
			j = line[i:].find("<")
			if j >= 0:
				end = min(end, j)
						
			return line[i:i+end]
			
		if self.isComment(line):
			return line
			
		if line.find("for (") < 0:
			return line
			
		i = line.find("=")
		if i < 0:
			return line
		
		begin = getValue(i+1)
		
		i = line.find(";")
		if i < 0:
			return line
			
		label = getLabel(i+1)

		i = line.find("<")
		if i < 0:
			return line
			
		i = line.find("<=")
		if i < 0:
			i = line.find("<")
			le = ""
			i += 1
		else:
			le = "+1"
			i += 2
			
		end = getValue(i)
		
		bracket = False
		if line.find("{") > 0:
			bracket = True
			
		print ": ------------->: "
		print line
				
		i = line.find("for (")
		
		line = line[:i] + "for (" + label + " in " + begin + " ... " + end + le + ")"
		
		if bracket:
			line += " {"
			
		line += "\n"
		
		print line
		
		return line
	
	#-----------------------------------------------------------------------------
	# /* @:get, set rate Number */
	#    --> public var rate (get, set):Number;
	# 
	# /* @:set_type */
	#    --> replaced with parsed type
	#
	# /* @:set_return 0; */
	#    --> return 0;
	#
	# /* @:end */
	#    --> end of get/set block
	#-----------------------------------------------------------------------------
	def convertGettersAndSetters(self, line):
	
		#-----------------------------------------------------------------------------
		def getterSetterDefinition(pos, line):
			self._getterSetterMode = True
			self._getterSetterOverride = False
			self._getterSetterOverride2 = False

			pos += len("/* @:get, set") + 1
			i = line[pos:].find(" ") + pos
			self._getterSetterLabel = label = line[pos:i]

			pos = i+1
			i = line[pos:].find(" ") + pos
			self._getterSetterType = type = line[pos:i]

			line = line.replace ( \
				"/* @:get, set " + label + " " + type + " */", \
				"public var " + label + " (get, set):" + type + ";" \
			)

			return line

		#-----------------------------------------------------------------------------
		def overrideGetterSetterDefinition(pos, line):
			self._getterSetterMode = True
			self._getterSetterOverride = True
			self._getterSetterOverride2 = False

			pos += len("/* @:override get, set") + 1
			i = line[pos:].find(" ") + pos
			self._getterSetterLabel = label = line[pos:i]

			pos = i+1
			i = line[pos:].find(" ") + pos
			self._getterSetterType = type = line[pos:i]	

# is this needed?!?!
			'''
			line = line.replace ( \
				"/* @:override get, set " + label + " " + type + " */", \
				"public var " + label + " (get, set):" + type + ";" \
			)
			'''

			return line

		#-----------------------------------------------------------------------------
		def override2GetterSetterDefinition(pos, line):
			self._getterSetterMode = True
			self._getterSetterOverride = False
			self._getterSetterOverride2 = True

			pos += len("/* @:override2 get, set") + 1
			i = line[pos:].find(" ") + pos
			self._getterSetterLabel = label = line[pos:i]

			pos = i+1
			i = line[pos:].find(" ") + pos
			self._getterSetterType = type = line[pos:i]

# is this needed?!?!
			'''
			line = line.replace ( \
				"/* @:override get, set " + label + " " + type + " */", \
				"public var " + label + " (get, set):" + type + ";" \
			)
			'''

			return line

		#-----------------------------------------------------------------------------
		# @:override2: leave things along
		#
		# @:override:
		#    flash: remove override
		#    windows: keep override
		#-----------------------------------------------------------------------------
		def cleanupOverride2A(line):
#			line = line.replace("public override", "public")
			line = line.replace("// void {", "")

			return line

		def cleanupOverride2B(line):
			beg = line.find("public")
			end = line.find("{")

			if beg < 0 or end < 0:
				return line

			windows = line[beg:end+1]
			flash = line[beg:end+1]
			flash = flash.replace("public override", "@:$etter($label) public")
			flash = flash.replace("$label", self._getterSetterLabel)
			if line.find("function get") >= 0:
				flash = flash.replace("$etter", "getter")
			if line.find("function set") >= 0:
				flash = flash.replace("$etter", "setter")
				if self._getterSetterOverride:
					flash = flash.replace(self._getterSetterType + " {", "Void {")

# it looks like the latest version of HaXe actually has consistent getter/setters
#			final = line.replace(windows, "#if (windows || html5) " + windows + " #else " + flash + " #end")
			final = "		" + windows + "\n"

			print ": =================================>: ", windows
			print ": =================================>: ", flash
			print ": ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~>: ", final

			return final

		#-----------------------------------------------------------------------------
		pos = line.find("/* @:get, set")
		if pos >= 0:
			return getterSetterDefinition(pos, line)

		pos = line.find("/* @:override get, set")
		if pos >= 0:
			return overrideGetterSetterDefinition(pos, line)

		pos = line.find("/* @:override2 get, set")
		if pos >= 0:
			return override2GetterSetterDefinition(pos, line)

		if not self._getterSetterMode:
			return line

		line = line.replace("function get " + self._getterSetterLabel, "function get_" + self._getterSetterLabel)
		line = line.replace("function set " + self._getterSetterLabel, "function set_" + self._getterSetterLabel)

		line = line.replace("/* @:set_type */", self._getterSetterType + " { //")

		if not self._getterSetterOverride2:
			line = cleanupOverride2A(line)

		pos = line.find("/* @:set_return")
		if pos >= 0:
			pos += len("/* @:set_return") + 1

			i = line[pos:].find(";") + pos

			returnValue = line[pos:i]

			if not self._getterSetterOverride:
				line = line.replace("/* @:set_return " + returnValue + "; */", "return " + returnValue + ";")
			else:
#				line = line.replace("/* @:set_return " + returnValue + "; */", "#if (windows || html5) return " + returnValue + "; #end")
				line = line.replace("/* @:set_return " + returnValue + "; */", "return " + returnValue + ";\n")

			if not self._getterSetterOverride2:
				line = cleanupOverride2B(line)

			return line
			
		if line.find("/* @:end */") >= 0:
			self._getterSetterMode = False
			
		if not self._getterSetterOverride2:
			line = cleanupOverride2B(line)
			
		return line
	
	#-----------------------------------------------------------------------------
	def convertInline(self, line):
		line = line.replace("[Inline]", "// [Inline]")
		
		return line

	#-----------------------------------------------------------------------------
	# CONFIG::flash
	#    --> true
	#
	# CONFIG::starling
	#    --> false
	#-----------------------------------------------------------------------------
	def convertConfigs(self, line):
		if self.isComment(line):
			return line
			
		if line.find("if (CONFIG::") >= 0:
			line = line.replace("CONFIG::flash", "true /* CONFIG::flash */")
			line = line.replace("CONFIG::starling", "false /* CONFIG::starling */")
		
			return line
			
		line = line.replace("CONFIG::flash", "/* CONFIG::flash */")
		line = line.replace("CONFIG::starling", "/* CONFIG::starling */")
		
		return line
		
	#-----------------------------------------------------------------------------
	def convertExtendsObject(self, line):
		if line.find("extends Object {") > 0:
			line = line.replace("extends Object {", "{")
			
			self._extendsObject = True
			
		if self._extendsObject:
			if line.find("super ();") > 0:
				line = line.replace("super ();", "// super ();")
				
		return line
	
	#-----------------------------------------------------------------------------
	# protected
	#    --> private
	#-----------------------------------------------------------------------------	
	def convertProtected(self, line):
		line = line.replace ("protected var", "private var")
		line = line.replace ("protected static var", "private static var")
		line = line.replace ("protected function", "private function")
		line = line.replace ("protected override function", "private override function")
		return line
	
	#-----------------------------------------------------------------------------
	# public static const
	#    --> public static inline var
	#
	# private static const
	#    --> private static inline var
	#
	# public const
	#    --> public static inline var
	#
	# private const
	#    --> private static inline var
	#-----------------------------------------------------------------------------
	def convertConst(self, line):
		line = line.replace("public static const", "public static inline var")
		line = line.replace("private static const", "private static inline var")
		line = line.replace("public const", "public static inline var")
		line = line.replace("private const", "private static inline var")
		
		return line

	#-----------------------------------------------------------------------------
	# forEach
	#
	# <map>.forEach {
	# 	function (key:*):void {
	#	}
	# );
	#
	#    -->:
	#
	# for (key in <map>.keys ()) {
	#	function (key:Dynamic):Void {
	#   } (key);
	# }
	#
	#-----------------------------------------------------------------------------
	# doWhile
	#
	# <map>.doWhile {
	#	function (key:*):Boolean {
	#		return true;
	#	}
	# );
	#
	#    -->:
	#
	# for (key in <map>.keys ()) {
	#	if !function (key:Dynamic):Boolean {
	#		return true;
	#	} (key) break;
	# }
	#-----------------------------------------------------------------------------
	def convertForEach_OLD(self, line):
		if self.isComment(line):
			return line

		startLoop = False

		if line.find(".forEach (") >= 0:
			self._forEach = True
			self._doWhile = False
			self._loopLevel = 0
			self._loopCast = False
			if line.find("/* @:castkey */") >= 0:
				self._loopCast = True
			startLoop = True

		if line.find(".doWhile (") >= 0:
			self._forEach = False
			self._doWhile = True
			self._loopLevel = 0
			self._loopCast = False
			if line.find("/* @:castkey */") >= 0:
				self._loopCast = True
			startLoop = True

		if startLoop:
			for i in xrange(0, len(line)):
				if line[i] != " " and line[i] != "\t":
					break;

			end = line[i:].find(".forEach")
			if end < 0:
				end = line[i:].find(".doWhile")
			label = line[i:end+i]

			line = line[:i] + "for (__key__ in " + label + ".keys ()) {\n"

			return line

		if not (self._forEach or self._doWhile):
			return line

		self._loopLevel += line.count("{")
		self._loopLevel -= line.count("}")

		if self._loopLevel and line.find("function (") >= 0 and self._doWhile:
			line = line.replace ("function (", "if (!function (")

		if self._loopLevel == 0 and line.count("}") > 0:
			if self._forEach:
				if self._loopCast:
					line = line[:-1] + " (cast __key__);\n"
				else:
					line = line[:-1] + " (__key__);\n"
			else:
				if self._loopCast:
					line = line[:-1] + " (cast __key__)) break;\n"
				else:
					line = line[:-1] + " (__key__)) break;\n"

			return line

		if self._loopLevel == 0 and line.find(");"):
			line = line.replace(");", "}")

			self._forEach = False
			self._doWhile = False
			self._loopCast = False
			self._loopLevel = 0

		return line

	#-----------------------------------------------------------------------------
	# forEach
	#
	# <map>.forEach (
	# 	function (key:*):void {
	#	}
	# );
	#
	#    -->:
	#
	# XType.forEach (map,
	# 	function (key:*):Boolean {
	#		return true;
	#	}
	# );
	#
	#-----------------------------------------------------------------------------
	# doWhile
	#
	# <map>.doWhile (
	#	function (key:*):Boolean {
	#		return true;
	#	}
	# );
	#
	#    -->:
	#
	# XType.doWhile (map,
	# 	function (key:*):Boolean {
	#		return true;
	#	}
	# );
	#
	#-----------------------------------------------------------------------------
	def convertForEach(self, line):
		if self.isComment(line):
			return line

		def findName ():
			for i in xrange(0, len(line)):
				if line[i] != " " and line[i] != "\t":
					break;

			end = line[i:].find(".forEach")
			if end < 0:
				end = line[i:].find(".doWhile")
			return line[i:end+i]

		if line.find(".forEach (") >= 0:
			name = findName ()
			line = line.replace(name + ".forEach (", "XType.forEach (" + name + ", ")

		if line.find(".doWhile (") >= 0:
			name = findName ()
			line = line.replace(name + ".doWhile (", "XType.doWhile (" + name + ", ")

		return line

	#-----------------------------------------------------------------------------
	def convertXML(self, line):
		if not (self._src_folder.startswith("kx\\resource") or self._src_fileName == "XApp.as" or self._src_fileName == "TextureAtlas.as" or self._src_fileName == "XStaticSubTextureManager.as"):
			return line
			
		line = line.replace(":XMLList", ":Array<XSimpleXMLNode>")
		line = line.replace(".length ()", ".length")
		line = line.replace(":XML", ":XSimpleXMLNode")
		line = line.replace("new XML", "new XSimpleXMLNode")
		
		return line

	#-----------------------------------------------------------------------------
	# expand XDict.removeAllKeys.
	#
	# HaXe Maps don't support a removeAllKeys method
	#-----------------------------------------------------------------------------
	def convertRemoveAllKeys(self, line):
#		if self.isComment(line):
#			return line

		if line.find(".removeAllKeys") < 0:
			return line

		for i in xrange(0, len(line)):
			if line[i] != " " and line[i] != "\t":
				break;

		end = line[i:].find(".")
		label = line[i:end+i]

		# line = line[:i] + "for (__key__ in " + label + ".keys ()) { " + label + ".remove (__key__); } // removeAllKeys\n"
		line = line[:i] + "XType.removeAllKeys (" + label +");\n"

		return line
			
	#-----------------------------------------------------------------------------	
	# import flash. 
	#    --> import openfl.
	#-----------------------------------------------------------------------------	
	def convertImports(self, line):
		if self.isComment(line):
			return line
			
		line = line.replace("import flash.", "import openfl.")

		return line

	#-----------------------------------------------------------------------------	
	# e:Error) 
	#    --> e:Dynamic
	#-----------------------------------------------------------------------------	
	def convertErrors(self, line):
		if self.isComment(line):
			return line
			
		line = line.replace("e:Error)", "e:Dynamic)")
		
		return line
		
	#----------------------------------------------------------------------------
	# HaXe doesn't recognize + signs preceding numbers
	#
	# +64
	#    --> 64							
	#----------------------------------------------------------------------------
	def convertPlusSigns(self, line):
		if self.isComment(line):
			return line

		if line.find("= ++") >= 0:
			return line

		line = line.replace("= +", "= ")
		line = line.replace(", +", ", ")

		return line

	#-----------------------------------------------------------------------------
        # override function setup (__xxx:XWorld, args:Array)
	#-----------------------------------------------------------------------------
	def convertXLogicObjectSetup(self, line):
		if self.isComment(line):
			return line

		line = line.replace("override function setup (__xxx:XWorld, args:Array)", "override function setup (__xxx:XWorld, args:Array /* <Dynamic> */)")

		return line

	#-----------------------------------------------------------------------------
	# trace
	#    --> // trace
	#-----------------------------------------------------------------------------
	def convertTraces(self, line):
		if self.isComment(line):
			return line

		line = line.replace("trace (\"", "// trace (\"")

		return line

	#-----------------------------------------------------------------------------
	def processLine(self, line, dst):
		self._lineNumber += 1
		self._skipLine = False

		line = self.convertImports(line)
		line = self.convertErrors(line)
#		line = self.convertTraces(line)
		line = self.convertPlusSigns(line)
		line = self.convertExtendsObject(line)
		line = self.convertXLogicObjectSetup(line)
		line = self.convertArraysAndMaps(line)
		line = self.convertArraysAndMaps(line)
		line = self.convertBreaks(line)
		line = self.convertClass(line)
		line = self.convertInterface(line)
		line = self.convertTypes(line)
		line = self.convertCasts(line)
		line = self.convertIs(line)
		line = self.convertGettersAndSetters(line)
		line = self.convertForLoops(line)
		line = self.convertHaXeBlock(line)
		line = self.convertPackage(line)
		line = self.convertInline(line)
		line = self.convertConfigs(line)
		line = self.convertProtected(line)
		line = self.convertConst(line)
		line = self.convertForEach(line)
		line = self.convertXML(line)
		line = self.convertIncludes(line, dst)
		line = self.convertRemoveAllKeys(line)
		line = line.replace("starling.display.MovieClip", "openfl.display.MovieClip")

		if not self._skipLine:
			dst.write(line)

	#-----------------------------------------------------------------------------
	def processNewFile(self, targetDir, src_file_path):
		dst_file_path = targetDir + src_file_path[src_file_path.find(os.path.sep):]

		dst_file_path = dst_file_path.replace(".as", ".hx")

		print ": src: ", src_file_path
		print ": dst: ", dst_file_path

		self._src_folder, self._src_fileName = self.splitFolderAndFilename(src_file_path)
		folder, fileName = self.splitFolderAndFilename(dst_file_path)

		print ": src folder, name: ", self._src_folder, self._src_fileName
		print ": dst folder, name: ", folder, fileName, os.getcwd(), os.path.exists(folder)

		if not os.path.exists(folder):
			self.mkdir(folder)

		dst = open(dst_file_path, "w")

		self.processFile2(src_file_path, dst)

		dst.close()

	#-----------------------------------------------------------------------------
	def processFile2(self, src_file_path, dst):
		src = open(src_file_path)
		self._numLines = 0
		for line in src:
			self._numLines += 1
		src.close()
		src = open(src_file_path)

		self._className = ""
		self._haXeBlock = False
		self._as3Block = False
		self._getterSetterMode = False
		self._extendsObject = False
		self._forEach = False
		self._doWhile = False
		self._loopLevel = 0
		self._loopCast = False

		self._lineNumber = 0
		for line in src:
			self.processLine(line, dst)

		print ": ", self._numLines
		
		src.close()
		
	#-----------------------------------------------------------------------------
	def processDirectory(self, targetDir, paths):

	#-----------------------------------------------------------------------------
		for i in xrange(len(paths)):
			path = paths[i]

	#-----------------------------------------------------------------------------
			for (dirpath, dirnames, filenames) in walk(path):
				for j in xrange(len(filenames)):
					if filenames[j].endswith(".as") or filenames[j].endswith(".h"):
						file_path = path + os.path.sep + filenames[j]

						if self._skipAssets == "use" or (self._skipAssets == "skip" and path.find("\\assets") < 0):
							self.processNewFile (targetDir, file_path)

				for j in xrange(len(dirnames)):
					dirnames[j] = path + os.path.sep + dirnames[j]

				if len(dirnames):
					self.processDirectory(targetDir, dirnames)

#-----------------------------------------------------------------------------
if len(sys.argv) < 3:
	print "usage: python as32HaXe.py <path> <skipAssets>"
	exit(0)

 
skipAssets = sys.argv[2]
sourceDir = sys.argv[1]
targetDir = "_" + sourceDir

print ": sourceDir: ", sourceDir
print ": skipAssets: ", skipAssets

if os.path.exists(targetDir):
	shutil.rmtree(targetDir)

o = Update(skipAssets)
o.processDirectory(targetDir, [sourceDir])


