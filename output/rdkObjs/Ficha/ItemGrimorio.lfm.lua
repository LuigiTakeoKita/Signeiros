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
    obj:setName("ItemGrimorio");
    obj:setHeight(30);
    obj:setTheme("dark");
    obj:setMargins({top=5});


        function self:alternarVisibilidade()
            if self.cbxInvisivel.checked then
                NDB.setPermission(sheet, "group", "jogadores", "read", nil)
                NDB.setPermission(sheet, "group", "espectadores", "read", nil)
            else
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
    obj.edit1:setField("sequencia");
    obj.edit1:setVisible(false);
    obj.edit1:setWidth(0);
    obj.edit1:setName("edit1");

    obj.flowLayout1 = GUI.fromHandle(_obj_newObject("flowLayout"));
    obj.flowLayout1:setParent(obj);
    obj.flowLayout1:setAlign("left");
    obj.flowLayout1:setWidth(150);
    obj.flowLayout1:setMargins({left=10});
    obj.flowLayout1:setName("flowLayout1");

    obj.image1 = GUI.fromHandle(_obj_newObject("image"));
    obj.image1:setParent(obj.flowLayout1);
    obj.image1:setWidth(30);
    obj.image1:setHeight(30);
    obj.image1:setStyle("stretch");
    obj.image1:setField("signo1");
    obj.image1:setName("image1");

    obj.image2 = GUI.fromHandle(_obj_newObject("image"));
    obj.image2:setParent(obj.flowLayout1);
    obj.image2:setWidth(30);
    obj.image2:setHeight(30);
    obj.image2:setStyle("stretch");
    obj.image2:setField("signo2");
    obj.image2:setName("image2");

    obj.image3 = GUI.fromHandle(_obj_newObject("image"));
    obj.image3:setParent(obj.flowLayout1);
    obj.image3:setWidth(30);
    obj.image3:setHeight(30);
    obj.image3:setStyle("stretch");
    obj.image3:setField("signo3");
    obj.image3:setName("image3");

    obj.image4 = GUI.fromHandle(_obj_newObject("image"));
    obj.image4:setParent(obj.flowLayout1);
    obj.image4:setWidth(30);
    obj.image4:setHeight(30);
    obj.image4:setStyle("stretch");
    obj.image4:setField("signo4");
    obj.image4:setName("image4");

    obj.image5 = GUI.fromHandle(_obj_newObject("image"));
    obj.image5:setParent(obj.flowLayout1);
    obj.image5:setWidth(30);
    obj.image5:setHeight(30);
    obj.image5:setStyle("stretch");
    obj.image5:setField("signo5");
    obj.image5:setName("image5");

    obj.edit2 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit2:setParent(obj);
    obj.edit2:setAlign("left");
    obj.edit2:setField("nomeMagia");
    obj.edit2:setWidth(350);
    obj.edit2:setMargins({left=10});
    obj.edit2:setName("edit2");

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
        function (_)
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
        end, obj);

    obj._e_event1 = obj.cbxInvisivel:addEventListener("onClick",
        function (_)
            self:alternarVisibilidade();
        end, obj);

    obj._e_event2 = obj.button1:addEventListener("onClick",
        function (_)
            System.setClipboardText(tableToStr(sheet))
        end, obj);

    obj._e_event3 = obj.button2:addEventListener("onClick",
        function (_)
            if sheet ~= nil then 
                            Dialogs.confirmOkCancel("Deseja realmente deletar essa linha?\n\"" .. (sheet.nomeMagia or sheet.sequencia or "") .. "\"",
                            function (confirmado)
                                if confirmado then
                                    NDB.deleteNode(sheet)
                                end
                            end)
                        end
        end, obj);

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

        if self.image2 ~= nil then self.image2:destroy(); self.image2 = nil; end;
        if self.image1 ~= nil then self.image1:destroy(); self.image1 = nil; end;
        if self.flowLayout1 ~= nil then self.flowLayout1:destroy(); self.flowLayout1 = nil; end;
        if self.cbxInvisivel ~= nil then self.cbxInvisivel:destroy(); self.cbxInvisivel = nil; end;
        if self.edit2 ~= nil then self.edit2:destroy(); self.edit2 = nil; end;
        if self.button1 ~= nil then self.button1:destroy(); self.button1 = nil; end;
        if self.image5 ~= nil then self.image5:destroy(); self.image5 = nil; end;
        if self.edit1 ~= nil then self.edit1:destroy(); self.edit1 = nil; end;
        if self.image4 ~= nil then self.image4:destroy(); self.image4 = nil; end;
        if self.button2 ~= nil then self.button2:destroy(); self.button2 = nil; end;
        if self.image3 ~= nil then self.image3:destroy(); self.image3 = nil; end;
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
    title = "", 
    description=""};

ItemGrimorio = _ItemGrimorio;
Firecast.registrarForm(_ItemGrimorio);

return _ItemGrimorio;
