# 만국박람회 

> 프로젝트 기간 : 2022-04-11 ~ 2022-04-22
팀원 : 사파리(@saafaaari), papri(@papriOS) / 리뷰어 : 혀나노나(@hyunable)

## 프로젝트 소개

> JSON 포멧의 데이터와 매칭할 모델 타입을 구현하고 데이터를 파싱하여 View에 표시
TableView의 전반적 동작 구현 , ViewController간 데이터를 전달
Auto Layout 적용과 Dynamic Type을 통한 Accessibility 향상

### 구현 화면


<img src="https://user-images.githubusercontent.com/91936941/164646628-f7fa6066-e45a-4654-825c-049794a3603b.gif" width="300">

### 접근성

<img src="https://i.imgur.com/dZNUDB1.gif" width="600">

## PR

[STEP1](https://github.com/yagom-academy/ios-exposition-universelle/pull/142)

[STEP2](https://github.com/yagom-academy/ios-exposition-universelle/pull/153)

[STEP3](https://github.com/yagom-academy/ios-exposition-universelle/pull/161)


## 개발환경 및 라이브러리

[![swift](https://img.shields.io/badge/swift-5.0-orange)]()
[![xcode](https://img.shields.io/badge/Xcode-13.1-blue)]()
[![iOS](https://img.shields.io/badge/iOS-15.0-red)]()

## 키워드
`MVC` `JSONDecoder` `UITableView` `CustomCell` `ReusableCell` `UIListContentConfiguration` `UnitTest` `Bundel` `DataSource & Delegate` `Accessibility & Dynamic Types` `AutoLayout` `NavigationController` `NSMutableAttributedString` `NSCoder &  NSCoding` `DI(Dependency Injection)` `NumberFormatter`

## 구현내용
- Bundle를 이용한 JSON파일 접근
- JSON파일을 Decoding하여 Model생성
- MVC Design Pattern 적용
- NSMutableAttributedString이용한 특정 Text속성 변경
- Segue및 NavigationController를 이용한 화면 전환
- AutoLayout 적용하여 다양한 기기 대응
- UITableViewController및 CustomCell을 이용한 작품 목록화면 구현
- JSON Data를 Parsing하여 TableView에 표시
- Dynamic Types를 이용한 Accessibility 향상

## 학습내용
- Decodable프로토콜을 이용한 JSON파일 Decoding
- CodingKey를 이용한 데이터 네이밍 변환 
- NSMutableAttributedString타입을 이용한 특정 Text속성 변경
- TableViewDataSource와 TableViewDelegate의 역할
- ReusableCell의 이해
- ViewController간 데이터 전달 및 Initializer를 이용한 의존성 주입(Dependency Injection)
- init? 초기화 구문과 required init 초기화 구문의 이해
- NSCoder &  NSCoding의 이해
- 특정화면 가로세로화면 고정
- AutoLayout 적용과 이해
- Accessibility 향상과 이해



## 고민한 점 및 해결 
> 선택된 해결 방안은 Bold체로 쓰여져 있습니다


### JSON 파일 decode하는 제네릭한 함수 구현 방법
- **Decodable 프로토콜 확장**
- 제네릭을 이용한 DecodeManager의 타입 구현
 
이번 프로젝트에서 두 타입에 대한 Decoding를 해야하는데 두 타입 모두 공용으로 사용할 수 있는 Parsing 메서드 구현 방법을 고민하였다. 하나는 제네릭 타입을 활용하여 들어올 타입을 추상화하는 방법이였고, 하나는 두 타입 모두 `Decodable` 프로토콜을 채택했기 때문에 `Decodable`를 `extension`하여 기본 구현을 하는 방법을 고민했다. 프로젝트 팀원과 캠프 동기끼리 생각을 공유하며 결과적으로

```swift
extension Decodable {
   static func parsingJson(name: String) -> Self? {
        guard let path = Bundle.main.path(forResource: name, ofType: "json") else { return nil }
        guard let jsonString = try? String(contentsOfFile: path) else { return nil }
        guard let data = jsonString.data(using: .utf8) else { return nil }
        let jsonDecoder = JSONDecoder()
        
        return try? jsonDecoder.decode(Self.self, from: data)
    }
}
```
위와 같이 `Decodable`를 확장하여 기본구현을 하는 방법을 선택했다.


---

### JSON 파일 decode하는 코드의 위치
- **data에 관한 기능이기에 Model에 위치**
- NSDataAsset 타입이 UIKit에 정의되어 있기에 Controller에 위치

JSON파일을 읽어올 때 `NSDataAsset`를 이용하였다. 하지만, 이를 Model에 구현하려고 하니 `NSDataAsset`가 UIKit에 구현되어 있어 Model에 적합한지 ViewController에 적합한지 팀원과 많은 고민과 얘기를 나눴다. 그 결과 `Bundle`를 이용하여 JSON파일을 읽어오는 방법을 알았고, 결과적으로 Model에 위치했다.

---
### 로컬 JSON파일에 접근하는 방법
- NSDataAsset
- **Bundle.main.path(string path를 얻음)**/ Bundle.main.url(URL을 얻음)로 파일 위치를 찾아서 접근

---

### TableView의 Cell의 데이터를 표시하는 방법
- `itemCell.defaultContentConfiguration()`
- **`CustomCell`**

처음엔 cell의 Label과 Image에 직접 접근해서 data를 입력했다. 하지만, Deprecated된다는 Warning를 마주할 수 있었다. 때문에 iOS14 버전에 나온 `defaultContentConfiguration()`를 이용하였다. 하지만, 아직 iOS14이하 버전이 사용자들에게 널리 사용된다는 리뷰를 받아, 

```swift
guard let itemCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TableViewCell else { return UITableViewCell() }
        
itemCell.itemTitleLebel.text = itemsList?[indexPath.row].title
itemCell.itemImageView.image = UIImage(named: itemsList?[indexPath.row].imageName ?? "swift")
itemCell.itemShortDescriptionLabel.text = itemsList?[indexPath.row].shortDescription
```
위와 같이 `CustomCell`를 이용하여 모든 버전에 사용할 수 있도록 구현하였다.

---
###  TableViewController에서 itemDetailViewController로 데이터를 전달하는 방법
- itemDetailViewController에서 item을 굳이 들고 있지 않아도 되는 상황(item이라는 변수가 ui에 바인딩 되고 나서는 다른곳에서 변경되거나 쓰이지 않고 있기 때문)을 고려하여, itemDetailViewController에 item property를 부여하지 않고 다음과 같은 코드를 추가한다
    ```swift
    private func setUpView(item: Heritage) {
            title = item.title
            itemImageView.image = UIImage(named: item.imageName)
            ItemDescriptionLabel.text = item.description
        }
    ```
- **itemDetailViewController의 지정 이니셜라이저를 구현하여, TableViewController에서 itemDetailViewController의 인스턴스를 생성해 navigation controller로 화면 전환이 이루어질때 데이터가 전달될 수 있도록 구현한다**
```swift
//ItemDetailViewController의 Initializer
    init?(item: Heritage, coder: NSCoder) {
        self.item = item
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        self.item = Heritage(title: "데이터 입력 실패", imageName: "swift", shortDescription: "데이터 입력 실패", description: "데이터 입력 실패")
        super.init(coder: coder)
    }

// TableViewController에서 ItemDetailViewController의 인스턴스 생성
    guard let subViewController = self.storyboard?.instantiateViewController(identifier: subViewVCIdentifier,
                                                                             creator: { coder in ItemDetailViewController(item: item, coder: coder) }
                                                                            ) else { return }
```
위 코드를 이용하여 데이터의 인스턴스를 외부에서 Initializer를 이용하여 주입했다.

---
###  버튼 안 content(text)의 높이에 따라 버튼을 포함하고 있는 stackView의 높이를 늘리는 방법

---

### 특정 ViewController 화면 고정
