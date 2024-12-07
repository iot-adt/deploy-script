#!/bin/bash

# 사용자 정의 변수
GIT_REPO_URL="https://github.com/iot-adt/frontend.git" # Git 리포지토리 URL
PROJECT_NAME="react-app"                               # 로컬 프로젝트 폴더명
NGINX_SITE_NAME="react-app"                            # Nginx 설정 파일 이름
NGINX_WEB_ROOT="/var/www/html"                         # Nginx 웹 루트 디렉토리
BRANCH="main"                                          # Git 브랜치 이름

echo "🚀 시작: React 프로젝트 배포 스크립트"

# 1. Git에서 프로젝트 클론 또는 업데이트
if [ -d "$PROJECT_NAME" ]; then
  echo "📁 $PROJECT_NAME 디렉토리가 이미 존재합니다. 업데이트 중..."
  cd "$PROJECT_NAME" || exit
  git pull origin "$BRANCH"
else
  echo "📂 $PROJECT_NAME 디렉토리가 없습니다. Git에서 클론 중..."
  git clone -b "$BRANCH" "$GIT_REPO_URL" "$PROJECT_NAME"
  cd "$PROJECT_NAME" || exit
fi

# 2. Node.js 의존성 설치
echo "📦 의존성 설치 중 (npm install)..."
npm install

# 3. React 프로젝트 빌드
echo "🏗️  React 프로젝트 빌드 중 (npm run build)..."
npm run build

# 4. Nginx로 빌드 파일 배포
echo "🚚 빌드 파일을 Nginx 웹 루트로 복사 중..."
sudo rm -rf "$NGINX_WEB_ROOT"/*
sudo cp -r dist/* "$NGINX_WEB_ROOT"

# 5. Nginx 설정
echo "🔧 Nginx 설정 파일 생성 중..."
NGINX_CONFIG="/etc/nginx/sites-available/$NGINX_SITE_NAME"
sudo bash -c "cat > $NGINX_CONFIG" <<EOL
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    
    root $NGINX_WEB_ROOT;
    index index.html;

    server_name _;

    location / {
        try_files \$uri /index.html;
    }

    location /assets {
        alias $NGINX_WEB_ROOT/assets;
    }
}
EOL

# 6. Nginx 설정 활성화 및 서비스 재시작
echo "🌐 Nginx 설정 활성화 중..."
sudo ln -sf "$NGINX_CONFIG" /etc/nginx/sites-enabled/
sudo nginx -t # Nginx 설정 테스트
sudo systemctl restart nginx

echo "🎉 배포 완료"
