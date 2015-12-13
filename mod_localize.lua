----------------------------------------------------------
-- mod_localize
----------------------------------------------------------

local _M = {}

_M.locale = 'en'
_M.langTbl = {}

function _M:setLocale( locale )
	self.locale = locale

	--clear tbl to be sure
	self.langTbl = {}

	--load lang file
	--fix by Misael M.
	if(self.locale~="es" and self.locale~="en" and self.locale~="de" and self.locale~="no" and self.locale~="pt")then
		self.locale="en"
		print("Not translation available for you locate, default=en")
	end
	local langFilePath = system.pathForFile( "lang/" .. self.locale .. ".txt", system.ResourceDirectory )

	--loop over translated lines, build lang tbl
	local pattern = "(.+)%s*=%s*(.+)"
	for line in io.lines( langFilePath ) do
		for k, v in string.gmatch( line, pattern ) do
			self.langTbl[ string.trim( k ) ] = string.trim( v )
		end
	end
end

function _M.str( strKey, ... )

	local langTbl = _M.langTbl

	local str = langTbl[ strKey ]
	if str then
		if ... then
			return string.format( str, ... )
		else
			return str
		end
	end

	error( "Localization string not found!  Please add \"" .. strKey .. "\" to lang/" .. _M.locale .. ".txt" )
end

function string.trim(self)
   return self:match('^%s*(.-)%s*$')
end

return _M
