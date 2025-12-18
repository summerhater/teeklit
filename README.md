# 🍃 Teeklit (티클릿)
> **"티클 모아 일상 복귀"** - 국민체육진흥공단의 국민체력 운동 영상 와 100 API
투두 기능을 결합한 은둔 고립 · 청년 회복 지원형 실천 커뮤니티 앱

<br>

## 📌 목차
1. [기획배경](#1-기획배경)
2. [상세 기능 및 페이지 구성](#2-상세-기능-및-페이지-구성)
3. [인프라 아키텍처](#3-인프라-아키텍처)
4. [개발 환경](#4-개발-환경)
5. [팀원 소개](#5-팀원-소개)
6. [프로젝트 결과 및 성과](#6-프로젝트-결과-및-성과)
7. [개선 사항 및 추후 계획](#7-개선-사항-및-추후-계획)

<br>

## 1. 기획배경
2025년 기준 청년층 '쉬었음' 인구가 50만 명을 돌파하며 사회적 고립 문제가 심화되고 있습니다. **Teeklit**은 거창한 목표 대신 '물 마시기', '환기하기' 같은 아주 작은 단위의 행동(이하 ***티클***)과 국민체육진흥공단의 검증된 운동 영상을 결합하여, 고립 청년들이 다시 세상 밖으로 나올 수 있는 **자기효능감**과 **일상의 리듬**을 되찾도록 돕고자 기획하게 되었습니다.

<br>

## 2. 상세 기능 및 페이지 구성

### (1) 메인 및 활동 대시보드
- **오늘의 티클**: 시간대별 인사 메시지와 함께 오늘 완수해야 할 작은 할 일 목록을 제공합니다.
- **활동 통계**: 일일/주간 성취도를 시각화하여 변화하는 일상을 한눈에 확인합니다.

<div align="center">
  <img src="이미지_주소_입력" width="45%" alt="메인 페이지" />
  <img src="이미지_주소_입력" width="45%" alt="대시보드 페이지" />
</div>

### (2) 티클 생성 및 운동 추천
- **티클 관리**: 복잡한 계획 대신 당장 실행 가능한 작은 단위의 행동을 직접 생성하고 관리합니다.
- **운동 추천**: 국민체력100 API를 활용하여 저난이도의 안전한 운동 콘텐츠를 큐레이션합니다.

<div align="center">
  <img src="이미지_주소_입력" width="45%" alt="티클 생성" />
  <img src="이미지_주소_입력" width="45%" alt="운동 추천" />
</div>

### (3) 커뮤니티 및 마이페이지
- **익명 커뮤니티**: 서로의 티클 달성을 응원하고 고민을 나누며 사회적 연결감을 회복합니다.
- **나의 기록**: 그동안 쌓아온 티클 기록과 배지, 포인트 현황을 확인합니다.

<div align="center">
  <img src="이미지_주소_입력" width="45%" alt="커뮤니티" />
  <img src="이미지_주소_입력" width="45%" alt="마이페이지" />
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

## 6. 프로젝트 결과 및 성과

### ✅ 혁신적인 일상 회복 모델 구현
- **공공데이터 활용**: 국민체력100의 검증된 운동 정보를 활용하여 신뢰도 높은 건강 콘텐츠를 구현했습니다.
- **자기효능감 형성**: "할 수 있겠다"는 경험을 강화하는 '티클' 단위의 행동 유도로 초기 참여 장벽을 크게 낮췄습니다.

### ✅ 효율적인 개발 및 배포
- **Serverless 인프라**: Firebase를 활용하여 서버 관리 비용을 최소화하고 실시간 데이터 동기화를 안정적으로 구현했습니다.
- **멀티 플랫폼 대응**: Flutter 단일 코드베이스를 통해 개발 생산성을 높이고 다양한 기기 환경에 대응했습니다.

<br>

## 7. 개선 사항 및 추후 계획

### 🔮 내 티클(할일) 기능 확장
- **맞춤형 루틴 추천**: 사용자 활동 로그를 바탕으로 한 개인화된 활동 추천 모델을 구축할 계획입니다.

### ⚖️ 성능 최적화 및 외부 연동
- **오프라인 연계**: 거주지 주변의 오프라인 체육 시설 정보 연동을 통해 실제 외부 활동으로의 연결을 강화할 예정입니다.
- **데이터 모니터링**: 사용자 증가에 따른 데이터 부하를 관리하기 위한 로드 밸런싱 및 성능 최적화를 진행할 예정입니다.

---
**Team 새싹랩(Sesac Lab)**
