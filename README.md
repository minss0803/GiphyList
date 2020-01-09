# Giphy Search API App

GIPHY API를 이용해서 GIPHY 애플리케이션의 Search 화면과 Favorites 화면의 기능셋을 구현

## 개발 환경
- minVersion : iOS 10
- targetVersion : iOS 13
- Swift 5
- Xcode 11
- CocoaPods

## 실행 방법
```
1. git clone https://github.com/minss0803/GiphyList.git
2. pod install
3. open GiphyList.xcworkspace
4. Run the application
```
## 화면 구성
**1. 메인화면**
1. Favorites된 이미지의 목록화면 노출
2. Favorites된 리스트를 선택 시, 상세화면을 이동

**2. 검색화면**
1. 키워드를 입력 후, '검색'버튼을 누르면 해당 키워드로 검색함
2. 검색 결과가 리스트에 노출
3. 이미지 리스트를 선택 시, 상세화면으로 이동

**3. 이미지 상세화면**
1. Favorites On/Off 기능 구현

## 외부 라이브러리
### RxSwift + Dependencies
- RxSwift : 선언형 프로그래밍을 구현하는데 사용
- RxCocoa, RxGesture : 뷰 이벤트 Action을 Rx형태로 감지하는데 사용
- RxAppState : viewController의 lifeCycle을 Rx형태로 감지하는데 사용
- RxRealm : Favorite한 목록을 Ream 모델형태로 앱 내에 저장

### Image + Animation + UI
- Kingfisher : 이미지캐시 로딩으 구현하는데 사용
- SnapKit : `오토레이아웃`을 코드로 구현하는데 사용
- Toaster : `토스트 메시지`를 띄우기 위해 사용
- WaterFallLayout : 콜렉션뷰를 폭포수 형태의 Layout으로 구현하는데 사용
