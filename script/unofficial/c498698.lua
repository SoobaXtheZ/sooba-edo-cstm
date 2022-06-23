--B.E.S. INTRUDER
--By Sooba
local s,id=GetID()
function s.initial_effect(c)
    c:EnableCounterPermit(0x1f)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_MACHINE),1,1,Synchro.NonTunerEx(Card.IsRace,RACE_MACHINE),1,99)
	c:EnableReviveLimit()
--add from grave
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e1:SetCode(EVENT_SUMMON_SUCCESS)
  e1:SetCountLimit(1,id)
  e1:SetTarget(s.thtg)
  e1:SetOperation(s.thop)
  c:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  c:RegisterEffect(e2)
  --quadruple banish effect
  local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(s.rmop)
	e3:SetOperation(s.rmtg)
	c:RegisterEffect(e3)
 --Add Counter to "B.E.S." monster when Summoned
  local e4=Effect.CreateEffect(c)
  e4:SetCategory(CATEGORY_COUNTER)
  e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCode(EVENT_SUMMON_SUCCESS)
  e4:SetCondition(s.ctcon)
  e4:SetTarget(s.cttg)
  e4:SetOperation(s.ctop)
  c:RegisterEffect(e4)
  local e5=e4:Clone()
  e5:SetCode(EVENT_SPSUMMON_SUCCESS)
  c:RegisterEffect(e5)
end
--Add from grave when synchro'd
function s.thfilter(c)
	return c:IsSetCard(0x15) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
--Add Counter to "B.E.S." monster when Summoned
function s.ctfilter(c,tp)
  return c:IsFaceup() and c:IsSetCard(0x15) and c:IsControler(tp)
end
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
  return eg and eg:IsExists(s.ctfilter,1,nil,tp) and eg:GetFirst()~=e:GetHandler()
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  local ec=eg:FilterCount(s.ctfilter,nil,tp)
  Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,ec,0,0x1f)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local g=eg:Filter(s.ctfilter,nil,tp)
  local tc=g:GetFirst()
  for tc in aux.Next(g) do
    tc:AddCounter(0x1f,1)
  end
end
--Quadruple banish effect
function s.filter(c)
  return c:IsOnField()
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
  if chk==0 then return ct>0 and Duel.IsCanRemoveCounter(tp,LOCATION_MZONE,0,0x1f,1,REASON_COST)
  end
  local cc=Duel.GetCounter(tp,LOCATION_MZONE,0,0x1f)
  local g=Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_ONFIELD,1,5,nil)
  Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,cc,0,0)
  Duel.RemoveCounter(tp,LOCATION_MZONE,0,0x1f,#g,REASON_COST)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
  Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end