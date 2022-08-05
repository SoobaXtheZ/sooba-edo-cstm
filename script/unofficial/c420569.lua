--S-Force ReisenKeiler
function c420569.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x15a),2)
	--attack gain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(s.tgtg)
	e1:SetValue(600)
	c:RegisterEffect(e1)
	--no summone
		local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_MATERIAL)
	e3:SetValue(aux.cannotmatfilter(SUMMON_TYPE_FUSION,SUMMON_TYPE_SYNCHRO,SUMMON_TYPE_XYZ,SUMMON_TYPE_LINK))
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(aux.SecurityTarget)
	c:RegisterEffect(e3)
	--direct attack
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.atkcond)
	e4:SetCost(aux.SecurityForceCost)
	e4:SetTarget(s.atktg)
	e4:SetOperation(s.atkop)
	c:RegisterEffect(e4)
	--cannot be targeted/destroyed
	local eballs=Effect.CreateEffect(c)
	eballs:SetType(EFFECT_TYPE_SINGLE)
	eballs:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	eballs:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	eballs:SetRange(LOCATION_MZONE)
	eballs:SetValue(1)
	c:RegisterEffect(eballs)
	local ebalss=eballs:Clone()
	ebalss:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	ebalss:SetValue(1)
	c:RegisterEffect(ebalss)	
end
s.listed_series={0x15a}
function s.tgtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsSetCard(0x15a) 
end
--direct attack
	function s.atkcond(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
	 function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsAbleToEnterBP() and Duel.GetFlagEffect(tp,id)==0 end
end
	 function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e6=Effect.CreateEffect(e:GetHandler())
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_DIRECT_ATTACK)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x15a))
	e6:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e6,tp)
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end
