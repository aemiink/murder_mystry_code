local kopyaDeposu = game:GetService("ReplicatedStorage")
local durumDegeri = kopyaDeposu:WaitForChild("DurumDegeri")
local zamanDegeri = kopyaDeposu:WaitForChild("ZamanDegeri")
local ekranArayuzu = script.Parent
local durumBasligi = ekranArayuzu:WaitForChild("DurumBasligi")


function saniyedenDakikayaDonusturucu(saniyeler)
	local dakikalar = math.floor(saniyeler / 60)
	local kalanSaniyeler = saniyeler % 60
	return tostring(dakikalar) .. ":" .. kalanSaniyeler
end

function durumBasligiGuncellemesi()
	if zamanDegeri.Value > 0 then
		durumBasligi.Text = durumDegeri.Value
	else
		durumBasligi.Text = durumDegeri.Value .. "(" .. saniyedenDakikayaDonusturucu(zamanDegeri.Value) .. ")"
	end
end

durumDegeri.Changed:Connect(durumBasligiGuncellemesi)
zamanDegeri.Changed:Connect(durumBasligiGuncellemesi)
durumBasligiGuncellemesi()
