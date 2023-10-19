-------------------------------------------------------------------------Değişken-------------------------------------------------------

--> Değişken = local anahtar kelimesi kullanırız genellikle. Bilgisayarın hafızasında tuttuğu referanslardır. İstediğimiz yrde kullanırız.

--> 1. HaritaTutucu Adındaki klasöre Referans Olacak.
local haritaTutucu = workspace:WaitForChild("HaritaTutucu")
--> 2. ServerStorage'e Referans Olacak.
local sunucuDeposu = game:GetService("ServerStorage")
--> 3. Haritalar adındaki klasöre Referans Olacak.
local haritalar = sunucuDeposu:WaitForChild("Harita")

---------------------------------------------------------------Güncelleme------------------------------------------------------------------

--> ReplicatedStorage adını verdiğim servise bir referans değişken oluşturalım.
local kopyaDeposu = game:GetService("ReplicatedStorage")
--> kopyaDeposu'nun içerisinde bulunan durum değeri adındaki string value'ye referans olacak değişkne
local durumDegeri = kopyaDeposu:WaitForChild("DurumDegeri")
--> kopyaDeposu'nun içerisinde bulunan zaman değeri adındaki int value'ye referans olacak değişkne
local zamanDegeri = kopyaDeposu:WaitForChild("ZamanDegeri")
-->Son olarak oyun süresini belirten bir değişken
local oyunSuresi = 5 * 60

---------------------------------------------------------------Güncelleme 2-------------------------------------------------------------------

--> Lobide Başka oyuncular eğer oyuna katılırsa diye yeni oyuna başlamadan küçük bir bekleme süresi veriyoruz.
local lobiBeklemeSuresi = 30

----------------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------Oyunun Kodları----------------------------------------------------------------

--> Oyunumuz Tamamiyle bir döngü içerisinde geçecek, bu yüzden sonsuz döngü kullanırım.
while true do
	--> Durum Değerini haritanın seçilme durumuna göre ayarladım.
	durumDegeri.Value = "Harita Seçiliyor, Lütfen Bekleyiniz!"
	--> zaman değerini bureada zaman gözükmeyecek şekilde ayarlayacağım.
	zamanDegeri.Value = -1
	--> HaritaTutucu adındaki klasördeki tüm haritları sil.
	haritaTutucu:ClearAllChildren() --> ClearAllChildren() fonksiyonu bir klasörün, modelin içindeki tüm elemanları siler.
	--> Bekleme Süresi 2 Saniye
	wait(2)
	--> Haritalar Adındaki Klasörün içindeki tüm modelleri listeye alıcaz.
	local tumHaritalar = haritalar:GetChildren() --> GetChildren() fonksiyonu bir klasörün ya da modelin içindeki tüm elemanlara ulaşım sağlayıp bir liste içerisine koyar.	
	--> Oluşturuduğumuz Listeden Rastgele bir Harita Seçecez.
	local yeniHarita = tumHaritalar[math.random(1 , #tumHaritalar)]:Clone() --> math.random() fonksiyonu rastgele sayı belirler. # işareti ise bir listenin içerisindeki eleman sayısına ulaşmamızı sağlar.
	--> Seçilen Haritanın Parentini belirle
	yeniHarita.Parent = workspace.HaritaTutucu
	--> Haritanın Tamamının Yüklenmesi İçin 20 Saniye Bekleme Süresi 
	wait(20)

	--> Oyuncuların Oyuna Girebilmesi İçin Gerekli Olan Bir Sonsuz Döngü Oluşturmamız Lazım.
	while true do
		--> en az bir oyuncu gelmesi için 5 saniye bekle
		wait(5)
		
		--> Durum Değerini oyuncuların oyuna girme durumuna göre ayarladım.
		durumDegeri.Value = "Oyuncular Bekleniyor, En Az 3 Oyuncu Olana Kadar Bekleyiniz!"
		--> zaman değerini bureada zaman gözükmeyecek şekilde ayarlayacağım.
		zamanDegeri.Value = -1
		
		--> Toplam oyuncuları bir listeye almamız ki kaç tane oyuncu oyuna girmiş görebilelim.
		oyuncular = {}
		-- Oyuna giren tüm oyuncuları saklayan bir oyuncu değişkeni oluşturma
		-- Her katılımcı için aşağıdakileri yapacağız
		for i, oyuncu in pairs(game.Players:GetPlayers()) do
			-- Oyuncular adlı lısteyi oyuncuyu ekle
			table.insert(oyuncular,oyuncu)
		end
		if #oyuncular >= 3 then
			--> Döngüyü Bitiren Komutu Yaz
			break
		end
	end
	
	--> Durum Değerini oyunun başlama durumuna göre ayarladım.
	durumDegeri.Value = "Oyundasınız! Kalan Süre:"
	--> zaman değerini bureada zaman gözükmeyecek şekilde ayarlayacağım.
	zamanDegeri.Value = oyunSuresi
	
	--> Avcıyı Rastgele Belirle
	avci = oyuncular[math.random(1,#oyuncular)]
	-->Şerifin Seçilmesi İçin Bir Sonsuz Döngü 
	while true do
		-->Rastgele Oyuncu Seç.
		rastgeleOyuncu = oyuncular[math.random(1,#oyuncular)]
		--> Rastgele oyuncum eğer avcıma eşit değilse
		if rastgeleOyuncu ~= avci then
			--> Şerif Rastgele Oyuncu olarak
			serif = rastgeleOyuncu
			--> Döngüyü Bitiren Komutu Yaz
			break
		end
	end
	--> DogmaNoktalari adını verdiğimiz klasörü referans olarak bir değişkenin içerisine kaydettik.
	local dogmaNoktalari = yeniHarita:WaitForChild("DogmaNoktalari")
	--> DogmaNoktalari adini verdiğimiz klasörün içindeki elemanları bir liste haline getirmemiz lazım.
	local spawns = dogmaNoktalari:GetChildren() --> GetChildren() fonksiyonu bir klasörün ya da modelin içindeki tüm elemanlara ulaşım sağlayıp bir liste içerisine koyar.	
	
	--> Oyunun içerisinde bulunan tüm oyuncuları bulmamız gerekir.
	--> Bunuda yaparken for dongüsünü kullanırız.
	--> in pairs() fonksiyonu herhangi bir nesneyi nereden alacağımızı söylerken kullanılır.
	for i, oyuncu in pairs(oyuncular) do
		--> Eğer oyuncu var ise ve oyuncunun Karakteri de varsa ve spawns'ın sayısı 0'dan büyükse
		if oyuncu and oyuncu.Character and #spawns > 0 then
			--> Oyun içerisinde bulunan karkaterimzden(Model) içinden "HumanoidRootPart" adındaki nesneyi almamız gerekiyor
			-->:WaitForChild() fonksiyonu herhangi bir modelin içerisinden bir nesneyi almamızı sağlar.
			local humanoidrootpart = oyuncu.Character:WaitForChild("HumanoidRootPart")
			--> Rastgele bir eleman sayısı (index) belirlemem gerekir bunu da bir değişkene kaydedeceğim.
			--> math.random() rastgele bir sayı belirlememi sağlar
			--> # sembölü bir listenin içerisindeki eleman sayısını belirlemek için kullanılır.
			local spawnindex = math.random(1, #spawns)
			--> Spawns adını verdiğim listeden yukarıda belirlediğin sıra numarasına göre bir tane spawn seçmesini istiyorum
			--> spawns içerisindeki bir sıra numarasını belirlemek istiyorsak [] bu indeks numarasını belirlememizi sağlar.
			local spawn = spawns[spawnindex]
			
			--> Eğer humanoidrootpart varsa ve spawn varsa
			if humanoidrootpart and spawn then
				--> tablodan spawnindex'i rastgel seçilmiş olan spawn'ı kaldırıcağız.
				table.remove(spawns, spawnindex)
				-->RootPart'ın yerini Spawn ile değiştiricez.
				-->Işınlama İşlemini yaparken CFrame adını verdiğim bir kavramı kullanırız.
				humanoidrootpart.CFrame = CFrame.new(spawn.Position + Vector3.new(0,3,0))
				
				--> Oyuncuların oyunda olduğunu belirleyecek olan bir nesnedir.
				local eslesme = Instance.new("StringValue")
				eslesme.Name = "Eşleşme"
				eslesme.Parent = oyuncu.Character
				
				--> Oyuncumuzun içerisinde bulunan sırtçantasını bir değişkene kaydettik
				local sirtCantasi = oyuncu:FindFirstChild("Backpack")
				
				-->Eğer Sırtçantası varsa
				if sirtCantasi then
					--> aynı zamanda eğer oyuncum avcıysa
					if oyuncu == avci then
						--> Kılıcı vermem lazım.
						--> :WaitForChild() fonksiyonu herhangi bir modelin içerisinden bir nesneyi almamızı sağlar.
						--> :Clone() fonksiyonunu kullanarak oluşturduğum kılıcı duplicate yapıyoruz.
						local kilic = sunucuDeposu:WaitForChild("SwordKodland2022"):Clone()
						kilic.Parent = sirtCantasi
					elseif oyuncu == serif then
						--> 	Netkodland vermem lazım.
						--> :WaitForChild() fonksiyonu herhangi bir modelin içerisinden bir nesneyi almamızı sağlar.
						--> :Clone() fonksiyonunu kullanarak oluşturduğum kılıcı duplicate yapıyoruz.
						local silah = sunucuDeposu:WaitForChild("NetKodland"):Clone()
						silah.Parent = sirtCantasi
					
					end
				end
			end
		end
	end
	--> :Remove() fonksiyonu herhangi belirtilen nesneleri oyundan kaldırımayı sağlar.
	dogmaNoktalari:Remove()
	--> Sonlu while döngüsünü kullanarak bir sayac oluşturuyorum
	local sayac = oyunSuresi
	--> Sonsuz döngüyü oluşturuyoruz.
	while sayac > 0 do
		-->Bekleme süresi veriyoruz döngünün bir saniyede bir tekrar etmesi için.
		wait(1)
		-->sayac değerinden bir çıkarıtıyoruz.
		sayac = sayac - 1
		--> Zaman değerinin değerini sayac olarak ayarlıyorum.
		zamanDegeri.Value = sayac

		--> Aktif Oyuncuları depolayan bir liste(array) oluştururuz.
		--> {} --> boş bir dizininin oluşturulduğunu belirtir.
		--> Dizi kavramı içerisinde birden fazla eleman(veri) bulunduran değişken tipidir.
		aktifOyuncular = {}
		--> Avcının hala oyunda olup olmadığını belirten bir mantıksal veri tipinde değer oluştururuz.
		--> true veya false veri değerine sahip olan değişkenlerin veri tipi boolean'dır.
		avciOyundami = false
		
		--> Dizimizi aktif oyuncuların bilgileri ile doldurmalıyız. Bu bilgiler sayesinde oyuncualrın oyunda olup olmadığını kontrol edeceğiz.
		--> Kontrol sağlayabilmek için for döngüsünü kullanacağız.
		--> for dongüleri belirlediğimiz klasörün içindeki elemanları döndüren bir döngüdür.
		for i, oyuncu in pairs(oyuncular) do
			--> İlk önce oyuncumuzuzun oyun içerisindeki modelini tanıtmamız gerekiyor.Bunun nedeni içindeki nesnelere erişim sağlamamız lazım.
			local karakter = oyuncu.Character
			--> Oyuncu karakterinin içerisinde, haritaya ışınlandıktan sonra oluşan "Eşleşme" adındaki nesneyi bir değişkene atıyoruz.
			local eslesmeNesnesi = karkater:FindFirstChild("Eşleşme")
			--> Oyuncu karakterinin içerisinde var olan "Humanoid" değerini bir değişkene atıyoruz.
			local humanoid = karakter:FindFirstChild("Humanoid")

			--> Eğer Eslesme Nesnesi varsa ve humanoid'in sağlık değeri 0'dan büyükse
			if eslesmeNesnesi and humanoid.Health > 0 then
				--> Aynı zamanda eğer Avcı oyuna dahil ise avcının oyunda olduğunu da belirtmemiz gerekir..
				if oyuncu == avci then
					--> Oluşturduğumuz avciOyundami değişkenini true olarak değiştiriyoruz bu bağlamda
					avciOyundami = true
				end
				--> Yukarıda oluşturduğumuz şartlar karşılanıyorsa aktif oyuncular adlı diziye oyuncuları ekleyebiliriz.
				table.insert(aktifOyuncular, oyuncu)	
			end
		end 
		--1 (veya daha az) aktif oyuncu kaldıysa veya oyuncular arasında avcı yoksa maçtan sorumlu döngüyü durdurun.
		if #aktifOyuncular <= 1 or not avciOyundami then
			--> break komutu bir döngüyü durdurur. 
			break
		end	
	end
	--> Lobide bulunan doğma noktalarının bir dizisini oluşturuyoruz.
	--> {} --> boş bir dizininin oluşturulduğunu belirtir
	local spawnNoktalari = {}
	--> spawnNoktalari adindaki diziyi doldurmak için bir for dongüsü oluşturuyoruz.
	--> for dongüleri belirlediğimiz klasörün içindeki elemanları döndüren bir döngüdür.
	--> isinlanmaNoktasi adlı değişkeni lobi içerisindeki elemanlarda arıyoruz.
	for i, isinlanmaNoktasi in pairs(workspace:WaitForChild("Lobi"):GetChildren()) do
		--> Lobide ışınlanma noktalarının haricinde bir sürü eleman mevcut.
		--> Bu bağlamda isinlanmaNoktasi'nin ismi SpawnLocation'a eşitse diye bir şart getiriyoruz.
		if isinlanmaNoktasi == "SpawnLocation" then
			--> SpawnNoktalari adındaki dizimize isnlanmaNoktalarini ekliyoruz.
			table.insert(spawnNoktalari, isinlanmaNoktasi)
		end
	end

	--> Oyuncular öldükten sonra silahlarla avcı ve şerifin elinde silahla lobiye dönmesini istemeyiz.
	--> Bu bağlamda oyuncular silahlarını devre dışı bırakarak sırt çantalarına kaldırıyoruz.
	for i, oyuncu in pairs(aktifOyuncular) do
		--> ilk önce oyuncumuzun karkaterinde bulunan humanoid nesnesini arıyoruz
		local humanoid = oyuncu.Character:FindFirstChild("Humanoid")
		--> Ardından eğer oyuncunun humanoidi varsa
		if humanoid then
			-->humanoidin elinde bulunan araçları(silah veya kılıç) elinden alıp sırt çantasına koyuyoruz.
			humanoid:UnequipTools()
		end

		--> Artık oyuncuları lobiye tekrar ışınlama zamanı!
		--> Rastgele bir spawn noktasını seçmek için bir değişken oluşturup kullanıyoruz
		--> Daha önce doldurduğumuz spawnNoktalari adindaki listenin içinden rastgele seçeceğiz. 
		--> [] = işareti bir sıra numarası belirtir. Bu indeks anlamına gelir.
		--> # işareti ise önek aldığı listenin içerisindeki eleman sayısını belirler.
		local rastgeleDogmaNoktasi = [math.random(1, #spawnNoktalari)]
		--> Oyuncuları lobiden rastgele seçtiğimiz spawn'a taşıyoruz.
		--> MoveTo() fonksiyonu oyuncunun modelini belirlediğimiz pozisyona götülmememizi sağlar.
		oyuncu.Character:MoveTo(rastgeleDogmaNoktasi.Position)
		--> Oyuncular Lobiye ışınlandıktan sonra artık sırtçantasına kaldırdığımız silahları silebiliriz.
		--> Bunun için ilk önce oyuncunun sırtçantasını bir değişkene atıyoruz.
		local sirtCantasi = oyuncu:FindFirstChild("Backpack")
		--> Artık şartımızı belirleyebiliriz.
		--> Eğer sirtCantasi varsa
		if sirtCantasi then
			--> Sırt çantasının içindeki tüm elemanları silmesini istiyoruz.
			--> :ClearAllChilderen() Fonksiyonu bu eylemi yapar.
			sirtCantasi:ClearAllChilderen()
		end
	end
	--> Artık Lobideki Zamanlayıcıyı etkinleştirebiliriz.
	--> Daha önce ayarladığımız stringValue(durumDegeri) adındaki değişkenimizin değerini değiştirerek işe başlıyoruz.
	durumDegeri.Value = "Ara! Yeni Oyun için Kalan Süre: "
	--> zamanDeğeri adındaki değişkenimizin değerini ise lobiBeklemeSüresi olarak atayalım.
	zamanDegeri.Value = lobiBeklemeSuresi
	--> Yeni bir değişken oluşturup, sonlu döngümüzü ayarlamak için kullanalım.
	local donguZamanlayicisi = lobiBeklemeSuresi

	--> Artık Sonlu döngümüzü oluşturup, lobiBeklemeSuresi kadar ara vermemizi sağlayalım!
	--> donguZamanlayicisi 0'dan büyükse bu döngü çalışacaktır.
	while donguZamanlayicisi > 0 do
		--> Döngümüz saniye cinsinden belirlediğimiz değer kadar bekleyeceği için sayının 1 saniye 1 azalmasını istiyoruz.
		--> Bu bağlamda 1 saniyelik bekleme süresinin ardından döngü devam edecek.
		--> wait() fonksiyonu bu işi yapar.
		wait(1)
		--> Ardından dongüZamanlayicisindan her bir saniyede bir bir azaltacağız.
		donguZamanlayicisi = donguZamanlayicisi - 1
		--> Arık bu döngününde sonunu getirebiliriz.
		--> Bunun için zamanDeğerimizi her seferinde güncelleyerek GUI üzerinde doğru değeri gösterebilriiz.
		zamanDegeri.Value = donguZamanlayicisi
	end
end





