local _class={}
setmetatable(_class,{__mode="kv"})
function Class(super)
    local class_type={}
    class_type.ctor     = false
	class_type.__delete=false
    class_type.super    = super
	
    class_type.New      = 
        function(...)
            local obj={}
            do
                local create=nil
                create = function(c,...)
                    if c.super then
                        create(c.super,...)
                    end
                    if c.ctor then		--构造函数
                        c.ctor(obj,...)
                    end
					if c.__delete then	--析构函数
						c.Destroy=function (self)
							if c.super then
								if c.super.__delete then
									c.super.__delete(self)
								end
							end
							c.__delete(self)
						end
					end

                end
				setmetatable(obj,{ __index = _class[class_type] })	
                create(class_type,...)	
				
            end
         
            return obj
        end
		
    local vtbl={}
    _class[class_type]=vtbl

    setmetatable(class_type,{__newindex=
        function(t,k,v)
            vtbl[k]=v
        end,
		__index = vtbl
    })
	
    
    if super then
        setmetatable(vtbl,{__index=
            function(t,k)
                local ret=_class[super][k]
                vtbl[k]=ret
                return ret
            end
        })
    end

    return class_type
end