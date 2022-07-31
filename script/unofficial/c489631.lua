-- Space Arcade Hub
-- made by B.E.S. Sooba (Based Expert Skylarker)
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCondition(s.actcon)
	c:RegisterEffect(e0)
--Change its name to "Boss Rush"
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
	e1:SetValue(66947414)
	c:RegisterEffect(e1)
	--cannot be targeted
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(s.tgcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--recover
		local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,{id,1})
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
	end
	s.listed_names={66947414}
s.listed_series={0x15}
function s.cfilter(c)
	return c:IsCode(66947414) and not c:IsPublic()
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x15) and not c:IsCode(id)
end
function s.con(e)
	return Duel.IsExistingMatchingCard(s.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
--destroy to recover
function s.tgfilter(c,e,tp)
    return c:IsFaceup() and c:IsSetCard(0x15)
        and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,c)
end
function s.spfilter(c,e,tp,tc)
    return c:IsSetCard(0x15) and c:GetLevel()<=tc:GetLevel() and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.tgfilter(chkc,e,tp) end
   if chk==0 then return Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if not tc:IsRelateToEffect(e) then return end
    local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp,tc)
   if #sc>0 and Duel.SendtoHand(sc,tp,REASON_EFFECT)~=0 then
       Duel.Destroy(tc,REASON_EFFECT)
   end
end
--anti targetting
function s.tgcon(e)
	local tp=e:GetHandlerPlayer()
		return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsSetCard,0x15),tp,LOCATION_MZONE,0,1,nil)
end
--activate
function s.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsSetCard,0x15),tp,LOCATION_MZONE,0,1,nil)
end