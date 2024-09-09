require("firecast.lua");
local __o_rrpgObjs = require("rrpgObjs.lua");
require("rrpgGUI.lua");
require("rrpgDialogs.lua");
require("rrpgLFM.lua");
require("ndb.lua");
require("locale.lua");
local __o_Utils = require("utils.lua");

local function constructNew_ItemGrimorio()
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
    obj:setName("ItemGrimorio");
    obj:setHeight(30);
    obj:setTheme("dark");
    obj:setMargins({top=5});


        function self:alternarVisibilidade()
            if self.cbxInvisivel.checked then
                sheet.vis = "true"
                NDB.setPermission(sheet, "group", "jogadores", "read", nil)
                NDB.setPermission(sheet, "group", "espectadores", "read", nil)
            else
                sheet.vis = "false"
                NDB.setPermission(sheet, "group", "jogadores", "read", "deny")
                NDB.setPermission(sheet, "group", "espectadores", "read", "deny")
            end
            NDB.setPermission(sheet, "group", "dono", "writePermissions", nil)
        end

        function self:atualizarCbxInvisivel()          
            self.cbxInvisivel.checked = NDB.getPermission(sheet, "group", "espectadores", "read") == "deny" or
                                        NDB.getPermission(sheet, "group", "jogadores", "read") == "deny"
            self.cbxInvisivel.enabled = NDB.testPermission(sheet, "writePermissions")
        end
    


    obj.cbxInvisivel = GUI.fromHandle(_obj_newObject("imageCheckBox"));
    obj.cbxInvisivel:setParent(obj);
    obj.cbxInvisivel:setName("cbxInvisivel");
    obj.cbxInvisivel:setAlign("left");
    obj.cbxInvisivel:setWidth(25);
    obj.cbxInvisivel:setImageChecked("/Ficha/images/invisivel.png");
    obj.cbxInvisivel:setImageUnchecked("/Ficha/images/visivel.png");
    obj.cbxInvisivel:setAutoChange(false);

    obj.edit1 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit1:setParent(obj);
    obj.edit1:setAlign("left");
    obj.edit1:setField("sequencia");
    obj.edit1:setReadOnly(true);
    obj.edit1:setWidth(100);
    obj.edit1:setMargins({left=10});
    obj.edit1:setName("edit1");

    obj.edit2 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit2:setParent(obj);
    obj.edit2:setField("vis");
    obj.edit2:setVisible(false);
    obj.edit2:setWidth(0);
    obj.edit2:setName("edit2");

    obj.edit3 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit3:setParent(obj);
    obj.edit3:setAlign("left");
    obj.edit3:setField("nomeMagia");
    obj.edit3:setWidth(350);
    obj.edit3:setMargins({left=10});
    obj.edit3:setHint("Nome da Magia");
    obj.edit3:setName("edit3");

    obj.button1 = GUI.fromHandle(_obj_newObject("button"));
    obj.button1:setParent(obj);
    obj.button1:setAlign("left");
    obj.button1:setText("Copiar Sequência");
    obj.button1:setWidth(150);
    obj.button1:setMargins({left=10});
    obj.button1:setName("button1");

    obj.button2 = GUI.fromHandle(_obj_newObject("button"));
    obj.button2:setParent(obj);
    obj.button2:setAlign("left");
    obj.button2:setText("Deletar Item");
    obj.button2:setWidth(150);
    obj.button2:setMargins({left=10});
    obj.button2:setName("button2");

    obj._e_event0 = obj:addEventListener("onScopeNodeChanged",
        function ()
            if self.observer ~= nil then
                        self.observer.enabled = false
                        self.observer = nil
                    end
                    if sheet ~= nil then   
                        self.observer = NDB.newObserver(sheet)
                        self.observer.onPermissionListChanged = function(node)
                            self:atualizarCbxInvisivel()
                        end
                        self.observer.onFinalPermissionsCouldBeChanged = function(node)
                            self:atualizarCbxInvisivel()
                        end
                        self:atualizarCbxInvisivel()
                    end
        end);

    obj._e_event1 = obj.cbxInvisivel:addEventListener("onClick",
        function (event)
            self:alternarVisibilidade();
        end);

    obj._e_event2 = obj.button1:addEventListener("onClick",
        function (event)
            System.setClipboardText(tableToStr(sheet))
                        popupShow("Mágica copiada.")
        end);

    obj._e_event3 = obj.button2:addEventListener("onClick",
        function (event)
            if sheet ~= nil then 
                            Dialogs.confirmOkCancel("Deseja realmente deletar essa linha?\n\"" .. (sheet.nomeMagia or sheet.sequencia or "") .. "\"",
                            function (confirmado)
                                if confirmado then
                                    NDB.deleteNode(sheet)
                                end
                            end)
                        end
        end);

    function obj:_releaseEvents()
        __o_rrpgObjs.removeEventListenerById(self._e_event3);
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

        if self.edit1 ~= nil then self.edit1:destroy(); self.edit1 = nil; end;
        if self.cbxInvisivel ~= nil then self.cbxInvisivel:destroy(); self.cbxInvisivel = nil; end;
        if self.edit3 ~= nil then self.edit3:destroy(); self.edit3 = nil; end;
        if self.edit2 ~= nil then self.edit2:destroy(); self.edit2 = nil; end;
        if self.button1 ~= nil then self.button1:destroy(); self.button1 = nil; end;
        if self.button2 ~= nil then self.button2:destroy(); self.button2 = nil; end;
        self:_oldLFMDestroy();
    end;

    obj:endUpdate();

    return obj;
end;

function newItemGrimorio()
    local retObj = nil;
    __o_rrpgObjs.beginObjectsLoading();

    __o_Utils.tryFinally(
      function()
        retObj = constructNew_ItemGrimorio();
      end,
      function()
        __o_rrpgObjs.endObjectsLoading();
      end);

    assert(retObj ~= nil);
    return retObj;
end;

local _ItemGrimorio = {
    newEditor = newItemGrimorio, 
    new = newItemGrimorio, 
    name = "ItemGrimorio", 
    dataType = "", 
    formType = "undefined", 
    formComponentName = "form", 
    cacheMode = "none", 
    title = "", 
    description=""};

ItemGrimorio = _ItemGrimorio;
Firecast.registrarForm(_ItemGrimorio);

return _ItemGrimorio;
