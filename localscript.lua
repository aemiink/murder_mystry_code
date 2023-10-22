--> ReplicatedStorage'i de bir değişken içerisinde depolamam lazım
local repStorage = game:GetService("ReplicatedStorage")
--> ZamanDegerini bir değişken içerisinde depolamam lazım
local zamanDegeri = repStorage:WaitForChild("ZamanDegeri")
--> DurumDegerini de bir değişken içerisinde depolamam lazım.
local durumDegeri = repStorage:WaitForChild("DurumDegeri")
-->GUI
local GUI = script.Parent
--> GUI'nin içerisinde yer Text Label
local durumTablosu = GUI:WaitForChild("DurumTablosu")


--> Fonksiyon saniyeleri dakikaya çevirecek bir fonksiyon.
function saniyedenDakikayaCeviri(saniye)
	--> saniyeleri 60'a bölersek sonuç bize dakikayı verir.
	local dakikalar = saniye / 60
	--> Kalan saniyeyi bulabilmek için tüm saniyeleri 60'a böler kalanı alırız.
	--> % işareti belirlediğimiz sayıyı 60'a böler ve kalanı alır.
	--> math.floor() fonksiyonu ise matematiksel işlemleri yaparken aynı anda birden fazla işlem yaptığımızı belirler.
	local kalanSaniyeler = math.floor(saniye % 60)
	--> Her seferinde bu değerler değişeceği için bu fonksiyonu döndürmeliyiz.
	--> return: anahtar kelimesi bir fonksiyonu dödnür.
	--> tostring() fonksiyonu int olan bir değeri yazısal bir değere dönüştürür 
	return tostring(dakikalar) .. ":" .. kalanSaniyeler
end

--> Durum Tablosunu güncelleyebilmek için yeni bir fonksiyon oluşturdum.
function durumTablosunuGuncelleme()
	-->Eğer benim ZamanDegeri'm 0'dan küçükse
	if zamanDegeri.Value < 0 then
		--> durumTablosu'nun yazısını durum Değerine eşitle.
		durumTablosu.Text = durumDegeri.Value
	--> Değilse
	else
		--> durumTablosunun yazısını durum değeri + saniyedendakakayaceviren fonksiyonun sayısına eşitle.
		durumTablosu.Text = durumDegeri.Value .. "(" .. saniyedenDakikayaCeviri(zamanDegeri.Value) .. ")"
	end
end

zamanDegeri.Changed:Connect(durumTablosunuGuncelleme)
durumDegeri.Changed:Connect(durumTablosunuGuncelleme)
durumTablosunuGuncelleme()