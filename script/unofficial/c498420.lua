--B.E.S. Interceptor Cannons
--Made by Sooba 
local s,id=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
	--Counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(s.cttg)
	e2:SetOperation(s.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--Level up
   -- local e2=Effect.CreateEffect(c)
   -- e2:SetType(EFFECT_TYPE_SINGLE)
   -- e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
   -- e2:SetCode(EFFECT_UPDATE_LEVEL)
   -- e2:SetRange(LOCATION_MZONE)
   -- e2:SetValue(s.val)
   -- c:RegisterEffect(e2)
end
s.listed_series={0x15}
function s.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x15)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.thfilter(c)
	return c:IsSetCard(0x15) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
--function s.val(e,c)
 --   return e:GetHandler():GetCounter(0x1f)
---end