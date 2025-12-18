# 🍃 Teeklit (티클릿)
> **"티클 모아 일상 복귀"** - 국민체육진흥공단의 국민체력 100 API 운동 영상과 투두 기능을 결합한 은둔 고립 청년 회복 지원형 실천 커뮤니티 앱

<br>

## 📌 목차
1. [기획배경](#1-기획배경)
2. [상세 기능 및 페이지 구성](#2-상세-기능-및-페이지-구성)
3. [인프라 아키텍처](#3-인프라-아키텍처)
4. [개발 환경](#4-개발-환경)
5. [팀원 소개](#5-팀원-소개)
6. [Technical Deep Dive (개발 문서)](#6-technical-deep-dive-개발-문서)
7. [프로젝트 결과 및 성과](#7-프로젝트-결과-및-성과)
8. [개선 사항 및 추후 계획](#8-개선-사항-및-추후-계획)

<br>

## 1. 기획배경
2025년 기준 청년층 '쉬었음' 인구가 50만 명을 돌파하며 사회적 고립 문제가 심화되고 있습니다. **Teeklit**은 거창한 목표 대신 '물 마시기', '환기하기' 같은 아주 작은 단위의 행동(이하 ***티클***)과 국민체육진흥공단의 검증된 운동 영상을 결합하여, 고립 청년들이 다시 세상 밖으로 나올 수 있는 **자기효능감**과 **일상의 리듬**을 되찾도록 돕고자 기획하게 되었습니다.

<br>

## 2. 상세 기능 및 페이지 구성

### (1) 메인 및 활동 대시보드
- **오늘의 티클**: 시간대별 인사 메시지와 함께 오늘 완수해야 할 작은 할 일 목록을 제공합니다.
- **활동 통계**: 일일/주간 성취도를 시각화하여 변화하는 일상을 한눈에 확인합니다.

<div align="center">
  <img src="https://github.com/user-attachments/assets/이미지_주소_입력1" width="45%" alt="메인 페이지" />
  <img src="https://github.com/user-attachments/assets/이미지_주소_입력2" width="45%" alt="대시보드 페이지" />
</div>

### (2) 티클 생성 및 운동 추천
- **티클 관리**: 복잡한 계획 대신 당장 실행 가능한 작은 단위의 행동을 직접 생성하고 관리합니다.
- **운동 추천**: 국민체력100 API를 활용하여 저난이도의 안전한 운동 콘텐츠를 큐레이션합니다.

<div align="center">
  <img src="https://github.com/user-attachments/assets/이미지_주소_입력3" width="45%" alt="티클 생성" />
  <img src="https://github.com/user-attachments/assets/이미지_주소_입력4" width="45%" alt="운동 추천" />
</div>

### (3) 커뮤니티 및 마이페이지
- **익명 커뮤니티**: 서로의 티클 달성을 응원하고 고민을 나누며 사회적 연결감을 회복합니다.
- **나의 기록**: 그동안 쌓아온 티클 기록과 배지, 포인트 현황을 확인합니다.

<div align="center">
  <img src="https://github.com/user-attachments/assets/이미지_주소_입력5" width="45%" alt="커뮤니티" />
  <img src="https://github.com/user-attachments/assets/이미지_주소_입력6" width="45%" alt="마이페이지" />
</div>

<br>

## 3. 인프라 아키텍처
Teeklit은 안정적인 서비스 제공과 효율적인 데이터 관리를 위해 다음과 같은 구조를 가집니다.

- **Frontend**: **Flutter**를 활용한 Cross-platform 대응 (Android, iOS 동시 지원)
- **Backend**: **Firebase** 기반의 Serverless 아키텍처
  - **Authentication**: 이메일 및 익명 로그인 처리
  - **Cloud Firestore**: 사용자 활동 데이터 및 커뮤니티 게시물 실시간 저장
  - **Cloud Storage**: 프로필 이미지 및 활동 인증 사진 저장
- **External API**: 
  - **국민체육진흥공단**: 국민체력100 운동동영상 정보 연동
  - **YouTube Data API**: 운동 가이드 영상 스트리밍 제공

<br>

## 4. 개발 환경

### 💻 Language
<img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=Dart&logoColor=white">

### 🏗️ Framework & Library
<img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=Flutter&logoColor=white"> <img src="https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=Firebase&logoColor=black">

### ⚙️ Config & Communication
<img src="https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=GitHub&logoColor=white"> <img src="https://img.shields.io/badge/Notion-000000?style=for-the-badge&logo=Notion&logoColor=white"> <img src="https://img.shields.io/badge/Figma-F24E1E?style=for-the-badge&logo=Figma&logoColor=white">

<br>

## 5. 팀원 소개

| 이름 | 구분 | 수행 업무 |
| :--- | :--- | :--- |
| **전여민** | 팀장 | • 서비스 기획 <br> • Firebase Auth 기반 로그인 시스템 구축 <br> • 마이페이지 데이터 바인딩 및 관리 로직 구현 |
| **최란** | 팀원 | • 서비스 기획<br> • 프로젝트 총괄 및 일정 관리<br>• 서비스 GUI 설계 및 UX/UI 디자인 (Figma) <br> • '내 티클(할일)' & '홈'  Full Stack 개발 <br> • 서비스 배포 및 인프라 관리 (App Store / Play Store / One Store) |
| **이우형** | 팀원 | • 서비스 기획<br>  • '커뮤니티' 아키텍처 설계 (신고, 차단, 댓글 및 게시글 로직) <br> • '커뮤니티' 게시판 Full Stack 개발 <br> |
| **지경희** | 팀원 | • 서비스 기획<br>• 국민체력100 공공데이터 API 연동 및 추천 로직 <br> • '내 티클' 메인 UI 및 마이페이지 UI 구현 |

<br>

## 🚀 6. Technical Deep Dive (개발 문서)

### 📂 View Model에서의 Mixin 사용
**Architecture Design: MVVM 최적화 & Logic Separation**

[내 티클]의 세부 기능 중 하나인 '반복 티클 생성' 과정에서 발생한 ViewModel 비대화(Massive ViewModel) 문제를 해결하기 위해, **Dart의 Mixin Pattern을 활용한 역할 분리(Separation of Concerns)** 전략을 채택했습니다.

#### 1. 과제: ViewModel의 역할과 딜레마
- **설계 배경**: 유지보수성과 테스트 용이성을 위해 MVVM 기반 설계.
- **문제 직면**: 상태 관리, DB CRUD, 그리고 복잡한 '반복 날짜 계산 알고리즘'이 ViewModel 하나에 혼재되어 가독성과 응집도 저하 발생.

#### 2. 아키텍처 결정: Mixin을 통한 로직 분리
- **선택 근거**: 상속의 깊이를 늘리지 않으면서 기능을 수평적으로 확장 가능. 순수 연산 로직을 격리하여 재사용성 확보.
- **System Flow**:
| 단계 | 주체 (Actor) | 역할 (Responsibility) | 비고 |
| :--- | :--- | :--- | :--- |
| Step 1 | User / View | Task 설정 (반복 규칙 정의) | Input |
| Step 2 | Mixin (Logic) | 반복 규칙 해석 및 실행 날짜(N) 산출 | Pure Calculation |
| Step 3 | ViewModel | 산출된 날짜로 Teekle 인스턴스 $N$개 생성 | Instance Mapping |
| Step 4 | Repository | Task 및 Teekle 리스트 DB 저장 | Persistence |

#### 3. 구현 상세
- **TeekleSettingUtils (Mixin)**: 순수 입력값으로 결과를 도출하는 함수로 연산 로직 완벽 격리.
- **TeekleSettingViewModel**: `with TeekleSettingUtils`를 통해 '어떻게 계산하는가'가 아닌 '계산된 결과로 무엇을 할 것인가'에 집중.

---

### 📂 Firebase Firestore: Batch의 사용
**DB Persistence: Firestore WriteBatch의 전략적 채택**

반복 티클 생성 시 데이터 무결성(Data Integrity)을 확보하고 원자적(All-or-Nothing) 처리를 보장하기 위해 **Firestore WriteBatch**를 채택했습니다.

#### 1. 과제: 반복 작업의 데이터 무결성
- **문제**: N개의 티클 생성 시 개별 단건 쓰기를 사용하면 중간 실패 시 데이터 불완전성 발생. 수정 시 기존 데이터를 삭제하고 재생성하는 과정에서도 원자성 보장 필수.

#### 2. 구현 전략: WriteBatch vs Transaction
| 특징 | WriteBatch | Transaction |
| :--- | :--- | :--- |
| **핵심 목적** | 다수의 쓰기/업데이트/삭제 일괄 처리 | 읽기 기반 쓰기 (Read-Modify-Write) |
| **효율성** | **매우 빠름 (1회 RTT)** | 상대적으로 느림 (읽기 오버헤드 존재) |
| **채택 이유** | 생성 시 문서 ID를 클라이언트에서 새로 생성하므로 기존 상태를 읽고 수정할 필요가 없음 (동시성 제어 불필요) | - |

#### 3. 결과 및 가치
- **Atomicity**: 수백 개의 일정이 생성/수정될 때 단 하나라도 실패하면 롤백되어 일관성 유지.
- **Performance**: N번의 호출을 1회로 묶어 처리함으로써 사용자 경험(UX) 최적화.

<br>

## 7. 프로젝트 결과 및 성과
- **혁신적인 일상 회복 모델**: 공공데이터 기반의 검증된 운동 콘텐츠로 고립 청년의 신체 활동 활성화 유도.
- **자기효능감 형성**: '티클' 단위의 성공 경험 누적을 통한 심리적 장벽 완화.
- **효율적인 인프라 운영**: Firebase Serverless 환경 구축으로 운영 리소스 최소화 및 실시간 데이터 동기화 안정성 확보.

<br>

## 8. 개선 사항 및 추후 계획
- **맞춤형 루틴 추천**: 사용자 활동 로그 기반의 개인화된 AI 추천 모델 구축 예정.
- **오프라인 연계**: 지역별 국민체력100 센터 정보 연동을 통한 실제 사회 복귀 접점 확대.
- **성능 최적화**: 사용자 증가에 따른 데이터 부하 관리 및 로드 밸런싱 고도화.

---
**Team 새싹랩(Sesac Lab)**
