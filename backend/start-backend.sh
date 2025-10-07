#!/bin/bash

echo "🚀 Starting SnapLingua Backend..."

# Stop any existing processes on port 9090
echo "🔍 Stopping any existing processes on port 9090..."
PID=$(lsof -ti :9090)
if [ ! -z "$PID" ]; then
    echo "🛑 Stopping existing process on port 9090 (PID: $PID)"
    kill -9 $PID
    sleep 2
fi

# Also kill any Java processes to be safe
killall java 2>/dev/null || true
sleep 1

echo "🧹 Cleaning and starting application..."
./mvnw clean spring-boot:run

echo "✅ SnapLingua Backend is running at http://localhost:9090"