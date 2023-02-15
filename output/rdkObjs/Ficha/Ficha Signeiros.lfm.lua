require("firecast.lua");
local __o_rrpgObjs = require("rrpgObjs.lua");
require("rrpgGUI.lua");
require("rrpgDialogs.lua");
require("rrpgLFM.lua");
require("ndb.lua");
require("locale.lua");
local __o_Utils = require("utils.lua");

local function constructNew_Ficha_Signeiros()
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
    obj:setName("Ficha_Signeiros");
    obj:setFormType("sheetTemplate");
    obj:setDataType("Signeiros.Ficha");
    obj:setTitle("Ficha Signeiros");
    obj:setAlign("client");
    obj:setTheme("dark");

    obj.tabControl1 = GUI.fromHandle(_obj_newObject("tabControl"));
    obj.tabControl1:setParent(obj);
    obj.tabControl1:setAlign("client");
    obj.tabControl1:setName("tabControl1");

    obj.tab1 = GUI.fromHandle(_obj_newObject("tab"));
    obj.tab1:setParent(obj.tabControl1);
    obj.tab1:setTitle("Info Personagem");
    obj.tab1:setName("tab1");

    obj.Info = GUI.fromHandle(_obj_newObject("form"));
    obj.Info:setParent(obj.tab1);
    obj.Info:setName("Info");
    obj.Info:setAlign("client");
    obj.Info:setTheme("dark");
    obj.Info:setMargins({top=1});

    obj.flowLayout1 = GUI.fromHandle(_obj_newObject("flowLayout"));
    obj.flowLayout1:setParent(obj.Info);
    obj.flowLayout1:setAlign("top");
    obj.flowLayout1:setOrientation("horizontal");
    obj.flowLayout1:setHorzAlign("justify");
    obj.flowLayout1:setMargins({left=20, top=20, bottom=20, right=20});
    obj.flowLayout1:setAutoHeight(true);
    obj.flowLayout1:setLineSpacing(5.0);
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

    obj.richEdit1 = GUI.fromHandle(_obj_newObject("richEdit"));
    obj.richEdit1:setParent(obj.Info);
    obj.richEdit1:setAlign("client");
    obj.richEdit1:setField("historia");
    obj.richEdit1:setName("richEdit1");

    obj.tab2 = GUI.fromHandle(_obj_newObject("tab"));
    obj.tab2:setParent(obj.tabControl1);
    obj.tab2:setTitle("Grimório");
    obj.tab2:setName("tab2");

    obj.Grimorio = GUI.fromHandle(_obj_newObject("form"));
    obj.Grimorio:setParent(obj.tab2);
    obj.Grimorio:setName("Grimorio");
    obj.Grimorio:setAlign("client");
    obj.Grimorio:setTheme("dark");
    obj.Grimorio:setMargins({top=1});

    obj.Functions = GUI.fromHandle(_obj_newObject("form"));
    obj.Functions:setParent(obj.Grimorio);
    obj.Functions:setName("Functions");
    obj.Functions:setAlign("client");
    obj.Functions:setTheme("dark");
    obj.Functions:setMargins({top=1});


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
    


    obj.Functions_Roll = GUI.fromHandle(_obj_newObject("form"));
    obj.Functions_Roll:setParent(obj.Grimorio);
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
            return splitEmojis(node.sequencia)
        end
        function getLevel(magic)
            textSig = getText(magic)
            level = split(textSig, ":")
            return tonumber(level[1])
        end
        function hasLevel()
            sequencia = getSequencia()
            for i=1, #sequencia, 1 do
                if #sequencia > getLevel(icons[sequencia[i]]) then
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
                        flag = addXP(1, icons[sequencia[index]])
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
        function generateMsg(strRolagem, node)
            rolagem = Firecast.interpretarRolagem(strRolagem)
            rolagem:rolarLocalmente()
            resultsStr, resultInt = valuesRolls(rolagem.ops)
            dano = node.dano or 0
            dmg = calUnidades(tonumber(dano), resultInt)
            msg = node.sequencia .. ": " .. (node.nomeMagia or "Sem Nome") .. "\n"..
                    "Dados(".. strRolagem .."): ".. resultsStr .. " = " .. rolagem.resultado .. "(".. round(resultInt) ..")" .. "\n" ..
                    "Dano(".. (dano) .."): ".. dmg .."\n" ..
                    "Unidades: " .. generateUnidades(node.unidades, resultInt)
            return msg, rolagem
        end
        function hasPreparedMagic()
            nodes = NDB.getChildNodes(sheet.magics)
            for i=1, #nodes, 1 do
                if nodes[i].rolagem ~= nil then
                    return nodes[i]
                end
            end
            return nil
        end
        function revealResult()
            node = hasPreparedMagic()
            if node ~= nil then
                sequencia = splitEmojis(node.sequencia)
            else
                showMessage("Nenhuma magia preparada.")
                return
            end
            qnt = #sequencia
            msg, rolagem = generateMsg(node.rolagem, node)
            node.rolagem = nil
            mesaDoPersonagem = Firecast.getMesaDe(sheet)
            if qnt == 1 and getLevel(icons[sequencia[1]]) == 0 then
                item = rolagem.ops[1]
                if item.resultados[1] ~= item.face then
                    mesaDoPersonagem.chat:enviarMensagem("Magia:" .. node.sequencia .. " falhou. Resultado: " .. item.resultados[1])
                else
                    mesaDoPersonagem.chat:enviarMensagem(msg)
                end
            else
                mesaDoPersonagem.chat:enviarMensagem(msg)
            end
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
                level = getLevel(icons[sequencia[i]]) + 1
                strRolagem = strRolagem .. dices[level]
            end
            return strRolagem
        end
        function roll()
            strRolagem = generateRoll()
            node = self.grimorio.selectedNode
            if node.modoUltraSecreto == true then
                msg, rolagem = generateMsg(strRolagem, node)
                node.rolagemUltraSecreta = msg
                return
            end
            if node.modoSecreto == false or node.modoSecreto == nil then
                node.rolagem = strRolagem
                revealResult(strRolagem)
            else
                node.rolagem = strRolagem
                mesaDoPersonagem = Firecast.getMesaDe(sheet)
                mesaDoPersonagem.chat:enviarMensagem("Magia preparada: " .. node.sequencia)
                showMessage("Rolagem preparada.")
            end
        end
        function trySpell()
            if hasPreparedMagic() ~= nil then
                showMessage("Você já possui uma magia preparada, use-a antes.")
                return
            end
            sequencia = getSequencia()
            qnt = #sequencia
            if hasVigor(qnt) == false then
                showMessage("Vigor não suficiente para executar a magia.")
                return
            end
            if qnt == 1 and getLevel(icons[sequencia[1]]) == 0 then
                roll()
                return
            end
            if hasLevel() == false then
                showMessage("Você não possui level nos Signos necessário para executar a magia.")
                return
            end
            roll()
        end
    


    obj.Functions_Edit = GUI.fromHandle(_obj_newObject("form"));
    obj.Functions_Edit:setParent(obj.Grimorio);
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
    



        function orderSig(a, b)
            return icons[b] > icons[a]
        end
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
                    if nodo.vis == "false" then
                        NDB.setPermission(nodo, "group", "jogadores", "read", "deny")
                        NDB.setPermission(nodo, "group", "espectadores", "read", "deny")
                    end
                    NDB.deleteNode(magicsInv[i])
                end
            else
                sequencia = {}
                -- Criação da sequencia
                for i=1, #btns, 1 do
                    if btns[i].text == "" then
                        break
                    else
                        table.insert(sequencia, btns[i].text)
                    end
                end
                -- Ordenar e juntar
                table.sort(sequencia, orderSig)
                sequencia = table.concat(sequencia, "")
                -- Limitar lista de acordo com os signos selecionados - Grimório para Lista invisivel
                if addMode then
                    for i=1, #magics, 1 do
                        if string.find(magics[i].sequencia, sequencia) == nil then
                            nodo = self.grimorioInv:append()
                            NDB.setPermission(magics[i], "group", "jogadores", "read", nil)
                            NDB.setPermission(magics[i], "group", "espectadores", "read", nil)
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
                            if magicsInv[i].vis == "false" then
                                NDB.setPermission(nodo, "group", "jogadores", "read", "deny")
                                NDB.setPermission(nodo, "group", "espectadores", "read", "deny")
                            end
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
                btns[1].text = sig
            else
                -- Cria sequencia
                for i=1, #btns, 1 do
                    if btns[i].text == "" then
                        break
                    else
                        table.insert(sequencia, btns[i].text)
                    end
                end
                table.sort(sequencia, orderSig)
                -- Integra imagens nos botões corretos
                if 5 >= #sequencia then
                    for i=1, #sequencia, 1 do
                        btns[i].text = sequencia[i]
                    end
                end
            end
            if 6 > #sequencia then 
                searchList(true)
            end
        end
        function removeSig(btnNum)
            btns = {self.btn1, self.btn2, self.btn3, self.btn4, self.btn5}
            btns[btnNum].text = ""
            sequencia = {}
            -- Criação da sequencia
            for i=1, #btns, 1 do
                if btns[i].text ~= "" then
                    table.insert(sequencia, btns[i].text)
                end
            end
            table.sort(sequencia, orderSig)
            -- Integra emojis nos botões corretos
            if 5 >= #sequencia then
                for i=1, 5, 1 do
                    btns[i].text = sequencia[i]
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
        function popupShow(text)
            self.popupText.text = text
            self.popupMsg:show()
        end
    


    obj.popupMsg = GUI.fromHandle(_obj_newObject("popup"));
    obj.popupMsg:setParent(obj.Grimorio);
    obj.popupMsg:setName("popupMsg");
    obj.popupMsg:setWidth(300);
    obj.popupMsg:setHeight(200);
    obj.popupMsg:setBackOpacity(0.5);

    obj.popupText = GUI.fromHandle(_obj_newObject("label"));
    obj.popupText:setParent(obj.popupMsg);
    obj.popupText:setAlign("client");
    obj.popupText:setHorzTextAlign("center");
    obj.popupText:setText("Teste");
    obj.popupText:setName("popupText");
    obj.popupText:setAutoSize(true);
    obj.popupText:setFontSize(20);

    obj.edit14 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit14:setParent(obj.Grimorio);
    obj.edit14:setField("admPermission");
    obj.edit14:setVisible(false);
    obj.edit14:setWidth(0);
    obj.edit14:setHeight(0);
    obj.edit14:setName("edit14");

    obj.body = GUI.fromHandle(_obj_newObject("scrollBox"));
    obj.body:setParent(obj.Grimorio);
    obj.body:setAlign("client");
    obj.body:setMargins({left=5, top=5, bottom=5, right=5});
    obj.body:setName("body");

    obj.label15 = GUI.fromHandle(_obj_newObject("label"));
    obj.label15:setParent(obj.body);
    obj.label15:setAlign("top");
    obj.label15:setWidth(0);
    obj.label15:setText("");
    obj.label15:setName("label15");

    obj.flowLayout2 = GUI.fromHandle(_obj_newObject("flowLayout"));
    obj.flowLayout2:setParent(obj.body);
    obj.flowLayout2:setAlign("top");
    obj.flowLayout2:setOrientation("horizontal");
    obj.flowLayout2:setHorzAlign("justify");
    obj.flowLayout2:setAutoHeight(true);
    obj.flowLayout2:setName("flowLayout2");

    obj.layout1 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout1:setParent(obj.flowLayout2);
    obj.layout1:setWidth(800);
    obj.layout1:setHeight(800);
    obj.layout1:setMargins({left = 5, right = 5, top = 5, bottom = 5});
    obj.layout1:setName("layout1");

    obj.flowLayout3 = GUI.fromHandle(_obj_newObject("flowLayout"));
    obj.flowLayout3:setParent(obj.layout1);
    obj.flowLayout3:setAlign("top");
    obj.flowLayout3:setWidth(150);
    obj.flowLayout3:setHorzAlign("center");
    obj.flowLayout3:setAutoHeight(true);
    obj.flowLayout3:setName("flowLayout3");

    obj.layout2 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout2:setParent(obj.flowLayout3);
    obj.layout2:setWidth(150);
    obj.layout2:setHeight(150);
    obj.layout2:setName("layout2");

    obj.escudoAp = GUI.fromHandle(_obj_newObject("imageCheckBox"));
    obj.escudoAp:setParent(obj.layout2);
    obj.escudoAp:setAlign("top");
    obj.escudoAp:setName("escudoAp");
    obj.escudoAp:setWidth(100);
    obj.escudoAp:setHeight(100);
    obj.escudoAp:setField("selected");
    obj.escudoAp:setImageChecked("/Ficha/images/ShieldOn.png");
    obj.escudoAp:setImageUnchecked("/Ficha/images/ShieldOff.png");
    obj.escudoAp:setAutoChange(false);

    obj.button2 = GUI.fromHandle(_obj_newObject("button"));
    obj.button2:setParent(obj.layout2);
    obj.button2:setAlign("top");
    obj.button2:setText("Remover escudo");
    obj.button2:setWidth(150);
    obj.button2:setName("button2");

    obj.flowLayout4 = GUI.fromHandle(_obj_newObject("flowLayout"));
    obj.flowLayout4:setParent(obj.layout1);
    obj.flowLayout4:setAlign("top");
    obj.flowLayout4:setHeight(25);
    obj.flowLayout4:setMargins({left = 5, right = 5, top = 5, bottom = 5});
    obj.flowLayout4:setHorzAlign("center");
    obj.flowLayout4:setName("flowLayout4");

    obj.progressBar1 = GUI.fromHandle(_obj_newObject("progressBar"));
    obj.progressBar1:setParent(obj.flowLayout4);
    obj.progressBar1:setColor("yellow");
    obj.progressBar1:setWidth(600);
    obj.progressBar1:setFieldMax("vigorMax");
    obj.progressBar1:setField("vigor");
    obj.progressBar1:setHitTest(true);
    obj.progressBar1:setName("progressBar1");

    obj.button3 = GUI.fromHandle(_obj_newObject("button"));
    obj.button3:setParent(obj.flowLayout4);
    obj.button3:setText("Restaurar Vigor");
    obj.button3:setWidth(100);
    obj.button3:setMargins({left=10});
    obj.button3:setName("button3");

    obj.layout3 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout3:setParent(obj.layout1);
    obj.layout3:setAlign("top");
    obj.layout3:setHeight(300);
    obj.layout3:setMargins({left = 5, right = 5, top = 5, bottom = 5});
    obj.layout3:setName("layout3");

    obj.flowLayout5 = GUI.fromHandle(_obj_newObject("flowLayout"));
    obj.flowLayout5:setParent(obj.layout3);
    obj.flowLayout5:setAlign("top");
    obj.flowLayout5:setWidth(850);
    obj.flowLayout5:setHeight(85);
    obj.flowLayout5:setHorzAlign("center");
    obj.flowLayout5:setName("flowLayout5");

    obj.layout4 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout4:setParent(obj.flowLayout5);
    obj.layout4:setWidth(70);
    obj.layout4:setHeight(85);
    obj.layout4:setMargins({left=5});
    obj.layout4:setName("layout4");

    obj.button4 = GUI.fromHandle(_obj_newObject("button"));
    obj.button4:setParent(obj.layout4);
    obj.button4:setAlign("top");
    obj.button4:setText("🔥");
    obj.button4:setHeight(60);
    obj.button4:setHint("Calor");
    obj.button4:setFontSize(30);
    obj.button4:setName("button4");

    obj.label16 = GUI.fromHandle(_obj_newObject("label"));
    obj.label16:setParent(obj.layout4);
    obj.label16:setAlign("top");
    obj.label16:setHeight(25);
    obj.label16:setField("level1");
    obj.label16:setHorzTextAlign("center");
    obj.label16:setHitTest(true);
    obj.label16:setHint("Level: XP Atual/XP Upar");
    obj.label16:setName("label16");

    obj.layout5 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout5:setParent(obj.flowLayout5);
    obj.layout5:setWidth(70);
    obj.layout5:setHeight(85);
    obj.layout5:setMargins({left=5});
    obj.layout5:setName("layout5");

    obj.button5 = GUI.fromHandle(_obj_newObject("button"));
    obj.button5:setParent(obj.layout5);
    obj.button5:setAlign("top");
    obj.button5:setText("⚡");
    obj.button5:setHeight(60);
    obj.button5:setHint("Disrupção");
    obj.button5:setFontSize(30);
    obj.button5:setName("button5");

    obj.label17 = GUI.fromHandle(_obj_newObject("label"));
    obj.label17:setParent(obj.layout5);
    obj.label17:setAlign("top");
    obj.label17:setHeight(25);
    obj.label17:setField("level2");
    obj.label17:setHorzTextAlign("center");
    obj.label17:setHitTest(true);
    obj.label17:setHint("Level: XP Atual/XP Upar");
    obj.label17:setName("label17");

    obj.layout6 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout6:setParent(obj.flowLayout5);
    obj.layout6:setWidth(70);
    obj.layout6:setHeight(85);
    obj.layout6:setMargins({left=5});
    obj.layout6:setName("layout6");

    obj.button6 = GUI.fromHandle(_obj_newObject("button"));
    obj.button6:setParent(obj.layout6);
    obj.button6:setAlign("top");
    obj.button6:setText("🎲");
    obj.button6:setHeight(60);
    obj.button6:setHint("Engano");
    obj.button6:setFontSize(30);
    obj.button6:setName("button6");

    obj.label18 = GUI.fromHandle(_obj_newObject("label"));
    obj.label18:setParent(obj.layout6);
    obj.label18:setAlign("top");
    obj.label18:setHeight(25);
    obj.label18:setField("level3");
    obj.label18:setHorzTextAlign("center");
    obj.label18:setHitTest(true);
    obj.label18:setHint("Level: XP Atual/XP Upar");
    obj.label18:setName("label18");

    obj.layout7 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout7:setParent(obj.flowLayout5);
    obj.layout7:setWidth(70);
    obj.layout7:setHeight(85);
    obj.layout7:setMargins({left=5});
    obj.layout7:setName("layout7");

    obj.button7 = GUI.fromHandle(_obj_newObject("button"));
    obj.button7:setParent(obj.layout7);
    obj.button7:setAlign("top");
    obj.button7:setText("🌓");
    obj.button7:setHeight(60);
    obj.button7:setHint("Equilíbrio");
    obj.button7:setFontSize(30);
    obj.button7:setName("button7");

    obj.label19 = GUI.fromHandle(_obj_newObject("label"));
    obj.label19:setParent(obj.layout7);
    obj.label19:setAlign("top");
    obj.label19:setHeight(25);
    obj.label19:setField("level4");
    obj.label19:setHorzTextAlign("center");
    obj.label19:setHitTest(true);
    obj.label19:setHint("Level: XP Atual/XP Upar");
    obj.label19:setName("label19");

    obj.layout8 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout8:setParent(obj.flowLayout5);
    obj.layout8:setWidth(70);
    obj.layout8:setHeight(85);
    obj.layout8:setMargins({left=5});
    obj.layout8:setName("layout8");

    obj.button8 = GUI.fromHandle(_obj_newObject("button"));
    obj.button8:setParent(obj.layout8);
    obj.button8:setAlign("top");
    obj.button8:setText("👊");
    obj.button8:setHeight(60);
    obj.button8:setHint("Força");
    obj.button8:setFontSize(30);
    obj.button8:setName("button8");

    obj.label20 = GUI.fromHandle(_obj_newObject("label"));
    obj.label20:setParent(obj.layout8);
    obj.label20:setAlign("top");
    obj.label20:setHeight(25);
    obj.label20:setField("level5");
    obj.label20:setHorzTextAlign("center");
    obj.label20:setHitTest(true);
    obj.label20:setHint("Level: XP Atual/XP Upar");
    obj.label20:setName("label20");

    obj.layout9 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout9:setParent(obj.flowLayout5);
    obj.layout9:setWidth(70);
    obj.layout9:setHeight(85);
    obj.layout9:setMargins({left=5});
    obj.layout9:setName("layout9");

    obj.button9 = GUI.fromHandle(_obj_newObject("button"));
    obj.button9:setParent(obj.layout9);
    obj.button9:setAlign("top");
    obj.button9:setText("💫");
    obj.button9:setHeight(60);
    obj.button9:setHint("Imaterial");
    obj.button9:setFontSize(30);
    obj.button9:setName("button9");

    obj.label21 = GUI.fromHandle(_obj_newObject("label"));
    obj.label21:setParent(obj.layout9);
    obj.label21:setAlign("top");
    obj.label21:setHeight(25);
    obj.label21:setField("level6");
    obj.label21:setHorzTextAlign("center");
    obj.label21:setHitTest(true);
    obj.label21:setHint("Level: XP Atual/XP Upar");
    obj.label21:setName("label21");

    obj.layout10 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout10:setParent(obj.flowLayout5);
    obj.layout10:setWidth(70);
    obj.layout10:setHeight(85);
    obj.layout10:setMargins({left=5});
    obj.layout10:setName("layout10");

    obj.button10 = GUI.fromHandle(_obj_newObject("button"));
    obj.button10:setParent(obj.layout10);
    obj.button10:setAlign("top");
    obj.button10:setText("🎱");
    obj.button10:setHeight(60);
    obj.button10:setHint("Material");
    obj.button10:setFontSize(30);
    obj.button10:setName("button10");

    obj.label22 = GUI.fromHandle(_obj_newObject("label"));
    obj.label22:setParent(obj.layout10);
    obj.label22:setAlign("top");
    obj.label22:setHeight(25);
    obj.label22:setField("level7");
    obj.label22:setHorzTextAlign("center");
    obj.label22:setHitTest(true);
    obj.label22:setHint("Level: XP Atual/XP Upar");
    obj.label22:setName("label22");

    obj.layout11 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout11:setParent(obj.flowLayout5);
    obj.layout11:setWidth(70);
    obj.layout11:setHeight(85);
    obj.layout11:setMargins({left=5});
    obj.layout11:setName("layout11");

    obj.button11 = GUI.fromHandle(_obj_newObject("button"));
    obj.button11:setParent(obj.layout11);
    obj.button11:setAlign("top");
    obj.button11:setText("☔");
    obj.button11:setHeight(60);
    obj.button11:setHint("Proteção");
    obj.button11:setFontSize(30);
    obj.button11:setName("button11");

    obj.label23 = GUI.fromHandle(_obj_newObject("label"));
    obj.label23:setParent(obj.layout11);
    obj.label23:setAlign("top");
    obj.label23:setHeight(25);
    obj.label23:setField("level8");
    obj.label23:setHorzTextAlign("center");
    obj.label23:setHitTest(true);
    obj.label23:setHint("Level: XP Atual/XP Upar");
    obj.label23:setName("label23");

    obj.layout12 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout12:setParent(obj.layout3);
    obj.layout12:setAlign("top");
    obj.layout12:setWidth(850);
    obj.layout12:setHeight(340);
    obj.layout12:setMargins({top=10});
    obj.layout12:setName("layout12");

    obj.flowLayout6 = GUI.fromHandle(_obj_newObject("flowLayout"));
    obj.flowLayout6:setParent(obj.layout12);
    obj.flowLayout6:setAlign("top");
    obj.flowLayout6:setHeight(50);
    obj.flowLayout6:setHorzAlign("center");
    obj.flowLayout6:setName("flowLayout6");

    obj.btn1 = GUI.fromHandle(_obj_newObject("button"));
    obj.btn1:setParent(obj.flowLayout6);
    obj.btn1:setAlign("left");
    obj.btn1:setText("");
    obj.btn1:setWidth(50);
    obj.btn1:setHeight(50);
    obj.btn1:setName("btn1");
    obj.btn1:setMargins({left=5});
    obj.btn1:setFontSize(20);

    obj.btn2 = GUI.fromHandle(_obj_newObject("button"));
    obj.btn2:setParent(obj.flowLayout6);
    obj.btn2:setAlign("left");
    obj.btn2:setText("");
    obj.btn2:setWidth(50);
    obj.btn2:setHeight(50);
    obj.btn2:setName("btn2");
    obj.btn2:setMargins({left=5});
    obj.btn2:setFontSize(20);

    obj.btn3 = GUI.fromHandle(_obj_newObject("button"));
    obj.btn3:setParent(obj.flowLayout6);
    obj.btn3:setAlign("left");
    obj.btn3:setText("");
    obj.btn3:setWidth(50);
    obj.btn3:setHeight(50);
    obj.btn3:setName("btn3");
    obj.btn3:setMargins({left=5});
    obj.btn3:setFontSize(20);

    obj.btn4 = GUI.fromHandle(_obj_newObject("button"));
    obj.btn4:setParent(obj.flowLayout6);
    obj.btn4:setAlign("left");
    obj.btn4:setText("");
    obj.btn4:setWidth(50);
    obj.btn4:setHeight(50);
    obj.btn4:setName("btn4");
    obj.btn4:setMargins({left=5});
    obj.btn4:setFontSize(20);

    obj.btn5 = GUI.fromHandle(_obj_newObject("button"));
    obj.btn5:setParent(obj.flowLayout6);
    obj.btn5:setAlign("left");
    obj.btn5:setText("");
    obj.btn5:setWidth(50);
    obj.btn5:setHeight(50);
    obj.btn5:setName("btn5");
    obj.btn5:setMargins({left=5});
    obj.btn5:setFontSize(20);

    obj.adminTab = GUI.fromHandle(_obj_newObject("flowLayout"));
    obj.adminTab:setParent(obj.layout12);
    obj.adminTab:setAlign("top");
    obj.adminTab:setWidth(850);
    obj.adminTab:setHeight(35);
    obj.adminTab:setMargins({left = 5, right = 5, top = 5, bottom = 5});
    obj.adminTab:setHorzAlign("center");
    obj.adminTab:setName("adminTab");

    obj.button12 = GUI.fromHandle(_obj_newObject("button"));
    obj.button12:setParent(obj.adminTab);
    obj.button12:setWidth(150);
    obj.button12:setText("Adicionar Magia");
    obj.button12:setMargins({top=10});
    obj.button12:setName("button12");

    obj.button13 = GUI.fromHandle(_obj_newObject("button"));
    obj.button13:setParent(obj.adminTab);
    obj.button13:setWidth(150);
    obj.button13:setText("Ajustar Level de magia");
    obj.button13:setMargins({top=10, left=10});
    obj.button13:setName("button13");

    obj.layout13 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout13:setParent(obj.layout1);
    obj.layout13:setAlign("bottom");
    obj.layout13:setHeight(350);
    obj.layout13:setMargins({left = 5, right = 5, top = 5, bottom = 5});
    obj.layout13:setName("layout13");

    obj.magicDesc = GUI.fromHandle(_obj_newObject("dataScopeBox"));
    obj.magicDesc:setParent(obj.layout13);
    obj.magicDesc:setName("magicDesc");
    obj.magicDesc:setAlign("client");

    obj.rectangle1 = GUI.fromHandle(_obj_newObject("rectangle"));
    obj.rectangle1:setParent(obj.magicDesc);
    obj.rectangle1:setAlign("client");
    obj.rectangle1:setColor("black");
    obj.rectangle1:setXradius(10);
    obj.rectangle1:setYradius(10);
    obj.rectangle1:setPadding({top=5, left=5, right=5, bottom=5});
    obj.rectangle1:setName("rectangle1");

    obj.layout14 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout14:setParent(obj.rectangle1);
    obj.layout14:setAlign("top");
    obj.layout14:setHeight(135);
    obj.layout14:setName("layout14");

    obj.layout15 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout15:setParent(obj.layout14);
    obj.layout15:setAlign("left");
    obj.layout15:setWidth(600);
    obj.layout15:setName("layout15");

    obj.layout16 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout16:setParent(obj.layout15);
    obj.layout16:setAlign("top");
    obj.layout16:setHeight(25);
    obj.layout16:setMargins({top = 5});
    obj.layout16:setName("layout16");

    obj.label24 = GUI.fromHandle(_obj_newObject("label"));
    obj.label24:setParent(obj.layout16);
    obj.label24:setAlign("left");
    obj.label24:setText("Dano");
    obj.label24:setMargins({left = 5});
    obj.label24:setName("label24");

    obj.edit15 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit15:setParent(obj.layout16);
    obj.edit15:setAlign("left");
    obj.edit15:setWidth(50);
    obj.edit15:setField("dano");
    obj.edit15:setType("number");
    obj.edit15:setMin(0);
    obj.edit15:setMax(5);
    obj.edit15:setName("edit15");

    obj.layout17 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout17:setParent(obj.layout15);
    obj.layout17:setAlign("top");
    obj.layout17:setHeight(25);
    obj.layout17:setMargins({top = 5});
    obj.layout17:setName("layout17");

    obj.label25 = GUI.fromHandle(_obj_newObject("label"));
    obj.label25:setParent(obj.layout17);
    obj.label25:setAlign("left");
    obj.label25:setText("Unidade");
    obj.label25:setMargins({left = 5});
    obj.label25:setName("label25");

    obj.edit16 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit16:setParent(obj.layout17);
    obj.edit16:setAlign("left");
    obj.edit16:setWidth(400);
    obj.edit16:setField("unidades");
    obj.edit16:setHint("Nome=Valor,Nome=Valor ou Valor,Valor");
    obj.edit16:setName("edit16");

    obj.layout18 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout18:setParent(obj.layout15);
    obj.layout18:setAlign("top");
    obj.layout18:setHeight(80);
    obj.layout18:setMargins({top = 5});
    obj.layout18:setName("layout18");

    obj.label26 = GUI.fromHandle(_obj_newObject("label"));
    obj.label26:setParent(obj.layout18);
    obj.label26:setAlign("left");
    obj.label26:setHeight(55);
    obj.label26:setText("Ultra Secreto");
    obj.label26:setMargins({left = 5});
    obj.label26:setName("label26");

    obj.textEditor1 = GUI.fromHandle(_obj_newObject("textEditor"));
    obj.textEditor1:setParent(obj.layout18);
    obj.textEditor1:setAlign("left");
    obj.textEditor1:setWidth(400);
    obj.textEditor1:setHeight(55);
    obj.textEditor1:setField("rolagemUltraSecreta");
    obj.textEditor1:setReadOnly(true);
    obj.textEditor1:setName("textEditor1");

    obj.layout19 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout19:setParent(obj.layout14);
    obj.layout19:setAlign("right");
    obj.layout19:setWidth(200);
    obj.layout19:setName("layout19");

    obj.layout20 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout20:setParent(obj.layout19);
    obj.layout20:setAlign("top");
    obj.layout20:setWidth(90);
    obj.layout20:setHeight(25);
    obj.layout20:setMargins({top = 5});
    obj.layout20:setName("layout20");

    obj.button14 = GUI.fromHandle(_obj_newObject("button"));
    obj.button14:setParent(obj.layout20);
    obj.button14:setAlign("left");
    obj.button14:setText("Rolar");
    obj.button14:setWidth(60);
    obj.button14:setMargins({left=10});
    obj.button14:setName("button14");

    obj.checkBox1 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.checkBox1:setParent(obj.layout20);
    obj.checkBox1:setAlign("left");
    obj.checkBox1:setField("modoSecreto");
    obj.checkBox1:setText("Modo Secreto");
    obj.checkBox1:setMargins({left = 5});
    obj.checkBox1:setName("checkBox1");

    obj.layout21 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout21:setParent(obj.layout19);
    obj.layout21:setAlign("top");
    obj.layout21:setWidth(90);
    obj.layout21:setHeight(25);
    obj.layout21:setMargins({top = 5});
    obj.layout21:setName("layout21");

    obj.checkBox2 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.checkBox2:setParent(obj.layout21);
    obj.checkBox2:setAlign("left");
    obj.checkBox2:setField("modoUltraSecreto");
    obj.checkBox2:setText("Modo Ultra Secreto");
    obj.checkBox2:setMargins({left = 10});
    obj.checkBox2:setName("checkBox2");

    obj.layout22 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout22:setParent(obj.layout19);
    obj.layout22:setAlign("top");
    obj.layout22:setWidth(90);
    obj.layout22:setHeight(25);
    obj.layout22:setMargins({top = 5});
    obj.layout22:setName("layout22");

    obj.button15 = GUI.fromHandle(_obj_newObject("button"));
    obj.button15:setParent(obj.layout22);
    obj.button15:setAlign("left");
    obj.button15:setText("Revelar Valores");
    obj.button15:setWidth(180);
    obj.button15:setMargins({left=10});
    obj.button15:setName("button15");

    obj.label27 = GUI.fromHandle(_obj_newObject("label"));
    obj.label27:setParent(obj.rectangle1);
    obj.label27:setAlign("bottom");
    obj.label27:setText("Descrição");
    obj.label27:setMargins({left = 5});
    obj.label27:setName("label27");

    obj.textEditor2 = GUI.fromHandle(_obj_newObject("textEditor"));
    obj.textEditor2:setParent(obj.rectangle1);
    obj.textEditor2:setAlign("bottom");
    obj.textEditor2:setHeight(190);
    obj.textEditor2:setField("desc");
    obj.textEditor2:setMargins({top = 5});
    obj.textEditor2:setName("textEditor2");

    obj.flowLayout7 = GUI.fromHandle(_obj_newObject("flowLayout"));
    obj.flowLayout7:setParent(obj.flowLayout2);
    obj.flowLayout7:setAlign("client");
    obj.flowLayout7:setWidth(1000);
    obj.flowLayout7:setMargins({left = 5, right = 5, top = 5, bottom = 5});
    obj.flowLayout7:setAutoHeight(true);
    obj.flowLayout7:setName("flowLayout7");

    obj.flowPart11 = GUI.fromHandle(_obj_newObject("flowPart"));
    obj.flowPart11:setParent(obj.flowLayout7);
    obj.flowPart11:setMinWidth(500);
    obj.flowPart11:setMaxWidth(3000);
    obj.flowPart11:setHeight(30);
    obj.flowPart11:setName("flowPart11");

    obj.label28 = GUI.fromHandle(_obj_newObject("label"));
    obj.label28:setParent(obj.flowPart11);
    obj.label28:setAlign("left");
    obj.label28:setText("Grimório");
    obj.label28:setWidth(100);
    obj.label28:setHeight(25);
    lfm_setPropAsString(obj.label28, "fontStyle",  "bold");
    obj.label28:setName("label28");

    obj.button16 = GUI.fromHandle(_obj_newObject("button"));
    obj.button16:setParent(obj.flowPart11);
    obj.button16:setAlign("left");
    obj.button16:setLeft(10);
    obj.button16:setText("Copiar Grimório");
    obj.button16:setWidth(150);
    obj.button16:setHeight(25);
    obj.button16:setMargins({left = 10});
    obj.button16:setName("button16");

    obj.button17 = GUI.fromHandle(_obj_newObject("button"));
    obj.button17:setParent(obj.flowPart11);
    obj.button17:setAlign("left");
    obj.button17:setLeft(10);
    obj.button17:setText("Colar no Grimório");
    obj.button17:setWidth(150);
    obj.button17:setHeight(25);
    obj.button17:setMargins({left = 10});
    obj.button17:setName("button17");

    obj.flowLineBreak3 = GUI.fromHandle(_obj_newObject("flowLineBreak"));
    obj.flowLineBreak3:setParent(obj.flowLayout7);
    obj.flowLineBreak3:setName("flowLineBreak3");

    obj.flowPart12 = GUI.fromHandle(_obj_newObject("flowPart"));
    obj.flowPart12:setParent(obj.flowLayout7);
    obj.flowPart12:setMinWidth(500);
    obj.flowPart12:setMaxWidth(3000);
    obj.flowPart12:setHeight(755);
    obj.flowPart12:setName("flowPart12");

    obj.scrollBox1 = GUI.fromHandle(_obj_newObject("scrollBox"));
    obj.scrollBox1:setParent(obj.flowPart12);
    obj.scrollBox1:setAlign("client");
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
    obj.grimorioInv:setParent(obj.flowLayout7);
    obj.grimorioInv:setName("grimorioInv");
    obj.grimorioInv:setField("magicsInv");
    obj.grimorioInv:setTemplateForm("ItemGrimorio");
    obj.grimorioInv:setWidth(0);
    obj.grimorioInv:setHeight(0);
    obj.grimorioInv:setVisible(false);

    obj.tab3 = GUI.fromHandle(_obj_newObject("tab"));
    obj.tab3:setParent(obj.tabControl1);
    obj.tab3:setTitle("Inventário");
    obj.tab3:setName("tab3");

    obj.Inventario = GUI.fromHandle(_obj_newObject("form"));
    obj.Inventario:setParent(obj.tab3);
    obj.Inventario:setName("Inventario");
    obj.Inventario:setAlign("client");
    obj.Inventario:setTheme("dark");
    obj.Inventario:setMargins({top=1});

    obj.button18 = GUI.fromHandle(_obj_newObject("button"));
    obj.button18:setParent(obj.Inventario);
    obj.button18:setAlign("top");
    obj.button18:setText("Adicionar Item");
    obj.button18:setWidth(100);
    obj.button18:setName("button18");

    obj.scrollBox2 = GUI.fromHandle(_obj_newObject("scrollBox"));
    obj.scrollBox2:setParent(obj.Inventario);
    obj.scrollBox2:setAlign("top");
    obj.scrollBox2:setHeight(755);
    obj.scrollBox2:setMargins({top = 10});
    obj.scrollBox2:setName("scrollBox2");

    obj.inventario = GUI.fromHandle(_obj_newObject("recordList"));
    obj.inventario:setParent(obj.scrollBox2);
    obj.inventario:setName("inventario");
    obj.inventario:setField("inventario");
    obj.inventario:setTemplateForm("ItemInventario");
    obj.inventario:setAlign("client");
    obj.inventario:setSelectable(true);

    obj.tab4 = GUI.fromHandle(_obj_newObject("tab"));
    obj.tab4:setParent(obj.tabControl1);
    obj.tab4:setTitle("Anotações");
    obj.tab4:setName("tab4");

    obj.Anotacoes = GUI.fromHandle(_obj_newObject("form"));
    obj.Anotacoes:setParent(obj.tab4);
    obj.Anotacoes:setName("Anotacoes");
    obj.Anotacoes:setAlign("client");
    obj.Anotacoes:setTheme("dark");
    obj.Anotacoes:setMargins({top=1});

    obj.anotacoes = GUI.fromHandle(_obj_newObject("richEdit"));
    obj.anotacoes:setParent(obj.Anotacoes);
    obj.anotacoes:setAlign("client");
    lfm_setPropAsString(obj.anotacoes, "backgroundColor",  "white");
    lfm_setPropAsString(obj.anotacoes, "defaultFontColor",  "black");
    obj.anotacoes:setField("anotacoes");
    obj.anotacoes:setName("anotacoes");
    lfm_setPropAsString(obj.anotacoes, "animateImages",  "false");


        function getCurrentJogador()
            user = Firecast.getCurrentUser()
            mesaDoPersonagem = Firecast.getMesaDe(sheet);
            jogadores = mesaDoPersonagem.jogadores
            for i = 1, #jogadores, 1 do
                    if jogadores[i].login == user.login then
                        return jogadores[i]
                    end
            end
        end
   


    obj._e_event0 = obj:addEventListener("onNodeReady",
        function (_)
            jogador = getCurrentJogador()
                    self.adminTab.visible = jogador.isMestre
                    self.anotacoes.visible = jogador.isMestre
                    if sheet.level1 == nil then
                        sheet.vigor = 15
                        sheet.vigorMax = 15
                        sheet.level1 = "0: 0/4"
                        sheet.level2 = "0: 0/4"
                        sheet.level3 = "0: 0/4"
                        sheet.level4 = "0: 0/4"
                        sheet.level5 = "0: 0/4"
                        sheet.level6 = "0: 0/4"
                        sheet.level7 = "0: 0/4"
                        sheet.level8 = "0: 0/4"
                    end
        end, obj);

    obj._e_event1 = obj.button1:addEventListener("onClick",
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

    obj._e_event2 = obj.escudoAp:addEventListener("onClick",
        function (_)
            if (selected == "" or selected == nil) then
                                                node = self.grimorio.selectedNode
                                                if (node == nil) then
                                                    popupShow("Escudo não encontrado.")
                                                else
                                                    selected = node.sequencia
                                                    self.escudoAp.checked = true
                                                    popupShow("Escudo aplicado.")
                                                end
                                            else
                                                magics = NDB.getChildNodes(sheet.magics)
                                                magicsInv = NDB.getChildNodes(sheet.magicsInv)
                                                selectedNode = nil
                                                for i=1, #magics, 1 do
                                                    if magics[i].sequencia == selected then
                                                        selectedNode = magics[i]
                                                        break
                                                    end
                                                end
                                                if selectedNode == nil then
                                                    for i=1, #magicsInv, 1 do
                                                        if magicsInv[i].sequencia == selected then
                                                            selectedNode = magicsInv[i]
                                                            break
                                                        end
                                                    end
                                                end
                                                self.magicDesc.node = selectedNode
                                                popupShow("Escudo selecionado.")
                                            end
        end, obj);

    obj._e_event3 = obj.button2:addEventListener("onClick",
        function (_)
            selected = ""
                                            self.escudoAp.checked = false
                                            popupShow("Escudo removido.")
        end, obj);

    obj._e_event4 = obj.progressBar1:addEventListener("onClick",
        function (_)
            popupShow("Vigor: " .. sheet.vigor .. "/" .. sheet.vigorMax)
        end, obj);

    obj._e_event5 = obj.button3:addEventListener("onClick",
        function (_)
            Dialogs.confirmOkCancel("Deseja resetar o vigor(".. sheet.vigorMax ..")?",
                                        function (confirmado)
                                            if confirmado then
                                                sheet.vigor = sheet.vigorMax
                                            end
                                        end)
        end, obj);

    obj._e_event6 = obj.button4:addEventListener("onClick",
        function (_)
            sig = "🔥"
                                    addSig(sig)
        end, obj);

    obj._e_event7 = obj.button5:addEventListener("onClick",
        function (_)
            sig = "⚡"
                                    addSig(sig)
        end, obj);

    obj._e_event8 = obj.button6:addEventListener("onClick",
        function (_)
            sig = "🎲"
                                    addSig(sig)
        end, obj);

    obj._e_event9 = obj.button7:addEventListener("onClick",
        function (_)
            sig = "🌓"
                                    addSig(sig)
        end, obj);

    obj._e_event10 = obj.button8:addEventListener("onClick",
        function (_)
            sig = "👊"
                                    addSig(sig)
        end, obj);

    obj._e_event11 = obj.button9:addEventListener("onClick",
        function (_)
            sig = "💫"
                                    addSig(sig)
        end, obj);

    obj._e_event12 = obj.button10:addEventListener("onClick",
        function (_)
            sig = "🎱"
                                    addSig(sig)
        end, obj);

    obj._e_event13 = obj.button11:addEventListener("onClick",
        function (_)
            sig = "☔"
                                    addSig(sig)
        end, obj);

    obj._e_event14 = obj.btn1:addEventListener("onClick",
        function (_)
            btnNum = 1
                                    removeSig(btnNum)
        end, obj);

    obj._e_event15 = obj.btn2:addEventListener("onClick",
        function (_)
            btnNum = 2
                                    removeSig(btnNum)
        end, obj);

    obj._e_event16 = obj.btn3:addEventListener("onClick",
        function (_)
            btnNum = 3
                                    removeSig(btnNum)
        end, obj);

    obj._e_event17 = obj.btn4:addEventListener("onClick",
        function (_)
            btnNum = 4
                                    removeSig(btnNum)
        end, obj);

    obj._e_event18 = obj.btn5:addEventListener("onClick",
        function (_)
            btnNum = 5
                                    removeSig(btnNum)
        end, obj);

    obj._e_event19 = obj.button12:addEventListener("onClick",
        function (_)
            btns = {self.btn1, self.btn2, self.btn3, self.btn4, self.btn5}
                            sequencia = ""
                            for i=1, 5, 1 do
                                sequencia = sequencia .. btns[i].text
                            end
                            if sequencia == "" then
                                popupShow("Nenhum Signo na magia.")
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
                                    self.grimorio:sort()
                                else
                                    popupShow("Mágica já escrita no Grimório.")
                                end
                            end
        end, obj);

    obj._e_event20 = obj.button13:addEventListener("onClick",
        function (_)
            Dialogs.choose("Escolha o Signo.", {"🔥 - Calor","⚡ - Disrupção","🎲 - Engano","🌓 - Equilíbrio","👊 - Força","💫 - Imaterial","🎱 - Material","☔ - Proteção"},
                                function(selected, selectedIndex, selectedText)
                                    if selected == false then 
                                        popupShow("Operação cancelada.")
                                    else
                                        sig = selectedIndex
                                        Dialogs.choose("Escolha o Level.", {"0","1","2","3","4","5","6"},
                                            function(selected2, selectedIndex2, selectedText2)
                                                if selected2 == false then 
                                                    popupShow("Operação cancelada.")
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
                                                                popupShow("Operação cancelada.")
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

    obj._e_event21 = obj.button14:addEventListener("onClick",
        function (_)
            node = self.grimorio.selectedNode
                                                            if node ~= nil then
                                                                trySpell()
                                                            end
        end, obj);

    obj._e_event22 = obj.button15:addEventListener("onClick",
        function (_)
            revealResult()
        end, obj);

    obj._e_event23 = obj.button16:addEventListener("onClick",
        function (_)
            copyAll()
        end, obj);

    obj._e_event24 = obj.button17:addEventListener("onClick",
        function (_)
            pasteAll()
                                        self.grimorio:sort()
        end, obj);

    obj._e_event25 = obj.grimorio:addEventListener("onSelect",
        function (_)
            node = self.grimorio.selectedNode
                                            self.magicDesc.node = node
        end, obj);

    obj._e_event26 = obj.grimorio:addEventListener("onCompare",
        function (_, nodeA, nodeB)
            a = nodeA.sequencia or ""
                                            b = nodeB.sequencia or ""
                                            return sortSig(a, b)
        end, obj);

    obj._e_event27 = obj.button18:addEventListener("onClick",
        function (_)
            self.inventario:append()
        end, obj);

    function obj:_releaseEvents()
        __o_rrpgObjs.removeEventListenerById(self._e_event27);
        __o_rrpgObjs.removeEventListenerById(self._e_event26);
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

        if self.label14 ~= nil then self.label14:destroy(); self.label14 = nil; end;
        if self.tab3 ~= nil then self.tab3:destroy(); self.tab3 = nil; end;
        if self.flowPart8 ~= nil then self.flowPart8:destroy(); self.flowPart8 = nil; end;
        if self.button15 ~= nil then self.button15:destroy(); self.button15 = nil; end;
        if self.flowPart10 ~= nil then self.flowPart10:destroy(); self.flowPart10 = nil; end;
        if self.layout15 ~= nil then self.layout15:destroy(); self.layout15 = nil; end;
        if self.layout10 ~= nil then self.layout10:destroy(); self.layout10 = nil; end;
        if self.edit9 ~= nil then self.edit9:destroy(); self.edit9 = nil; end;
        if self.flowLayout3 ~= nil then self.flowLayout3:destroy(); self.flowLayout3 = nil; end;
        if self.layout17 ~= nil then self.layout17:destroy(); self.layout17 = nil; end;
        if self.edit7 ~= nil then self.edit7:destroy(); self.edit7 = nil; end;
        if self.flowPart7 ~= nil then self.flowPart7:destroy(); self.flowPart7 = nil; end;
        if self.edit12 ~= nil then self.edit12:destroy(); self.edit12 = nil; end;
        if self.flowLayout1 ~= nil then self.flowLayout1:destroy(); self.flowLayout1 = nil; end;
        if self.btn2 ~= nil then self.btn2:destroy(); self.btn2 = nil; end;
        if self.label26 ~= nil then self.label26:destroy(); self.label26 = nil; end;
        if self.flowPart1 ~= nil then self.flowPart1:destroy(); self.flowPart1 = nil; end;
        if self.button16 ~= nil then self.button16:destroy(); self.button16 = nil; end;
        if self.label23 ~= nil then self.label23:destroy(); self.label23 = nil; end;
        if self.button2 ~= nil then self.button2:destroy(); self.button2 = nil; end;
        if self.flowPart2 ~= nil then self.flowPart2:destroy(); self.flowPart2 = nil; end;
        if self.flowLayout5 ~= nil then self.flowLayout5:destroy(); self.flowLayout5 = nil; end;
        if self.label22 ~= nil then self.label22:destroy(); self.label22 = nil; end;
        if self.layout13 ~= nil then self.layout13:destroy(); self.layout13 = nil; end;
        if self.layout3 ~= nil then self.layout3:destroy(); self.layout3 = nil; end;
        if self.label24 ~= nil then self.label24:destroy(); self.label24 = nil; end;
        if self.label13 ~= nil then self.label13:destroy(); self.label13 = nil; end;
        if self.layout8 ~= nil then self.layout8:destroy(); self.layout8 = nil; end;
        if self.tab2 ~= nil then self.tab2:destroy(); self.tab2 = nil; end;
        if self.layout1 ~= nil then self.layout1:destroy(); self.layout1 = nil; end;
        if self.rectangle1 ~= nil then self.rectangle1:destroy(); self.rectangle1 = nil; end;
        if self.label27 ~= nil then self.label27:destroy(); self.label27 = nil; end;
        if self.grimorio ~= nil then self.grimorio:destroy(); self.grimorio = nil; end;
        if self.inventario ~= nil then self.inventario:destroy(); self.inventario = nil; end;
        if self.layout12 ~= nil then self.layout12:destroy(); self.layout12 = nil; end;
        if self.edit14 ~= nil then self.edit14:destroy(); self.edit14 = nil; end;
        if self.button1 ~= nil then self.button1:destroy(); self.button1 = nil; end;
        if self.Grimorio ~= nil then self.Grimorio:destroy(); self.Grimorio = nil; end;
        if self.edit4 ~= nil then self.edit4:destroy(); self.edit4 = nil; end;
        if self.label8 ~= nil then self.label8:destroy(); self.label8 = nil; end;
        if self.label4 ~= nil then self.label4:destroy(); self.label4 = nil; end;
        if self.label6 ~= nil then self.label6:destroy(); self.label6 = nil; end;
        if self.edit11 ~= nil then self.edit11:destroy(); self.edit11 = nil; end;
        if self.layout9 ~= nil then self.layout9:destroy(); self.layout9 = nil; end;
        if self.Info ~= nil then self.Info:destroy(); self.Info = nil; end;
        if self.edit5 ~= nil then self.edit5:destroy(); self.edit5 = nil; end;
        if self.button13 ~= nil then self.button13:destroy(); self.button13 = nil; end;
        if self.textEditor2 ~= nil then self.textEditor2:destroy(); self.textEditor2 = nil; end;
        if self.label15 ~= nil then self.label15:destroy(); self.label15 = nil; end;
        if self.body ~= nil then self.body:destroy(); self.body = nil; end;
        if self.flowPart12 ~= nil then self.flowPart12:destroy(); self.flowPart12 = nil; end;
        if self.scrollBox2 ~= nil then self.scrollBox2:destroy(); self.scrollBox2 = nil; end;
        if self.label12 ~= nil then self.label12:destroy(); self.label12 = nil; end;
        if self.magicDesc ~= nil then self.magicDesc:destroy(); self.magicDesc = nil; end;
        if self.btn3 ~= nil then self.btn3:destroy(); self.btn3 = nil; end;
        if self.edit8 ~= nil then self.edit8:destroy(); self.edit8 = nil; end;
        if self.flowLayout7 ~= nil then self.flowLayout7:destroy(); self.flowLayout7 = nil; end;
        if self.flowPart4 ~= nil then self.flowPart4:destroy(); self.flowPart4 = nil; end;
        if self.grimorioInv ~= nil then self.grimorioInv:destroy(); self.grimorioInv = nil; end;
        if self.label16 ~= nil then self.label16:destroy(); self.label16 = nil; end;
        if self.layout19 ~= nil then self.layout19:destroy(); self.layout19 = nil; end;
        if self.edit2 ~= nil then self.edit2:destroy(); self.edit2 = nil; end;
        if self.label9 ~= nil then self.label9:destroy(); self.label9 = nil; end;
        if self.edit10 ~= nil then self.edit10:destroy(); self.edit10 = nil; end;
        if self.edit16 ~= nil then self.edit16:destroy(); self.edit16 = nil; end;
        if self.label28 ~= nil then self.label28:destroy(); self.label28 = nil; end;
        if self.edit1 ~= nil then self.edit1:destroy(); self.edit1 = nil; end;
        if self.flowLineBreak1 ~= nil then self.flowLineBreak1:destroy(); self.flowLineBreak1 = nil; end;
        if self.Functions_Edit ~= nil then self.Functions_Edit:destroy(); self.Functions_Edit = nil; end;
        if self.button4 ~= nil then self.button4:destroy(); self.button4 = nil; end;
        if self.tab4 ~= nil then self.tab4:destroy(); self.tab4 = nil; end;
        if self.button3 ~= nil then self.button3:destroy(); self.button3 = nil; end;
        if self.label1 ~= nil then self.label1:destroy(); self.label1 = nil; end;
        if self.layout4 ~= nil then self.layout4:destroy(); self.layout4 = nil; end;
        if self.flowLineBreak3 ~= nil then self.flowLineBreak3:destroy(); self.flowLineBreak3 = nil; end;
        if self.button7 ~= nil then self.button7:destroy(); self.button7 = nil; end;
        if self.Functions_Roll ~= nil then self.Functions_Roll:destroy(); self.Functions_Roll = nil; end;
        if self.label17 ~= nil then self.label17:destroy(); self.label17 = nil; end;
        if self.Anotacoes ~= nil then self.Anotacoes:destroy(); self.Anotacoes = nil; end;
        if self.flowLayout4 ~= nil then self.flowLayout4:destroy(); self.flowLayout4 = nil; end;
        if self.flowPart5 ~= nil then self.flowPart5:destroy(); self.flowPart5 = nil; end;
        if self.flowPart9 ~= nil then self.flowPart9:destroy(); self.flowPart9 = nil; end;
        if self.edit13 ~= nil then self.edit13:destroy(); self.edit13 = nil; end;
        if self.layout5 ~= nil then self.layout5:destroy(); self.layout5 = nil; end;
        if self.popupMsg ~= nil then self.popupMsg:destroy(); self.popupMsg = nil; end;
        if self.layout20 ~= nil then self.layout20:destroy(); self.layout20 = nil; end;
        if self.flowPart11 ~= nil then self.flowPart11:destroy(); self.flowPart11 = nil; end;
        if self.button11 ~= nil then self.button11:destroy(); self.button11 = nil; end;
        if self.layout18 ~= nil then self.layout18:destroy(); self.layout18 = nil; end;
        if self.Inventario ~= nil then self.Inventario:destroy(); self.Inventario = nil; end;
        if self.button12 ~= nil then self.button12:destroy(); self.button12 = nil; end;
        if self.button6 ~= nil then self.button6:destroy(); self.button6 = nil; end;
        if self.button5 ~= nil then self.button5:destroy(); self.button5 = nil; end;
        if self.label21 ~= nil then self.label21:destroy(); self.label21 = nil; end;
        if self.flowPart6 ~= nil then self.flowPart6:destroy(); self.flowPart6 = nil; end;
        if self.tabControl1 ~= nil then self.tabControl1:destroy(); self.tabControl1 = nil; end;
        if self.flowLayout2 ~= nil then self.flowLayout2:destroy(); self.flowLayout2 = nil; end;
        if self.popupText ~= nil then self.popupText:destroy(); self.popupText = nil; end;
        if self.label10 ~= nil then self.label10:destroy(); self.label10 = nil; end;
        if self.label19 ~= nil then self.label19:destroy(); self.label19 = nil; end;
        if self.button10 ~= nil then self.button10:destroy(); self.button10 = nil; end;
        if self.layout2 ~= nil then self.layout2:destroy(); self.layout2 = nil; end;
        if self.button17 ~= nil then self.button17:destroy(); self.button17 = nil; end;
        if self.checkBox2 ~= nil then self.checkBox2:destroy(); self.checkBox2 = nil; end;
        if self.richEdit1 ~= nil then self.richEdit1:destroy(); self.richEdit1 = nil; end;
        if self.flowPart3 ~= nil then self.flowPart3:destroy(); self.flowPart3 = nil; end;
        if self.btn4 ~= nil then self.btn4:destroy(); self.btn4 = nil; end;
        if self.adminTab ~= nil then self.adminTab:destroy(); self.adminTab = nil; end;
        if self.label11 ~= nil then self.label11:destroy(); self.label11 = nil; end;
        if self.layout11 ~= nil then self.layout11:destroy(); self.layout11 = nil; end;
        if self.label3 ~= nil then self.label3:destroy(); self.label3 = nil; end;
        if self.label20 ~= nil then self.label20:destroy(); self.label20 = nil; end;
        if self.edit15 ~= nil then self.edit15:destroy(); self.edit15 = nil; end;
        if self.textEditor1 ~= nil then self.textEditor1:destroy(); self.textEditor1 = nil; end;
        if self.flowLayout6 ~= nil then self.flowLayout6:destroy(); self.flowLayout6 = nil; end;
        if self.button9 ~= nil then self.button9:destroy(); self.button9 = nil; end;
        if self.escudoAp ~= nil then self.escudoAp:destroy(); self.escudoAp = nil; end;
        if self.btn1 ~= nil then self.btn1:destroy(); self.btn1 = nil; end;
        if self.edit6 ~= nil then self.edit6:destroy(); self.edit6 = nil; end;
        if self.label25 ~= nil then self.label25:destroy(); self.label25 = nil; end;
        if self.label7 ~= nil then self.label7:destroy(); self.label7 = nil; end;
        if self.button8 ~= nil then self.button8:destroy(); self.button8 = nil; end;
        if self.button18 ~= nil then self.button18:destroy(); self.button18 = nil; end;
        if self.label18 ~= nil then self.label18:destroy(); self.label18 = nil; end;
        if self.label2 ~= nil then self.label2:destroy(); self.label2 = nil; end;
        if self.edit3 ~= nil then self.edit3:destroy(); self.edit3 = nil; end;
        if self.label5 ~= nil then self.label5:destroy(); self.label5 = nil; end;
        if self.layout6 ~= nil then self.layout6:destroy(); self.layout6 = nil; end;
        if self.layout22 ~= nil then self.layout22:destroy(); self.layout22 = nil; end;
        if self.progressBar1 ~= nil then self.progressBar1:destroy(); self.progressBar1 = nil; end;
        if self.layout14 ~= nil then self.layout14:destroy(); self.layout14 = nil; end;
        if self.layout16 ~= nil then self.layout16:destroy(); self.layout16 = nil; end;
        if self.layout21 ~= nil then self.layout21:destroy(); self.layout21 = nil; end;
        if self.anotacoes ~= nil then self.anotacoes:destroy(); self.anotacoes = nil; end;
        if self.button14 ~= nil then self.button14:destroy(); self.button14 = nil; end;
        if self.tab1 ~= nil then self.tab1:destroy(); self.tab1 = nil; end;
        if self.btn5 ~= nil then self.btn5:destroy(); self.btn5 = nil; end;
        if self.Functions ~= nil then self.Functions:destroy(); self.Functions = nil; end;
        if self.flowLineBreak2 ~= nil then self.flowLineBreak2:destroy(); self.flowLineBreak2 = nil; end;
        if self.checkBox1 ~= nil then self.checkBox1:destroy(); self.checkBox1 = nil; end;
        if self.scrollBox1 ~= nil then self.scrollBox1:destroy(); self.scrollBox1 = nil; end;
        if self.layout7 ~= nil then self.layout7:destroy(); self.layout7 = nil; end;
        self:_oldLFMDestroy();
    end;

    obj:endUpdate();

    return obj;
end;

function newFicha_Signeiros()
    local retObj = nil;
    __o_rrpgObjs.beginObjectsLoading();

    __o_Utils.tryFinally(
      function()
        retObj = constructNew_Ficha_Signeiros();
      end,
      function()
        __o_rrpgObjs.endObjectsLoading();
      end);

    assert(retObj ~= nil);
    return retObj;
end;

local _Ficha_Signeiros = {
    newEditor = newFicha_Signeiros, 
    new = newFicha_Signeiros, 
    name = "Ficha_Signeiros", 
    dataType = "Signeiros.Ficha", 
    formType = "sheetTemplate", 
    formComponentName = "form", 
    title = "Ficha Signeiros", 
    description=""};

Ficha_Signeiros = _Ficha_Signeiros;
Firecast.registrarForm(_Ficha_Signeiros);
Firecast.registrarDataType(_Ficha_Signeiros);

return _Ficha_Signeiros;
