
# 사이드카 패치

기존의 오래된 Mac(10.15 카탈리나)과 iPad에 사이드카가 가능합니다

사이드카가 불가능하다고 애플에서 공지한 맥은 아래와 같습니다:
'iMac13,1, iMac13,2, iMac13,3, iMac14,1, iMac14,2, iMac14,3, iMac14,4, iMac15,1, iMac16,1, iMac16,2, MacBook8,1, MacBookAir5,1, MacBookAir5,2, MacBookAir6,1, MacBookAir6,2, MacBookAir7,1, MacBookAir7,2, MacBookPro9,1, MacBookPro9,2, MacBookPro10,1, MacBookPro10,2, MacBookPro11,1, MacBookPro11,2, MacBookPro11,3, MacBookPro11,4, MacBookPro11,5, MacBookPro12,1, Macmini6,1, Macmini6,2, Macmini7,1, MacPro5,1, MacPro6,1'

사이드카가 불가능하다고 공지한 iPad는 아래와 같습니다:
'iPad4,1, iPad4,2, iPad4,3, iPad4,4, iPad4,5, iPad4,6, iPad4,7, iPad4,8, iPad4,9, iPad5,1, iPad5,2, iPad5,3, iPad5,4, iPad6,11, iPad6,12'

여러분은 아래의 스크립트를 입력하여 가지고 있는 Mac의 모델식별자(예를들어 iMac13,1)를 확인할 수 있습니다: `sysctl hw.model`.

여러분은 'Mactracker'란 앱을 사용하여 iPad의 모델 식별자(예를들어 iPad4,1)를 확인할 수 있습니다: [Mactracker (iOS App Store)](https://apps.apple.com/us/app/mactracker/id311421597)

이 스크립트는 macOS에 있는 블랙리스트 실행을 중지합니다. 또한 이 스크립트는 iPadOS의 root 시스템을 패치하지는 않습니다. 이 스크립트는 macOS 카탈리나 10.15(19A583)에서 테스트되었습니다.

## 패치하는 방법

이 방법은 굉장히 불안정합니다. 아래의 링크로 가시면 많은 이슈를 확인할 수 있습니다. [이슈](https://github.com/pookjw/SidecarPatcher/issues). Please use this at your own risk.

1. `/System/Library/PrivateFrameworks/SidecarCore.framework/Versions/A/SidecarCore` 파일을 백업합니다. 본 스크립트는 기존의 원본 시스템 파일을 별도로 제공하지 않습니다. 복원하기 위해서는 꼭 파일을 백업해주세요.

2. **Command Line Tools** 을 아래의 링크에서 다운로드 합니다. [다운로드](https://developer.apple.com/download/more/).

- 애플의 개발자 계정이 필요합니다. 여러분은 무료로 개발자 계정을 사용할 수 있습니다.

3. **System Integrity Protection** 를 비활성화 합니다. [System Integrity Protection를 비활성화 하는 방법](https://www.imore.com/how-turn-system-integrity-protection-macos).

- **System Integrity Protection** 비활성화 확인하기 위해 terminal에 다음과 같이 입력합니다: `csrutil status`

4. 가장 최신에 발행된 파일을 다운로드 합니다 [다운로드](https://github.com/pookjw/SidecarPatcher/releases) 그리고 압축을 풀어줍니다.

- 이 파일을 크롬 브라우져에서 다운로드할 경우, 경고 메세지가 보일 것 입니다. 이 파일은 바이러스가 아니지만 스크립트형식의 파일의 경우 다운로드시 위험하다는 메세지를 볼 수 있습니다. 염려하지 않으셔도 됩니다.

5. **Terminal** 을 열고 오른쪽 스크립트를 입력해 줍니다(주의) `chmod +x /path/to/SidecarPatcher` and `sudo /path/to/SidecarPatcher`. 

- `/path/to/SidecarPatcher` 는 여러분이 저장한 `SidecarPatcher`의 주소를 말합니다. 예를들어 `/Users/pook/Downloads/SidecarPatcher`와 같은 경로입니다. 만약 이 내용이 무슨말인지 모르겠다면 그냥 터미널에 다운로드 받은 'SidecarPatcher' 파일을 끌어다 놓으면 자동으로 경로를 인식합니다.

- 여러분은 macOS의 암호를 입력해야 합니다(sudo 명령어 때문)

- 원래 SidecarCore 파일로 되돌릴 때까지 이미 시스템을 패치한 경우 이 스크립트 실행을 다시 할 필요는 없습니다.

- xcrun 에러나 충돌이 발생할 경우 재부팅합니다: [#4](https://github.com/pookjw/SidecarPatcher/issues/4)

## 되돌리는 방법

- 간단한 방법

Catalina Installer를 사용하여 MacOS를 다시 설치합니다. 디스크를 지우지 않고 설치하면 데이터가 지워지지 않고 시스템을 다시 설치하기만 하면 됩니다.

- 처음에 한 백업파일을 이용하는 방법

1. **System Integrity Protection** 비활성화 확인. [System Integrity Protection를 비활성화 하는 방법](https://www.imore.com/how-turn-system-integrity-protection-macos).

**System Integrity Protection** 비활성화 확인하기 위해 terminal에 다음과 같이 입력합니다: `csrutil status`

2. terminal에 오른쪽 커맨드를 입력합니다. `sudo mount -uw /`

3. 처음에 백업한 파일을 복사/붙여넣기 하는 과정입니다. 오른쪽 커맨드를 입력해 주세요(주의): `sudo cp /path/to/original/SidecarCore /System/Library/PrivateFrameworks/SidecarCore.framework/Versions/A/SidecarCore`

- 'SidecarCore'의 경로를 잘 확인해 주세요 `/path/to/original/SidecarCore`.

4. SidecarCore 확인: `sudo codesign -f -s - /System/Library/PrivateFrameworks/SidecarCore.framework/Versions/A/SidecarCore`

5. 사용권한을 755로 설정합니다: `sudo chmod 755 /System/Library/PrivateFrameworks/SidecarCore.framework/Versions/A/SidecarCore`

6. 재부팅합니다. 시스템 무결성 보호를 다시 실행하려면, 이 링크를 확인해 주세요. [System Integrity Protection를 활성화 하는 방법](https://www.imore.com/how-turn-system-integrity-protection-macos).