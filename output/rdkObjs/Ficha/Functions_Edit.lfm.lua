require("firecast.lua");
local __o_rrpgObjs = require("rrpgObjs.lua");
require("rrpgGUI.lua");
require("rrpgDialogs.lua");
require("rrpgLFM.lua");
require("ndb.lua");
require("locale.lua");
local __o_Utils = require("utils.lua");

local function constructNew_Functions_Edit()
    local obj = GUI.fromHandle(_obj_newObject("form"));
    local self = obj;
    local sheet = nil;

    rawset(obj, "_oldSetNodeObjectFunction", obj.setNodeObject);

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
    obj:setName("Functions_Edit");
    obj:setAlign("client");
    obj:setTheme("dark");
    obj:setMargins({top=1});


        function copyAll()
            magics = NDB.getChildNodes(sheet.magics)
            magicsInv = NDB.getChildNodes(sheet.magicsInv)
            magics = mergeTables(magics, magicsInv)
            System.setClipboardText(tableToStr(magics))
            popupShow("Grimório copiado.")
        end
        function inGrimorio(sequencia)
            magics = NDB.getChildNodes(sheet.magics)
            for i=1, #magics, 1 do
                if magics[i].sequencia == sequencia then
                    return true
                end
            end
            return false
        end
        function paste(table)
            if inGrimorio(table.sequencia) then 
                return
            end
            node = self.grimorio:append()
            node.sequencia = table.sequencia
            if table.nome ~= nil then
                node.nome = table.nome
            end
            if table.dano ~= nil then
                node.dano = table.dano
            end
            if table.desc ~= nil then
                node.desc = table.desc
            end
            if table.unidades ~= nil then
                node.unidades = table.unidades
            end
        end
        function pasteAll()
            str = System.getClipboardText()
            if string.find(str, "sequencia = ") == nil then
                return
            end
            str = totable(str)
            if type(str[1]) == "table" then
                for i=1, #str, 1 do
                    paste(str[i])
                end
            else
                paste(str)
            end
            popupShow("Mágia inserida no grimmório.")
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

function newFunctions_Edit()
    local retObj = nil;
    __o_rrpgObjs.beginObjectsLoading();

    __o_Utils.tryFinally(
      function()
        retObj = constructNew_Functions_Edit();
      end,
      function()
        __o_rrpgObjs.endObjectsLoading();
      end);

    assert(retObj ~= nil);
    return retObj;
end;

local _Functions_Edit = {
    newEditor = newFunctions_Edit, 
    new = newFunctions_Edit, 
    name = "Functions_Edit", 
    dataType = "", 
    formType = "undefined", 
    formComponentName = "form", 
    cacheMode = "none", 
    title = "", 
    description=""};

Functions_Edit = _Functions_Edit;
Firecast.registrarForm(_Functions_Edit);

return _Functions_Edit;
