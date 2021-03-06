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


        icons = {["🔥"]=1,["⚡"]=2,["🎲"]=3,["🌓"]=4,["👊"]=5,["💫"]=6,["🎱"]=7,["☔"]=8}
        local function splitEmojis(str)
            local res = {}
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
        local function sortSig(a, b)
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
        local function split(s, delimiter)
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


        local function getText(magic)
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
        local function setText(magic, text)
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
        local function addXP(qnt, magic)
            local text = getText(magic)
            text = split(text, ":")
            local xp = split(text[2], "/")
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
            local qnts = {3, 5, 7, 9, 11, 100}
            setText(magic, text[1].. ": 0/" .. qnts[text[1]])
            return true
        end
        local function reduceVigor(qnt)
            if 0 > qnt then
                return
            end
            sheet.vigor = sheet.vigor - qnt
        end
        local function hasVigor(qnt)
            return sheet.vigor >= qnt
        end
        local function getSequencia()
            local node = self.grimorio.selectedNode
            return splitEmojis(node.sequencia)
        end
        local function getLevel(magic)
            local textSig = getText(magic)
            local level = split(textSig, ":")
            return tonumber(level[1])
        end
        local function hasLevel()
            local sequencia = getSequencia()
            for i=1, #sequencia, 1 do
                if #sequencia > getLevel(icons[sequencia[i]]) then
                    return false
                end
            end
            return true
        end
        local function discountVigor(size, result)
            for i=1, size, 1 do
                local value = 12*size - (i-1)*2
                if result > value then
                    return size-(i-1)
                end
            end
            return 0
        end
        local function afterRoll(rolagem)
            local sequencia = getSequencia()
            local qnt = #sequencia
            local discount = discountVigor(qnt, rolagem.resultado)
            reduceVigor(qnt-discount)
            local index = 1
            for i=1, #rolagem.ops, 1 do
                if rolagem.ops[i].tipo == "dado" then
                    local item = rolagem.ops[i]
                    if item.resultados[1] == item.face then
                        local flag = addXP(1, icons[sequencia[index]])
                        if flag then
                            return
                        end
                    end
                    index = index + 1
                end
            end
        end
        local function valuesRolls(ops)
            local results = ""
            local value = 0
            for i=1, #ops, 1 do
                if ops[i].tipo == "dado" then
                    if i ~= 1 then
                        results = results .. ", "
                    end
                    for j=1, #ops[i].resultados, 1 do
                        local item = ops[i].resultados[j]
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
        local function calUnidades(value, sum)
            return math.floor(value*(1+(sum/10))+0.2)
        end
        local function generateUnidades(txtUnits, sum)
            if txtUnits == nil then
                return "Nenhuma unidade."
            end
            local allUnits = split(txtUnits, ",")
            local msg = ""
            for i=1, #allUnits, 1 do
                if i ~= 1 then
                    msg = msg .. ", "
                end
                local parts = split(allUnits[i], "=")
                if #parts == 2 then
                    msg = msg .. trim(parts[1]) .. "(".. trim(parts[2]) ..") = " .. calUnidades(tonumber(parts[2]), sum)
                else
                    msg = msg .. "Unidade " .. i .. "(".. tonumber(parts[1]) .. ") = " .. calUnidades(tonumber(parts[1]), sum)
                end
            end
            return msg
        end
        local function generateMsg(strRolagem)
            local node = self.grimorio.selectedNode
            rolagem = Firecast.interpretarRolagem(strRolagem)
            rolagem:rolarLocalmente()
            local resultsStr, resultInt = valuesRolls(rolagem.ops)
            local dano = node.dano or 0
            local dmg = calUnidades(tonumber(dano), resultInt)
            local msg =   node.sequencia .. ": " .. (node.nomeMagia or "Sem Nome") .. "\n"..
                    "Dados(".. strRolagem .."): ".. resultsStr .. " = " .. rolagem.resultado .. "(".. round(resultInt) ..")" .. "\n" ..
                    "Dano(".. (dano) .."): ".. dmg .."\n" ..
                    "Unidades: " .. generateUnidades(node.unidades, resultInt)
            return msg, rolagem
        end
        local function revealResult(strRolagem)
            local msg, rolagem = generateMsg(strRolagem)
            local mesaDoPersonagem = Firecast.getMesaDe(sheet)
            mesaDoPersonagem.chat:enviarMensagem(msg)
            afterRoll(rolagem)
        end
        local function generateRoll()
            local sequencia = getSequencia()
            local dices = {"1d4", "1d4", "1d6", "1d8", "1d10", "1d12", "1d20"}
            local strRolagem = ""
            for i=1, #sequencia, 1 do
                if i ~= 1 then
                    strRolagem = strRolagem .. "+"
                end
                local level = getLevel(icons[sequencia[i]]) + 1
                strRolagem = strRolagem .. dices[level]
            end
            return strRolagem
        end
        local function roll()
            local strRolagem = generateRoll()
            local node = self.grimorio.selectedNode
            if node.modoSecreto == false or node.modoSecreto == nil then
                revealResult(strRolagem)
            else
                node.rolagem = strRolagem
                local mesaDoPersonagem = Firecast.getMesaDe(sheet)
                mesaDoPersonagem.chat:enviarMensagem("Magia preparada: " .. node.sequencia)
                showMessage("Rolagem preparada.")
            end
        end
        local function level0Roll()
            local strRolagem = generateRoll()
            local msg, rolagem = generateMsg(strRolagem)
            local item = rolagem.ops[1]
            local mesaDoPersonagem = Firecast.getMesaDe(sheet)
            afterRoll(rolagem)
            if item.resultados[1] == item.face then
                mesaDoPersonagem.chat:enviarMensagem(msg)
                return
            end
            mesaDoPersonagem.chat:enviarMensagem("Magia falhou. Resultado: " .. item.resultados[1])
        end
        local function trySpell()
            local sequencia = getSequencia()
            local qnt = #sequencia
            if hasVigor(qnt) == false then
                showMessage("Vigor não suficiente para executar a magia.")
                return
            end
            if qnt == 1 and getLevel(icons[sequencia[1]]) == 0 then
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


        local function copyAll()
            local magics = NDB.getChildNodes(sheet.magics)
            System.setClipboardText(tableToStr(magics))
        end
        local function inGrimorio(sequencia)
            local magics = NDB.getChildNodes(sheet.magics)
            for i=1, #magics, 1 do
                if magics[i].sequencia == sequencia then
                    return true
                end
            end
            return false
        end
        local function paste(table)
            if inGrimorio(table.sequencia) then 
                return
            end
            local node = self.grimorio:append()
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
        local function pasteAll()
            local str = System.getClipboardText()
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
    



        local function searchList(addMode)
            local magics = NDB.getChildNodes(sheet.magics)
            local magicsInv = NDB.getChildNodes(sheet.magicsInv)
            local btns = {self.btn1, self.btn2, self.btn3, self.btn4, self.btn5}
            if btns[1] == "" then
                for i=1, #magicsInv, 1 do
                    local nodo = self.grimorio:append()
                    NDB.copy(nodo, magicsInv[i])
                    NDB.deleteNode(magicsInv[i])
                end
            else
                local s = {}
                local index = 1
                for i=1, 5, 1 do
                    if i == 1 then
                        table.insert(s, btns[i].text)
                    else
                        if string.find(s[index], btns[i].text) then
                            s[index] = s[index] .. btns[i].text
                        else
                            table.insert(s, btns[i].text)
                            index = index + 1
                        end
                    end
                end
                if addMode then
                    for i=1, #magics, 1 do
                        for j=1, #s, 1 do
                            if string.find(magics[i].sequencia, s[j]) == nil then
                                local nodo = self.grimorioInv:append()
                                NDB.copy(nodo, magics[i])
                                NDB.deleteNode(magics[i])
                                break
                            end
                        end
                    end
                else
                    for i=1, #magicsInv, 1 do
                        local flag = true
                        for j=1, #s, 1 do
                            if string.find(magicsInv[i].sequencia, s[j]) == nil then
                                flag = false
                                break
                            end
                        end
                        if flag == true then
                            local nodo = self.grimorio:append()
                            NDB.copy(nodo, magicsInv[i])
                            NDB.deleteNode(magicsInv[i])
                        end
                    end
                end
            end
            self.grimorio:needRepaint()
            self.grimorio:sort()
        end
        local function orderSig(a, b)
            return icons[b] > icons[a]
        end
        local function addSig(sig)
            local btns = {self.btn1, self.btn2, self.btn3, self.btn4, self.btn5}
            local sequencia = {sig}
            if self.btn1.text == "" then
                self.btn1.text = sig
            else
                for i=1, #btns, 1 do
                    if btns[i].text == "" then
                        break
                    else
                        table.insert(sequencia, btns[i].text)
                    end
                end
                table.sort(sequencia, orderSig)
                if 5 >= #sequencia then
                    for i=1, 5, 1 do
                        btns[i].text = sequencia[i]
                    end
                end
            end
            if 6 > #sequencia then 
                searchList(true)
            end
        end
        local function removeSig(btnNum)
            local btns = {self.btn1, self.btn2, self.btn3, self.btn4, self.btn5}
            btns[btnNum].text = ""
            local sequencia = {}
            for i=1, #btns, 1 do
                if btns[i].text ~= "" then
                    table.insert(sequencia, btns[i].text)
                end
            end
            table.sort(sequencia, orderSig)
            if 5 >= #sequencia then
                for i=1, 5, 1 do
                    btns[i].text = sequencia[i]
                end
            end
            searchList(false)
        end
        local function altVigor()
            local vigor = 15
            for i=1, 8, 1 do
                local level = getLevel(i)
                if level >= 3 then
                    vigor = vigor + 1
                end
                if level >= 5 then
                    vigor = vigor + 1
                end
            end
            sheet.vigorMax = vigor
        end
        local function altLevel(sig, text)
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
        local SIZE = 1650
        local function hasSize()
            return self.body.width > SIZE
        end
        local function resizeLayout()
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
    obj.flowLayout1:setHeight(150);
    obj.flowLayout1:setMargins({left = 5, right = 5, top = 5, bottom = 5});
    obj.flowLayout1:setHorzAlign("center");
    obj.flowLayout1:setName("flowLayout1");

    obj.flowPart1 = GUI.fromHandle(_obj_newObject("flowPart"));
    obj.flowPart1:setParent(obj.flowLayout1);
    obj.flowPart1:setMinWidth(300);
    obj.flowPart1:setMaxWidth(425);
    obj.flowPart1:setHeight(25);
    obj.flowPart1:setVertAlign("center");
    obj.flowPart1:setName("flowPart1");

    obj.label1 = GUI.fromHandle(_obj_newObject("label"));
    obj.label1:setParent(obj.flowPart1);
    obj.label1:setAlign("left");
    obj.label1:setText("Vida");
    obj.label1:setWidth(100);
    obj.label1:setHeight(25);
    obj.label1:setName("label1");

    obj.edit2 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit2:setParent(obj.flowPart1);
    obj.edit2:setAlign("left");
    obj.edit2:setField("vidaAt");
    obj.edit2:setWidth(100);
    obj.edit2:setHeight(25);
    obj.edit2:setType("number");
    obj.edit2:setName("edit2");

    obj.label2 = GUI.fromHandle(_obj_newObject("label"));
    obj.label2:setParent(obj.flowPart1);
    obj.label2:setAlign("left");
    obj.label2:setText("/");
    obj.label2:setWidth(10);
    obj.label2:setHeight(25);
    obj.label2:setMargins({left=5});
    obj.label2:setName("label2");

    obj.edit3 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit3:setParent(obj.flowPart1);
    obj.edit3:setAlign("left");
    obj.edit3:setField("vidaMax");
    obj.edit3:setWidth(100);
    obj.edit3:setHeight(25);
    obj.edit3:setType("number");
    obj.edit3:setName("edit3");

    obj.flowPart2 = GUI.fromHandle(_obj_newObject("flowPart"));
    obj.flowPart2:setParent(obj.flowLayout1);
    obj.flowPart2:setMinWidth(300);
    obj.flowPart2:setMaxWidth(425);
    obj.flowPart2:setHeight(25);
    obj.flowPart2:setVertAlign("center");
    obj.flowPart2:setName("flowPart2");

    obj.label3 = GUI.fromHandle(_obj_newObject("label"));
    obj.label3:setParent(obj.flowPart2);
    obj.label3:setAlign("left");
    obj.label3:setText("Escudo");
    obj.label3:setWidth(100);
    obj.label3:setHeight(25);
    obj.label3:setName("label3");

    obj.edit4 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit4:setParent(obj.flowPart2);
    obj.edit4:setAlign("left");
    obj.edit4:setField("escudoAt");
    obj.edit4:setWidth(100);
    obj.edit4:setHeight(25);
    obj.edit4:setType("number");
    obj.edit4:setName("edit4");

    obj.label4 = GUI.fromHandle(_obj_newObject("label"));
    obj.label4:setParent(obj.flowPart2);
    obj.label4:setAlign("left");
    obj.label4:setText("/");
    obj.label4:setWidth(10);
    obj.label4:setHeight(25);
    obj.label4:setMargins({left=5});
    obj.label4:setName("label4");

    obj.edit5 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit5:setParent(obj.flowPart2);
    obj.edit5:setAlign("left");
    obj.edit5:setField("escudoMax");
    obj.edit5:setWidth(100);
    obj.edit5:setHeight(25);
    obj.edit5:setType("number");
    obj.edit5:setName("edit5");

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

    obj.button1 = GUI.fromHandle(_obj_newObject("button"));
    obj.button1:setParent(obj.flowLayout2);
    obj.button1:setText("Restaurar Vigor");
    obj.button1:setWidth(100);
    obj.button1:setMargins({left=10});
    obj.button1:setName("button1");

    obj.layout3 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout3:setParent(obj.layout1);
    obj.layout3:setAlign("top");
    obj.layout3:setHeight(300);
    obj.layout3:setMargins({left = 5, right = 5, top = 5, bottom = 5});
    obj.layout3:setName("layout3");

    obj.flowLayout3 = GUI.fromHandle(_obj_newObject("flowLayout"));
    obj.flowLayout3:setParent(obj.layout3);
    obj.flowLayout3:setAlign("top");
    obj.flowLayout3:setWidth(850);
    obj.flowLayout3:setHeight(85);
    obj.flowLayout3:setHorzAlign("center");
    obj.flowLayout3:setName("flowLayout3");

    obj.layout4 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout4:setParent(obj.flowLayout3);
    obj.layout4:setWidth(70);
    obj.layout4:setHeight(85);
    obj.layout4:setMargins({left=5});
    obj.layout4:setName("layout4");

    obj.button2 = GUI.fromHandle(_obj_newObject("button"));
    obj.button2:setParent(obj.layout4);
    obj.button2:setAlign("top");
    obj.button2:setText("🔥");
    obj.button2:setHeight(60);
    obj.button2:setHint("Calor");
    obj.button2:setFontSize(30);
    obj.button2:setName("button2");

    obj.label5 = GUI.fromHandle(_obj_newObject("label"));
    obj.label5:setParent(obj.layout4);
    obj.label5:setAlign("top");
    obj.label5:setHeight(25);
    obj.label5:setField("level1");
    obj.label5:setHorzTextAlign("center");
    obj.label5:setHitTest(true);
    obj.label5:setHint("Level: XP Atual/XP Upar");
    obj.label5:setName("label5");

    obj.layout5 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout5:setParent(obj.flowLayout3);
    obj.layout5:setWidth(70);
    obj.layout5:setHeight(85);
    obj.layout5:setMargins({left=5});
    obj.layout5:setName("layout5");

    obj.button3 = GUI.fromHandle(_obj_newObject("button"));
    obj.button3:setParent(obj.layout5);
    obj.button3:setAlign("top");
    obj.button3:setText("⚡");
    obj.button3:setHeight(60);
    obj.button3:setHint("Disrupção");
    obj.button3:setFontSize(30);
    obj.button3:setName("button3");

    obj.label6 = GUI.fromHandle(_obj_newObject("label"));
    obj.label6:setParent(obj.layout5);
    obj.label6:setAlign("top");
    obj.label6:setHeight(25);
    obj.label6:setField("level2");
    obj.label6:setHorzTextAlign("center");
    obj.label6:setHitTest(true);
    obj.label6:setHint("Level: XP Atual/XP Upar");
    obj.label6:setName("label6");

    obj.layout6 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout6:setParent(obj.flowLayout3);
    obj.layout6:setWidth(70);
    obj.layout6:setHeight(85);
    obj.layout6:setMargins({left=5});
    obj.layout6:setName("layout6");

    obj.button4 = GUI.fromHandle(_obj_newObject("button"));
    obj.button4:setParent(obj.layout6);
    obj.button4:setAlign("top");
    obj.button4:setText("🎲");
    obj.button4:setHeight(60);
    obj.button4:setHint("Engano");
    obj.button4:setFontSize(30);
    obj.button4:setName("button4");

    obj.label7 = GUI.fromHandle(_obj_newObject("label"));
    obj.label7:setParent(obj.layout6);
    obj.label7:setAlign("top");
    obj.label7:setHeight(25);
    obj.label7:setField("level3");
    obj.label7:setHorzTextAlign("center");
    obj.label7:setHitTest(true);
    obj.label7:setHint("Level: XP Atual/XP Upar");
    obj.label7:setName("label7");

    obj.layout7 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout7:setParent(obj.flowLayout3);
    obj.layout7:setWidth(70);
    obj.layout7:setHeight(85);
    obj.layout7:setMargins({left=5});
    obj.layout7:setName("layout7");

    obj.button5 = GUI.fromHandle(_obj_newObject("button"));
    obj.button5:setParent(obj.layout7);
    obj.button5:setAlign("top");
    obj.button5:setText("🌓");
    obj.button5:setHeight(60);
    obj.button5:setHint("Equilíbrio");
    obj.button5:setFontSize(30);
    obj.button5:setName("button5");

    obj.label8 = GUI.fromHandle(_obj_newObject("label"));
    obj.label8:setParent(obj.layout7);
    obj.label8:setAlign("top");
    obj.label8:setHeight(25);
    obj.label8:setField("level4");
    obj.label8:setHorzTextAlign("center");
    obj.label8:setHitTest(true);
    obj.label8:setHint("Level: XP Atual/XP Upar");
    obj.label8:setName("label8");

    obj.layout8 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout8:setParent(obj.flowLayout3);
    obj.layout8:setWidth(70);
    obj.layout8:setHeight(85);
    obj.layout8:setMargins({left=5});
    obj.layout8:setName("layout8");

    obj.button6 = GUI.fromHandle(_obj_newObject("button"));
    obj.button6:setParent(obj.layout8);
    obj.button6:setAlign("top");
    obj.button6:setText("👊");
    obj.button6:setHeight(60);
    obj.button6:setHint("Força");
    obj.button6:setFontSize(30);
    obj.button6:setName("button6");

    obj.label9 = GUI.fromHandle(_obj_newObject("label"));
    obj.label9:setParent(obj.layout8);
    obj.label9:setAlign("top");
    obj.label9:setHeight(25);
    obj.label9:setField("level5");
    obj.label9:setHorzTextAlign("center");
    obj.label9:setHitTest(true);
    obj.label9:setHint("Level: XP Atual/XP Upar");
    obj.label9:setName("label9");

    obj.layout9 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout9:setParent(obj.flowLayout3);
    obj.layout9:setWidth(70);
    obj.layout9:setHeight(85);
    obj.layout9:setMargins({left=5});
    obj.layout9:setName("layout9");

    obj.button7 = GUI.fromHandle(_obj_newObject("button"));
    obj.button7:setParent(obj.layout9);
    obj.button7:setAlign("top");
    obj.button7:setText("💫");
    obj.button7:setHeight(60);
    obj.button7:setHint("Imaterial");
    obj.button7:setFontSize(30);
    obj.button7:setName("button7");

    obj.label10 = GUI.fromHandle(_obj_newObject("label"));
    obj.label10:setParent(obj.layout9);
    obj.label10:setAlign("top");
    obj.label10:setHeight(25);
    obj.label10:setField("level6");
    obj.label10:setHorzTextAlign("center");
    obj.label10:setHitTest(true);
    obj.label10:setHint("Level: XP Atual/XP Upar");
    obj.label10:setName("label10");

    obj.layout10 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout10:setParent(obj.flowLayout3);
    obj.layout10:setWidth(70);
    obj.layout10:setHeight(85);
    obj.layout10:setMargins({left=5});
    obj.layout10:setName("layout10");

    obj.button8 = GUI.fromHandle(_obj_newObject("button"));
    obj.button8:setParent(obj.layout10);
    obj.button8:setAlign("top");
    obj.button8:setText("🎱");
    obj.button8:setHeight(60);
    obj.button8:setHint("Material");
    obj.button8:setFontSize(30);
    obj.button8:setName("button8");

    obj.label11 = GUI.fromHandle(_obj_newObject("label"));
    obj.label11:setParent(obj.layout10);
    obj.label11:setAlign("top");
    obj.label11:setHeight(25);
    obj.label11:setField("level7");
    obj.label11:setHorzTextAlign("center");
    obj.label11:setHitTest(true);
    obj.label11:setHint("Level: XP Atual/XP Upar");
    obj.label11:setName("label11");

    obj.layout11 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout11:setParent(obj.flowLayout3);
    obj.layout11:setWidth(70);
    obj.layout11:setHeight(85);
    obj.layout11:setMargins({left=5});
    obj.layout11:setName("layout11");

    obj.button9 = GUI.fromHandle(_obj_newObject("button"));
    obj.button9:setParent(obj.layout11);
    obj.button9:setAlign("top");
    obj.button9:setText("☔");
    obj.button9:setHeight(60);
    obj.button9:setHint("Proteção");
    obj.button9:setFontSize(30);
    obj.button9:setName("button9");

    obj.label12 = GUI.fromHandle(_obj_newObject("label"));
    obj.label12:setParent(obj.layout11);
    obj.label12:setAlign("top");
    obj.label12:setHeight(25);
    obj.label12:setField("level8");
    obj.label12:setHorzTextAlign("center");
    obj.label12:setHitTest(true);
    obj.label12:setHint("Level: XP Atual/XP Upar");
    obj.label12:setName("label12");

    obj.layout12 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout12:setParent(obj.layout3);
    obj.layout12:setAlign("top");
    obj.layout12:setWidth(850);
    obj.layout12:setHeight(340);
    obj.layout12:setMargins({top=10});
    obj.layout12:setName("layout12");

    obj.flowLayout4 = GUI.fromHandle(_obj_newObject("flowLayout"));
    obj.flowLayout4:setParent(obj.layout12);
    obj.flowLayout4:setAlign("top");
    obj.flowLayout4:setHeight(50);
    obj.flowLayout4:setHorzAlign("center");
    obj.flowLayout4:setName("flowLayout4");

    obj.btn1 = GUI.fromHandle(_obj_newObject("button"));
    obj.btn1:setParent(obj.flowLayout4);
    obj.btn1:setAlign("left");
    obj.btn1:setText("");
    obj.btn1:setWidth(50);
    obj.btn1:setHeight(50);
    obj.btn1:setName("btn1");
    obj.btn1:setMargins({left=5});
    obj.btn1:setFontSize(20);

    obj.btn2 = GUI.fromHandle(_obj_newObject("button"));
    obj.btn2:setParent(obj.flowLayout4);
    obj.btn2:setAlign("left");
    obj.btn2:setText("");
    obj.btn2:setWidth(50);
    obj.btn2:setHeight(50);
    obj.btn2:setName("btn2");
    obj.btn2:setMargins({left=5});
    obj.btn2:setFontSize(20);

    obj.btn3 = GUI.fromHandle(_obj_newObject("button"));
    obj.btn3:setParent(obj.flowLayout4);
    obj.btn3:setAlign("left");
    obj.btn3:setText("");
    obj.btn3:setWidth(50);
    obj.btn3:setHeight(50);
    obj.btn3:setName("btn3");
    obj.btn3:setMargins({left=5});
    obj.btn3:setFontSize(20);

    obj.btn4 = GUI.fromHandle(_obj_newObject("button"));
    obj.btn4:setParent(obj.flowLayout4);
    obj.btn4:setAlign("left");
    obj.btn4:setText("");
    obj.btn4:setWidth(50);
    obj.btn4:setHeight(50);
    obj.btn4:setName("btn4");
    obj.btn4:setMargins({left=5});
    obj.btn4:setFontSize(20);

    obj.btn5 = GUI.fromHandle(_obj_newObject("button"));
    obj.btn5:setParent(obj.flowLayout4);
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

    obj.button10 = GUI.fromHandle(_obj_newObject("button"));
    obj.button10:setParent(obj.adminTab);
    obj.button10:setWidth(150);
    obj.button10:setText("Adicionar Magia");
    obj.button10:setMargins({top=10});
    obj.button10:setName("button10");

    obj.button11 = GUI.fromHandle(_obj_newObject("button"));
    obj.button11:setParent(obj.adminTab);
    obj.button11:setWidth(150);
    obj.button11:setText("Ajustar Level de magia");
    obj.button11:setMargins({top=10, left=10});
    obj.button11:setName("button11");

    obj.layout13 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout13:setParent(obj.layout1);
    obj.layout13:setAlign("top");
    obj.layout13:setHeight(300);
    obj.layout13:setMargins({left = 5, right = 5, top = 5, bottom = 5});
    obj.layout13:setName("layout13");

    obj.magicDesc = GUI.fromHandle(_obj_newObject("dataScopeBox"));
    obj.magicDesc:setParent(obj.layout13);
    obj.magicDesc:setName("magicDesc");
    obj.magicDesc:setAlign("client");

    obj.rectangle1 = GUI.fromHandle(_obj_newObject("rectangle"));
    obj.rectangle1:setParent(obj.magicDesc);
    obj.rectangle1:setAlign("top");
    obj.rectangle1:setColor("black");
    obj.rectangle1:setXradius(10);
    obj.rectangle1:setYradius(10);
    obj.rectangle1:setHeight(290);
    obj.rectangle1:setPadding({top=5, left=5, right=5, bottom=5});
    obj.rectangle1:setName("rectangle1");

    obj.layout14 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout14:setParent(obj.rectangle1);
    obj.layout14:setAlign("client");
    obj.layout14:setName("layout14");

    obj.layout15 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout15:setParent(obj.layout14);
    obj.layout15:setAlign("top");
    obj.layout15:setHeight(60);
    obj.layout15:setName("layout15");

    obj.layout16 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout16:setParent(obj.layout15);
    obj.layout16:setAlign("left");
    obj.layout16:setWidth(600);
    obj.layout16:setHeight(50);
    obj.layout16:setName("layout16");

    obj.layout17 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout17:setParent(obj.layout16);
    obj.layout17:setAlign("top");
    obj.layout17:setWidth(90);
    obj.layout17:setHeight(25);
    obj.layout17:setMargins({top = 5});
    obj.layout17:setName("layout17");

    obj.label13 = GUI.fromHandle(_obj_newObject("label"));
    obj.label13:setParent(obj.layout17);
    obj.label13:setAlign("left");
    obj.label13:setText("Dano");
    obj.label13:setMargins({left = 5});
    obj.label13:setName("label13");

    obj.edit6 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit6:setParent(obj.layout17);
    obj.edit6:setAlign("left");
    obj.edit6:setWidth(50);
    obj.edit6:setField("dano");
    obj.edit6:setType("number");
    obj.edit6:setMin(0);
    obj.edit6:setMax(5);
    obj.edit6:setName("edit6");

    obj.layout18 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout18:setParent(obj.layout16);
    obj.layout18:setAlign("top");
    obj.layout18:setWidth(90);
    obj.layout18:setHeight(25);
    obj.layout18:setMargins({top = 5});
    obj.layout18:setName("layout18");

    obj.label14 = GUI.fromHandle(_obj_newObject("label"));
    obj.label14:setParent(obj.layout18);
    obj.label14:setAlign("left");
    obj.label14:setText("Unidade");
    obj.label14:setMargins({left = 5});
    obj.label14:setName("label14");

    obj.edit7 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit7:setParent(obj.layout18);
    obj.edit7:setAlign("left");
    obj.edit7:setWidth(300);
    obj.edit7:setField("unidades");
    obj.edit7:setHint("Nome=Valor,Nome=Valor ou Valor,Valor");
    obj.edit7:setName("edit7");

    obj.layout19 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout19:setParent(obj.layout15);
    obj.layout19:setAlign("right");
    obj.layout19:setWidth(200);
    obj.layout19:setHeight(60);
    obj.layout19:setName("layout19");

    obj.layout20 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout20:setParent(obj.layout19);
    obj.layout20:setAlign("top");
    obj.layout20:setWidth(90);
    obj.layout20:setHeight(25);
    obj.layout20:setMargins({top = 5});
    obj.layout20:setName("layout20");

    obj.button12 = GUI.fromHandle(_obj_newObject("button"));
    obj.button12:setParent(obj.layout20);
    obj.button12:setAlign("left");
    obj.button12:setText("Rolar");
    obj.button12:setWidth(60);
    obj.button12:setMargins({left=10});
    obj.button12:setName("button12");

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

    obj.button13 = GUI.fromHandle(_obj_newObject("button"));
    obj.button13:setParent(obj.layout21);
    obj.button13:setAlign("left");
    obj.button13:setText("Revelar Valores");
    obj.button13:setWidth(180);
    obj.button13:setMargins({left=10});
    obj.button13:setName("button13");

    obj.label15 = GUI.fromHandle(_obj_newObject("label"));
    obj.label15:setParent(obj.layout14);
    obj.label15:setAlign("bottom");
    obj.label15:setText("Descrição");
    obj.label15:setMargins({left = 5});
    obj.label15:setName("label15");

    obj.textEditor1 = GUI.fromHandle(_obj_newObject("textEditor"));
    obj.textEditor1:setParent(obj.layout14);
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

    obj.layout22 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout22:setParent(obj.layout2);
    obj.layout22:setAlign("top");
    obj.layout22:setHeight(25);
    obj.layout22:setName("layout22");

    obj.label16 = GUI.fromHandle(_obj_newObject("label"));
    obj.label16:setParent(obj.layout22);
    obj.label16:setAlign("left");
    obj.label16:setText("Grimório");
    obj.label16:setWidth(100);
    obj.label16:setHeight(25);
    lfm_setPropAsString(obj.label16, "fontStyle",  "bold");
    obj.label16:setName("label16");

    obj.button14 = GUI.fromHandle(_obj_newObject("button"));
    obj.button14:setParent(obj.layout22);
    obj.button14:setAlign("left");
    obj.button14:setLeft(10);
    obj.button14:setText("Copiar Grimório");
    obj.button14:setWidth(150);
    obj.button14:setHeight(25);
    obj.button14:setMargins({left = 10});
    obj.button14:setName("button14");

    obj.button15 = GUI.fromHandle(_obj_newObject("button"));
    obj.button15:setParent(obj.layout22);
    obj.button15:setAlign("left");
    obj.button15:setLeft(10);
    obj.button15:setText("Colar no Grimório");
    obj.button15:setWidth(150);
    obj.button15:setHeight(25);
    obj.button15:setMargins({left = 10});
    obj.button15:setName("button15");

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

    obj._e_event1 = obj.progressBar1:addEventListener("onClick",
        function (_)
            showMessage("Vigor: " .. sheet.vigor .. "/" .. sheet.vigorMax)
        end, obj);

    obj._e_event2 = obj.button1:addEventListener("onClick",
        function (_)
            Dialogs.confirmOkCancel("Deseja resetar o vigor(".. sheet.vigorMax ..")?",
                                    function (confirmado)
                                        if confirmado then
                                            sheet.vigor = sheet.vigorMax
                                        end
                                    end)
        end, obj);

    obj._e_event3 = obj.button2:addEventListener("onClick",
        function (_)
            sig = "🔥"
                                    addSig(sig)
        end, obj);

    obj._e_event4 = obj.button3:addEventListener("onClick",
        function (_)
            sig = "⚡"
                                    addSig(sig)
        end, obj);

    obj._e_event5 = obj.button4:addEventListener("onClick",
        function (_)
            sig = "🎲"
                                    addSig(sig)
        end, obj);

    obj._e_event6 = obj.button5:addEventListener("onClick",
        function (_)
            sig = "🌓"
                                    addSig(sig)
        end, obj);

    obj._e_event7 = obj.button6:addEventListener("onClick",
        function (_)
            sig = "👊"
                                    addSig(sig)
        end, obj);

    obj._e_event8 = obj.button7:addEventListener("onClick",
        function (_)
            sig = "💫"
                                    addSig(sig)
        end, obj);

    obj._e_event9 = obj.button8:addEventListener("onClick",
        function (_)
            sig = "🎱"
                                    addSig(sig)
        end, obj);

    obj._e_event10 = obj.button9:addEventListener("onClick",
        function (_)
            sig = "☔"
                                    addSig(sig)
        end, obj);

    obj._e_event11 = obj.btn1:addEventListener("onClick",
        function (_)
            btnNum = 1
                                    removeSig(btnNum)
        end, obj);

    obj._e_event12 = obj.btn2:addEventListener("onClick",
        function (_)
            btnNum = 2
                                    removeSig(btnNum)
        end, obj);

    obj._e_event13 = obj.btn3:addEventListener("onClick",
        function (_)
            btnNum = 3
                                    removeSig(btnNum)
        end, obj);

    obj._e_event14 = obj.btn4:addEventListener("onClick",
        function (_)
            btnNum = 4
                                    removeSig(btnNum)
        end, obj);

    obj._e_event15 = obj.btn5:addEventListener("onClick",
        function (_)
            btnNum = 5
                                    removeSig(btnNum)
        end, obj);

    obj._e_event16 = obj.button10:addEventListener("onClick",
        function (_)
            local btns = {self.btn1, self.btn2, self.btn3, self.btn4, self.btn5}
                            local s = ""
                            for i=1, 5, 1 do
                                s = s .. btns[i].text
                            end
                            if s == "" then
                                showMessage("Nenhum Signo na magia.")
                            else
                                local magics = NDB.getChildNodes(sheet.magics)
                                local flag = true
                                for i=1, #magics, 1 do
                                    if magics[i].sequencia == s then
                                        flag = false
                                        break
                                    end
                                end
                                if flag then
                                    local node = self.grimorio:append()
                                    node.sequencia = s
                                    self.grimorio:sort()
                                else
                                    showMessage("Mágica já escrita no Grimório.")
                                end
                            end
        end, obj);

    obj._e_event17 = obj.button11:addEventListener("onClick",
        function (_)
            Dialogs.choose("Escolha o Signo.", {"🔥 - Calor","⚡ - Disrupção","🎲 - Engano","🌓 - Equilíbrio","👊 - Força","💫 - Imaterial","🎱 - Material","☔ - Proteção"},
                                function(selected, selectedIndex, selectedText)
                                    if selected == false then 
                                        showMessage("Operação cancelada.")
                                    else
                                        local sig = selectedIndex
                                        Dialogs.choose("Escolha o Level.", {"0","1","2","3","4","5","6"},
                                            function(selected2, selectedIndex2, selectedText2)
                                                if selected2 == false then 
                                                    showMessage("Operação cancelada.")
                                                else
                                                    local level = selectedIndex2
                                                    local qnts = {4, 3, 5, 7, 9, 11, 100}
                                                    local choises = {}
                                                    for i=0, qnts[level]-1, 1 do
                                                        table.insert(choises, "" .. i)
                                                    end
                                                    Dialogs.choose("Escolha a quantidade de XP.", choises,
                                                        function(selected3, selectedIndex3, selectedText3)
                                                            if selected3 == false then 
                                                                showMessage("Operação cancelada.")
                                                            else
                                                                local text = selectedText2 .. ": " .. selectedText3 .. "/" .. qnts[level]
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

    obj._e_event18 = obj.button12:addEventListener("onClick",
        function (_)
            local node = self.grimorio.selectedNode
                                                            if node ~= nil then
                                                                trySpell()
                                                            end
        end, obj);

    obj._e_event19 = obj.button13:addEventListener("onClick",
        function (_)
            local node = self.grimorio.selectedNode
                                                            if node ~= nil then
                                                                if node.rolagem ~= nil then
                                                                    revealResult(node.rolagem)
                                                                    node.rolagem = nil
                                                                else
                                                                    showMessage("Nenhuma magia preparada.")
                                                                end
                                                            end
        end, obj);

    obj._e_event20 = obj.button14:addEventListener("onClick",
        function (_)
            copyAll()
        end, obj);

    obj._e_event21 = obj.button15:addEventListener("onClick",
        function (_)
            pasteAll()
                                    self.grimorio:sort()
        end, obj);

    obj._e_event22 = obj.grimorio:addEventListener("onSelect",
        function (_)
            local node = self.grimorio.selectedNode
                                    self.magicDesc.node = node
        end, obj);

    obj._e_event23 = obj.grimorio:addEventListener("onCompare",
        function (_, nodeA, nodeB)
            a = nodeA.sequencia or ""
                                    b = nodeB.sequencia or ""
                                    return sortSig(a, b)
        end, obj);

    function obj:_releaseEvents()
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
        if self.label14 ~= nil then self.label14:destroy(); self.label14 = nil; end;
        if self.button3 ~= nil then self.button3:destroy(); self.button3 = nil; end;
        if self.label1 ~= nil then self.label1:destroy(); self.label1 = nil; end;
        if self.layout4 ~= nil then self.layout4:destroy(); self.layout4 = nil; end;
        if self.button15 ~= nil then self.button15:destroy(); self.button15 = nil; end;
        if self.layout15 ~= nil then self.layout15:destroy(); self.layout15 = nil; end;
        if self.layout10 ~= nil then self.layout10:destroy(); self.layout10 = nil; end;
        if self.button7 ~= nil then self.button7:destroy(); self.button7 = nil; end;
        if self.Functions_Roll ~= nil then self.Functions_Roll:destroy(); self.Functions_Roll = nil; end;
        if self.flowLayout3 ~= nil then self.flowLayout3:destroy(); self.flowLayout3 = nil; end;
        if self.flowLayout4 ~= nil then self.flowLayout4:destroy(); self.flowLayout4 = nil; end;
        if self.layout5 ~= nil then self.layout5:destroy(); self.layout5 = nil; end;
        if self.layout17 ~= nil then self.layout17:destroy(); self.layout17 = nil; end;
        if self.edit7 ~= nil then self.edit7:destroy(); self.edit7 = nil; end;
        if self.layout20 ~= nil then self.layout20:destroy(); self.layout20 = nil; end;
        if self.button11 ~= nil then self.button11:destroy(); self.button11 = nil; end;
        if self.flowLayout1 ~= nil then self.flowLayout1:destroy(); self.flowLayout1 = nil; end;
        if self.layout18 ~= nil then self.layout18:destroy(); self.layout18 = nil; end;
        if self.btn2 ~= nil then self.btn2:destroy(); self.btn2 = nil; end;
        if self.button12 ~= nil then self.button12:destroy(); self.button12 = nil; end;
        if self.button6 ~= nil then self.button6:destroy(); self.button6 = nil; end;
        if self.flowPart1 ~= nil then self.flowPart1:destroy(); self.flowPart1 = nil; end;
        if self.button5 ~= nil then self.button5:destroy(); self.button5 = nil; end;
        if self.button2 ~= nil then self.button2:destroy(); self.button2 = nil; end;
        if self.flowPart2 ~= nil then self.flowPart2:destroy(); self.flowPart2 = nil; end;
        if self.layout13 ~= nil then self.layout13:destroy(); self.layout13 = nil; end;
        if self.flowLayout2 ~= nil then self.flowLayout2:destroy(); self.flowLayout2 = nil; end;
        if self.layout3 ~= nil then self.layout3:destroy(); self.layout3 = nil; end;
        if self.label13 ~= nil then self.label13:destroy(); self.label13 = nil; end;
        if self.layout8 ~= nil then self.layout8:destroy(); self.layout8 = nil; end;
        if self.layout1 ~= nil then self.layout1:destroy(); self.layout1 = nil; end;
        if self.label10 ~= nil then self.label10:destroy(); self.label10 = nil; end;
        if self.button10 ~= nil then self.button10:destroy(); self.button10 = nil; end;
        if self.rectangle1 ~= nil then self.rectangle1:destroy(); self.rectangle1 = nil; end;
        if self.layout2 ~= nil then self.layout2:destroy(); self.layout2 = nil; end;
        if self.grimorio ~= nil then self.grimorio:destroy(); self.grimorio = nil; end;
        if self.layout12 ~= nil then self.layout12:destroy(); self.layout12 = nil; end;
        if self.btn4 ~= nil then self.btn4:destroy(); self.btn4 = nil; end;
        if self.button1 ~= nil then self.button1:destroy(); self.button1 = nil; end;
        if self.adminTab ~= nil then self.adminTab:destroy(); self.adminTab = nil; end;
        if self.edit4 ~= nil then self.edit4:destroy(); self.edit4 = nil; end;
        if self.label8 ~= nil then self.label8:destroy(); self.label8 = nil; end;
        if self.label11 ~= nil then self.label11:destroy(); self.label11 = nil; end;
        if self.layout11 ~= nil then self.layout11:destroy(); self.layout11 = nil; end;
        if self.label3 ~= nil then self.label3:destroy(); self.label3 = nil; end;
        if self.label4 ~= nil then self.label4:destroy(); self.label4 = nil; end;
        if self.label6 ~= nil then self.label6:destroy(); self.label6 = nil; end;
        if self.layout9 ~= nil then self.layout9:destroy(); self.layout9 = nil; end;
        if self.textEditor1 ~= nil then self.textEditor1:destroy(); self.textEditor1 = nil; end;
        if self.button9 ~= nil then self.button9:destroy(); self.button9 = nil; end;
        if self.edit5 ~= nil then self.edit5:destroy(); self.edit5 = nil; end;
        if self.btn1 ~= nil then self.btn1:destroy(); self.btn1 = nil; end;
        if self.button13 ~= nil then self.button13:destroy(); self.button13 = nil; end;
        if self.edit6 ~= nil then self.edit6:destroy(); self.edit6 = nil; end;
        if self.label15 ~= nil then self.label15:destroy(); self.label15 = nil; end;
        if self.body ~= nil then self.body:destroy(); self.body = nil; end;
        if self.label7 ~= nil then self.label7:destroy(); self.label7 = nil; end;
        if self.button8 ~= nil then self.button8:destroy(); self.button8 = nil; end;
        if self.label2 ~= nil then self.label2:destroy(); self.label2 = nil; end;
        if self.edit3 ~= nil then self.edit3:destroy(); self.edit3 = nil; end;
        if self.label5 ~= nil then self.label5:destroy(); self.label5 = nil; end;
        if self.layout6 ~= nil then self.layout6:destroy(); self.layout6 = nil; end;
        if self.label12 ~= nil then self.label12:destroy(); self.label12 = nil; end;
        if self.magicDesc ~= nil then self.magicDesc:destroy(); self.magicDesc = nil; end;
        if self.progressBar1 ~= nil then self.progressBar1:destroy(); self.progressBar1 = nil; end;
        if self.btn3 ~= nil then self.btn3:destroy(); self.btn3 = nil; end;
        if self.layout22 ~= nil then self.layout22:destroy(); self.layout22 = nil; end;
        if self.layout14 ~= nil then self.layout14:destroy(); self.layout14 = nil; end;
        if self.layout16 ~= nil then self.layout16:destroy(); self.layout16 = nil; end;
        if self.layout21 ~= nil then self.layout21:destroy(); self.layout21 = nil; end;
        if self.button14 ~= nil then self.button14:destroy(); self.button14 = nil; end;
        if self.btn5 ~= nil then self.btn5:destroy(); self.btn5 = nil; end;
        if self.label16 ~= nil then self.label16:destroy(); self.label16 = nil; end;
        if self.grimorioInv ~= nil then self.grimorioInv:destroy(); self.grimorioInv = nil; end;
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
