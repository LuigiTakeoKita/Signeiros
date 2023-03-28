require("firecast.lua");
local __o_rrpgObjs = require("rrpgObjs.lua");
require("rrpgGUI.lua");
require("rrpgDialogs.lua");
require("rrpgLFM.lua");
require("ndb.lua");
require("locale.lua");
local __o_Utils = require("utils.lua");

local function constructNew_Inventario()
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
    obj:setName("Inventario");
    obj:setAlign("client");
    obj:setTheme("dark");
    obj:setMargins({top=1});

    obj.flowLayout1 = GUI.fromHandle(_obj_newObject("flowLayout"));
    obj.flowLayout1:setParent(obj);
    obj.flowLayout1:setAlign("client");
    obj.flowLayout1:setAutoHeight(true);
    obj.flowLayout1:setName("flowLayout1");

    obj.layout1 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout1:setParent(obj.flowLayout1);
    obj.layout1:setWidth(465);
    obj.layout1:setHeight(900);
    obj.layout1:setMargins({left=5, top=5});
    obj.layout1:setName("layout1");

    obj.layout2 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout2:setParent(obj.layout1);
    obj.layout2:setAlign("top");
    obj.layout2:setHeight(25);
    obj.layout2:setMargins({left=30});
    obj.layout2:setName("layout2");

    obj.label1 = GUI.fromHandle(_obj_newObject("label"));
    obj.label1:setParent(obj.layout2);
    obj.label1:setAlign("left");
    obj.label1:setText("Armaduras");
    lfm_setPropAsString(obj.label1, "fontStyle",  "bold");
    obj.label1:setName("label1");

    obj.button1 = GUI.fromHandle(_obj_newObject("button"));
    obj.button1:setParent(obj.layout2);
    obj.button1:setAlign("right");
    obj.button1:setText("Adicionar Armadura");
    obj.button1:setWidth(150);
    obj.button1:setMargins({right=5});
    obj.button1:setName("button1");

    obj.button2 = GUI.fromHandle(_obj_newObject("button"));
    obj.button2:setParent(obj.layout2);
    obj.button2:setAlign("right");
    obj.button2:setText("Colar Armadura");
    obj.button2:setWidth(150);
    obj.button2:setName("button2");

    obj.layout3 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout3:setParent(obj.layout1);
    obj.layout3:setAlign("top");
    obj.layout3:setHeight(25);
    obj.layout3:setMargins({top=10});
    obj.layout3:setName("layout3");

    obj.label2 = GUI.fromHandle(_obj_newObject("label"));
    obj.label2:setParent(obj.layout3);
    obj.label2:setAlign("left");
    obj.label2:setText("");
    obj.label2:setWidth(20);
    obj.label2:setMargins({left=5});
    obj.label2:setName("label2");

    obj.label3 = GUI.fromHandle(_obj_newObject("label"));
    obj.label3:setParent(obj.layout3);
    obj.label3:setAlign("left");
    obj.label3:setText("Nome");
    obj.label3:setWidth(200);
    obj.label3:setHorzTextAlign("center");
    obj.label3:setMargins({left=5});
    obj.label3:setName("label3");

    obj.label4 = GUI.fromHandle(_obj_newObject("label"));
    obj.label4:setParent(obj.layout3);
    obj.label4:setAlign("left");
    obj.label4:setText("Defesa");
    obj.label4:setWidth(50);
    obj.label4:setHorzTextAlign("center");
    obj.label4:setMargins({left=5});
    obj.label4:setName("label4");

    obj.scrollBox1 = GUI.fromHandle(_obj_newObject("scrollBox"));
    obj.scrollBox1:setParent(obj.layout1);
    obj.scrollBox1:setAlign("top");
    obj.scrollBox1:setHeight(755);
    obj.scrollBox1:setMargins({top = 5});
    obj.scrollBox1:setName("scrollBox1");

    obj.iArmaduras = GUI.fromHandle(_obj_newObject("recordList"));
    obj.iArmaduras:setParent(obj.scrollBox1);
    obj.iArmaduras:setName("iArmaduras");
    obj.iArmaduras:setField("iArmaduras");
    obj.iArmaduras:setTemplateForm("ItemArmadura");
    obj.iArmaduras:setAlign("client");

    obj.layout4 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout4:setParent(obj.flowLayout1);
    obj.layout4:setWidth(520);
    obj.layout4:setHeight(900);
    obj.layout4:setMargins({left=5, top=5});
    obj.layout4:setName("layout4");

    obj.layout5 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout5:setParent(obj.layout4);
    obj.layout5:setAlign("top");
    obj.layout5:setHeight(25);
    obj.layout5:setMargins({left=30});
    obj.layout5:setName("layout5");

    obj.label5 = GUI.fromHandle(_obj_newObject("label"));
    obj.label5:setParent(obj.layout5);
    obj.label5:setAlign("left");
    obj.label5:setText("Armas");
    lfm_setPropAsString(obj.label5, "fontStyle",  "bold");
    obj.label5:setName("label5");

    obj.button3 = GUI.fromHandle(_obj_newObject("button"));
    obj.button3:setParent(obj.layout5);
    obj.button3:setAlign("right");
    obj.button3:setText("Adicionar Arma");
    obj.button3:setWidth(150);
    obj.button3:setMargins({right=5});
    obj.button3:setName("button3");

    obj.button4 = GUI.fromHandle(_obj_newObject("button"));
    obj.button4:setParent(obj.layout5);
    obj.button4:setAlign("right");
    obj.button4:setText("Colar Arma");
    obj.button4:setWidth(150);
    obj.button4:setName("button4");

    obj.layout6 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout6:setParent(obj.layout4);
    obj.layout6:setAlign("top");
    obj.layout6:setHeight(25);
    obj.layout6:setMargins({top=10});
    obj.layout6:setName("layout6");

    obj.label6 = GUI.fromHandle(_obj_newObject("label"));
    obj.label6:setParent(obj.layout6);
    obj.label6:setAlign("left");
    obj.label6:setText("");
    obj.label6:setWidth(20);
    obj.label6:setMargins({left=5});
    obj.label6:setName("label6");

    obj.label7 = GUI.fromHandle(_obj_newObject("label"));
    obj.label7:setParent(obj.layout6);
    obj.label7:setAlign("left");
    obj.label7:setText("Nome");
    obj.label7:setWidth(200);
    obj.label7:setHorzTextAlign("center");
    obj.label7:setMargins({left=5});
    obj.label7:setName("label7");

    obj.label8 = GUI.fromHandle(_obj_newObject("label"));
    obj.label8:setParent(obj.layout6);
    obj.label8:setAlign("left");
    obj.label8:setText("Ataque");
    obj.label8:setWidth(50);
    obj.label8:setHorzTextAlign("center");
    obj.label8:setMargins({left=5});
    obj.label8:setName("label8");

    obj.label9 = GUI.fromHandle(_obj_newObject("label"));
    obj.label9:setParent(obj.layout6);
    obj.label9:setAlign("left");
    obj.label9:setText("Defesa");
    obj.label9:setWidth(50);
    obj.label9:setHorzTextAlign("center");
    obj.label9:setMargins({left=5});
    obj.label9:setName("label9");

    obj.scrollBox2 = GUI.fromHandle(_obj_newObject("scrollBox"));
    obj.scrollBox2:setParent(obj.layout4);
    obj.scrollBox2:setAlign("top");
    obj.scrollBox2:setHeight(755);
    obj.scrollBox2:setMargins({top = 5});
    obj.scrollBox2:setName("scrollBox2");

    obj.iArmas = GUI.fromHandle(_obj_newObject("recordList"));
    obj.iArmas:setParent(obj.scrollBox2);
    obj.iArmas:setName("iArmas");
    obj.iArmas:setField("iArmas");
    obj.iArmas:setTemplateForm("ItemArma");
    obj.iArmas:setAlign("client");

    obj._e_event0 = obj.button1:addEventListener("onClick",
        function (_)
            self.iArmaduras:append()
                                    popupShow("Armadura adicionada.")
        end, obj);

    obj._e_event1 = obj.button2:addEventListener("onClick",
        function (_)
            str = System.getClipboardText()
                                    if string.find(str, "name = ") == nil then
                                        return
                                    end
                                    copyTable = totable(str)
                                    node = self.iArmaduras:append()
                                    if copyTable.cbItem ~= nil then
                                        node.cbItem = copyTable.cbItem
                                    end
                                    if copyTable.name ~= nil then
                                        node.name = copyTable.name
                                    end
                                    
            
                                    if copyTable.vNome ~= nil then
                                        node.vNome = copyTable.vNome
                                    end
                                    
            
                                    if copyTable.vDefesa ~= nil then
                                        node.vDefesa = copyTable.vDefesa
                                    end
        end, obj);

    obj._e_event2 = obj.button3:addEventListener("onClick",
        function (_)
            self.iArmas:append()
                                    popupShow("Arma adicionada.")
        end, obj);

    obj._e_event3 = obj.button4:addEventListener("onClick",
        function (_)
            str = System.getClipboardText()
                                    if string.find(str, "name = ") == nil then
                                        return
                                    end
                                    copyTable = totable(str)
                                    node = self.iArmas:append()
                                    if copyTable.cbItem ~= nil then
                                        node.cbItem = copyTable.cbItem
                                    end
                                    if copyTable.name ~= nil then
                                        node.name = copyTable.name
                                    end
                                    
            
                                    if copyTable.vNome ~= nil then
                                        node.vNome = copyTable.vNome
                                    end
                                    
            
                                    if copyTable.vAtaque ~= nil then
                                        node.vAtaque = copyTable.vAtaque
                                    end
                                    
            
                                    if copyTable.vDefesa ~= nil then
                                        node.vDefesa = copyTable.vDefesa
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

        if self.scrollBox2 ~= nil then self.scrollBox2:destroy(); self.scrollBox2 = nil; end;
        if self.button4 ~= nil then self.button4:destroy(); self.button4 = nil; end;
        if self.flowLayout1 ~= nil then self.flowLayout1:destroy(); self.flowLayout1 = nil; end;
        if self.label5 ~= nil then self.label5:destroy(); self.label5 = nil; end;
        if self.button1 ~= nil then self.button1:destroy(); self.button1 = nil; end;
        if self.button3 ~= nil then self.button3:destroy(); self.button3 = nil; end;
        if self.label1 ~= nil then self.label1:destroy(); self.label1 = nil; end;
        if self.layout4 ~= nil then self.layout4:destroy(); self.layout4 = nil; end;
        if self.layout6 ~= nil then self.layout6:destroy(); self.layout6 = nil; end;
        if self.label8 ~= nil then self.label8:destroy(); self.label8 = nil; end;
        if self.label3 ~= nil then self.label3:destroy(); self.label3 = nil; end;
        if self.label4 ~= nil then self.label4:destroy(); self.label4 = nil; end;
        if self.button2 ~= nil then self.button2:destroy(); self.button2 = nil; end;
        if self.label6 ~= nil then self.label6:destroy(); self.label6 = nil; end;
        if self.layout3 ~= nil then self.layout3:destroy(); self.layout3 = nil; end;
        if self.iArmaduras ~= nil then self.iArmaduras:destroy(); self.iArmaduras = nil; end;
        if self.label9 ~= nil then self.label9:destroy(); self.label9 = nil; end;
        if self.layout1 ~= nil then self.layout1:destroy(); self.layout1 = nil; end;
        if self.scrollBox1 ~= nil then self.scrollBox1:destroy(); self.scrollBox1 = nil; end;
        if self.label7 ~= nil then self.label7:destroy(); self.label7 = nil; end;
        if self.layout2 ~= nil then self.layout2:destroy(); self.layout2 = nil; end;
        if self.layout5 ~= nil then self.layout5:destroy(); self.layout5 = nil; end;
        if self.iArmas ~= nil then self.iArmas:destroy(); self.iArmas = nil; end;
        if self.label2 ~= nil then self.label2:destroy(); self.label2 = nil; end;
        self:_oldLFMDestroy();
    end;

    obj:endUpdate();

    return obj;
end;

function newInventario()
    local retObj = nil;
    __o_rrpgObjs.beginObjectsLoading();

    __o_Utils.tryFinally(
      function()
        retObj = constructNew_Inventario();
      end,
      function()
        __o_rrpgObjs.endObjectsLoading();
      end);

    assert(retObj ~= nil);
    return retObj;
end;

local _Inventario = {
    newEditor = newInventario, 
    new = newInventario, 
    name = "Inventario", 
    dataType = "", 
    formType = "undefined", 
    formComponentName = "form", 
    title = "", 
    description=""};

Inventario = _Inventario;
Firecast.registrarForm(_Inventario);

return _Inventario;
