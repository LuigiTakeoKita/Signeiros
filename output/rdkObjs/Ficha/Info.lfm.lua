require("firecast.lua");
local __o_rrpgObjs = require("rrpgObjs.lua");
require("rrpgGUI.lua");
require("rrpgDialogs.lua");
require("rrpgLFM.lua");
require("ndb.lua");
require("locale.lua");
local __o_Utils = require("utils.lua");

local function constructNew_Info()
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
    obj:setName("Info");
    obj:setAlign("client");
    obj:setTheme("dark");
    obj:setMargins({top=1});

    obj.flowLayout1 = GUI.fromHandle(_obj_newObject("flowLayout"));
    obj.flowLayout1:setParent(obj);
    obj.flowLayout1:setAlign("client");
    obj.flowLayout1:setOrientation("horizontal");
    obj.flowLayout1:setHorzAlign("justify");
    obj.flowLayout1:setMargins({left=20, top=20, bottom=20, right=20});
    obj.flowLayout1:setName("flowLayout1");

    obj.flowPart1 = GUI.fromHandle(_obj_newObject("flowPart"));
    obj.flowPart1:setParent(obj.flowLayout1);
    obj.flowPart1:setMinWidth(100);
    obj.flowPart1:setMaxWidth(500);
    obj.flowPart1:setHeight(25);
    obj.flowPart1:setName("flowPart1");

    obj.label1 = GUI.fromHandle(_obj_newObject("label"));
    obj.label1:setParent(obj.flowPart1);
    obj.label1:setAlign("left");
    obj.label1:setText("Nome");
    obj.label1:setWidth(90);
    obj.label1:setName("label1");

    obj.edit1 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit1:setParent(obj.flowPart1);
    obj.edit1:setAlign("client");
    obj.edit1:setField("nome");
    obj.edit1:setName("edit1");

    obj.flowPart2 = GUI.fromHandle(_obj_newObject("flowPart"));
    obj.flowPart2:setParent(obj.flowLayout1);
    obj.flowPart2:setMinWidth(100);
    obj.flowPart2:setMaxWidth(500);
    obj.flowPart2:setHeight(25);
    obj.flowPart2:setName("flowPart2");

    obj.label2 = GUI.fromHandle(_obj_newObject("label"));
    obj.label2:setParent(obj.flowPart2);
    obj.label2:setAlign("left");
    obj.label2:setText("Player");
    obj.label2:setWidth(90);
    obj.label2:setName("label2");

    obj.edit2 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit2:setParent(obj.flowPart2);
    obj.edit2:setAlign("client");
    obj.edit2:setField("player");
    obj.edit2:setName("edit2");

    obj.flowPart3 = GUI.fromHandle(_obj_newObject("flowPart"));
    obj.flowPart3:setParent(obj.flowLayout1);
    obj.flowPart3:setMinWidth(100);
    obj.flowPart3:setMaxWidth(200);
    obj.flowPart3:setHeight(25);
    obj.flowPart3:setName("flowPart3");

    obj.label3 = GUI.fromHandle(_obj_newObject("label"));
    obj.label3:setParent(obj.flowPart3);
    obj.label3:setAlign("left");
    obj.label3:setText("Idade");
    obj.label3:setWidth(90);
    obj.label3:setName("label3");

    obj.edit3 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit3:setParent(obj.flowPart3);
    obj.edit3:setAlign("client");
    obj.edit3:setField("idade");
    obj.edit3:setType("number");
    obj.edit3:setName("edit3");

    obj.flowPart4 = GUI.fromHandle(_obj_newObject("flowPart"));
    obj.flowPart4:setParent(obj.flowLayout1);
    obj.flowPart4:setMinWidth(100);
    obj.flowPart4:setMaxWidth(200);
    obj.flowPart4:setHeight(25);
    obj.flowPart4:setName("flowPart4");

    obj.label4 = GUI.fromHandle(_obj_newObject("label"));
    obj.label4:setParent(obj.flowPart4);
    obj.label4:setAlign("left");
    obj.label4:setText("Dinheiro");
    obj.label4:setWidth(90);
    obj.label4:setName("label4");

    obj.edit4 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit4:setParent(obj.flowPart4);
    obj.edit4:setAlign("client");
    obj.edit4:setField("dinheiro");
    obj.edit4:setType("number");
    obj.edit4:setName("edit4");

    obj.flowLineBreak1 = GUI.fromHandle(_obj_newObject("flowLineBreak"));
    obj.flowLineBreak1:setParent(obj.flowLayout1);
    obj.flowLineBreak1:setName("flowLineBreak1");

    obj.flowPart5 = GUI.fromHandle(_obj_newObject("flowPart"));
    obj.flowPart5:setParent(obj.flowLayout1);
    obj.flowPart5:setMinWidth(295);
    obj.flowPart5:setMaxWidth(300);
    obj.flowPart5:setHeight(25);
    obj.flowPart5:setVertAlign("center");
    obj.flowPart5:setMargins({top=5});
    obj.flowPart5:setName("flowPart5");

    obj.label5 = GUI.fromHandle(_obj_newObject("label"));
    obj.label5:setParent(obj.flowPart5);
    obj.label5:setAlign("left");
    obj.label5:setText("Dano");
    obj.label5:setWidth(75);
    obj.label5:setName("label5");

    obj.edit5 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit5:setParent(obj.flowPart5);
    obj.edit5:setAlign("left");
    obj.edit5:setField("dano");
    obj.edit5:setWidth(100);
    obj.edit5:setType("number");
    obj.edit5:setHint("Valor de dano a ser calculado.");
    obj.edit5:setName("edit5");

    obj.button1 = GUI.fromHandle(_obj_newObject("button"));
    obj.button1:setParent(obj.flowPart5);
    obj.button1:setAlign("left");
    obj.button1:setText("Aplicar Dano");
    obj.button1:setWidth(100);
    obj.button1:setMargins({left=10});
    obj.button1:setName("button1");

    obj.flowPart6 = GUI.fromHandle(_obj_newObject("flowPart"));
    obj.flowPart6:setParent(obj.flowLayout1);
    obj.flowPart6:setMinWidth(300);
    obj.flowPart6:setMaxWidth(425);
    obj.flowPart6:setHeight(25);
    obj.flowPart6:setVertAlign("center");
    obj.flowPart6:setMargins({top=5});
    obj.flowPart6:setName("flowPart6");

    obj.label6 = GUI.fromHandle(_obj_newObject("label"));
    obj.label6:setParent(obj.flowPart6);
    obj.label6:setAlign("left");
    obj.label6:setText("Vitalidade");
    obj.label6:setWidth(75);
    obj.label6:setName("label6");

    obj.edit6 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit6:setParent(obj.flowPart6);
    obj.edit6:setAlign("left");
    obj.edit6:setField("vitalidadeAt");
    obj.edit6:setWidth(100);
    obj.edit6:setType("number");
    obj.edit6:setHorzTextAlign("trailing");
    obj.edit6:setName("edit6");

    obj.label7 = GUI.fromHandle(_obj_newObject("label"));
    obj.label7:setParent(obj.flowPart6);
    obj.label7:setAlign("left");
    obj.label7:setText("/");
    obj.label7:setWidth(10);
    obj.label7:setMargins({left=5});
    obj.label7:setName("label7");

    obj.edit7 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit7:setParent(obj.flowPart6);
    obj.edit7:setAlign("left");
    obj.edit7:setField("vitalidadeMax");
    obj.edit7:setWidth(100);
    obj.edit7:setType("number");
    obj.edit7:setName("edit7");

    obj.flowPart7 = GUI.fromHandle(_obj_newObject("flowPart"));
    obj.flowPart7:setParent(obj.flowLayout1);
    obj.flowPart7:setMinWidth(300);
    obj.flowPart7:setMaxWidth(425);
    obj.flowPart7:setHeight(25);
    obj.flowPart7:setVertAlign("center");
    obj.flowPart7:setMargins({top=5});
    obj.flowPart7:setName("flowPart7");

    obj.label8 = GUI.fromHandle(_obj_newObject("label"));
    obj.label8:setParent(obj.flowPart7);
    obj.label8:setAlign("left");
    obj.label8:setText("Ferimento");
    obj.label8:setWidth(75);
    obj.label8:setName("label8");

    obj.edit8 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit8:setParent(obj.flowPart7);
    obj.edit8:setAlign("left");
    obj.edit8:setField("ferimentoAt");
    obj.edit8:setWidth(100);
    obj.edit8:setType("number");
    obj.edit8:setHorzTextAlign("trailing");
    obj.edit8:setName("edit8");

    obj.label9 = GUI.fromHandle(_obj_newObject("label"));
    obj.label9:setParent(obj.flowPart7);
    obj.label9:setAlign("left");
    obj.label9:setText("/");
    obj.label9:setWidth(10);
    obj.label9:setMargins({left=5});
    obj.label9:setName("label9");

    obj.edit9 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit9:setParent(obj.flowPart7);
    obj.edit9:setAlign("left");
    obj.edit9:setField("ferimentoMax");
    obj.edit9:setWidth(100);
    obj.edit9:setType("number");
    obj.edit9:setName("edit9");

    obj.flowPart8 = GUI.fromHandle(_obj_newObject("flowPart"));
    obj.flowPart8:setParent(obj.flowLayout1);
    obj.flowPart8:setMinWidth(300);
    obj.flowPart8:setMaxWidth(425);
    obj.flowPart8:setHeight(25);
    obj.flowPart8:setVertAlign("center");
    obj.flowPart8:setMargins({top=5});
    obj.flowPart8:setName("flowPart8");

    obj.label10 = GUI.fromHandle(_obj_newObject("label"));
    obj.label10:setParent(obj.flowPart8);
    obj.label10:setAlign("left");
    obj.label10:setText("Armadura ");
    obj.label10:setWidth(75);
    obj.label10:setName("label10");

    obj.edit10 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit10:setParent(obj.flowPart8);
    obj.edit10:setAlign("left");
    obj.edit10:setField("armaduraAt");
    obj.edit10:setWidth(100);
    obj.edit10:setHorzTextAlign("trailing");
    obj.edit10:setName("edit10");

    obj.label11 = GUI.fromHandle(_obj_newObject("label"));
    obj.label11:setParent(obj.flowPart8);
    obj.label11:setAlign("left");
    obj.label11:setText("/");
    obj.label11:setWidth(10);
    obj.label11:setMargins({left=5});
    obj.label11:setName("label11");

    obj.edit11 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit11:setParent(obj.flowPart8);
    obj.edit11:setAlign("left");
    obj.edit11:setField("armaduraMax");
    obj.edit11:setWidth(100);
    obj.edit11:setReadOnly(true);
    obj.edit11:setName("edit11");

    obj.flowPart9 = GUI.fromHandle(_obj_newObject("flowPart"));
    obj.flowPart9:setParent(obj.flowLayout1);
    obj.flowPart9:setMinWidth(300);
    obj.flowPart9:setMaxWidth(425);
    obj.flowPart9:setHeight(25);
    obj.flowPart9:setVertAlign("center");
    obj.flowPart9:setMargins({top=5});
    obj.flowPart9:setName("flowPart9");

    obj.label12 = GUI.fromHandle(_obj_newObject("label"));
    obj.label12:setParent(obj.flowPart9);
    obj.label12:setAlign("left");
    obj.label12:setText("Escudo Mágico");
    obj.label12:setWidth(100);
    obj.label12:setName("label12");

    obj.edit12 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit12:setParent(obj.flowPart9);
    obj.edit12:setAlign("left");
    obj.edit12:setField("escudoMAt");
    obj.edit12:setWidth(100);
    obj.edit12:setType("number");
    obj.edit12:setHorzTextAlign("trailing");
    obj.edit12:setName("edit12");

    obj.label13 = GUI.fromHandle(_obj_newObject("label"));
    obj.label13:setParent(obj.flowPart9);
    obj.label13:setAlign("left");
    obj.label13:setText("/");
    obj.label13:setWidth(10);
    obj.label13:setMargins({left=5});
    obj.label13:setName("label13");

    obj.edit13 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit13:setParent(obj.flowPart9);
    obj.edit13:setAlign("left");
    obj.edit13:setField("escudoMMax");
    obj.edit13:setWidth(100);
    obj.edit13:setType("number");
    obj.edit13:setName("edit13");

    obj.flowLineBreak2 = GUI.fromHandle(_obj_newObject("flowLineBreak"));
    obj.flowLineBreak2:setParent(obj.flowLayout1);
    obj.flowLineBreak2:setName("flowLineBreak2");

    obj.flowPart10 = GUI.fromHandle(_obj_newObject("flowPart"));
    obj.flowPart10:setParent(obj.flowLayout1);
    obj.flowPart10:setMinWidth(100);
    obj.flowPart10:setMaxWidth(200);
    obj.flowPart10:setHeight(25);
    obj.flowPart10:setName("flowPart10");

    obj.label14 = GUI.fromHandle(_obj_newObject("label"));
    obj.label14:setParent(obj.flowPart10);
    obj.label14:setAlign("left");
    obj.label14:setText("História");
    obj.label14:setWidth(90);
    obj.label14:setName("label14");

    obj.flowLineBreak3 = GUI.fromHandle(_obj_newObject("flowLineBreak"));
    obj.flowLineBreak3:setParent(obj.flowLayout1);
    obj.flowLineBreak3:setName("flowLineBreak3");

    obj.flowPart11 = GUI.fromHandle(_obj_newObject("flowPart"));
    obj.flowPart11:setParent(obj.flowLayout1);
    obj.flowPart11:setMinWidth(100);
    obj.flowPart11:setMaxWidth(2000);
    obj.flowPart11:setHeight(800);
    obj.flowPart11:setName("flowPart11");

    obj.richEdit1 = GUI.fromHandle(_obj_newObject("richEdit"));
    obj.richEdit1:setParent(obj.flowPart11);
    obj.richEdit1:setAlign("client");
    obj.richEdit1:setField("historia");
    obj.richEdit1:setName("richEdit1");

    obj._e_event0 = obj.button1:addEventListener("onClick",
        function (_)
            dano = (sheet.dano or 0)
                                valor =  dano - (sheet.armaduraAt or 0)
                                sheet.armaduraAt = sheet.armaduraAt - dano
                                if 0 > sheet.armaduraAt then
                                    sheet.armaduraAt = 0
                                end
                                if valor > 0 then
                                    sheet.vitalidadeAt = (sheet.vitalidadeAt or 0) - valor
                                    showMessage("Você tomou: " .. valor .. " de dano.")
                                else
                                    showMessage("Nenhum dano aplicado.")
                                end
        end, obj);

    function obj:_releaseEvents()
        __o_rrpgObjs.removeEventListenerById(self._e_event0);
    end;

    obj._oldLFMDestroy = obj.destroy;

    function obj:destroy() 
        self:_releaseEvents();

        if (self.handle ~= 0) and (self.setNodeDatabase ~= nil) then
          self:setNodeDatabase(nil);
        end;

        if self.label14 ~= nil then self.label14:destroy(); self.label14 = nil; end;
        if self.flowPart3 ~= nil then self.flowPart3:destroy(); self.flowPart3 = nil; end;
        if self.button1 ~= nil then self.button1:destroy(); self.button1 = nil; end;
        if self.flowPart8 ~= nil then self.flowPart8:destroy(); self.flowPart8 = nil; end;
        if self.label1 ~= nil then self.label1:destroy(); self.label1 = nil; end;
        if self.edit4 ~= nil then self.edit4:destroy(); self.edit4 = nil; end;
        if self.label8 ~= nil then self.label8:destroy(); self.label8 = nil; end;
        if self.label11 ~= nil then self.label11:destroy(); self.label11 = nil; end;
        if self.flowPart10 ~= nil then self.flowPart10:destroy(); self.flowPart10 = nil; end;
        if self.label3 ~= nil then self.label3:destroy(); self.label3 = nil; end;
        if self.label4 ~= nil then self.label4:destroy(); self.label4 = nil; end;
        if self.label6 ~= nil then self.label6:destroy(); self.label6 = nil; end;
        if self.edit11 ~= nil then self.edit11:destroy(); self.edit11 = nil; end;
        if self.flowLineBreak3 ~= nil then self.flowLineBreak3:destroy(); self.flowLineBreak3 = nil; end;
        if self.richEdit1 ~= nil then self.richEdit1:destroy(); self.richEdit1 = nil; end;
        if self.edit9 ~= nil then self.edit9:destroy(); self.edit9 = nil; end;
        if self.edit5 ~= nil then self.edit5:destroy(); self.edit5 = nil; end;
        if self.edit6 ~= nil then self.edit6:destroy(); self.edit6 = nil; end;
        if self.flowPart5 ~= nil then self.flowPart5:destroy(); self.flowPart5 = nil; end;
        if self.flowPart9 ~= nil then self.flowPart9:destroy(); self.flowPart9 = nil; end;
        if self.label7 ~= nil then self.label7:destroy(); self.label7 = nil; end;
        if self.edit13 ~= nil then self.edit13:destroy(); self.edit13 = nil; end;
        if self.edit7 ~= nil then self.edit7:destroy(); self.edit7 = nil; end;
        if self.flowPart7 ~= nil then self.flowPart7:destroy(); self.flowPart7 = nil; end;
        if self.flowPart11 ~= nil then self.flowPart11:destroy(); self.flowPart11 = nil; end;
        if self.label2 ~= nil then self.label2:destroy(); self.label2 = nil; end;
        if self.edit3 ~= nil then self.edit3:destroy(); self.edit3 = nil; end;
        if self.flowLayout1 ~= nil then self.flowLayout1:destroy(); self.flowLayout1 = nil; end;
        if self.edit12 ~= nil then self.edit12:destroy(); self.edit12 = nil; end;
        if self.label5 ~= nil then self.label5:destroy(); self.label5 = nil; end;
        if self.label12 ~= nil then self.label12:destroy(); self.label12 = nil; end;
        if self.flowPart1 ~= nil then self.flowPart1:destroy(); self.flowPart1 = nil; end;
        if self.edit8 ~= nil then self.edit8:destroy(); self.edit8 = nil; end;
        if self.flowPart2 ~= nil then self.flowPart2:destroy(); self.flowPart2 = nil; end;
        if self.flowPart4 ~= nil then self.flowPart4:destroy(); self.flowPart4 = nil; end;
        if self.flowPart6 ~= nil then self.flowPart6:destroy(); self.flowPart6 = nil; end;
        if self.edit2 ~= nil then self.edit2:destroy(); self.edit2 = nil; end;
        if self.label9 ~= nil then self.label9:destroy(); self.label9 = nil; end;
        if self.edit10 ~= nil then self.edit10:destroy(); self.edit10 = nil; end;
        if self.label10 ~= nil then self.label10:destroy(); self.label10 = nil; end;
        if self.label13 ~= nil then self.label13:destroy(); self.label13 = nil; end;
        if self.edit1 ~= nil then self.edit1:destroy(); self.edit1 = nil; end;
        if self.flowLineBreak1 ~= nil then self.flowLineBreak1:destroy(); self.flowLineBreak1 = nil; end;
        if self.flowLineBreak2 ~= nil then self.flowLineBreak2:destroy(); self.flowLineBreak2 = nil; end;
        self:_oldLFMDestroy();
    end;

    obj:endUpdate();

    return obj;
end;

function newInfo()
    local retObj = nil;
    __o_rrpgObjs.beginObjectsLoading();

    __o_Utils.tryFinally(
      function()
        retObj = constructNew_Info();
      end,
      function()
        __o_rrpgObjs.endObjectsLoading();
      end);

    assert(retObj ~= nil);
    return retObj;
end;

local _Info = {
    newEditor = newInfo, 
    new = newInfo, 
    name = "Info", 
    dataType = "", 
    formType = "undefined", 
    formComponentName = "form", 
    title = "", 
    description=""};

Info = _Info;
Firecast.registrarForm(_Info);

return _Info;
