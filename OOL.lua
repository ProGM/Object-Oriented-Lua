--Object Oriented Lua

local OOL = {}

-- defining general class metamethods

local class = {}
function class.new(self, ...)
	local attributes_new = table.deep_copy(self.__attributes)
	local instance = setmetatable( attributes_new, { __index = self} )
	if instance.init and type(instance.init) == "function" then
		instance.init(instance, unpack(arg) )
	else
		print("OOL: Warning: No such method init!")
	end
	return instance
end

function class.is_A(self, classType )
	local result = getmetatable( self )
	while result ~= nil and result.__index ~= nil do
		if result.__index == classType then return true end
		result = getmetatable( result.__index )
	end

	return false
end

function class.super( self, method, ... )
	local result = getmetatable( self )
	assert(result)
	assert(result.__index)
	result = getmetatable( result.__index )
	assert(result)
	assert(result.__index)
	result = result.__index
	if result[method] and type(result[method]) == "function" then
		return result[method](self, unpack(arg))
	else
		assert(false, "No such method " .. method)
	end
end

function class.getClass( self )
	local result = getmetatable( self )
	if result and result.__index then
		return result.__index
	end
	return nil
end

function class.extends( self, attributes )
	attributes = attributes or {}
	local newClass = {}

	newClass.__attributes = table.merge(self.__attributes, attributes)
	newClass = setmetatable(newClass, { __index = self, __call = self.new })
	return newClass
end

-- end class metamethods

function OOL.class( attributes )
	attributes = attributes or {}
	local result = {}
	result.__attributes = attributes
	result = setmetatable(result, {__index = class, __call = class.new})

	return result
end

return OOL
