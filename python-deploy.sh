#!/bin/bash

# 사용자 정의 설정
GIT_REPO_URL=https://github.com/euijinkk/flask-test-server.git # Git 저장소 URL
PROJECT_DIR=~/python-app                                       # 클론할 프로젝트 폴더
SCRIPT_NAME=test.py                                            # 실행할 Python 스크립트 이름

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
g
# 3. pipreqs 설치 및 requirements.txt 생성
echo "3. pipreqs 설치 및 requirements.txt 생성..."
pip install --upgrade pip
pip install pipreqs
pipreqs $PROJECT_DIR --force

# 4. requirements.txt 기반 라이브러리 설치
if [ -f "$PROJECT_DIR/requirements.txt" ]; then
  echo "4. requirements.txt 기반으로 라이브러리 설치..."
  pip install -r $PROJECT_DIR/requirements.txt
else
  echo "오류: requirements.txt가 생성되지 않았습니다."
  exit 1
fi

# 5. Python 스크립트 실행
echo "5. Python 스크립트 실행..."
if [ -f "$PROJECT_DIR/$SCRIPT_NAME" ]; then
  python3 $PROJECT_DIR/$SCRIPT_NAME
else
  echo "오류: $PROJECT_DIR/$SCRIPT_NAME 파일이 존재하지 않습니다."
  exit 1
fi
