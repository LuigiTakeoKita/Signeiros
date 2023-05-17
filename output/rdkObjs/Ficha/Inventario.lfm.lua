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


        function qntEquip()
            qnt = 0
            if (sheet ~= nil) then 
                items = NDB.getChildNodes(sheet.iArmas)
                for i=1, #items, 1 do
                    if items[i].cbItem == true then
                        qnt = qnt + 1
                    end
                end
            end
            return qnt
        end
        function getEquip()
            equip = {}
            if (sheet ~= nil) then 
                items = NDB.getChildNodes(sheet.iArmas)
                for i=1, #items, 1 do
                    if items[i].cbItem == true then
                        table.insert(equip, items[i])
                    end
                end
            end
            return equip
        end
        function changeArma(node)
            if node ~= nil then
                if node.cbItem == true then
                    if node.name == nil or trim(node.name) == "" then
                        node.cbItem = false
                        return
                    end
                    qnt = qntEquip()
                    if qnt > 2 then
                        node.cbItem = false
                        return
                    end
                    if (sheet ~= nil) then 
                        if qnt == 1 then
                            self.equip1.node = getEquip()[1]
                        else
                            self.equip1.node = getEquip()[1]
                            self.equip2.node = getEquip()[2]
                        end
                    end
                else
                    self.equip1.node = getEquip()[1]
                    self.equip2.node = getEquip()[2]
                end
            end
        end
        function RollThis(str, text)
            rolagem = Firecast.interpretarRolagem(str)
            mesaDoPersonagem = Firecast.getMesaDe(sheet)
            if mesaDoPersonagem ~= nil then
                mesaDoPersonagem.chat:rolarDados(rolagem, text)
            end
        end
    


    obj.flowLayout1 = GUI.fromHandle(_obj_newObject("flowLayout"));
    obj.flowLayout1:setParent(obj);
    obj.flowLayout1:setAlign("client");
    obj.flowLayout1:setAutoHeight(true);
    obj.flowLayout1:setName("flowLayout1");

    obj.layout1 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout1:setParent(obj.flowLayout1);
    obj.layout1:setWidth(485);
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
    obj.layout3:setMargins({top=5});
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
    obj.layout4:setWidth(540);
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
    obj.layout6:setWidth(300);
    obj.layout6:setHeight(90);
    obj.layout6:setMargins({top=5});
    obj.layout6:setName("layout6");

    obj.rectangle1 = GUI.fromHandle(_obj_newObject("rectangle"));
    obj.rectangle1:setParent(obj.layout6);
    obj.rectangle1:setAlign("client");
    obj.rectangle1:setColor("#505050");
    obj.rectangle1:setStrokeColor("black");
    obj.rectangle1:setStrokeSize(2);
    obj.rectangle1:setName("rectangle1");

    obj.equip1 = GUI.fromHandle(_obj_newObject("dataScopeBox"));
    obj.equip1:setParent(obj.rectangle1);
    obj.equip1:setName("equip1");
    obj.equip1:setAlign("top");
    obj.equip1:setHeight(30);

    obj.layout7 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout7:setParent(obj.equip1);
    obj.layout7:setAlign("client");
    obj.layout7:setMargins({left=5});
    obj.layout7:setName("layout7");

    obj.label6 = GUI.fromHandle(_obj_newObject("label"));
    obj.label6:setParent(obj.layout7);
    obj.label6:setAlign("left");
    obj.label6:setField("name");
    obj.label6:setName("label6");

    obj.label7 = GUI.fromHandle(_obj_newObject("label"));
    obj.label7:setParent(obj.layout7);
    obj.label7:setAlign("left");
    obj.label7:setField("vAtaque");
    obj.label7:setName("label7");

    obj.button5 = GUI.fromHandle(_obj_newObject("button"));
    obj.button5:setParent(obj.layout7);
    obj.button5:setAlign("left");
    obj.button5:setText("Atk");
    obj.button5:setWidth(50);
    obj.button5:setMargins({left=5});
    obj.button5:setName("button5");

    obj.label8 = GUI.fromHandle(_obj_newObject("label"));
    obj.label8:setParent(obj.layout7);
    obj.label8:setAlign("left");
    obj.label8:setField("vDefesa");
    obj.label8:setMargins({left=5});
    obj.label8:setName("label8");

    obj.button6 = GUI.fromHandle(_obj_newObject("button"));
    obj.button6:setParent(obj.layout7);
    obj.button6:setAlign("left");
    obj.button6:setText("Def");
    obj.button6:setWidth(50);
    obj.button6:setMargins({left=5});
    obj.button6:setName("button6");

    obj.layout8 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout8:setParent(obj.rectangle1);
    obj.layout8:setAlign("top");
    obj.layout8:setHeight(30);
    obj.layout8:setMargins({left=5});
    obj.layout8:setName("layout8");

    obj.label9 = GUI.fromHandle(_obj_newObject("label"));
    obj.label9:setParent(obj.layout8);
    obj.label9:setAlign("left");
    obj.label9:setWidth(120);
    obj.label9:setText("");
    obj.label9:setName("label9");

    obj.edit1 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit1:setParent(obj.layout8);
    obj.edit1:setAlign("left");
    obj.edit1:setWidth(120);
    obj.edit1:setField("atkCombinado");
    obj.edit1:setName("edit1");

    obj.button7 = GUI.fromHandle(_obj_newObject("button"));
    obj.button7:setParent(obj.layout8);
    obj.button7:setAlign("left");
    obj.button7:setText("Atk");
    obj.button7:setWidth(50);
    obj.button7:setMargins({left=5});
    obj.button7:setName("button7");

    obj.edit2 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit2:setParent(obj.layout8);
    obj.edit2:setAlign("left");
    obj.edit2:setWidth(120);
    obj.edit2:setField("defCombinado");
    obj.edit2:setMargins({left=5});
    obj.edit2:setName("edit2");

    obj.button8 = GUI.fromHandle(_obj_newObject("button"));
    obj.button8:setParent(obj.layout8);
    obj.button8:setAlign("left");
    obj.button8:setText("Def");
    obj.button8:setWidth(50);
    obj.button8:setMargins({left=5});
    obj.button8:setName("button8");

    obj.equip2 = GUI.fromHandle(_obj_newObject("dataScopeBox"));
    obj.equip2:setParent(obj.rectangle1);
    obj.equip2:setName("equip2");
    obj.equip2:setAlign("top");
    obj.equip2:setHeight(30);

    obj.layout9 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout9:setParent(obj.equip2);
    obj.layout9:setAlign("client");
    obj.layout9:setMargins({left=5});
    obj.layout9:setName("layout9");

    obj.label10 = GUI.fromHandle(_obj_newObject("label"));
    obj.label10:setParent(obj.layout9);
    obj.label10:setAlign("left");
    obj.label10:setField("name");
    obj.label10:setName("label10");

    obj.label11 = GUI.fromHandle(_obj_newObject("label"));
    obj.label11:setParent(obj.layout9);
    obj.label11:setAlign("left");
    obj.label11:setField("vAtaque");
    obj.label11:setName("label11");

    obj.button9 = GUI.fromHandle(_obj_newObject("button"));
    obj.button9:setParent(obj.layout9);
    obj.button9:setAlign("left");
    obj.button9:setText("Atk");
    obj.button9:setWidth(50);
    obj.button9:setMargins({left=5});
    obj.button9:setName("button9");

    obj.label12 = GUI.fromHandle(_obj_newObject("label"));
    obj.label12:setParent(obj.layout9);
    obj.label12:setAlign("left");
    obj.label12:setField("vDefesa");
    obj.label12:setMargins({left=5});
    obj.label12:setName("label12");

    obj.button10 = GUI.fromHandle(_obj_newObject("button"));
    obj.button10:setParent(obj.layout9);
    obj.button10:setAlign("left");
    obj.button10:setText("Def");
    obj.button10:setWidth(50);
    obj.button10:setMargins({left=5});
    obj.button10:setName("button10");

    obj.layout10 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout10:setParent(obj.layout4);
    obj.layout10:setAlign("top");
    obj.layout10:setHeight(25);
    obj.layout10:setMargins({top=5});
    obj.layout10:setName("layout10");

    obj.label13 = GUI.fromHandle(_obj_newObject("label"));
    obj.label13:setParent(obj.layout10);
    obj.label13:setAlign("left");
    obj.label13:setText("");
    obj.label13:setWidth(20);
    obj.label13:setMargins({left=5});
    obj.label13:setName("label13");

    obj.label14 = GUI.fromHandle(_obj_newObject("label"));
    obj.label14:setParent(obj.layout10);
    obj.label14:setAlign("left");
    obj.label14:setText("Nome");
    obj.label14:setWidth(200);
    obj.label14:setHorzTextAlign("center");
    obj.label14:setMargins({left=5});
    obj.label14:setName("label14");

    obj.label15 = GUI.fromHandle(_obj_newObject("label"));
    obj.label15:setParent(obj.layout10);
    obj.label15:setAlign("left");
    obj.label15:setText("Ataque");
    obj.label15:setWidth(50);
    obj.label15:setHorzTextAlign("center");
    obj.label15:setMargins({left=5});
    obj.label15:setName("label15");

    obj.label16 = GUI.fromHandle(_obj_newObject("label"));
    obj.label16:setParent(obj.layout10);
    obj.label16:setAlign("left");
    obj.label16:setText("Defesa");
    obj.label16:setWidth(50);
    obj.label16:setHorzTextAlign("center");
    obj.label16:setMargins({left=5});
    obj.label16:setName("label16");

    obj.scrollBox2 = GUI.fromHandle(_obj_newObject("scrollBox"));
    obj.scrollBox2:setParent(obj.layout4);
    obj.scrollBox2:setAlign("top");
    obj.scrollBox2:setHeight(665);
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

    obj._e_event4 = obj.button5:addEventListener("onClick",
        function (_)
            str = self.equip1.node.vAtaque or ""
                                            name = self.equip1.node.name
                                            if str == "" then
                                                popupShow("Não possui valor de ataque.")
                                                return 
                                            end
                                            RollThis(str, "Rolagem de ataque(".. name ..").")
        end, obj);

    obj._e_event5 = obj.button6:addEventListener("onClick",
        function (_)
            str = self.equip1.node.vDefesa or ""
                                            name = self.equip1.node.name
                                            if str == "" then
                                                popupShow("Não possui valor de defesa.")
                                                return 
                                            end
                                            RollThis(str, "Rolagem de defesa(".. name ..").")
        end, obj);

    obj._e_event6 = obj.button7:addEventListener("onClick",
        function (_)
            str = sheet.atkCombinado or ""
                                        if str == "" then
                                            popupShow("Não possui valor de ataque combinado.")
                                            return 
                                        end
                                        RollThis(str, "Rolagem de ataque combinado.")
        end, obj);

    obj._e_event7 = obj.button8:addEventListener("onClick",
        function (_)
            str = sheet.defCombinado or ""
                                        if str == "" then
                                            popupShow("Não possui valor de defesa combinado.")
                                            return 
                                        end
                                        RollThis(str, "Rolagem de defesa combinado.")
        end, obj);

    obj._e_event8 = obj.button9:addEventListener("onClick",
        function (_)
            str = self.equip2.node.vAtaque or ""
                                            name = self.equip2.node.name
                                            if str == "" then
                                                popupShow("Não possui valor de ataque.")
                                                return 
                                            end
                                            RollThis(str, "Rolagem de ataque(".. name ..").")
        end, obj);

    obj._e_event9 = obj.button10:addEventListener("onClick",
        function (_)
            str = self.equip2.node.vDefesa or ""
                                            name = self.equip2.node.name
                                            if str == "" then
                                                popupShow("Não possui valor de defesa.")
                                                return 
                                            end
                                            RollThis(str, "Rolagem de defesa(".. name ..").")
        end, obj);

    function obj:_releaseEvents()
        __o_rrpgObjs.removeEventListenerById(self._e_event9);
        __o_rrpgObjs.removeEventListenerById(self._e_event8);
        __o_rrpgObjs.removeEventListenerById(self._e_event7);
        __o_rrpgObjs.removeEventListenerById(self._e_event6);
        __o_rrpgObjs.removeEventListenerById(self._e_event5);
        __o_rrpgObjs.removeEventListenerById(self._e_event4);
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

        if self.button10 ~= nil then self.button10:destroy(); self.button10 = nil; end;
        if self.button4 ~= nil then self.button4:destroy(); self.button4 = nil; end;
        if self.label13 ~= nil then self.label13:destroy(); self.label13 = nil; end;
        if self.label14 ~= nil then self.label14:destroy(); self.label14 = nil; end;
        if self.iArmas ~= nil then self.iArmas:destroy(); self.iArmas = nil; end;
        if self.button1 ~= nil then self.button1:destroy(); self.button1 = nil; end;
        if self.button3 ~= nil then self.button3:destroy(); self.button3 = nil; end;
        if self.label1 ~= nil then self.label1:destroy(); self.label1 = nil; end;
        if self.layout4 ~= nil then self.layout4:destroy(); self.layout4 = nil; end;
        if self.label8 ~= nil then self.label8:destroy(); self.label8 = nil; end;
        if self.label11 ~= nil then self.label11:destroy(); self.label11 = nil; end;
        if self.label3 ~= nil then self.label3:destroy(); self.label3 = nil; end;
        if self.label4 ~= nil then self.label4:destroy(); self.label4 = nil; end;
        if self.label6 ~= nil then self.label6:destroy(); self.label6 = nil; end;
        if self.button7 ~= nil then self.button7:destroy(); self.button7 = nil; end;
        if self.layout9 ~= nil then self.layout9:destroy(); self.layout9 = nil; end;
        if self.layout10 ~= nil then self.layout10:destroy(); self.layout10 = nil; end;
        if self.button9 ~= nil then self.button9:destroy(); self.button9 = nil; end;
        if self.iArmaduras ~= nil then self.iArmaduras:destroy(); self.iArmaduras = nil; end;
        if self.label15 ~= nil then self.label15:destroy(); self.label15 = nil; end;
        if self.label7 ~= nil then self.label7:destroy(); self.label7 = nil; end;
        if self.layout5 ~= nil then self.layout5:destroy(); self.layout5 = nil; end;
        if self.button8 ~= nil then self.button8:destroy(); self.button8 = nil; end;
        if self.label2 ~= nil then self.label2:destroy(); self.label2 = nil; end;
        if self.scrollBox2 ~= nil then self.scrollBox2:destroy(); self.scrollBox2 = nil; end;
        if self.flowLayout1 ~= nil then self.flowLayout1:destroy(); self.flowLayout1 = nil; end;
        if self.label5 ~= nil then self.label5:destroy(); self.label5 = nil; end;
        if self.layout6 ~= nil then self.layout6:destroy(); self.layout6 = nil; end;
        if self.label12 ~= nil then self.label12:destroy(); self.label12 = nil; end;
        if self.button6 ~= nil then self.button6:destroy(); self.button6 = nil; end;
        if self.button5 ~= nil then self.button5:destroy(); self.button5 = nil; end;
        if self.button2 ~= nil then self.button2:destroy(); self.button2 = nil; end;
        if self.label16 ~= nil then self.label16:destroy(); self.label16 = nil; end;
        if self.layout3 ~= nil then self.layout3:destroy(); self.layout3 = nil; end;
        if self.equip1 ~= nil then self.equip1:destroy(); self.equip1 = nil; end;
        if self.edit2 ~= nil then self.edit2:destroy(); self.edit2 = nil; end;
        if self.layout8 ~= nil then self.layout8:destroy(); self.layout8 = nil; end;
        if self.label9 ~= nil then self.label9:destroy(); self.label9 = nil; end;
        if self.layout1 ~= nil then self.layout1:destroy(); self.layout1 = nil; end;
        if self.scrollBox1 ~= nil then self.scrollBox1:destroy(); self.scrollBox1 = nil; end;
        if self.rectangle1 ~= nil then self.rectangle1:destroy(); self.rectangle1 = nil; end;
        if self.layout2 ~= nil then self.layout2:destroy(); self.layout2 = nil; end;
        if self.layout7 ~= nil then self.layout7:destroy(); self.layout7 = nil; end;
        if self.edit1 ~= nil then self.edit1:destroy(); self.edit1 = nil; end;
        if self.equip2 ~= nil then self.equip2:destroy(); self.equip2 = nil; end;
        if self.label10 ~= nil then self.label10:destroy(); self.label10 = nil; end;
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
