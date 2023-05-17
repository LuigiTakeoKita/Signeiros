require("firecast.lua");
local __o_rrpgObjs = require("rrpgObjs.lua");
require("rrpgGUI.lua");
require("rrpgDialogs.lua");
require("rrpgLFM.lua");
require("ndb.lua");
require("locale.lua");
local __o_Utils = require("utils.lua");

local function constructNew_ItemArma()
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
    obj:setName("ItemArma");
    obj:setHeight(30);
    obj:setTheme("dark");
    obj:setMargins({top=5});

    obj.checkBox1 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.checkBox1:setParent(obj);
    obj.checkBox1:setAlign("left");
    obj.checkBox1:setField("cbItem");
    obj.checkBox1:setWidth(20);
    obj.checkBox1:setMargins({left=5});
    obj.checkBox1:setName("checkBox1");

    obj.edit1 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit1:setParent(obj);
    obj.edit1:setAlign("left");
    obj.edit1:setField("name");
    obj.edit1:setWidth(200);
    obj.edit1:setMargins({left=5});
    obj.edit1:setName("edit1");

    obj.edit2 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit2:setParent(obj);
    obj.edit2:setAlign("left");
    obj.edit2:setField("vAtaque");
    obj.edit2:setWidth(50);
    obj.edit2:setMargins({left=5});
    obj.edit2:setHorzTextAlign("center");
    obj.edit2:setName("edit2");

    obj.edit3 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit3:setParent(obj);
    obj.edit3:setAlign("left");
    obj.edit3:setField("vDefesa");
    obj.edit3:setWidth(50);
    obj.edit3:setMargins({left=5});
    obj.edit3:setHorzTextAlign("center");
    obj.edit3:setName("edit3");

    obj.button1 = GUI.fromHandle(_obj_newObject("button"));
    obj.button1:setParent(obj);
    obj.button1:setAlign("left");
    obj.button1:setText("Copiar");
    obj.button1:setWidth(70);
    obj.button1:setMargins({left=5});
    obj.button1:setName("button1");

    obj.button2 = GUI.fromHandle(_obj_newObject("button"));
    obj.button2:setParent(obj);
    obj.button2:setAlign("left");
    obj.button2:setText("Deletar Item");
    obj.button2:setWidth(100);
    obj.button2:setMargins({left=5});
    obj.button2:setName("button2");

    obj._e_event0 = obj.checkBox1:addEventListener("onChange",
        function (_)
            changeArma(sheet)
        end, obj);

    obj._e_event1 = obj.button1:addEventListener("onClick",
        function (_)
            System.setClipboardText(tableToStr(sheet))
                        popupShow("Armadura copiada.")
        end, obj);

    obj._e_event2 = obj.button2:addEventListener("onClick",
        function (_)
            if sheet ~= nil then 
                            Dialogs.confirmOkCancel("Deseja realmente deletar essa arma?\n\"" .. (sheet.name or "") .. "\"",
                            function (confirmado)
                                if confirmado then
                                    value = 0
                                    sheet.cbItem = false
                                    changeArma(sheet)
                                    NDB.deleteNode(sheet)
                                end
                            end)
                        end
        end, obj);

    function obj:_releaseEvents()
        __o_rrpgObjs.removeEventListenerById(self._e_event2);
        __o_rrpgObjs.removeEventListenerById(self._e_event1);
        __o_rrpgObjs.removeEventListenerById(self._e_event0);
    end;

    obj._oldLFMDestroy = obj.destroy;

    function obj:destroy() 
        self:_releaseEvents();

        if (self.handle ~= 0) and (self.setNodeDatabase ~= nil) then
          self:setNodeDatabase(nil);
        end;

        if self.button2 ~= nil then self.button2:destroy(); self.button2 = nil; end;
        if self.edit3 ~= nil then self.edit3:destroy(); self.edit3 = nil; end;
        if self.edit1 ~= nil then self.edit1:destroy(); self.edit1 = nil; end;
        if self.edit2 ~= nil then self.edit2:destroy(); self.edit2 = nil; end;
        if self.checkBox1 ~= nil then self.checkBox1:destroy(); self.checkBox1 = nil; end;
        if self.button1 ~= nil then self.button1:destroy(); self.button1 = nil; end;
        self:_oldLFMDestroy();
    end;

    obj:endUpdate();

    return obj;
end;

function newItemArma()
    local retObj = nil;
    __o_rrpgObjs.beginObjectsLoading();

    __o_Utils.tryFinally(
      function()
        retObj = constructNew_ItemArma();
      end,
      function()
        __o_rrpgObjs.endObjectsLoading();
      end);

    assert(retObj ~= nil);
    return retObj;
end;

local _ItemArma = {
    newEditor = newItemArma, 
    new = newItemArma, 
    name = "ItemArma", 
    dataType = "", 
    formType = "undefined", 
    formComponentName = "form", 
    title = "", 
    description=""};

ItemArma = _ItemArma;
Firecast.registrarForm(_ItemArma);

return _ItemArma;
