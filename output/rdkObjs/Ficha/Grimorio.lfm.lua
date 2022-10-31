require("firecast.lua");
local __o_rrpgObjs = require("rrpgObjs.lua");
require("rrpgGUI.lua");
require("rrpgDialogs.lua");
require("rrpgLFM.lua");
require("ndb.lua");
require("locale.lua");
local __o_Utils = require("utils.lua");

local function constructNew_Grimorio()
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
    obj:setName("Grimorio");
    obj:setAlign("client");
    obj:setTheme("dark");
    obj:setMargins({top=1});

    obj.Functions = GUI.fromHandle(_obj_newObject("form"));
    obj.Functions:setParent(obj);
    obj.Functions:setName("Functions");
    obj.Functions:setAlign("client");
    obj.Functions:setTheme("dark");
    obj.Functions:setMargins({top=1});


        function getSigno(txt)
            a = split(txt, "/")
            if #a ~= 5 then
                return nil
            end
            a = split(a[5], ".png")
            return tonumber(a[1])
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
    


    obj.Functions_Roll = GUI.fromHandle(_obj_newObject("form"));
    obj.Functions_Roll:setParent(obj);
    obj.Functions_Roll:setName("Functions_Roll");


        function getText(magic)
            if     magic == 1 then return sheet.level1
            elseif magic == 2 then return sheet.level2
            elseif magic == 3 then return sheet.level3
            elseif magic == 4 then return sheet.level4
            elseif magic == 5 then return sheet.level5
            elseif magic == 6 then return sheet.level6
            elseif magic == 7 then return sheet.level7
            elseif magic == 8 then return sheet.level8
            else
                return "1: 0/0"
            end
        end
        function setText(magic, text)
            if     magic == 1 then sheet.level1 = text
            elseif magic == 2 then sheet.level2 = text
            elseif magic == 3 then sheet.level3 = text
            elseif magic == 4 then sheet.level4 = text
            elseif magic == 5 then sheet.level5 = text
            elseif magic == 6 then sheet.level6 = text
            elseif magic == 7 then sheet.level7 = text
            elseif magic == 8 then sheet.level8 = text
            else
                showMessage("Error")
            end
        end
        function addXP(qnt, magic)
            text = getText(magic)
            text = split(text, ":")
            xp = split(text[2], "/")
            if tonumber(xp[2]) > tonumber(xp[1])+qnt then
                setText(magic, text[1].. ": ".. tonumber(xp[1])+qnt .. "/" .. xp[2])
                return
            end
            text[1] = tonumber(text[1])+1
            if text[1] == 7 then
                setText(magic, "6: 100/100")
                return true
            end
            if text[1] == 3 or text[1] == 5 then
                sheet.vigorMax = sheet.vigorMax + 1
            end
            qnts = {3, 5, 7, 9, 11, 100}
            setText(magic, text[1].. ": 0/" .. qnts[text[1]])
            return true
        end
        function reduceVigor(qnt)
            if 0 > qnt then
                return
            end
            sheet.vigor = sheet.vigor - qnt
        end
        function hasVigor(qnt)
            return sheet.vigor >= qnt
        end
        function getSequencia()
            node = self.grimorio.selectedNode
            res = split(node.sequencia, " ")
            for i=1, #res, 1 do
                res[i] = tonumber(res[i])
            end
            return res
        end
        function getLevel(magic)
            textSig = getText(magic)
            level = split(textSig, ":")
            return tonumber(level[1])
        end
        function hasLevel()
            sequencia = getSequencia()
            for i=1, #sequencia, 1 do
                if #sequencia > getLevel(sequencia[i]) then
                    return false
                end
            end
            return true
        end
        function discountVigor(size, result)
            for i=1, size, 1 do
                value = 12*size - (i-1)*2
                if result > value then
                    return size-(i-1)
                end
            end
            return 0
        end
        function afterRoll(rolagem)
            sequencia = getSequencia()
            qnt = #sequencia
            discount = discountVigor(qnt, rolagem.resultado)
            reduceVigor(qnt-discount)
            index = 1
            for i=1, #rolagem.ops, 1 do
                if rolagem.ops[i].tipo == "dado" then
                    item = rolagem.ops[i]
                    if item.resultados[1] == item.face then
                        flag = addXP(1, sequencia[index])
                        if flag then
                            return
                        end
                    end
                    index = index + 1
                end
            end
        end
        function valuesRolls(ops)
            results = ""
            value = 0
            for i=1, #ops, 1 do
                if ops[i].tipo == "dado" then
                    if i ~= 1 then
                        results = results .. ", "
                    end
                    for j=1, #ops[i].resultados, 1 do
                        item = ops[i].resultados[j]
                        results = results .. round(item)
                        if item > 10 then
                            results = results .. "(10)"
                            value = value + 10
                        else
                            value = value + item
                        end
                    end
                end
            end
            return results, value
        end
        function calUnidades(value, sum)
            return math.floor(value*(1+(sum/10))+0.2)
        end
        function generateUnidades(txtUnits, sum)
            if txtUnits == nil then
                return "Nenhuma unidade."
            end
            allUnits = split(txtUnits, ",")
            msg = ""
            for i=1, #allUnits, 1 do
                if i ~= 1 then
                    msg = msg .. ", "
                end
                parts = split(allUnits[i], "=")
                if #parts == 2 then
                    msg = msg .. trim(parts[1]) .. "(".. trim(parts[2]) ..") = " .. calUnidades(tonumber(parts[2]), sum)
                else
                    msg = msg .. "Unidade " .. i .. "(".. tonumber(parts[1]) .. ") = " .. calUnidades(tonumber(parts[1]), sum)
                end
            end
            return msg
        end
        function generateMsg(strRolagem)
            node = self.grimorio.selectedNode
            rolagem = Firecast.interpretarRolagem(strRolagem)
            rolagem:rolarLocalmente()
            resultsStr, resultInt = valuesRolls(rolagem.ops)
            dano = node.dano or 0
            dmg = calUnidades(tonumber(dano), resultInt)
            msg = (node.nomeMagia or "Sem Nome") .. "\n"..
                    "Dados(".. strRolagem .."): ".. resultsStr .. " = " .. rolagem.resultado .. "(".. round(resultInt) ..")" .. "\n" ..
                    "Dano(".. (dano) .."): ".. dmg .."\n" ..
                    "Unidades: " .. generateUnidades(node.unidades, resultInt)
            return msg, rolagem
        end
        function revealResult(strRolagem)
            msg, rolagem = generateMsg(strRolagem)
            mesaDoPersonagem = Firecast.getMesaDe(sheet)
            mesaDoPersonagem.chat:enviarMensagem(msg)
            afterRoll(rolagem)
        end
        function generateRoll()
            sequencia = getSequencia()
            dices = {"1d4", "1d4", "1d6", "1d8", "1d10", "1d12", "1d20"}
            strRolagem = ""
            for i=1, #sequencia, 1 do
                if i ~= 1 then
                    strRolagem = strRolagem .. "+"
                end
                level = getLevel(sequencia[i]) + 1
                strRolagem = strRolagem .. dices[level]
            end
            return strRolagem
        end
        function roll()
            strRolagem = generateRoll()
            node = self.grimorio.selectedNode
            if node.modoSecreto == false or node.modoSecreto == nil then
                revealResult(strRolagem)
            else
                node.rolagem = strRolagem
                mesaDoPersonagem = Firecast.getMesaDe(sheet)
                mesaDoPersonagem.chat:enviarMensagem("Magia preparada.")
                showMessage("Rolagem preparada.")
            end
        end
        function level0Roll()
            strRolagem = generateRoll()
            msg, rolagem = generateMsg(strRolagem)
            item = rolagem.ops[1]
            mesaDoPersonagem = Firecast.getMesaDe(sheet)
            afterRoll(rolagem)
            if item.resultados[1] == item.face then
                mesaDoPersonagem.chat:enviarMensagem(msg)
                return
            end
            mesaDoPersonagem.chat:enviarMensagem("Magia falhou. Resultado: " .. item.resultados[1])
        end
        function trySpell()
            sequencia = getSequencia()
            qnt = #sequencia
            if hasVigor(qnt) == false then
                showMessage("Vigor não suficiente para executar a magia.")
                return
            end
            if qnt == 1 and getLevel(sequencia[1]) == 0 then
                level0Roll()
                return
            end
            if hasLevel() == false then
                showMessage("Você não possui level nos Signos necessário para executar a magia.")
                return
            end
            roll()
        end
    


    obj.Functions_Edit = GUI.fromHandle(_obj_newObject("form"));
    obj.Functions_Edit:setParent(obj);
    obj.Functions_Edit:setName("Functions_Edit");
    obj.Functions_Edit:setAlign("client");
    obj.Functions_Edit:setTheme("dark");
    obj.Functions_Edit:setMargins({top=1});


        function copyAll()
            magics = NDB.getChildNodes(sheet.magics)
            System.setClipboardText(tableToStr(magics))
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
            if table.signo1 ~= nil then
                node.signo1 = table.signo1
            end
            if table.signo2 ~= nil then
                node.signo2 = table.signo2
            end
            if table.signo3 ~= nil then
                node.signo3 = table.signo3
            end
            if table.signo4 ~= nil then
                node.signo4 = table.signo4
            end
            if table.signo5 ~= nil then
                node.signo5 = table.signo5
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
        end
    



        -- Verificar item oculto
        function searchList(addMode)
            magics = NDB.getChildNodes(sheet.magics)
            magicsInv = NDB.getChildNodes(sheet.magicsInv)
            btns = {self.btn1, self.btn2, self.btn3, self.btn4, self.btn5}
            -- Nenhun Signo selecionado
            if btns[1].src == "" then
                -- Passa todos as magias da lista invisivel para o grimorio
                for i=1, #magicsInv, 1 do
                    nodo = self.grimorio:append()
                    NDB.copy(nodo, magicsInv[i])
                    NDB.deleteNode(magicsInv[i])
                end
            else
                sequencia = {}
                -- Criação da sequencia
                for i=1, #btns, 1 do
                    signo = getSigno(btns[i].src)
                    if signo ~= nil then 
                        table.insert(sequencia, signo)
                    end
                end
                -- Ordenar e juntar
                table.sort(sequencia)
                sequencia = table.concat(sequencia, " ")
                -- Limitar lista de acordo com os signos selecionados - Grimório para Lista invisivel
                if addMode then
                    for i=1, #magics, 1 do
                        if string.find(magics[i].sequencia, sequencia) == nil then
                            nodo = self.grimorioInv:append()
                            NDB.copy(nodo, magics[i])
                            NDB.deleteNode(magics[i])
                        end
                    end
                -- Limitar lista de acordo com os signos selecionados - Lista invisivel para Grimório
                else
                    for i=1, #magicsInv, 1 do
                        if string.find(magicsInv[i].sequencia, sequencia) ~= nil then
                            nodo = self.grimorio:append()
                            NDB.copy(nodo, magicsInv[i])
                            NDB.deleteNode(magicsInv[i])
                        end
                    end
                end
            end
            self.grimorio:needRepaint()
            self.grimorio:sort()
        end
        function addSig(sig)
            btns = {self.btn1, self.btn2, self.btn3, self.btn4, self.btn5}
            sequencia = {sig}
            -- É o primeiro
            if btns[1] == "" then
                btns[1].src = "/Ficha/images/signos/" .. sig .. ".png"
            else
                -- Cria sequencia
                for i=1, #btns, 1 do
                    signo = getSigno(btns[i].src)
                    if signo ~= nil then 
                        table.insert(sequencia, signo)
                    end
                end
                table.sort(sequencia)
                if 5 >= #sequencia then
                    for i=1, #sequencia, 1 do
                        btns[i].src = "/Ficha/images/signos/" .. sequencia[i] .. ".png"
                    end
                end
            end
            if 6 > #sequencia then 
                searchList(true)
            end
        end
        function removeSig(btnNum)
            btns = {self.btn1, self.btn2, self.btn3, self.btn4, self.btn5}
            btns[btnNum].src = ""
            sequencia = {}
            for i=1, #btns, 1 do
                signo = getSigno(btns[i].src)
                if signo ~= nil then 
                    table.insert(sequencia, signo)
                end
            end
            table.sort(sequencia)
            if 5 >= #sequencia then
                for i=1, 5, 1 do
                    if sequencia[i] ~= nil then
                        btns[i].src = "/Ficha/images/signos/" .. sequencia[i] .. ".png"
                    else
                        btns[i].src = ""
                    end
                end
            end
            searchList(false)
        end
        function altVigor()
            vigor = 15
            for i=1, 8, 1 do
                level = getLevel(i)
                if level >= 3 then
                    vigor = vigor + 1
                end
                if level >= 5 then
                    vigor = vigor + 1
                end
            end
            sheet.vigorMax = vigor
        end
        function altLevel(sig, text)
            if     sig == 1 then sheet.level1 = text
            elseif sig == 2 then sheet.level2 = text
            elseif sig == 3 then sheet.level3 = text
            elseif sig == 4 then sheet.level4 = text
            elseif sig == 5 then sheet.level5 = text
            elseif sig == 6 then sheet.level6 = text
            elseif sig == 7 then sheet.level7 = text
            elseif sig == 8 then sheet.level8 = text
            else
                showMessage("Error")
            end
            altVigor()
        end
        SIZE = 1650
        function hasSize()
            return self.body.width > SIZE
        end
        function resizeLayout()
            if hasSize() then
                self.layout2.left = 850
                self.layout2.top = 0
                self.layout2.width = 800 + self.body.width - SIZE
            else
                self.layout2.left = 0
                self.layout2.top = 810
                self.layout2.width = 800
            end
        end
    


    obj.body = GUI.fromHandle(_obj_newObject("scrollBox"));
    obj.body:setParent(obj);
    obj.body:setAlign("client");
    obj.body:setMargins({left=5, top=5, bottom=5, right=5});
    obj.body:setName("body");

    obj.edit1 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit1:setParent(obj.body);
    obj.edit1:setField("admPermission");
    obj.edit1:setVisible(false);
    obj.edit1:setWidth(0);
    obj.edit1:setHeight(0);
    obj.edit1:setName("edit1");

    obj.layout1 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout1:setParent(obj.body);
    obj.layout1:setLeft(0);
    obj.layout1:setTop(0);
    obj.layout1:setWidth(800);
    obj.layout1:setHeight(800);
    obj.layout1:setMargins({left = 5, right = 5, top = 5, bottom = 5});
    obj.layout1:setName("layout1");

    obj.flowLayout1 = GUI.fromHandle(_obj_newObject("flowLayout"));
    obj.flowLayout1:setParent(obj.layout1);
    obj.flowLayout1:setAlign("top");
    obj.flowLayout1:setWidth(150);
    obj.flowLayout1:setHorzAlign("center");
    obj.flowLayout1:setAutoHeight(true);
    obj.flowLayout1:setName("flowLayout1");

    obj.layout3 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout3:setParent(obj.flowLayout1);
    obj.layout3:setWidth(150);
    obj.layout3:setHeight(150);
    obj.layout3:setName("layout3");

    obj.escudoAp = GUI.fromHandle(_obj_newObject("imageCheckBox"));
    obj.escudoAp:setParent(obj.layout3);
    obj.escudoAp:setAlign("top");
    obj.escudoAp:setName("escudoAp");
    obj.escudoAp:setWidth(100);
    obj.escudoAp:setHeight(100);
    obj.escudoAp:setField("selected");
    obj.escudoAp:setImageChecked("/Ficha/images/ShieldOn.png");
    obj.escudoAp:setImageUnchecked("/Ficha/images/ShieldOff.png");
    obj.escudoAp:setAutoChange(false);

    obj.button1 = GUI.fromHandle(_obj_newObject("button"));
    obj.button1:setParent(obj.layout3);
    obj.button1:setAlign("top");
    obj.button1:setText("Remover escudo");
    obj.button1:setWidth(150);
    obj.button1:setName("button1");

    obj.flowLayout2 = GUI.fromHandle(_obj_newObject("flowLayout"));
    obj.flowLayout2:setParent(obj.layout1);
    obj.flowLayout2:setAlign("top");
    obj.flowLayout2:setHeight(25);
    obj.flowLayout2:setMargins({left = 5, right = 5, top = 5, bottom = 5});
    obj.flowLayout2:setHorzAlign("center");
    obj.flowLayout2:setName("flowLayout2");

    obj.progressBar1 = GUI.fromHandle(_obj_newObject("progressBar"));
    obj.progressBar1:setParent(obj.flowLayout2);
    obj.progressBar1:setColor("yellow");
    obj.progressBar1:setWidth(600);
    obj.progressBar1:setFieldMax("vigorMax");
    obj.progressBar1:setField("vigor");
    obj.progressBar1:setHitTest(true);
    obj.progressBar1:setName("progressBar1");

    obj.button2 = GUI.fromHandle(_obj_newObject("button"));
    obj.button2:setParent(obj.flowLayout2);
    obj.button2:setText("Restaurar Vigor");
    obj.button2:setWidth(100);
    obj.button2:setMargins({left=10});
    obj.button2:setName("button2");

    obj.layout4 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout4:setParent(obj.layout1);
    obj.layout4:setAlign("top");
    obj.layout4:setHeight(300);
    obj.layout4:setMargins({left = 5, right = 5, top = 5, bottom = 5});
    obj.layout4:setName("layout4");

    obj.flowLayout3 = GUI.fromHandle(_obj_newObject("flowLayout"));
    obj.flowLayout3:setParent(obj.layout4);
    obj.flowLayout3:setAlign("top");
    obj.flowLayout3:setWidth(850);
    obj.flowLayout3:setHeight(85);
    obj.flowLayout3:setHorzAlign("center");
    obj.flowLayout3:setName("flowLayout3");

    obj.layout5 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout5:setParent(obj.flowLayout3);
    obj.layout5:setWidth(70);
    obj.layout5:setHeight(85);
    obj.layout5:setMargins({left=5});
    obj.layout5:setName("layout5");

    obj.image1 = GUI.fromHandle(_obj_newObject("image"));
    obj.image1:setParent(obj.layout5);
    obj.image1:setAlign("top");
    obj.image1:setHeight(60);
    obj.image1:setWidth(60);
    obj.image1:setStyle("proportional");
    obj.image1:setHitTest(true);
    obj.image1:setHint("Calor");
    obj.image1:setSRC("/Ficha/images/signos/1.png");
    obj.image1:setName("image1");

    obj.label1 = GUI.fromHandle(_obj_newObject("label"));
    obj.label1:setParent(obj.layout5);
    obj.label1:setAlign("top");
    obj.label1:setHeight(25);
    obj.label1:setField("level1");
    obj.label1:setHorzTextAlign("center");
    obj.label1:setHitTest(true);
    obj.label1:setHint("Level: XP Atual/XP Upar");
    obj.label1:setName("label1");

    obj.layout6 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout6:setParent(obj.flowLayout3);
    obj.layout6:setWidth(70);
    obj.layout6:setHeight(85);
    obj.layout6:setMargins({left=5});
    obj.layout6:setName("layout6");

    obj.image2 = GUI.fromHandle(_obj_newObject("image"));
    obj.image2:setParent(obj.layout6);
    obj.image2:setAlign("top");
    obj.image2:setHeight(60);
    obj.image2:setWidth(60);
    obj.image2:setStyle("proportional");
    obj.image2:setHitTest(true);
    obj.image2:setHint("Disrupção");
    obj.image2:setSRC("/Ficha/images/signos/2.png");
    obj.image2:setName("image2");

    obj.label2 = GUI.fromHandle(_obj_newObject("label"));
    obj.label2:setParent(obj.layout6);
    obj.label2:setAlign("top");
    obj.label2:setHeight(25);
    obj.label2:setField("level2");
    obj.label2:setHorzTextAlign("center");
    obj.label2:setHitTest(true);
    obj.label2:setHint("Level: XP Atual/XP Upar");
    obj.label2:setName("label2");

    obj.layout7 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout7:setParent(obj.flowLayout3);
    obj.layout7:setWidth(70);
    obj.layout7:setHeight(85);
    obj.layout7:setMargins({left=5});
    obj.layout7:setName("layout7");

    obj.image3 = GUI.fromHandle(_obj_newObject("image"));
    obj.image3:setParent(obj.layout7);
    obj.image3:setAlign("top");
    obj.image3:setHeight(60);
    obj.image3:setWidth(60);
    obj.image3:setStyle("proportional");
    obj.image3:setHitTest(true);
    obj.image3:setHint("Engano");
    obj.image3:setSRC("/Ficha/images/signos/3.png");
    obj.image3:setName("image3");

    obj.label3 = GUI.fromHandle(_obj_newObject("label"));
    obj.label3:setParent(obj.layout7);
    obj.label3:setAlign("top");
    obj.label3:setHeight(25);
    obj.label3:setField("level3");
    obj.label3:setHorzTextAlign("center");
    obj.label3:setHitTest(true);
    obj.label3:setHint("Level: XP Atual/XP Upar");
    obj.label3:setName("label3");

    obj.layout8 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout8:setParent(obj.flowLayout3);
    obj.layout8:setWidth(70);
    obj.layout8:setHeight(85);
    obj.layout8:setMargins({left=5});
    obj.layout8:setName("layout8");

    obj.image4 = GUI.fromHandle(_obj_newObject("image"));
    obj.image4:setParent(obj.layout8);
    obj.image4:setAlign("top");
    obj.image4:setHeight(60);
    obj.image4:setWidth(60);
    obj.image4:setStyle("proportional");
    obj.image4:setHitTest(true);
    obj.image4:setHint("Equilíbrio");
    obj.image4:setSRC("/Ficha/images/signos/4.png");
    obj.image4:setName("image4");

    obj.label4 = GUI.fromHandle(_obj_newObject("label"));
    obj.label4:setParent(obj.layout8);
    obj.label4:setAlign("top");
    obj.label4:setHeight(25);
    obj.label4:setField("level4");
    obj.label4:setHorzTextAlign("center");
    obj.label4:setHitTest(true);
    obj.label4:setHint("Level: XP Atual/XP Upar");
    obj.label4:setName("label4");

    obj.layout9 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout9:setParent(obj.flowLayout3);
    obj.layout9:setWidth(70);
    obj.layout9:setHeight(85);
    obj.layout9:setMargins({left=5});
    obj.layout9:setName("layout9");

    obj.image5 = GUI.fromHandle(_obj_newObject("image"));
    obj.image5:setParent(obj.layout9);
    obj.image5:setAlign("top");
    obj.image5:setHeight(60);
    obj.image5:setWidth(60);
    obj.image5:setStyle("proportional");
    obj.image5:setHitTest(true);
    obj.image5:setHint("Força");
    obj.image5:setSRC("/Ficha/images/signos/5.png");
    obj.image5:setName("image5");

    obj.label5 = GUI.fromHandle(_obj_newObject("label"));
    obj.label5:setParent(obj.layout9);
    obj.label5:setAlign("top");
    obj.label5:setHeight(25);
    obj.label5:setField("level5");
    obj.label5:setHorzTextAlign("center");
    obj.label5:setHitTest(true);
    obj.label5:setHint("Level: XP Atual/XP Upar");
    obj.label5:setName("label5");

    obj.layout10 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout10:setParent(obj.flowLayout3);
    obj.layout10:setWidth(70);
    obj.layout10:setHeight(85);
    obj.layout10:setMargins({left=5});
    obj.layout10:setName("layout10");

    obj.image6 = GUI.fromHandle(_obj_newObject("image"));
    obj.image6:setParent(obj.layout10);
    obj.image6:setAlign("top");
    obj.image6:setHeight(60);
    obj.image6:setWidth(60);
    obj.image6:setStyle("proportional");
    obj.image6:setHitTest(true);
    obj.image6:setHint("Imaterial");
    obj.image6:setSRC("/Ficha/images/signos/6.png");
    obj.image6:setName("image6");

    obj.label6 = GUI.fromHandle(_obj_newObject("label"));
    obj.label6:setParent(obj.layout10);
    obj.label6:setAlign("top");
    obj.label6:setHeight(25);
    obj.label6:setField("level6");
    obj.label6:setHorzTextAlign("center");
    obj.label6:setHitTest(true);
    obj.label6:setHint("Level: XP Atual/XP Upar");
    obj.label6:setName("label6");

    obj.layout11 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout11:setParent(obj.flowLayout3);
    obj.layout11:setWidth(70);
    obj.layout11:setHeight(85);
    obj.layout11:setMargins({left=5});
    obj.layout11:setName("layout11");

    obj.image7 = GUI.fromHandle(_obj_newObject("image"));
    obj.image7:setParent(obj.layout11);
    obj.image7:setAlign("top");
    obj.image7:setHeight(60);
    obj.image7:setWidth(60);
    obj.image7:setStyle("proportional");
    obj.image7:setHitTest(true);
    obj.image7:setHint("Material");
    obj.image7:setSRC("/Ficha/images/signos/7.png");
    obj.image7:setName("image7");

    obj.label7 = GUI.fromHandle(_obj_newObject("label"));
    obj.label7:setParent(obj.layout11);
    obj.label7:setAlign("top");
    obj.label7:setHeight(25);
    obj.label7:setField("level7");
    obj.label7:setHorzTextAlign("center");
    obj.label7:setHitTest(true);
    obj.label7:setHint("Level: XP Atual/XP Upar");
    obj.label7:setName("label7");

    obj.layout12 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout12:setParent(obj.flowLayout3);
    obj.layout12:setWidth(70);
    obj.layout12:setHeight(85);
    obj.layout12:setMargins({left=5});
    obj.layout12:setName("layout12");

    obj.image8 = GUI.fromHandle(_obj_newObject("image"));
    obj.image8:setParent(obj.layout12);
    obj.image8:setAlign("top");
    obj.image8:setHeight(60);
    obj.image8:setWidth(60);
    obj.image8:setStyle("proportional");
    obj.image8:setHitTest(true);
    obj.image8:setHint("Proteção");
    obj.image8:setSRC("/Ficha/images/signos/8.png");
    obj.image8:setName("image8");

    obj.label8 = GUI.fromHandle(_obj_newObject("label"));
    obj.label8:setParent(obj.layout12);
    obj.label8:setAlign("top");
    obj.label8:setHeight(25);
    obj.label8:setField("level8");
    obj.label8:setHorzTextAlign("center");
    obj.label8:setHitTest(true);
    obj.label8:setHint("Level: XP Atual/XP Upar");
    obj.label8:setName("label8");

    obj.layout13 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout13:setParent(obj.layout4);
    obj.layout13:setAlign("top");
    obj.layout13:setWidth(850);
    obj.layout13:setHeight(340);
    obj.layout13:setMargins({top=10});
    obj.layout13:setName("layout13");

    obj.flowLayout4 = GUI.fromHandle(_obj_newObject("flowLayout"));
    obj.flowLayout4:setParent(obj.layout13);
    obj.flowLayout4:setAlign("top");
    obj.flowLayout4:setHeight(50);
    obj.flowLayout4:setHorzAlign("center");
    obj.flowLayout4:setName("flowLayout4");

    obj.rectangle1 = GUI.fromHandle(_obj_newObject("rectangle"));
    obj.rectangle1:setParent(obj.flowLayout4);
    obj.rectangle1:setAlign("left");
    obj.rectangle1:setWidth(50);
    obj.rectangle1:setHeight(50);
    obj.rectangle1:setMargins({left=5});
    obj.rectangle1:setColor("black");
    obj.rectangle1:setStrokeColor("red");
    obj.rectangle1:setStrokeSize(2);
    obj.rectangle1:setName("rectangle1");

    obj.btn1 = GUI.fromHandle(_obj_newObject("image"));
    obj.btn1:setParent(obj.rectangle1);
    obj.btn1:setWidth(50);
    obj.btn1:setHeight(50);
    obj.btn1:setStyle("stretch");
    obj.btn1:setHitTest(true);
    obj.btn1:setName("btn1");

    obj.rectangle2 = GUI.fromHandle(_obj_newObject("rectangle"));
    obj.rectangle2:setParent(obj.flowLayout4);
    obj.rectangle2:setAlign("left");
    obj.rectangle2:setWidth(50);
    obj.rectangle2:setHeight(50);
    obj.rectangle2:setMargins({left=5});
    obj.rectangle2:setColor("black");
    obj.rectangle2:setStrokeColor("red");
    obj.rectangle2:setStrokeSize(2);
    obj.rectangle2:setName("rectangle2");

    obj.btn2 = GUI.fromHandle(_obj_newObject("image"));
    obj.btn2:setParent(obj.rectangle2);
    obj.btn2:setWidth(50);
    obj.btn2:setHeight(50);
    obj.btn2:setStyle("stretch");
    obj.btn2:setHitTest(true);
    obj.btn2:setName("btn2");

    obj.rectangle3 = GUI.fromHandle(_obj_newObject("rectangle"));
    obj.rectangle3:setParent(obj.flowLayout4);
    obj.rectangle3:setAlign("left");
    obj.rectangle3:setWidth(50);
    obj.rectangle3:setHeight(50);
    obj.rectangle3:setMargins({left=5});
    obj.rectangle3:setColor("black");
    obj.rectangle3:setStrokeColor("red");
    obj.rectangle3:setStrokeSize(2);
    obj.rectangle3:setName("rectangle3");

    obj.btn3 = GUI.fromHandle(_obj_newObject("image"));
    obj.btn3:setParent(obj.rectangle3);
    obj.btn3:setWidth(50);
    obj.btn3:setHeight(50);
    obj.btn3:setStyle("stretch");
    obj.btn3:setHitTest(true);
    obj.btn3:setName("btn3");

    obj.rectangle4 = GUI.fromHandle(_obj_newObject("rectangle"));
    obj.rectangle4:setParent(obj.flowLayout4);
    obj.rectangle4:setAlign("left");
    obj.rectangle4:setWidth(50);
    obj.rectangle4:setHeight(50);
    obj.rectangle4:setMargins({left=5});
    obj.rectangle4:setColor("black");
    obj.rectangle4:setStrokeColor("red");
    obj.rectangle4:setStrokeSize(2);
    obj.rectangle4:setName("rectangle4");

    obj.btn4 = GUI.fromHandle(_obj_newObject("image"));
    obj.btn4:setParent(obj.rectangle4);
    obj.btn4:setWidth(50);
    obj.btn4:setHeight(50);
    obj.btn4:setStyle("stretch");
    obj.btn4:setHitTest(true);
    obj.btn4:setName("btn4");

    obj.rectangle5 = GUI.fromHandle(_obj_newObject("rectangle"));
    obj.rectangle5:setParent(obj.flowLayout4);
    obj.rectangle5:setAlign("left");
    obj.rectangle5:setWidth(50);
    obj.rectangle5:setHeight(50);
    obj.rectangle5:setMargins({left=5});
    obj.rectangle5:setColor("black");
    obj.rectangle5:setStrokeColor("red");
    obj.rectangle5:setStrokeSize(2);
    obj.rectangle5:setName("rectangle5");

    obj.btn5 = GUI.fromHandle(_obj_newObject("image"));
    obj.btn5:setParent(obj.rectangle5);
    obj.btn5:setWidth(50);
    obj.btn5:setHeight(50);
    obj.btn5:setStyle("stretch");
    obj.btn5:setHitTest(true);
    obj.btn5:setName("btn5");

    obj.adminTab = GUI.fromHandle(_obj_newObject("flowLayout"));
    obj.adminTab:setParent(obj.layout13);
    obj.adminTab:setAlign("top");
    obj.adminTab:setWidth(850);
    obj.adminTab:setHeight(35);
    obj.adminTab:setMargins({left = 5, right = 5, top = 5, bottom = 5});
    obj.adminTab:setHorzAlign("center");
    obj.adminTab:setName("adminTab");

    obj.button3 = GUI.fromHandle(_obj_newObject("button"));
    obj.button3:setParent(obj.adminTab);
    obj.button3:setWidth(150);
    obj.button3:setText("Adicionar Magia");
    obj.button3:setMargins({top=10});
    obj.button3:setName("button3");

    obj.button4 = GUI.fromHandle(_obj_newObject("button"));
    obj.button4:setParent(obj.adminTab);
    obj.button4:setWidth(150);
    obj.button4:setText("Ajustar Level de magia");
    obj.button4:setMargins({top=10, left=10});
    obj.button4:setName("button4");

    obj.layout14 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout14:setParent(obj.layout1);
    obj.layout14:setAlign("top");
    obj.layout14:setHeight(300);
    obj.layout14:setMargins({left = 5, right = 5, top = 5, bottom = 5});
    obj.layout14:setName("layout14");

    obj.magicDesc = GUI.fromHandle(_obj_newObject("dataScopeBox"));
    obj.magicDesc:setParent(obj.layout14);
    obj.magicDesc:setName("magicDesc");
    obj.magicDesc:setAlign("client");

    obj.rectangle6 = GUI.fromHandle(_obj_newObject("rectangle"));
    obj.rectangle6:setParent(obj.magicDesc);
    obj.rectangle6:setAlign("top");
    obj.rectangle6:setColor("black");
    obj.rectangle6:setXradius(10);
    obj.rectangle6:setYradius(10);
    obj.rectangle6:setHeight(290);
    obj.rectangle6:setPadding({top=5, left=5, right=5, bottom=5});
    obj.rectangle6:setName("rectangle6");

    obj.layout15 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout15:setParent(obj.rectangle6);
    obj.layout15:setAlign("client");
    obj.layout15:setName("layout15");

    obj.layout16 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout16:setParent(obj.layout15);
    obj.layout16:setAlign("top");
    obj.layout16:setHeight(60);
    obj.layout16:setName("layout16");

    obj.layout17 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout17:setParent(obj.layout16);
    obj.layout17:setAlign("left");
    obj.layout17:setWidth(600);
    obj.layout17:setHeight(50);
    obj.layout17:setName("layout17");

    obj.layout18 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout18:setParent(obj.layout17);
    obj.layout18:setAlign("top");
    obj.layout18:setWidth(90);
    obj.layout18:setHeight(25);
    obj.layout18:setMargins({top = 5});
    obj.layout18:setName("layout18");

    obj.label9 = GUI.fromHandle(_obj_newObject("label"));
    obj.label9:setParent(obj.layout18);
    obj.label9:setAlign("left");
    obj.label9:setText("Dano");
    obj.label9:setMargins({left = 5});
    obj.label9:setName("label9");

    obj.edit2 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit2:setParent(obj.layout18);
    obj.edit2:setAlign("left");
    obj.edit2:setWidth(50);
    obj.edit2:setField("dano");
    obj.edit2:setType("number");
    obj.edit2:setMin(0);
    obj.edit2:setMax(5);
    obj.edit2:setName("edit2");

    obj.layout19 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout19:setParent(obj.layout17);
    obj.layout19:setAlign("top");
    obj.layout19:setWidth(90);
    obj.layout19:setHeight(25);
    obj.layout19:setMargins({top = 5});
    obj.layout19:setName("layout19");

    obj.label10 = GUI.fromHandle(_obj_newObject("label"));
    obj.label10:setParent(obj.layout19);
    obj.label10:setAlign("left");
    obj.label10:setText("Unidade");
    obj.label10:setMargins({left = 5});
    obj.label10:setName("label10");

    obj.edit3 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit3:setParent(obj.layout19);
    obj.edit3:setAlign("left");
    obj.edit3:setWidth(300);
    obj.edit3:setField("unidades");
    obj.edit3:setHint("Nome=Valor,Nome=Valor ou Valor,Valor");
    obj.edit3:setName("edit3");

    obj.layout20 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout20:setParent(obj.layout16);
    obj.layout20:setAlign("right");
    obj.layout20:setWidth(200);
    obj.layout20:setHeight(60);
    obj.layout20:setName("layout20");

    obj.layout21 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout21:setParent(obj.layout20);
    obj.layout21:setAlign("top");
    obj.layout21:setWidth(90);
    obj.layout21:setHeight(25);
    obj.layout21:setMargins({top = 5});
    obj.layout21:setName("layout21");

    obj.button5 = GUI.fromHandle(_obj_newObject("button"));
    obj.button5:setParent(obj.layout21);
    obj.button5:setAlign("left");
    obj.button5:setText("Rolar");
    obj.button5:setWidth(60);
    obj.button5:setMargins({left=10});
    obj.button5:setName("button5");

    obj.checkBox1 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.checkBox1:setParent(obj.layout21);
    obj.checkBox1:setAlign("left");
    obj.checkBox1:setField("modoSecreto");
    obj.checkBox1:setText("Modo Secreto");
    obj.checkBox1:setMargins({left = 5});
    obj.checkBox1:setName("checkBox1");

    obj.layout22 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout22:setParent(obj.layout20);
    obj.layout22:setAlign("top");
    obj.layout22:setWidth(90);
    obj.layout22:setHeight(25);
    obj.layout22:setMargins({top = 5});
    obj.layout22:setName("layout22");

    obj.button6 = GUI.fromHandle(_obj_newObject("button"));
    obj.button6:setParent(obj.layout22);
    obj.button6:setAlign("left");
    obj.button6:setText("Revelar Valores");
    obj.button6:setWidth(180);
    obj.button6:setMargins({left=10});
    obj.button6:setName("button6");

    obj.label11 = GUI.fromHandle(_obj_newObject("label"));
    obj.label11:setParent(obj.layout15);
    obj.label11:setAlign("bottom");
    obj.label11:setText("Descrição");
    obj.label11:setMargins({left = 5});
    obj.label11:setName("label11");

    obj.textEditor1 = GUI.fromHandle(_obj_newObject("textEditor"));
    obj.textEditor1:setParent(obj.layout15);
    obj.textEditor1:setAlign("bottom");
    obj.textEditor1:setHeight(190);
    obj.textEditor1:setField("desc");
    obj.textEditor1:setMargins({top = 5});
    obj.textEditor1:setName("textEditor1");

    obj.layout2 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout2:setParent(obj.body);
    obj.layout2:setWidth(900);
    obj.layout2:setHeight(800);
    obj.layout2:setMargins({left = 5, right = 5, top = 5, bottom = 5});
    obj.layout2:setName("layout2");

    obj.layout23 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout23:setParent(obj.layout2);
    obj.layout23:setAlign("top");
    obj.layout23:setHeight(25);
    obj.layout23:setName("layout23");

    obj.label12 = GUI.fromHandle(_obj_newObject("label"));
    obj.label12:setParent(obj.layout23);
    obj.label12:setAlign("left");
    obj.label12:setText("Grimório");
    obj.label12:setWidth(100);
    obj.label12:setHeight(25);
    lfm_setPropAsString(obj.label12, "fontStyle",  "bold");
    obj.label12:setName("label12");

    obj.button7 = GUI.fromHandle(_obj_newObject("button"));
    obj.button7:setParent(obj.layout23);
    obj.button7:setAlign("left");
    obj.button7:setLeft(10);
    obj.button7:setText("Copiar Grimório");
    obj.button7:setWidth(150);
    obj.button7:setHeight(25);
    obj.button7:setMargins({left = 10});
    obj.button7:setName("button7");

    obj.button8 = GUI.fromHandle(_obj_newObject("button"));
    obj.button8:setParent(obj.layout23);
    obj.button8:setAlign("left");
    obj.button8:setLeft(10);
    obj.button8:setText("Colar no Grimório");
    obj.button8:setWidth(150);
    obj.button8:setHeight(25);
    obj.button8:setMargins({left = 10});
    obj.button8:setName("button8");

    obj.scrollBox1 = GUI.fromHandle(_obj_newObject("scrollBox"));
    obj.scrollBox1:setParent(obj.layout2);
    obj.scrollBox1:setAlign("top");
    obj.scrollBox1:setHeight(755);
    obj.scrollBox1:setMargins({top = 10});
    obj.scrollBox1:setName("scrollBox1");

    obj.grimorio = GUI.fromHandle(_obj_newObject("recordList"));
    obj.grimorio:setParent(obj.scrollBox1);
    obj.grimorio:setName("grimorio");
    obj.grimorio:setField("magics");
    obj.grimorio:setTemplateForm("ItemGrimorio");
    obj.grimorio:setAlign("client");
    obj.grimorio:setSelectable(true);

    obj.grimorioInv = GUI.fromHandle(_obj_newObject("recordList"));
    obj.grimorioInv:setParent(obj.layout2);
    obj.grimorioInv:setName("grimorioInv");
    obj.grimorioInv:setField("magicsInv");
    obj.grimorioInv:setTemplateForm("ItemGrimorio");
    obj.grimorioInv:setWidth(0);
    obj.grimorioInv:setHeight(0);
    obj.grimorioInv:setVisible(false);

    obj._e_event0 = obj.body:addEventListener("onResize",
        function (_)
            resizeLayout()
        end, obj);

    obj._e_event1 = obj.escudoAp:addEventListener("onClick",
        function (_)
            if (selected == "" or selected == nil) then
                                            selected = self.grimorio.selectedNode
                                            if (selected == nil) then
                                                showMessage("Escudo não encontrado.")
                                            else
                                                self.escudoAp.checked = true
                                                showMessage("Escudo aplicado.")
                                            end
                                        else
                                            self.magicDesc.node = selected
                                            showMessage("Escudo selecionado.")
                                        end
        end, obj);

    obj._e_event2 = obj.button1:addEventListener("onClick",
        function (_)
            selected = ""
                                        self.escudoAp.checked = false
                                        showMessage("Escudo removido.")
        end, obj);

    obj._e_event3 = obj.progressBar1:addEventListener("onClick",
        function (_)
            showMessage("Vigor: " .. sheet.vigor .. "/" .. sheet.vigorMax)
        end, obj);

    obj._e_event4 = obj.button2:addEventListener("onClick",
        function (_)
            Dialogs.confirmOkCancel("Deseja resetar o vigor(".. sheet.vigorMax ..")?",
                                    function (confirmado)
                                        if confirmado then
                                            sheet.vigor = sheet.vigorMax
                                        end
                                    end)
        end, obj);

    obj._e_event5 = obj.image1:addEventListener("onClick",
        function (_)
            sig = tonumber(1)
                                    addSig(sig)
        end, obj);

    obj._e_event6 = obj.image2:addEventListener("onClick",
        function (_)
            sig = tonumber(2)
                                    addSig(sig)
        end, obj);

    obj._e_event7 = obj.image3:addEventListener("onClick",
        function (_)
            sig = tonumber(3)
                                    addSig(sig)
        end, obj);

    obj._e_event8 = obj.image4:addEventListener("onClick",
        function (_)
            sig = tonumber(4)
                                    addSig(sig)
        end, obj);

    obj._e_event9 = obj.image5:addEventListener("onClick",
        function (_)
            sig = tonumber(5)
                                    addSig(sig)
        end, obj);

    obj._e_event10 = obj.image6:addEventListener("onClick",
        function (_)
            sig = tonumber(6)
                                    addSig(sig)
        end, obj);

    obj._e_event11 = obj.image7:addEventListener("onClick",
        function (_)
            sig = tonumber(7)
                                    addSig(sig)
        end, obj);

    obj._e_event12 = obj.image8:addEventListener("onClick",
        function (_)
            sig = tonumber(8)
                                    addSig(sig)
        end, obj);

    obj._e_event13 = obj.btn1:addEventListener("onClick",
        function (_)
            btnNum = 1
                                        removeSig(btnNum)
        end, obj);

    obj._e_event14 = obj.btn2:addEventListener("onClick",
        function (_)
            btnNum = 2
                                        removeSig(btnNum)
        end, obj);

    obj._e_event15 = obj.btn3:addEventListener("onClick",
        function (_)
            btnNum = 3
                                        removeSig(btnNum)
        end, obj);

    obj._e_event16 = obj.btn4:addEventListener("onClick",
        function (_)
            btnNum = 4
                                        removeSig(btnNum)
        end, obj);

    obj._e_event17 = obj.btn5:addEventListener("onClick",
        function (_)
            btnNum = 5
                                        removeSig(btnNum)
        end, obj);

    obj._e_event18 = obj.button3:addEventListener("onClick",
        function (_)
            btns = {self.btn1, self.btn2, self.btn3, self.btn4, self.btn5}
                            sequencia = ""
                            for i=1, 5, 1 do
                                if getSigno(btns[i].src) == nil then
                                    break
                                end
                                if i ~= 1 then
                                    sequencia = sequencia .. " "
                                end
                                sequencia = sequencia .. getSigno(btns[i].src)
                            end
                            if sequencia == "" then
                                showMessage("Nenhum Signo na magia.")
                            else
                                -- Verifica se sequencia ja existe
                                magics = NDB.getChildNodes(sheet.magics)
                                flag = true
                                for i=1, #magics, 1 do
                                    if magics[i].sequencia == sequencia then
                                        flag = false
                                        break
                                    end
                                end
                                if flag then
                                    -- Adiciona magia
                                    node = self.grimorio:append()
                                    node.sequencia = sequencia
                                    sequencia = split(sequencia, " ")
                                    -- Adiciona imagens
                                    if sequencia[1] ~= nil then
                                        node.signo1 = "/Ficha/images/signos/" .. sequencia[1] .. ".png"
                                    end
                                    if sequencia[2] ~= nil then
                                        node.signo2 = "/Ficha/images/signos/" .. sequencia[2] .. ".png"
                                    end
                                    if sequencia[3] ~= nil then
                                        node.signo3 = "/Ficha/images/signos/" .. sequencia[3] .. ".png"
                                    end
                                    if sequencia[4] ~= nil then
                                        node.signo4 = "/Ficha/images/signos/" .. sequencia[4] .. ".png"
                                    end
                                    if sequencia[5] ~= nil then
                                        node.signo5 = "/Ficha/images/signos/" .. sequencia[5] .. ".png"
                                    end
                                    self.grimorio:sort()
                                else
                                    showMessage("Mágica já escrita no Grimório.")
                                end
                            end
        end, obj);

    obj._e_event19 = obj.button4:addEventListener("onClick",
        function (_)
            Dialogs.choose("Escolha o Signo.", {"1 - Calor","2 - Disrupção","3 - Engano","4 - Equilíbrio","5 - Força","6 - Imaterial","7 - Material","8 - Proteção"},
                                function(selected, selectedIndex, selectedText)
                                    if selected == false then 
                                        showMessage("Operação cancelada.")
                                    else
                                        sig = selectedIndex
                                        Dialogs.choose("Escolha o Level.", {"0","1","2","3","4","5","6"},
                                            function(selected2, selectedIndex2, selectedText2)
                                                if selected2 == false then 
                                                    showMessage("Operação cancelada.")
                                                else
                                                    level = selectedIndex2
                                                    qnts = {4, 3, 5, 7, 9, 11, 100}
                                                    choises = {}
                                                    for i=0, qnts[level]-1, 1 do
                                                        table.insert(choises, "" .. i)
                                                    end
                                                    Dialogs.choose("Escolha a quantidade de XP.", choises,
                                                        function(selected3, selectedIndex3, selectedText3)
                                                            if selected3 == false then 
                                                                showMessage("Operação cancelada.")
                                                            else
                                                                text = selectedText2 .. ": " .. selectedText3 .. "/" .. qnts[level]
                                                                altLevel(sig, text)
                                                            end
                                                        end
                                                    )
                                                end
                                            end
                                        )
                                    end
                                end
                            )
        end, obj);

    obj._e_event20 = obj.button5:addEventListener("onClick",
        function (_)
            node = self.grimorio.selectedNode
                                                            if node ~= nil then
                                                                trySpell()
                                                            end
        end, obj);

    obj._e_event21 = obj.button6:addEventListener("onClick",
        function (_)
            node = self.grimorio.selectedNode
                                                            if node ~= nil then
                                                                if node.rolagem ~= nil then
                                                                    revealResult(node.rolagem)
                                                                    node.rolagem = nil
                                                                else
                                                                    showMessage("Nenhuma magia preparada.")
                                                                end
                                                            end
        end, obj);

    obj._e_event22 = obj.button7:addEventListener("onClick",
        function (_)
            copyAll()
        end, obj);

    obj._e_event23 = obj.button8:addEventListener("onClick",
        function (_)
            pasteAll()
                                    self.grimorio:sort()
        end, obj);

    obj._e_event24 = obj.grimorio:addEventListener("onSelect",
        function (_)
            node = self.grimorio.selectedNode
                                    self.magicDesc.node = node
        end, obj);

    obj._e_event25 = obj.grimorio:addEventListener("onCompare",
        function (_, nodeA, nodeB)
            a = nodeA.sequencia or ""
                                    b = nodeB.sequencia or ""
                                    --return sortSig(a, b)
        end, obj);

    function obj:_releaseEvents()
        __o_rrpgObjs.removeEventListenerById(self._e_event25);
        __o_rrpgObjs.removeEventListenerById(self._e_event24);
        __o_rrpgObjs.removeEventListenerById(self._e_event23);
        __o_rrpgObjs.removeEventListenerById(self._e_event22);
        __o_rrpgObjs.removeEventListenerById(self._e_event21);
        __o_rrpgObjs.removeEventListenerById(self._e_event20);
        __o_rrpgObjs.removeEventListenerById(self._e_event19);
        __o_rrpgObjs.removeEventListenerById(self._e_event18);
        __o_rrpgObjs.removeEventListenerById(self._e_event17);
        __o_rrpgObjs.removeEventListenerById(self._e_event16);
        __o_rrpgObjs.removeEventListenerById(self._e_event15);
        __o_rrpgObjs.removeEventListenerById(self._e_event14);
        __o_rrpgObjs.removeEventListenerById(self._e_event13);
        __o_rrpgObjs.removeEventListenerById(self._e_event12);
        __o_rrpgObjs.removeEventListenerById(self._e_event11);
        __o_rrpgObjs.removeEventListenerById(self._e_event10);
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

        if self.Functions_Edit ~= nil then self.Functions_Edit:destroy(); self.Functions_Edit = nil; end;
        if self.button4 ~= nil then self.button4:destroy(); self.button4 = nil; end;
        if self.button3 ~= nil then self.button3:destroy(); self.button3 = nil; end;
        if self.label1 ~= nil then self.label1:destroy(); self.label1 = nil; end;
        if self.layout4 ~= nil then self.layout4:destroy(); self.layout4 = nil; end;
        if self.layout15 ~= nil then self.layout15:destroy(); self.layout15 = nil; end;
        if self.layout10 ~= nil then self.layout10:destroy(); self.layout10 = nil; end;
        if self.image3 ~= nil then self.image3:destroy(); self.image3 = nil; end;
        if self.Functions_Roll ~= nil then self.Functions_Roll:destroy(); self.Functions_Roll = nil; end;
        if self.button7 ~= nil then self.button7:destroy(); self.button7 = nil; end;
        if self.image8 ~= nil then self.image8:destroy(); self.image8 = nil; end;
        if self.flowLayout3 ~= nil then self.flowLayout3:destroy(); self.flowLayout3 = nil; end;
        if self.image5 ~= nil then self.image5:destroy(); self.image5 = nil; end;
        if self.flowLayout4 ~= nil then self.flowLayout4:destroy(); self.flowLayout4 = nil; end;
        if self.image7 ~= nil then self.image7:destroy(); self.image7 = nil; end;
        if self.layout5 ~= nil then self.layout5:destroy(); self.layout5 = nil; end;
        if self.layout17 ~= nil then self.layout17:destroy(); self.layout17 = nil; end;
        if self.layout20 ~= nil then self.layout20:destroy(); self.layout20 = nil; end;
        if self.flowLayout1 ~= nil then self.flowLayout1:destroy(); self.flowLayout1 = nil; end;
        if self.layout18 ~= nil then self.layout18:destroy(); self.layout18 = nil; end;
        if self.btn2 ~= nil then self.btn2:destroy(); self.btn2 = nil; end;
        if self.button6 ~= nil then self.button6:destroy(); self.button6 = nil; end;
        if self.rectangle2 ~= nil then self.rectangle2:destroy(); self.rectangle2 = nil; end;
        if self.rectangle3 ~= nil then self.rectangle3:destroy(); self.rectangle3 = nil; end;
        if self.rectangle6 ~= nil then self.rectangle6:destroy(); self.rectangle6 = nil; end;
        if self.button5 ~= nil then self.button5:destroy(); self.button5 = nil; end;
        if self.button2 ~= nil then self.button2:destroy(); self.button2 = nil; end;
        if self.image2 ~= nil then self.image2:destroy(); self.image2 = nil; end;
        if self.layout13 ~= nil then self.layout13:destroy(); self.layout13 = nil; end;
        if self.layout3 ~= nil then self.layout3:destroy(); self.layout3 = nil; end;
        if self.flowLayout2 ~= nil then self.flowLayout2:destroy(); self.flowLayout2 = nil; end;
        if self.layout8 ~= nil then self.layout8:destroy(); self.layout8 = nil; end;
        if self.layout1 ~= nil then self.layout1:destroy(); self.layout1 = nil; end;
        if self.image6 ~= nil then self.image6:destroy(); self.image6 = nil; end;
        if self.rectangle1 ~= nil then self.rectangle1:destroy(); self.rectangle1 = nil; end;
        if self.label10 ~= nil then self.label10:destroy(); self.label10 = nil; end;
        if self.layout2 ~= nil then self.layout2:destroy(); self.layout2 = nil; end;
        if self.layout23 ~= nil then self.layout23:destroy(); self.layout23 = nil; end;
        if self.grimorio ~= nil then self.grimorio:destroy(); self.grimorio = nil; end;
        if self.rectangle5 ~= nil then self.rectangle5:destroy(); self.rectangle5 = nil; end;
        if self.layout12 ~= nil then self.layout12:destroy(); self.layout12 = nil; end;
        if self.btn4 ~= nil then self.btn4:destroy(); self.btn4 = nil; end;
        if self.button1 ~= nil then self.button1:destroy(); self.button1 = nil; end;
        if self.adminTab ~= nil then self.adminTab:destroy(); self.adminTab = nil; end;
        if self.label8 ~= nil then self.label8:destroy(); self.label8 = nil; end;
        if self.layout11 ~= nil then self.layout11:destroy(); self.layout11 = nil; end;
        if self.label11 ~= nil then self.label11:destroy(); self.label11 = nil; end;
        if self.label3 ~= nil then self.label3:destroy(); self.label3 = nil; end;
        if self.label4 ~= nil then self.label4:destroy(); self.label4 = nil; end;
        if self.layout9 ~= nil then self.layout9:destroy(); self.layout9 = nil; end;
        if self.image1 ~= nil then self.image1:destroy(); self.image1 = nil; end;
        if self.label6 ~= nil then self.label6:destroy(); self.label6 = nil; end;
        if self.textEditor1 ~= nil then self.textEditor1:destroy(); self.textEditor1 = nil; end;
        if self.btn1 ~= nil then self.btn1:destroy(); self.btn1 = nil; end;
        if self.escudoAp ~= nil then self.escudoAp:destroy(); self.escudoAp = nil; end;
        if self.body ~= nil then self.body:destroy(); self.body = nil; end;
        if self.label7 ~= nil then self.label7:destroy(); self.label7 = nil; end;
        if self.button8 ~= nil then self.button8:destroy(); self.button8 = nil; end;
        if self.label2 ~= nil then self.label2:destroy(); self.label2 = nil; end;
        if self.edit3 ~= nil then self.edit3:destroy(); self.edit3 = nil; end;
        if self.layout6 ~= nil then self.layout6:destroy(); self.layout6 = nil; end;
        if self.label5 ~= nil then self.label5:destroy(); self.label5 = nil; end;
        if self.label12 ~= nil then self.label12:destroy(); self.label12 = nil; end;
        if self.rectangle4 ~= nil then self.rectangle4:destroy(); self.rectangle4 = nil; end;
        if self.progressBar1 ~= nil then self.progressBar1:destroy(); self.progressBar1 = nil; end;
        if self.btn3 ~= nil then self.btn3:destroy(); self.btn3 = nil; end;
        if self.magicDesc ~= nil then self.magicDesc:destroy(); self.magicDesc = nil; end;
        if self.layout14 ~= nil then self.layout14:destroy(); self.layout14 = nil; end;
        if self.image4 ~= nil then self.image4:destroy(); self.image4 = nil; end;
        if self.layout16 ~= nil then self.layout16:destroy(); self.layout16 = nil; end;
        if self.layout21 ~= nil then self.layout21:destroy(); self.layout21 = nil; end;
        if self.layout22 ~= nil then self.layout22:destroy(); self.layout22 = nil; end;
        if self.grimorioInv ~= nil then self.grimorioInv:destroy(); self.grimorioInv = nil; end;
        if self.btn5 ~= nil then self.btn5:destroy(); self.btn5 = nil; end;
        if self.Functions ~= nil then self.Functions:destroy(); self.Functions = nil; end;
        if self.edit2 ~= nil then self.edit2:destroy(); self.edit2 = nil; end;
        if self.label9 ~= nil then self.label9:destroy(); self.label9 = nil; end;
        if self.layout19 ~= nil then self.layout19:destroy(); self.layout19 = nil; end;
        if self.checkBox1 ~= nil then self.checkBox1:destroy(); self.checkBox1 = nil; end;
        if self.scrollBox1 ~= nil then self.scrollBox1:destroy(); self.scrollBox1 = nil; end;
        if self.edit1 ~= nil then self.edit1:destroy(); self.edit1 = nil; end;
        if self.layout7 ~= nil then self.layout7:destroy(); self.layout7 = nil; end;
        self:_oldLFMDestroy();
    end;

    obj:endUpdate();

    return obj;
end;

function newGrimorio()
    local retObj = nil;
    __o_rrpgObjs.beginObjectsLoading();

    __o_Utils.tryFinally(
      function()
        retObj = constructNew_Grimorio();
      end,
      function()
        __o_rrpgObjs.endObjectsLoading();
      end);

    assert(retObj ~= nil);
    return retObj;
end;

local _Grimorio = {
    newEditor = newGrimorio, 
    new = newGrimorio, 
    name = "Grimorio", 
    dataType = "", 
    formType = "undefined", 
    formComponentName = "form", 
    title = "", 
    description=""};

Grimorio = _Grimorio;
Firecast.registrarForm(_Grimorio);

return _Grimorio;
