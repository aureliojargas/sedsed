#!/usr/bin/python
# sedsed
# 20011127 <aurelio@verde666.org> ** 1a versão

#TODO name: sedsed - sed S...E...Debugger
import sys, re, os, getopt

# default config
color = 1                     # colored output? (it's nice)
DEBUG = 0                     # set developper's debug level [0-3]
indentprefix = '  '           # default indent prefix
action = 'indent'             # default action

#-------------------------------------------------------------------------------

def error(msg):
	print 'ERROR:',msg ; sys.exit(1)

def printUsage(exitcode=1):
	print """
usage: sedsed OPTION file

OPTIONS:

     -f                  ignored (it's here for convenience)

     -d, --debug         DEBUG the sed script
         --nocolor       no colors on debug output
         --hide          hide some debug info (options: PATT,HOLD,COMM)

     -i, --indent        script beautifier, prints indented and
                         one-command-per-line output do STDOUT
         --prefix        indent prefix string (default: 2 spaces)

     -t, --tokenize      script tokenizer, prints extensive
                         command by command information

     -h, --help          prints this help message and exit
"""
	sys.exit(exitcode)

# get cmdline options
errormsg = 'bad option or missing argument. try --help.'
try: (opt, args) = getopt.getopt(sys.argv[1:], 'hfdit',
     ['debug', 'hide=', 'nocolor', 'indent', 'prefix=','tokenize','help', 
      '_debuglevel=', '_diffdebug', '_stdout-only', 'dumpcute'])      # admin hidden opts
except getopt.GetoptError: error(errormsg)

actionopts = []
for o in opt:
	if o[0] in ('-d', '--debug')     : action = 'debug'
	elif o[0] in ('-i', '--indent')  : action = 'indent'; color = 0
	elif o[0] in ('-t', '--tokenize'): action = 'token' ; color = 0
	elif o[0] in ('-h', '--help')    : printUsage(0)
	elif o[0] == '--nocolor'    : color = 0
	elif o[0] == '--hide':                            # get hide options
		for hide in o[1].split(','):                  # save as no<OPT>
			actionopts.append('no'+hide.strip().lower())
	elif o[0] == '--prefix':
		if re.sub('\s','',o[1]):                      # prefix is valid?
			error("invalid indent prefix. must be spaces and/or TABs.")
		indentprefix = o[1]
	
	elif o[0] == '--_debuglevel': DEBUG = int(o[1])
	elif o[0] == '--dumpcute'   : DEBUG = 0; color = 1; action = 'dumpcute'
	elif o[0] == '--_diffdebug'  : action = 'debug' ; actionopts.append(o[0][2:])
	elif o[0] == '--_stdout-only': action = 'debug' ; actionopts.append(o[0][2:])

if not args: printUsage(1)                            # infile sanity checks
infile = args[0];
if not os.path.isfile(infile): error('file not found: %s'%infile)

if action == 'debug':                                 # set debug filename
	outfile = re.sub('\.sed$', '', infile)+'.sedd'
	if actionopts.count('_diffdebug'):                # check if commands on
		cutdebug = 'egrep -v "^  s@|^#---+$|# show "' # ...debug file are ok
		os.system('%s %s | diff -Bwu0 %s -'%(cutdebug, outfile, infile))
		sys.exit(0)

color_YLW = color_NO = color_RED = color_REV = ''     # color settings 
if color:
	color_YLW='\033[33;1m' ; color_RED='\033[31;1m'   # yellow, red
	color_NO='\033[m' ; color_REV='\033[7m'           # default, reverse

# the sed debug magic lines
showpatt = '  s/^/PATT:/;l;s/^PATT://   ;# show pattern space\n'
showhold = 'x;s/^/HOLD:/;l;s/^HOLD://;x ;# show hold space\n'
showcomm = '  s@^@COMM:%s\a%s\\\n   @;P;s/^[^\\n]*\\n   //'%(color_YLW,color_NO)
showcomm = showcomm +'     ;# show command\n'
restaddr = '{;} ;# restoring last address\n'
#reset_t  = 't:::::\a;::::::\a         ;# reseting t status\n'
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

sedcmds['file']  = 'rw'
sedcmds['addr']  = '/$0123456789\\'
sedcmds['multi'] = 'sy'
sedcmds['solo']  = 'nNdDgGhHxpPlq='
sedcmds['text']  = 'aci'
sedcmds['jump']  = ':bt'
sedcmds['block'] = '{}'
sedcmds['flag']  = 'gpI0123456789w'

patt['jump_label'] = r'[^\s;}#]*'             # _any_ char, except those, or None
patt['filename']   = r'[^\s]+'                # _any_ not blank char (strange...)
patt['flag']       = r'[%s]+'%sedcmds['flag'] # list of all flags
patt['topopts'] = r'#!\s*/[^\s]+\s+-([nf]+)'  # options on #!/bin/sed header

cmdfields = ['linenr', 'addr1', 'addr1flag', 'addr2', 'addr2flag', 'lastaddr', 'modifier',
       'id', 'content', 'delimiter', 'pattern', 'replace', 'flag', 'extrainfo', 'comment']

#-------------------------------------------------------------------------------

#FOLD: functions debug, error, runCommand, escEspChars, openBracket
def debug(msg, level=1):
	if DEBUG and DEBUG >= level: print '+++ DEBUG%d: %s'%(level,msg)

def runCommand(cmd):
	"""\
Executes system command and stores its output on a list.
Returns a (#exit_code, program_output[]) tuple.
"""
	list = []
	fd = os.popen(cmd)
	for line in fd.readlines():
		list.append(rstrip(line))  # stripping \s*\n
	ret = fd.close()
	if ret: ret = ret/256  # 16bit number
	return ret, list

def esc_RS_EspecialChars(str):
	str = str.replace('\\', '\\\\')                   # escape escape
	str = str.replace('&', r'\&')                     # matched pattern
	str = str.replace('@', r'\@')                     # delimiter
	return str

def isOpenBracket(str):
	# bracket open:  [   \\[   \\\\[ ...
	# not bracket : \[  \\\[  \\\\\[ ...
	isis = 0
	delim = '['
	str = re.sub('\[:[a-z]+:]', '', str)              # del [:charclasses:]
	if str.find(delim) == -1: return 0                # hey, no brackets!
	
	# only the last two count
	patterns = str.split(delim)[-2:]
	debug('bracketpatts: %s'%patterns,3)
	possibleescape, bracketpatt = patterns
	
	# maybe the bracket is escaped, and is not a metachar?
	m = re.search(r'\\+$', possibleescape)            # escaped bracket
	if m and len(m.group(0))%2:                       # if odd number of escapes
		debug('bracket INVALID! - escaped',2)
		isis = 0
	elif bracketpatt.find(']') == -1:                 # if not closed by ]
		debug('bracket OPEN! - found! found!',2)
		isis = 1                                      # it is opened! &:)
	
	return isis

#-------------------------------------------------------------------------------

def composeSedAddress(dict):
	addr = '%s%s'%(dict['addr1'],dict['addr1flag'])
	if dict['addr2']: addr = '%s,%s%s'%(addr,dict['addr2'],dict['addr2flag'])
	#if addr and dict['id'] not in 'btN':
	if addr: addr = '%s '%(addr)  # visual addr/cmd separation
	return addr

def composeSedCommand(dict):
	if dict['delimiter']:                             # s///
		cmd = '%s%s%s%s%s%s%s%s'%(
		    dict['modifier'] ,dict['id'],
		    dict['delimiter'],dict['pattern'],
		    dict['delimiter'],dict['replace'],
		    dict['delimiter'],dict['flag'])
		if dict['content']:
			cmd = cmd+' '+dict['content']             # s///w filename
	else:
		idsep=''
		spaceme = sedcmds['file']+sedcmds['jump']+sedcmds['text']
		if dict['id'] in spaceme: idsep=' '
		cmd = '%s%s%s%s'%(dict['modifier'],dict['id'],idsep,dict['content'])
	cmd = cmd.replace(linesep, '\n')
	return cmd

################################################################################

# SedCommand already receives lstrip()ed data and data != None
class SedCommand:
	def __init__(self, string):
		self.id = string[0]  # s
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
		self.rest = self.junk = string
		self.extrainfo = ''
		
		if self.id == '!':
			self.modifier = self.id                   # set modifier
			self.junk = self.junk[1:].lstrip()        # del !@junk
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
			if self.junk[-1] != '\\':
				self.content = self.junk
				self.isok = 1
		
		elif id in sedcmds['jump']:
			debug('type: jump',3)
			self.junk = self.junk.lstrip()
			m = re.match(patt['jump_label'], self.junk)
			if m:
				self.content = m.group()
				self.junk = self.junk[m.end():]
				self.isok = 1
		
		elif id in sedcmds['file']:
		#TODO deal with valid cmds like 'r bla;bla' (!!!) and 'r bla ;#comm'
		#TODO spaces and ; are valid as filename chars
			debug('type: file',3)
			self.junk = self.junk.lstrip()
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
				self.pattern = ps.content
				self.junk = ps.rest
				# 'replace' opt is to avoid openbracket check (s/bla/[/ is ok)
				hs = SedAddress(self.delimiter+self.junk, 'replace')
				if hs.isok:
					self.replace = hs.content
					self.junk = hs.rest.lstrip()
					
					### great s/patt/rplc/ sucessfully taken 
			
			if hs and hs.isok and self.junk:          # there are flags?
				debug('possible s/// flag: %s'%self.junk,3)
				m = re.match('(%s\s*)+'%patt['flag'],self.junk)
				if m:
					self.flag = m.group()
					self.junk = self.junk[m.end():].lstrip() # del flag@junk
					self.flag = re.sub('\s','',self.flag)  # del blanks@flag
					debug('FOUND s/// flag: %s'%self.flag.strip())
					
					### now we've got flags also				
				
				if 'w' in self.flag:                  # write file flag
					m = re.match(patt['filename'], self.junk)
					if m:
						self.content = m.group()
						debug('FOUND s///w filename: %s'%self.content)
						self.junk = self.junk[m.end():].lstrip()
						
						### and now, s///w filename is saved also
			
			if hs and hs.isok: self.isok = 1
		
		else:
			error("invalid sed command '%s' at line %d"%(id,linenr))
		
		if self.isok:
			self.full = composeSedCommand(vars(self))
			self.full = self.full.replace('\n', linesep) # oneliner
			self.rest = self.junk.lstrip()
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
	def __init__(self, string, context='addr'):
		self.delimiter = ''
		self.content = ''
		self.flag = ''
		self.full = ''
		
		self.isline = 0
		self.isok = 0
		self.escape = '' 
		self.rest = self.junk = string
		self.context = context
		
		self.setType()                                # numeric or pattern?
		self.doItAll()
		debug('SedAddress: %s'%vars(self),3)
		
	#------------------------------------------------------
	
	def doItAll(self):
		if self.isline: self.setLineAddr()
		else          : self.setPattAddr()
		
		if self.isok:
			self.full = '%s%s%s%s'%(self.escape,self.delimiter,self.content,self.delimiter)
			debug('FOUND addr: %s'%self.full)
			
			cutlen = len(self.full)+len(self.flag)
			self.rest = self.rest[cutlen:]            # del addr from junk
			self.flag = self.flag.strip()             # del blank from flag
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
		self.content = m.group(0)
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
		patterns = self.junk.split(self.delimiter)
		debug('addr patterns: %s'%patterns,2)
		
		while patterns:
			possiblepatt = patterns.pop(0)
			
			# if address not terminated, join next
			if incompleteaddr:
				possiblepatt = self.delimiter.join([incompleteaddr, possiblepatt])
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
					debug('FOUND addr flag: %s'%self.flag.strip())
			self.content = possiblepatt
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

# the sed script is syntax-error free?
ret, msg = runCommand("sed -f '%s' /dev/null"%infile)
if ret: error('#%d: syntax error on your sed script, please fix it before.'%ret)

f = open(infile); list = f.readlines(); f.close  # read/free sed script

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
for line in list:
	linenr = linenr + 1
	
	if linenr == 1:                                   # 1st line #!/... finder
		m= re.match(patt['topopts'], line)
		if m:                                         # we have options!
			ZZ[0]['topopts'] = m.group(1)             # saved on list header
			del m
	
	if incompletecmdline:
		line = linesep.join([incompletecmdline, line])
	
	if line[-1] == '\n': line = line[:-1]             # s/\n$//
	if not line.strip():                              # blank line
		blanklines.append(linenr)
		ZZ.append({'linenr': linenr, 'id': ''})
		continue
	
	if DEBUG: print ; debug('line:%d: %s'%(linenr,line))
	
	if line.lstrip()[0] == '#':
		linesplit = [line.lstrip()]      # trick to bypass comment lines
	else:
		linesplit = line.split(cmdsep)                # split lines at ;
	
	while linesplit:
		possiblecmd = linesplit.pop(0)
		if not incompletecmdline:
			if incompletecmd: possiblecmd = cmdsep.join([incompletecmd, possiblecmd])
			if incompleteaddr: possiblecmd = cmdsep.join([incompleteaddr, possiblecmd])
		else:
			incompletecmdline = ''
		
		if not possiblecmd: continue # ; at EOL or useless sequence of ;;;;
		
		debug('possiblecmd: '+possiblecmd,2)
		possiblecmd = possiblecmd.lstrip()            # del space at begin
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
					if addr.content: lastaddr = addr.full
					else: cmddict['lastaddr'] = lastaddr
				else:
					cmddict['addr2'] = addr.full
					cmddict['addr2flag'] = addr.flag
					if addr.content: lastaddr = addr.full
					else: cmddict['lastaddr'] = lastaddr
				rest = addr.rest
			else:
				incompleteaddr = addr.rest
				break                                 # join more cmds
			
			if not cmddict.has_key('addr2') and rest[0] == ',': # it's a range!
				possiblecmd = rest[1:].lstrip()       # del comma and blanks
				continue                              # process again
			else:
				incompleteaddr = ''
				possiblecmd = rest.lstrip()
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
				data[key] = data[key].replace(linesep, newlineshow)
			print "%10s:%s"%(key,data[key])
		print

# a command per line, : separated    (loooooooong lines)
#line:ad1:ad1f:ad2:ad2f:mod:cmd:content:delim:patt:rplc:flag:comment
def dumpOneliner(datalist, fancy=0):
	r = n = ''
	if fancy: r = '\033[7m'; n = '\033[m'; 
	for data in datalist[1:]:                         # skip headers at 0
		outline = data['linenr']
		if data['id']:
			for key in datalist[0]['fields'][1:]:     # skip linenr
				outline = '%s:%s%s%s'%(outline,r,data[key],n)
		print outline

def dumpCute(datalist):
	r = color_REV; n = color_NO; 
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
			cmd = cmd.replace(linesep, n+newlineshow+r)
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
	
	for data in datalist[1:]:                         # skip headers at 0
		if not data['id']:
			outlist.append('\n')
			continue                                  # blank line
		if data['id'] == '#' :
			indentstr = indfmt['string']*indent
			outlist.append('%s%s\n'%(indentstr,data['comment']))
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
			#outlist.append('%s%s%s%s\n'%(indentstr,addr,cmd,comm))
	
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
			
			cmdshow = cmd.replace('\n', newlineshow+color_YLW)
			cmdshow = esc_RS_EspecialChars(addr+cmdshow)
			showsedcmd = showcomm.replace('\a', cmdshow)
			
			registers = showpatt + showhold
			if hideregisters: registers = ''
			
			showall = '%s%s'%(registers,showsedcmd)
			
			# TODO not put t status on read-next-line commands:
			#  - n,d,q,b <nothing>,t <nothing> 
			if t_count and showall:
				if data['id'] not in 'ndq':
					tmp = save_t.replace('\a', '%03d'%t_count)
					showall = tmp.replace('#DEBUG#', showall)
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
	
	# writing to outfile
	f = open(outfile,'w'); f.writelines(outlist); f.close()
	
	# executing sed script
	cmdextra = ''
	if actionopts.count('_stdout-only'):
		cmdextra = "| egrep -v 'PATT|HOLD|COMM|\$$|\\$'"
	os.system("sed -%s %s%s"%(cmdlineopts, outfile, cmdextra))
	#print "-------------------- sed -%s %s"%(cmdlineopts, outfile)

################################################################################

# printing results format
dumptype = 1
if action == 'dumpcute': dumpCute(ZZ)
elif action == 'token' : dumpKeyValuePair(ZZ)
elif action == 'indent': dumpScript(ZZ, indentprefix)
elif action == 'debug' : doDebug(ZZ) 
# dumpOneliner(data)
#print '#BLANK lines: %s'%blanklines

#zzcep - cool example
#TODO commenter
#TODO ignore l command line break?
