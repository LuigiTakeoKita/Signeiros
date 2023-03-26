require("firecast.lua");
local __o_rrpgObjs = require("rrpgObjs.lua");
require("rrpgGUI.lua");
require("rrpgDialogs.lua");
require("rrpgLFM.lua");
require("ndb.lua");
require("locale.lua");
local __o_Utils = require("utils.lua");

local function constructNew_Functions_Roll()
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
    obj:setName("Functions_Roll");


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
                afterRoll(rolagem)
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

function newFunctions_Roll()
    local retObj = nil;
    __o_rrpgObjs.beginObjectsLoading();

    __o_Utils.tryFinally(
      function()
        retObj = constructNew_Functions_Roll();
      end,
      function()
        __o_rrpgObjs.endObjectsLoading();
      end);

    assert(retObj ~= nil);
    return retObj;
end;

local _Functions_Roll = {
    newEditor = newFunctions_Roll, 
    new = newFunctions_Roll, 
    name = "Functions_Roll", 
    dataType = "", 
    formType = "undefined", 
    formComponentName = "form", 
    title = "", 
    description=""};

Functions_Roll = _Functions_Roll;
Firecast.registrarForm(_Functions_Roll);

return _Functions_Roll;
