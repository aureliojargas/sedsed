#!/usr/bin/python
# sedsed
# 20011127 <aurelio@verde666.org> ** debut
# ChangeLog: see README file at http://sedsed.sf.net

import sys, re, os, getopt, string

# program self data
myname = 'sedsed'
myversion = 0.5
myhome = 'http://sedsed.sf.net'

# default config
color = 1                     # colored output? (it's nice)
DEBUG = 0                     # set developper's debug level [0-3]
EMUDEBUG = 0                  # emulator have it's own debug [0-3]
indentprefix = '  '           # default indent prefix
action = 'indent'             # default action

#-------------------------------------------------------------------------------

def error(msg):
	print 'ERROR:',msg ; sys.exit(1)

# OS/system functions
def readFile(file):            # remove \n$
	if not os.path.isfile(file): error('file not found: %s'%file)
	f = open(file); txt = f.read(); f.close
	txt = re.sub('\n$','',txt) ; return string.split(txt, '\n')
def writeFile(file, list=[]):
	if list:
		for i in range(len(list)): # ensuring line break
			list[i] = string.rstrip(list[i])+'\n'
	f = open(file,'w'); f.writelines(list); f.close()
def mkTmpFile(list=[]):
	from time import time
	file = '/tmp/sedsed.%s'%str(time())
	writeFile(file, list)
	return file
def runCommand(cmd): # Returns a (#exit_code, program_output[]) tuple
	list = [] ; fd = os.popen(cmd)
	for line in fd.readlines():
		list.append(rstrip(line))  # stripping \s*\n
	ret = fd.close()
	if ret: ret = ret/256  # 16bit number
	return ret, list


def printUsage(exitcode=1):
	print """
usage: sedsed OPTION [-e sedscript] [-f sedscriptfile] [inputfile]

OPTIONS:

     -f, --file          add file contents to the commands to be parsed
     -e, --expression    add the script to the commands to be parsed

     -d, --debug         DEBUG the sed script
         --nocolor       no colors on debug output
         --hide          hide some debug info (options: PATT,HOLD,COMM)
		 
         --emu           emulates GNU sed (INCOMPLETE)
         --emudebug      emulates GNU sed debugging the sed script (INCOMPLETE)

     -i, --indent        script beautifier, prints indented and
                         one-command-per-line output do STDOUT
         --prefix        indent prefix string (default: 2 spaces)

     -t, --tokenize      script tokenizer, prints extensive
                         command by command information
         --htmlize       converts sed script to a colorful HTML page

     -V, --version       prints the program version and exit
     -h, --help          prints this help message and exit


NOTE: --emu and --emudebug options are still INCOMPLETE and must
      be used with care. mainly regexes and address $ (last line)
      are not handled right by the emulator.
"""
	print "homepage: %s\n"%myhome
	sys.exit(exitcode)

# get cmdline options
errormsg = 'bad option or missing argument. try --help.'
try: (opt, args) = getopt.getopt(sys.argv[1:], 'he:f:ditV',
     ['debug', 'hide=', 'nocolor', 'indent', 'prefix=', 'emu', 'emudebug',
      'tokenize', 'htmlize', 'version', 'help', 'file=', 'expression=',
      '_debuglevel=','_emudebuglevel=','_stdout-only', 'dumpcute'])      # admin hidden opts
except getopt.GetoptError: error(errormsg)

actionopts = []
sedscript = []
infile = ''
for o in opt:
	if   o[0] in ('-d', '--debug')     : action = 'debug'
	elif o[0] in ('-i', '--indent')    : action = 'indent'; color = 0
	elif o[0] in ('-t', '--tokenize')  : action = 'token' ; color = 0
	elif o[0] in ('-e', '--expression'): sedscript.append(o[1])
	elif o[0] in ('-f', '--file')      :
		sedscript.extend(readFile(o[1])) ; infile = o[1]
	elif o[0] in ('-h', '--help')      : printUsage(0)
	elif o[0] in ('-v', '--version')   :
		print '%s v%s'%(myname,myversion); sys.exit(0)
	elif o[0] == '--htmlize' : action = 'html'  ; color = 0
	elif o[0] == '--emu'     : action = 'emu'
	elif o[0] == '--emudebug': action = 'emudebug'
	elif o[0] == '--nocolor' : color = 0
	elif o[0] == '--hide':                            # get hide options
		for hide in string.split(o[1], ','):          # save as no<OPT>
			actionopts.append('no'+string.lower(string.strip(hide)))
	elif o[0] == '--prefix':
		if re.sub('\s','',o[1]):                      # prefix is valid?
			error("invalid indent prefix. must be spaces and/or TABs.")
		indentprefix = o[1]
	
	elif o[0] == '--_debuglevel': DEBUG = int(o[1])
	elif o[0] == '--_emudebuglevel': EMUDEBUG = int(o[1])
	elif o[0] == '--dumpcute'   : DEBUG = 0; color = 1; action = 'dumpcute'
	elif o[0] == '--_stdout-only': action = 'debug' ; actionopts.append(o[0][2:])

# sanity checks
if not sedscript:
	if args: sedscript.append(args.pop(0))
	else: error("there's no sed script to parse! (try --help)")
# get all text files (if any)
textfiles = args
if not textfiles: textfiles = ['-']
# the sed script is syntax-error free?
if action == 'debug':
	tmpfile = mkTmpFile(sedscript)
	ret, msg = runCommand("sed -f '%s' /dev/null"%tmpfile)
	if ret: error('#%d: syntax error on your sed script, please fix it before.'%ret)
	os.remove(tmpfile)

# color is nice
color_YLW = color_NO = color_RED = color_REV = ''     # no color
if color:
	color_YLW='\033[33;1m' ; color_RED='\033[31;1m'   # yellow, red
	color_NO='\033[m' ; color_REV='\033[7m'           # default, reverse

# the sed debug magic lines
pattid = 'PATT:' ; holdid = 'HOLD:' ; commid = 'COMM:'
showpatt = '  s/^/%s/;l;s/^%s//   ;# show pattern space\n'%(pattid, pattid)
showhold = 'x;s/^/%s/;l;s/^%s//;x ;# show hold space\n'%(holdid, holdid)
showcomm = '  s@^@%s%s\a%s\\\n   @;P;s/^[^\\n]*\\n   //'%(commid,color_YLW,color_NO)
showcomm = showcomm +'     ;# show command\n'
restaddr = '{;} ;# restoring last address\n'
save_t = 't wasset\a\n#DEBUG#\nt wasclear\a\n: wasset\a\n#DEBUG#\n: wasclear\a\n'

# t wasset\a
# #DEBUG#
# t wasclear\a
# : wasset\a
# #DEBUG#
# : wasclear\a

if actionopts.count('nopatt'): showpatt = ''          # don't show!
if actionopts.count('nohold'): showhold = ''          # don't show!
if actionopts.count('nocomm'): showcomm = ''          # don't show!


#---------------------------------- patterns -----------------------------------
patt = {}
sedcmds = {}
html = {}

sedcmds['file']  = 'rw'
sedcmds['addr']  = '/$0123456789\\'
sedcmds['multi'] = 'sy'
sedcmds['solo']  = 'nNdDgGhHxpPlq='
sedcmds['text']  = 'aci'
sedcmds['jump']  = ':bt'
sedcmds['block'] = '{}'
sedcmds['flag']  = 'gpIi0123456789w'

patt['jump_label'] = r'[^\s;}#]*'             # _any_ char, except those, or None
patt['filename']   = r'[^\s]+'                # _any_ not blank char (strange...)
patt['flag']       = r'[%s]+'%sedcmds['flag'] # list of all flags
patt['topopts'] = r'#!\s*/[^\s]+\s+-([nf]+)'  # options on #!/bin/sed header

# HTML colors for --htmlize
html['addr1']     = '#8080ff'
html['addr1flag'] = '#ff6060'
html['addr2']     = '#8080ff'
html['addr2flag'] = '#ff6060'
html['lastaddr']  = ''
html['modifier']  = '#ff6060'
html['id']        = '#ffff00'
html['content']   = '#ff00ff'
html['delimiter'] = '#ff6060'
html['pattern']   = '#8080ff'
html['replace']   = ''
html['flag']      = '#00ff00'
html['extrainfo'] = ''
html['comment']   = '#00ffff'
html['escape']    = '#ff6060'
html['special']   = '#00ff00'
html['pattmeta']  = '#ff00ff'
html['plaintext'] = ''
html['branch']    = ''
# open HTML page with defined page colors
html['htmlheader'] = """\
<html>\n<head><meta name="Generator" content="sedsed --htmlize">
<title>Colorized %s</title></head><body bgcolor="#000000" text="#ffffff"
link="#ff00ff" alink="#ff00ff" vlink="#ff00ff">
<pre>\n"""%os.path.basename(infile)
# final comment about sedsed and close HTML
html['htmlfooter'] = """
<font color="%s"><b>### colorized by <a href="http://sedsed.sf.net">sedsed</a>\
, a sed script debugger/indenter/tokenizer/HTMLizer</b></font>\n
</pre></body></html>"""%html['comment']

cmdfields = ['linenr',
  'addr1', 'addr1flag', 'addr2', 'addr2flag', 'lastaddr', 'modifier',
  'id', 'content', 'delimiter', 'pattern', 'replace', 'flag',
  'extrainfo', 'comment']

#-------------------------------------------------------------------------------

def debug(msg, level=1):
	if DEBUG and DEBUG >= level: print '+++ DEBUG%d: %s'%(level,msg)

def esc_RS_EspecialChars(str):
	str = string.replace(str, '\\', '\\\\')           # escape escape
	str = string.replace(str, '&', r'\&')             # matched pattern
	str = string.replace(str, '@', r'\@')             # delimiter
	return str

def isOpenBracket(str):
	# bracket open:  [   \\[   \\\\[ ...
	# not bracket : \[  \\\[  \\\\\[ ...
	isis = 0
	delim = '['
	str = re.sub('\[:[a-z]+:]', '', str)              # del [:charclasses:]
	if string.find(str, delim) == -1: return 0        # hey, no brackets!
	
	# only the last two count
	patterns = string.split(str, delim)[-2:]
	debug('bracketpatts: %s'%patterns,3)
	possibleescape, bracketpatt = patterns
	
	# maybe the bracket is escaped, and is not a metachar?
	m = re.search(r'\\+$', possibleescape)            # escaped bracket
	if m and len(m.group(0))%2:                       # if odd number of escapes
		debug('bracket INVALID! - escaped',2)
		isis = 0
	elif string.find(bracketpatt, ']') == -1:         # if not closed by ]
		debug('bracket OPEN! - found! found!',2)
		isis = 1                                      # it is opened! &:)
	
	return isis

def paintHtml(id, txt):
	if txt:  # escaping HTML
		txt = string.replace(txt, '&', '&amp;')
		txt = string.replace(txt, '>', '&gt;')
		txt = string.replace(txt, '<', '&lt;')
	# some color adjustments and emphasis
	if   id == 'id' and txt in sedcmds['block']: id = 'delimiter'
	elif id == 'id' and txt == ':': id = 'content'
	elif id == 'replace':   # highlight \n, & and \$
		newtxt = paintHtml('special', '\\'+linesep)
		txt = string.replace(txt, '\\'+linesep, newtxt)
		txt = re.sub('(\\\\[1-9]|&amp;)', paintHtml('special', '\\1'), txt)
	elif id == 'pattern':   # highlight group open ( and or |
		txt = re.sub('(\\\\)([(|])', '\\1'+paintHtml('pattmeta', '\\2'), txt)
	elif id == 'plaintext': # highlight \$
		newtxt = paintHtml('special', '\\'+linesep)
		txt = string.replace(txt, '\\'+linesep, newtxt)
	elif id == 'branch':    # nice link to the label!
		txt = '<a href="#%s">%s</a>'%(txt,txt)
	elif id == 'target':    # link target
		txt = '<a name="%s">%s</a>'%(txt,txt); id = 'content'
	
	if html[id] and txt: txt = '<font color="%s"><b>%s</b></font>'%(html[id], txt)
	return txt

#-------------------------------------------------------------------------------

def composeSedAddress(dict):
	addr1 = ''
	if action == 'html':
		if dict['addr1']: addr1 = dict['addr1html']
		if dict['addr2']: addr2 = dict['addr2html']
	else:
		addr1 = '%s%s'%(dict['addr1'],dict['addr1flag'])
		if dict['addr2']: addr2 = '%s%s'%(dict['addr2'],dict['addr2flag'])
	
	if dict['addr2']: addr = '%s,%s'%(addr1,addr2)
	else: addr = addr1
	
	if addr: addr = '%s '%(addr)  # visual addr/cmd separation
	return addr

def composeSedCommand(dict):
	if dict['delimiter']:         # s///
		if action != 'html':
			cmd = '%s%s%s%s%s%s%s%s'%(
			    dict['modifier'] ,dict['id'],
			    dict['delimiter'],dict['pattern'],
			    dict['delimiter'],dict['replace'],
			    dict['delimiter'],dict['flag'])
			if dict['content']:   # s///w filename
				cmd = cmd+' '+dict['content']
		else:
			cmd = """%s%s%s%s%s%s%s%s"""%(
			    paintHtml('modifier' , dict['modifier'] ),
			    paintHtml('id'       , dict['id']       ),
			    paintHtml('delimiter', dict['delimiter']),
			    paintHtml('pattern'  , dict['pattern']  ),
			    paintHtml('delimiter', dict['delimiter']),
			    paintHtml('replace'  , dict['replace']  ),
			    paintHtml('delimiter', dict['delimiter']),
			    paintHtml('flag'     , dict['flag']     ))
			if dict['content']:   # s///w filename
				cmd = '%s %s'%(cmd,paintHtml('content', dict['content']))
	else:
		idsep=''
		spaceme = sedcmds['file']+sedcmds['jump']+sedcmds['text']
		if dict['id'] in spaceme: idsep=' '
		cmd = '%s%s%s%s'%(dict['modifier'],dict['id'],idsep,dict['content'])
		if action == 'html':
			if   dict['id'] in sedcmds['text']: content_type = 'plaintext'
			elif dict['id'] in 'bt': content_type = 'branch'
			elif dict['id'] == ':': content_type = 'target'
			else: content_type = 'content'
			
			cmd = '%s%s%s%s'%(
			       paintHtml('modifier'  , dict['modifier']),
			       paintHtml('id'        , dict['id']      ), idsep,
			       paintHtml(content_type, dict['content'] ))
	cmd = string.replace(cmd, linesep, '\n')
	return cmd

################################################################################

# SedCommand already receives lstrip()ed data and data != None
class SedCommand:
	def __init__(self, abcde):
		self.id = abcde[0]   # s
		self.content = ''    # txt, filename
		self.modifier = ''   # !
		self.full = ''       # !s/abc/def/g
		
		# for s/// & y///
		self.pattern = ''    # abc
		self.replace = ''    # def
		self.delimiter = ''  # /
		self.flag = ''       # g
		
		self.isok = 0
		self.comment = ''
		self.rest = self.junk = abcde
		self.extrainfo = ''
		
		if self.id == '!':
			self.modifier = self.id                   # set modifier
			self.junk = string.lstrip(self.junk[1:])  # del !@junk
			self.id = self.junk[0]                    # set id again
		self.junk = self.junk[1:]                     # del id@junk
		
		#self.setId()
		self.doItAll()
	
	#-----------------------------------------------------
	
	def doItAll(self):
		# here, junk arrives without the id, but not lstripped (s///)
		id = self.id
		
		#TODO put pending comment on the previous command (h ;#comm)
		if id == '#':
			debug('type: comment',3)
			self.comment = self.id+self.junk
			self.junk = ''
			self.isok = 1
		
		elif id in sedcmds['solo']:
			debug('type: solo',3)
			self.isok = 1
		elif id in sedcmds['block']:
			debug('type: block',3)
			self.isok = 1
		elif id in sedcmds['text']:
			debug('type: text',3)
			if self.junk[-1] != '\\': # ensuring \^M at start
				self.content = re.sub(r'^\\%s'%linesep, '', self.junk)
				self.content = '\\%s%s'%(linesep,self.content)
				self.isok = 1
		
		elif id in sedcmds['jump']:
			debug('type: jump',3)
			self.junk = string.lstrip(self.junk)
			m = re.match(patt['jump_label'], self.junk)
			if m:
				self.content = m.group()
				self.junk = self.junk[m.end():]
				self.isok = 1
		
		elif id in sedcmds['file']:
		#TODO deal with valid cmds like 'r bla;bla' (!!!) and 'r bla ;#comm'
		#TODO spaces and ; are valid as filename chars
			debug('type: file',3)
			self.junk = string.lstrip(self.junk)
			m = re.match(patt['filename'], self.junk)
			if m:
				self.content = m.group()
				self.junk = self.junk[m.end():]
				self.isok = 1
		
		elif id in sedcmds['multi']:                  # s/// & y///
			debug('type: multi',3)
			self.delimiter = self.junk[0]
			ps = SedAddress(self.junk)
			hs = ''
			if ps.isok:
				self.pattern = ps.pattern
				self.junk = ps.rest
				# 'replace' opt is to avoid openbracket check (s/bla/[/ is ok)
				hs = SedAddress(self.delimiter+self.junk, 'replace')
				if hs.isok:
					self.replace = hs.pattern
					self.junk = string.lstrip(hs.rest)
					
					### great s/patt/rplc/ sucessfully taken
			
			if hs and hs.isok and self.junk:          # there are flags?
				debug('possible s/// flag: %s'%self.junk,3)
				m = re.match('(%s\s*)+'%patt['flag'],self.junk)
				if m:
					self.flag = m.group()
					self.junk = string.lstrip(self.junk[m.end():]) # del flag
					self.flag = re.sub('\s','',self.flag)  # del blanks@flag
					debug('FOUND s/// flag: %s'%string.strip(self.flag))
					
					### now we've got flags also
				
				if 'w' in self.flag:                  # write file flag
					m = re.match(patt['filename'], self.junk)
					if m:
						self.content = m.group()
						debug('FOUND s///w filename: %s'%self.content)
						self.junk = string.lstrip(self.junk[m.end():])
						
						### and now, s///w filename is saved also
			
			if hs and hs.isok: self.isok = 1
		
		else:
			error("invalid sed command '%s' at line %d"%(id,linenr))
		
		if self.isok:
			self.full = composeSedCommand(vars(self))
			self.full = string.replace(self.full, '\n', linesep) # oneliner
			self.rest = string.lstrip(self.junk)
			debug('FOUND command: %s'%self.full)
			debug('rest left: %s'%self.rest,2)
			
			possiblecomment = self.rest
			if possiblecomment and possiblecomment[0] == '#':
				self.comment = possiblecomment
				debug('FOUND comment: %s'%self.comment)
		debug('SedCommand: %s'%vars(self),3)


################################################################################

#TIP an address is NOT multiline
class SedAddress:
	def __init__(self, abcde, context='addr'):
		self.delimiter = ''
		self.pattern = ''
		self.flag = ''
		self.full = ''
		self.html = ''
		
		self.isline = 0
		self.isok = 0
		self.escape = ''
		self.rest = self.junk = abcde
		self.context = context
		
		self.setType()                                # numeric or pattern?
		self.doItAll()
		debug('SedAddress: %s'%vars(self),3)
		
	#------------------------------------------------------
	
	def doItAll(self):
		if self.isline: self.setLineAddr()
		else          : self.setPattAddr()
		
		if self.isok:
			self.full = '%s%s%s%s'%(self.escape,self.delimiter,self.pattern,self.delimiter)
			if action == 'html':
				self.html = '%s%s%s%s'%(
				   paintHtml('escape'   , self.escape   ),
				   paintHtml('delimiter', self.delimiter),
				   paintHtml('pattern'  , self.pattern  ),
				   paintHtml('delimiter', self.delimiter))
			debug('FOUND addr: %s'%self.full)
			
			cutlen = len(self.full)+len(self.flag)
			self.rest = self.rest[cutlen:]            # del addr from junk
			self.flag = string.strip(self.flag)       # del blank from flag
			debug('rest left: %s'%self.rest,2)
		else:
			debug('OH NO! partial addr: %s'%self.rest)
	
	#------------------------------------------------------
	
	def setType(self):
		id = self.junk[0]
		if re.match('[0-9$]', id): self.isline = 1    # numeric address, easy!
		else:                                         # oh no, pattern
			if id == '\\':                            # strange delimiter (!/)
				self.escape = '\\'
				self.junk = self.junk[1:]             # del escape - s/^\\//
			self.delimiter = self.junk[0]             # set delimiter
			self.junk = self.junk[1:]                 # del delimiter@junk
	
	def setLineAddr(self):
		m = re.match(r'[0-9]+|\$', self.junk)
		self.pattern = m.group(0)
		self.isok = 1
	
	def setPattAddr(self):
		###
		# similar to command finder:
		# - split at pattern delimiter
		# - if address not terminated, join with next split chunk (loop)
		# - address found, return it
		#
		# We can deal with really catchy valid addresses like:
		#   /\/[/]\\/   and   \;\;[;;]\\;
		incompleteaddr = ''
		
		debug('addr delimiter: '+self.delimiter,2)
		patterns = string.split(self.junk, self.delimiter)
		debug('addr patterns: %s'%patterns,2)
		
		while patterns:
			possiblepatt = patterns.pop(0)
			
			# if address not terminated, join next
			if incompleteaddr:
				possiblepatt = string.join([incompleteaddr, possiblepatt],
				                            self.delimiter)
				incompleteaddr = ''
			debug('possiblepatt: '+possiblepatt,2)
			
			# maybe splitted at a (valid) escaped delimiter?
			if re.search(r'\\+$', possiblepatt):
				m = re.search(r'\\+$', possiblepatt)
				if len(m.group(0))%2:
					debug('address INCOMPLETE! - ends with \\ alone')
					incompleteaddr = possiblepatt
					continue
			
			if self.context != 'replace':
				# maybe splitted at a delimiter inside char class []?
				# BUG: []/[] is not catched - WONTFIX
				if isOpenBracket(possiblepatt):
					debug('address INCOMPLETE! - open bracket')
					incompleteaddr = possiblepatt
					continue
			
			break                                     # it's an address!
		
		if patterns:                                  # must have something left
			if patterns[0]:                           # the rest is a flag?
				debug('possible addr flag: %s'%patterns[0],3)
				m = re.match('\s*I\s*', patterns[0])
				if m:                                 # yes, a flag!
					self.flag = m.group()             # set addr flag
					debug('FOUND addr flag: %s'%string.strip(self.flag))
			self.pattern = possiblepatt
			self.isok = 1


################################################################################
################################################################################
################################################################################

### global view of the parser:
#
# - load the original sed script to a list, left the file free
# - scan the list (line by line)
# - as user can do more than one sed command on the same line, we split
#   "possible valid commands" by ; (brute force method)
# - validate each splitted command
# - if not valid, join next, and try to validate again (loop here)
# - if hit EOL and still not valid, join next line, validate (loop here)
# - hit EOF, we've got all info at hand
# - generate a result list with all sed command found and its data, each
#   command having it's own dictionary: {addr1: '', addr2: '', cmd: ''}
###


incompletecmd = ''
incompleteaddr = ''
incompletecmdline = ''
addr1 = addr2 = ''
lastaddr = ''
lastsubref = ''
has_t = 0
cmdsep = ';'
linesep = '§§§'
newlineshow = '%s\\N%s'%(color_RED,color_NO)
newlinemark = r']]\([\)'
blanklines= []
ZZ = []
ZZ.append({})  #for header

linenr = 0
cmddict = {}
for line in sedscript:
	linenr = linenr + 1
	
	if linenr == 1:                                   # 1st line #!/... finder
		m= re.match(patt['topopts'], line)
		if m:                                         # we have options!
			ZZ[0]['topopts'] = m.group(1)             # saved on list header
			del m
	
	if incompletecmdline:
		line = string.join([incompletecmdline, line], linesep)
	
	if line and line[-1] == '\n': line = line[:-1]    # s/\n$//
	if not string.strip(line):                        # blank line
		blanklines.append(linenr)
		ZZ.append({'linenr': linenr, 'id': ''})
		continue
	
	if DEBUG: print ; debug('line:%d: %s'%(linenr,line))
	
	if string.lstrip(line)[0] == '#':
		linesplit = [string.lstrip(line)]   # trick to bypass comment lines
	else:
		linesplit = string.split(line, cmdsep)        # split lines at ;
	
	while linesplit:
		possiblecmd = linesplit.pop(0)
		if not incompletecmdline:
			if incompletecmd:
				possiblecmd = string.join([incompletecmd, possiblecmd], cmdsep)
			if incompleteaddr:
				possiblecmd = string.join([incompleteaddr, possiblecmd], cmdsep)
		else:
			incompletecmdline = ''
		
		if not possiblecmd: continue # ; at EOL or useless sequence of ;;;;
		
		debug('possiblecmd: '+possiblecmd,2)
		possiblecmd = string.lstrip(possiblecmd)      # del space at begin
		cmdid = possiblecmd[0]                        # get 1st char (sed cmd)
		
		if cmdid == '\\' and len(possiblecmd) == 1:   # to get \;addr; (cool!)
			incompleteaddr = cmdid
			continue
		
		
		###----------- get addresses routine ---------------
		#
		# to handle ranges, match addresses one by one:
		# - matched addr at ^   ? get it and set addr1.
		# - next char is a comma? it's a range. get & set addr2.
		# - addresses are cutted from command, continue.
		#
		# we're not using split cause it fails at /bla[,]bla/ address
		#
		while 1:
			if not possiblecmd[0] in sedcmds['addr']: break # no addr
			
			addr = SedAddress(possiblecmd)            # get data
			
			if addr.isok:
				if not cmddict.has_key('addr1'):
					cmddict['linenr'] = linenr
					cmddict['addr1'] = addr.full
					cmddict['addr1flag'] = addr.flag
					cmddict['addr1html'] = addr.html
					if addr.pattern: lastaddr = addr.full
					else: cmddict['lastaddr'] = lastaddr
				else:
					cmddict['addr2'] = addr.full
					cmddict['addr2flag'] = addr.flag
					cmddict['addr2html'] = addr.html
					if addr.pattern: lastaddr = addr.full
					else: cmddict['lastaddr'] = lastaddr
				rest = addr.rest
			else:
				incompleteaddr = addr.rest
				break                                 # join more cmds
			
			if not cmddict.has_key('addr2') and rest[0] == ',': # it's a range!
				possiblecmd = string.lstrip(rest[1:]) # del comma and blanks
				continue                              # process again
			else:
				incompleteaddr = ''
				possiblecmd = string.lstrip(rest)
				break                                 # we're done!
		
		if incompleteaddr: continue                   # need more cmds!
		for key in cmdfields[:6]:  # filling not set addr fields
			if not cmddict.has_key(key): cmddict[key] = ''
		
		###-------------------------------------------------
		### from here, address is no more
		###-------------------------------------------------
		
		if not incompletecmd:
			if not possiblecmd: error('missing command at line %d!'%linenr)
			cmd = SedCommand(possiblecmd)
			if not cmddict['linenr']: cmddict['linenr'] = linenr
		else:
			cutme = len(cmd.modifier+cmd.id)
			cmd.rest = possiblecmd
			cmd.junk = possiblecmd[cutme:]
			cmd.doItAll()
		
		if cmd.isok:
			for key in cmdfields[6:]:                 # filling cmd entry data
				cmddict[key] = getattr(cmd, key)
			
			# saving last address content
			if cmd.pattern: lastaddr = cmd.delimiter+cmd.pattern+cmd.delimiter
			elif cmd.delimiter: cmddict['lastaddr'] = lastaddr
			
			if cmd.id == 's': lastsubref = len(ZZ)    # saving s/// position
			if cmd.id == 't':
				cmddict['extrainfo'] = lastsubref     # related s/// reference
				has_t = 1
			
			ZZ.append(cmddict)                        # saving full cmd entry
			debug('FULL entry: %s'%cmddict,3)
			cmddict = {}                              # reset data holder
			incompletecmd = incompletecmdline = ''    # reset incomplete holders
			
			if cmd.id   == '{': linesplit.insert(0,cmd.rest)
			if cmd.rest == '}': linesplit.insert(0,cmd.rest) # 3{p;d} (gnu)
			del cmd
		else:
			incompletecmd = cmd.rest                  # not ok, will join next
			debug('INCOMPLETE cmd: %s'%incompletecmd)
	
	if incompletecmd:
		incompletecmdline = incompletecmd

# populating list header
ZZ[0]['blanklines'] = blanklines
ZZ[0]['fields'] = cmdfields
ZZ[0]['has_t'] = has_t

################################################################################

# field:value line by line  (lots of lines!)
def dumpKeyValuePair(datalist):
	for data in datalist[1:]:                         # skip headers at 0
		if not data['id']: continue                   # blank line
		for key in datalist[0]['fields']:
			if key == 'replace':
				data[key] = string.replace(data[key], linesep, newlineshow)
			print "%10s:%s"%(key,data[key])
		print

# a command per line, : separated    (loooooooong lines)
#line:ad1:ad1f:ad2:ad2f:mod:cmd:content:delim:patt:rplc:flag:comment
def dumpOneliner(datalist, fancy=0):
	r = n = ''
	if fancy: r = '\033[7m'; n = '\033[m'
	for data in datalist[1:]:                         # skip headers at 0
		outline = data['linenr']
		if data['id']:
			for key in datalist[0]['fields'][1:]:     # skip linenr
				outline = '%s:%s%s%s'%(outline,r,data[key],n)
		print outline

def dumpCute(datalist):
	r = color_REV; n = color_NO
	for data in datalist[1:]:                         # skip headers at 0
		if not data['id']:
			print '%40s'%'[blank]'
		elif data['id'] == '#' :
			print data['comment']
		else:
			idsep=''
			if data['id'] in 'bt': idsep=' '
			cmd = '%s%s%s%s'%(data['modifier'],data['id'],idsep,data['content'])
			if data['delimiter']:
				cmd = '%s%s%s%s%s%s%s'%(cmd,
				    data['delimiter'],data['pattern'],
				    data['delimiter'],data['replace'],
				    data['delimiter'],data['flag'])
			cmd = string.replace(cmd, linesep, n+newlineshow+r)
			print '%s'%'-'*40
			print 'adr: %s%s%s%s  :::  %s%s%s%s'%(
			       r,data['addr1'],data['addr1flag'],n,
			       r,data['addr2'],data['addr2flag'],n)
			print 'cmd: %s%s%s   [%s]'%(r,cmd,n,data['comment'])

#-------------------------------------------------------------------------------

def dumpScript(datalist, indentprefix):
	indfmt = { 'string' : indentprefix, 'initlevel'  : 0,
	           'addrsep': ',' , 'joinaddrcmd': 0 }
	outlist = []
	adsep = indfmt['addrsep']
	indent = indfmt['initlevel']
	
	if action == 'html': outlist.append(html['htmlheader'])
	
	for data in datalist[1:]:                         # skip headers at 0
		if not data['id']:
			outlist.append('\n')
			continue                                  # blank line
		if data['id'] == '#' :
			indentstr = indfmt['string']*indent
			if action != 'html':
				outlist.append('%s%s\n'%(indentstr,data['comment']))
			else:
				outlist.append('%s%s\n'%(indentstr,
				                paintHtml('comment', data['comment'])))
		else:
			if data['id'] == '}': indent = indent - 1
			indentstr = indfmt['string']*indent # only indent++ after open {
			if data['id'] == '{': indent = indent + 1
			
			cmd = composeSedCommand(data)
			addr = composeSedAddress(data)
			
			# saving full line
			comm = ''
			if data['comment']: comm = ';'+data['comment']
			cmd = '%s%s%s'%(indentstr,addr,cmd)
			outlist.append('%-39s%s\n'%(cmd,comm))
	
	if action == 'html':
		outlist.append(html['htmlfooter'])
	
	for line in outlist: print line,                  # print the result

#-------------------------------------------------------------------------------

def doDebug(datalist):
	outlist = []
	cmdlineopts = 'f'
	t_count = 0
	hideregisters = 0
	
	if datalist[0].has_key('topopts'):
		cmdlineopts = datalist[0]['topopts']
	
	# if we have one or more t commands on the script, we need to save the t
	# command status between debug commands. as they perform s/// commands, the
	# t status of the "last substitution" is lost. so, we save the status doing
	# a nice loop trick before *every* command (necessary overhead). this loops
	# uses the :wassetNNN and wasclearNNN labels, where NNN is the label count.
	#TIP: t status resets: line read, t call
	if datalist[0]['has_t']: t_count = 1
	
	for i in range(len(datalist)):
		if i == 0: continue                           # skip headers at 0
		data = datalist[i]
		if not data['id']: continue                   # ignore blank line
		if data['id'] == '#': outlist.append('%s\n'%(data['comment']))
		else:
			cmd = composeSedCommand(data)
			addr = composeSedAddress(data)
			
			cmdshow = string.replace(cmd, '\n', newlineshow+color_YLW)
			cmdshow = esc_RS_EspecialChars(addr+cmdshow)
			showsedcmd = string.replace(showcomm, '\a', cmdshow)
			
			registers = showpatt + showhold
			if hideregisters: registers = ''
			
			showall = '%s%s'%(registers,showsedcmd)
			
			# TODO not put t status on read-next-line commands:
			#  - n,d,q,b <nothing>,t <nothing>
			if t_count and showall:
				if data['id'] not in 'ndq':
					tmp = string.replace(save_t, '\a', '%03d'%t_count)
					showall = string.replace(tmp, '#DEBUG#', showall)
					t_count = t_count + 1
			
			if data['lastaddr']: # null cmd to restore last addr: /addr/{;}
				showall = showall+data['lastaddr']+restaddr+'\n'
			
			# after jump or block commands don't show registers, because
			# they're not affected. exception: after b or t without target
			# (read next line)
			hideregisters = 0
			if data['id'] in sedcmds['jump'] and data['content']: hideregisters = 1
			elif data['id'] in sedcmds['block']: hideregisters = 1
			
			outlist.append("%s#%s\n%s\n"%(showall,'-'*50,addr+cmd))
	
	outlist.append(showpatt + showhold)           # last line status
	
	# executing sed script
	#TODO run debug on emulator? - SLOW!!! - or to it directly w/o extra .sedd
	cmdextra = inputfiles = ''
	if actionopts.count('_stdout-only'):
		cmdextra = "| egrep -v 'PATT|HOLD|COMM|\$$|\\$'"
	for file in textfiles: inputfiles = '%s %s'%(inputfiles,file)
	tmpfile = mkTmpFile(outlist)
	os.system("sed -%s %s %s %s"%(cmdlineopts, tmpfile, inputfiles, cmdextra))
	os.remove(tmpfile)

#-------------------------------------------------------------------------------

class emuSed:
#TODO check for syntax errors
#TODO convert regexes
#TODO organize debug msgs
#TODO make all this script a valid/callable python module
	def __init__(self, datalist, textfile, debug=0):
		self.inlist = ['']
		self.outlist = []
		self.cmdlist = []
		self.labels = {}
		self.blocks = {}
		self.addr1 = self.addr2 = ''
		self.linenr = 0
		self.cmdnr = 0
		self.holdspace = ''
		self.line = ''
		self.cmd = ''
		
		self.f_debug = debug
		self.f_stdin = 0
		self.rewindScript()
		
		# getting input data location (stdin or file)
		if textfile == '-': self.f_stdin = 1
		else: self.inlist.extend(readFile(textfile))
		
		# wipe null commands, save labels and block info
		blockopen = []
		for data in datalist[1:]:                # skip headers at 0
			if not data['id'] or data['id'] == '#': continue
			self.cmdlist.append(data)
			cmdpos = len(self.cmdlist)-1
			if   data['id'] == ':': self.labels[data['content']] = cmdpos
			elif data['id'] == '{': blockopen.append(cmdpos)
			elif data['id'] == '}': self.blocks[blockopen.pop()] = cmdpos
		del blockopen
		
		self.run()
	
	def rewindScript(self):
		self.EOS = 0     # end of script
		self.EOF = 0     # end of file
		self.cmdnr = -1
		self.f_delme = 0
		self.f_inrange = 0
		self.f_joinme = 0
	
	def readNextLine(self):
		self.linenr = self.linenr +1
		#TODO $ matches everyline.
		#TODO GNU sed retains stdout until next only if there is a $ addr
		if self.f_stdin:                         # reading STDIN interactively
			inputline = sys.stdin.readline()
			if not inputline: self.EOF = 1 ; return
			self.inlist.append(inputline[:-1])   # del \n$
		if self.linenr > len(self.inlist)-1:     # no more lines!
			self.EOF = 1 ; return
		next = self.inlist[self.linenr]
		if self.f_joinme: self.line = self.line+'\n'+next
		else            : self.line = next
		debug('line readed:%d:%s'%(self.linenr,`self.line`), 1)
	
	def _getAddress(self, fulladdr):
		addr = fulladdr                          # number
		if   addr[0] == '/' : addr = addr[1:-1]  # del //
		elif addr[0] == '\\': addr = addr[2:-1]  # del \xx
		return addr
	
	def _matchAddress(self, addr):
		ok = 0
		if addr[0] in '0123456789':              # 003 is valid
			if self.linenr == int(addr): ok = 1
		elif addr == '$':                        # last line
			if self.linenr == len(self.inlist)-1: ok = 1
		elif re.search(addr,self.line): ok = 1   # pattern
		if ok: debug('MATCHed addr:%s'%`addr`,2)
		return ok
	
	def testAddress(self):
		ok = 0 ; cmd = self.cmd ; PS = self.line
		
		if not cmd['addr1']:
			ok = 1              # no address
			debug('NO address!', 3)
		else:
			self.addr1 = self._getAddress(cmd['addr1'])
			debug('addr1: '+self.addr1, 2)
		
		if cmd['addr2']:                         # range
			self.addr2 = self._getAddress(cmd['addr2'])
			debug('addr2: '+self.addr2, 2)
			if self.f_inrange: self.f_inrange = 0
		
		if not ok:
			if self._matchAddress(self.addr1): ok = 1
			
			if self.addr2:                       # range
				if ok: self.f_inrange = 1        # start range
				elif self._matchAddress(self.addr2):
					ok = 1 ; self.f_inrange = 0  # end range
				elif self.f_inrange: ok = 1      # in range
				debug('in range: %d'%self.f_inrange, 3)
		
		debug('is hotline: %d'%ok, 3)
		debug('cmd: %s'%cmd['id'], 1)
		return ok
	
	def _makeRawString(self,str):
		raw = string.replace(str, '\t', '\\t')
		raw = string.replace(raw, '\n', '\\n')
		return raw +'$'
	
	def applyCmd(self):
		cmd = self.cmd ; PS = self.line ; HS = self.holdspace
		debug('cmdnr: %d'%self.cmdnr, 3)
		
		#TODO ! r w //  
		if   cmd['id'] == ':': pass
		elif cmd['id'] == '=': print(self.linenr)
		elif cmd['id'] == 'p': print(PS)
		elif cmd['id'] == 'P': print(re.sub('\n.*','', PS))
		elif cmd['id'] == 'q': self.EOF = 1
		elif cmd['id'] == 'h': HS = PS
		elif cmd['id'] == 'H': HS = HS+'\n'+PS
		elif cmd['id'] == 'g': PS = HS
		elif cmd['id'] == 'G': PS = PS+'\n'+HS
		elif cmd['id'] == 'x': PS, HS = HS, PS
		elif cmd['id'] == 'y':
			trtab = string.maketrans(cmd['pattern'], cmd['replace'])
			PS = string.translate(PS, trtab)
		elif cmd['id'] == 'l': print self._makeRawString(PS)
		elif cmd['id'] == 'd':
			self.f_delme = 1 ; self.EOS = 1      # d) forces next cicle
		elif cmd['id'] == 'D':                   # D) del till \n, next cicle
			cutted = re.sub('^.*?\n', '', PS)    #   del up to the 1st \n
			if cutted == PS: cutted = ''         #   if no \n at all, del all
			PS = cutted
			self.rewindScript()                  #   D forces rewind
			if not PS:                           #   no PS, start next cicle
				self.f_delme = 1 ; self.EOS = 1
			print '------',PS
		elif cmd['id'] == 'n':                   # n) print patt, read line
			print(PS)
			self.readNextLine(); PS = self.line
		elif cmd['id'] == 'N':                   # N) join next, read line
			self.f_joinme = 1
			self.readNextLine(); PS = self.line
		elif cmd['id'] in 'aic':                 # aic) spill text
			txt = re.sub(r'\\%s'%linesep, '\n', cmd['content'])
			txt = re.sub('^\n', '', txt)         #  delete first escape
			self.f_delme = 1
			if cmd['id'] == 'a': print(PS)       #  line before
			print(txt)                           #  put text
			if cmd['id'] == 'i': print(PS)       #  line after
		elif cmd['id'] in 'bt':                            # jump to...
			if not cmd['content']: self.EOS = 1            # ...end
			else: self.cmdnr = self.labels[cmd['content']] # ...label
		#TODO s///3 ; s//\1/ ; s//&/
		elif cmd['id'] == 's':
			times = 1 ; patt = cmd['pattern'] ; repl = cmd['replace']
			patt = re.sub(r'\\\(','(',patt)  #TODO test only, make function
			patt = re.sub(r'\\\)',')',patt)
			repl = re.sub(r'^\\\n','\n',repl) # NL escaped on repl
			if 'g' in cmd['flag']: times = 0           # global
			if 'i' in cmd['flag']: patt = '(?i)'+patt  # ignore case
			new = re.sub(patt, repl, PS, times)
			if 'p' in cmd['flag'] and new != PS: print new
			if 'w' in cmd['flag']:
				text = [new]            # w) open file truncating anyway
				if new == PS: text = '' # write patt only if s/// was ok
				writeFile(cmd['content'], text)
			PS = new
		
		if self.f_debug:
			showreg = 1
			fullcmd = "%s%s"%(composeSedAddress(cmd),
			   string.replace(composeSedCommand(cmd), '\n',
			                  newlineshow+color_YLW))
			print commid+color_YLW+fullcmd+color_NO
			if cmd['id'] in ':bt' and cmd['content']: showreg = 0
			if cmd['id'] in '{}': showreg = 0
			if showreg:
				print pattid+self._makeRawString(PS)
				print holdid+self._makeRawString(HS)
		
		self.line = PS ; self.holdspace = HS # save registers
	
	
	def run(self):
		while not self.EOF:
			self.rewindScript()
			self.readNextLine()
			if self.EOF: break
			
			if self.linenr == 1 and self.f_debug:   # debug info
				print pattid+self._makeRawString(self.line)
				print holdid+self._makeRawString(self.holdspace)
			
			while not self.EOS:
				if self.cmdnr == -1: self.cmdnr = 0 # 1st position
				self.cmd = self.cmdlist[self.cmdnr]
				if self.testAddress():
					self.applyCmd()
					if self.EOS or self.EOF: break
				elif self.cmd['id'] == '{': self.cmdnr = self.blocks[self.cmdnr]
				
				self.cmdnr = self.cmdnr +1 # next command
				if self.cmdnr > len(self.cmdlist)-1: break
			
			# default print pattern behaviour
			if not self.f_delme: print self.line


################################################################################

# printing results format
if action == 'dumpcute': dumpCute(ZZ)
elif action == 'token' : dumpKeyValuePair(ZZ)
elif action == 'indent': dumpScript(ZZ, indentprefix)
elif action == 'debug' : doDebug(ZZ)
elif action == 'html'  : dumpScript(ZZ, indentprefix)
elif action in ['emu', 'emudebug']:
	DEBUG = EMUDEBUG ; dodebug = 0
	if action == 'emudebug': dodebug = 1
	for textfile in textfiles: emuSed(ZZ, textfile, dodebug)

# dumpOneliner(data)
#TODO commenter
#TODO ignore l command line break?
#TODO accept \n as addr delimiter
