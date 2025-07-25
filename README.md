
# 📄 README – Domain Layer (İptal Edildi)

## 🧱 Domain Katmanı Nedir?

**Domain Layer**, Clean Architecture'da uygulamanın iş mantığını barındıran ve uygulama bağımsızlığı sağlayan en önemli katmandır. Bu katman şunları içerir:

- **UseCase** tanımları (örn: `AddToCartUseCase`)
- **Entity** modelleri (örn: `CartEntity`)
- **Repository Abstraction** (örn: `ICartRepository`)

Amaç:
Verinin lokal (örneğin Core Data) mi yoksa uzak sunucu (örneğin REST API) üzerinden mi alınacağına Data katmanı karar verir. App (UI) katmanı sadece ihtiyacını belirtir, verinin nereden geldiğini bilmez.

Bu yapı sayesinde, uygulamanın iş mantığı (UseCase'ler) dış katmanlara (UI, servisler, veri kaynakları gibi) bağımlı olmadan çalışır. Böylece:

Kodlar daha kolay test edilebilir,

Değişen servis ya da veri kaynağına rağmen iş mantığı korunur,

Proje modüler, okunabilir ve sürdürülebilir olur.

## 💡 Neden İptal Edildi?

Bu projede `Domain` katmanı **başlangıçta Clean Architecture prensibine uygun olarak ayrı bir Swift Package olarak yapılandırılmıştır.** Ancak aşağıdaki nedenlerle `App` katmanı içine entegre edilmiştir:

### 🚫 İptal Sebebi

- **Core Data ile Swift Package (SPM) uyumsuzluğu:**  
  Core Data'nın `.xcdatamodeld` dosyası SPM içinde derleme sırasında düzgün şekilde tanınmamaktadır.  
  Bu nedenle `NSEntityDescription` kullanımı `NSInvalidArgumentException` hatası üretmektedir.

- **Çözüm Denemeleri (Challenges):**  
  - `.process()` ile kaynak dahil edilmesi
  - `ModuleName.CartItemEntity` türü tanımlamaları
  - `CoreDataStack` dışarıdan inject edilmesi

  Ancak bunların hiçbiri SPM ortamında güvenilir ve sürdürülebilir bir çözüm üretmemiştir.

## ✅ Sonuç

- `Domain` katmanındaki tüm `UseCase`, `Entity` ve `Interface` tanımları artık doğrudan **`App` katmanına taşınmıştır.**
- Böylece:
  - `CartEntity`, `ProductEntity` gibi domain modeller doğrudan App katmanında barındırılır
  - `UseCase` sınıfları (`execute()` fonksiyonu ile) burada tanımlanır
  - Repository arayüzleri `protocol` olarak App içinde tanımlanır
  - App içindeki servisler (Core Data, API) ile doğrudan bağlantılı UseCase sınıfları oluşturulmuştur

## 📂 Eski Domain Yapısı Örneği

```swift
// ICartUseCase.swift
public protocol ICartUseCase {
    func execute(_ item: CartEntity) -> AnyPublisher<Void, Error>
}
```

```swift
// CartEntity.swift
public struct CartEntity {
    public let id: String
    public let name: String
    public let price: Double
    public let quantity: Int
}
```

## 🧠 Öğrenilen Dersler

- SPM ile `Core Data` kullanımı henüz tam anlamıyla desteklenmemektedir
- `App` katmanında iç içe geçmeyen, saf ve bağımlılıkları net UseCase yapısı daha verimli çalışmaktadır
- `Clean Architecture` prensiplerinden ödün verilmeden, adaptasyon ve esneklik önemlidir

## 📌 Not

> Domain katmanı kaldırılmış olsa da mimari yapı halen Clean Architecture mantığına uygun olarak `App` içerisinde katmanlı şekilde uygulanmıştır.
