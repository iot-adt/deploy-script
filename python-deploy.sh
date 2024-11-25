#!/bin/bash

# 사용자 정의 설정
GIT_REPO_URL=https://github.com/iot-adt/rfid_module.git # Git 저장소 URL
PROJECT_DIR=~/rfid_module                               # 클론할 프로젝트 폴더
SCRIPT_NAME=rfid_module_enroll.py                       # 실행할 Python 스크립트 이름

# 1. 프로젝트 디렉토리 확인 및 Git 클론
if [ ! -d "$PROJECT_DIR" ]; then
  echo "1. Git 저장소를 클론합니다: $PROJECT_DIR"
  git clone $GIT_REPO_URL $PROJECT_DIR
else
  echo "기존 프로젝트 디렉토리가 존재합니다. 최신 상태로 업데이트 중..."
  cd $PROJECT_DIR && git pull origin main
fi

# 2. 가상환경 생성 및 활성화
VENV_DIR=$PROJECT_DIR/venv
if [ ! -d "$VENV_DIR" ]; then
  echo "2. 가상환경 생성: $VENV_DIR"
  python3 -m venv $VENV_DIR
else
  echo "가상환경이 이미 존재합니다. 활성화 중..."
fi
source $VENV_DIR/bin/activate

# 3. Python 스크립트 실행
echo "3. Python 스크립트 실행..."
if [ -f "$PROJECT_DIR/$SCRIPT_NAME" ]; then
  python3 $PROJECT_DIR/$SCRIPT_NAME
else
  echo "오류: $PROJECT_DIR/$SCRIPT_NAME 파일이 존재하지 않습니다."
  exit 1
fi
