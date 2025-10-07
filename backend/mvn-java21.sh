#!/bin/bash
# Use Java 21 for Maven builds to avoid Java 25 compatibility issues

export JAVA_HOME=/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home
export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"

echo "Using Java version:"
java -version

echo ""
echo "Running Maven with Java 21..."
mvn "$@"