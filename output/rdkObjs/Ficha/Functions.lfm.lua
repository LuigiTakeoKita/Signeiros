require("firecast.lua");
local __o_rrpgObjs = require("rrpgObjs.lua");
require("rrpgGUI.lua");
require("rrpgDialogs.lua");
require("rrpgLFM.lua");
require("ndb.lua");
require("locale.lua");
local __o_Utils = require("utils.lua");

local function constructNew_Functions()
    local obj = GUI.fromHandle(_obj_newObject("form"));
    local self = obj;
    local sheet = nil;

    rawset(obj, "_oldSetNodeObjectFunction", rawget(obj, "setNodeObject"));

    function obj:setNodeObject(nodeObject)
        sheet = nodeObject;
        self.sheet = nodeObject;
        self:_oldSetNodeObjectFunction(nodeObject);
    end;

    function obj:setNodeDatabase(nodeObject)
        self:setNodeObject(nodeObject);
    end;

    _gui_assignInitialParentForForm(obj.handle);
    obj:beginUpdate();
    obj:setName("Functions");
    obj:setAlign("client");
    obj:setTheme("dark");
    obj:setMargins({top=1});


        icons = {["🔥"]=1,["⚡"]=2,["🎲"]=3,["🌓"]=4,["👊"]=5,["💫"]=6,["🎱"]=7,["☔"]=8}
        function splitEmojis(str)
            res = {}
            for emoji in str
            :gsub("(.)([\194-\244])", "%1\0%2")
            :gsub("%z(\240\159\143[\187-\191])", "%1")
            :gsub("%z(\239\184[\128-\143])", "%1")
            :gsub("%z(\226\128\141)%z", "%1")
            :gmatch"%Z+" 
            do
                table.insert(res, emoji)
            end
            return res
        end
        function sortSig(a, b)
            ta = splitEmojis(a)
            tb = splitEmojis(b)
            if #ta ~= #tb then
                if #ta > #tb then
                    return 1
                else
                    return -1
                end
            end
            for i=1, #ta, 1 do
                if icons[ta[i]] > icons[tb[i]] then
                    return 1
                end
                if icons[tb[i]] > icons[ta[i]] then
                    return -1
                end
            end
            return 1
        end
        function split(s, delimiter)
            result = {};
            for match in (s..delimiter):gmatch("(.-)"..delimiter) do
                table.insert(result, match);
            end
            return result;
        end
        function trim(s)
            return (s:gsub("^%s*(.-)%s*$", "%1"))
        end
        function mergeTables(t1, t2)
            for key, value in pairs(t2) do
	            t1[key] = value
            end 
            return t1
        end
    


    function obj:_releaseEvents()
    end;

    obj._oldLFMDestroy = obj.destroy;

    function obj:destroy() 
        self:_releaseEvents();

        if (self.handle ~= 0) and (self.setNodeDatabase ~= nil) then
          self:setNodeDatabase(nil);
        end;

        self:_oldLFMDestroy();
    end;

    obj:endUpdate();

    return obj;
end;

function newFunctions()
    local retObj = nil;
    __o_rrpgObjs.beginObjectsLoading();

    __o_Utils.tryFinally(
      function()
        retObj = constructNew_Functions();
      end,
      function()
        __o_rrpgObjs.endObjectsLoading();
      end);

    assert(retObj ~= nil);
    return retObj;
end;

local _Functions = {
    newEditor = newFunctions, 
    new = newFunctions, 
    name = "Functions", 
    dataType = "", 
    formType = "undefined", 
    formComponentName = "form", 
    title = "", 
    description=""};

Functions = _Functions;
Firecast.registrarForm(_Functions);

return _Functions;
