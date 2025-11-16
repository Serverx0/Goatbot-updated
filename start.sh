#!/bin/bash
set -e

echo "🤖 Starting Goat Bot V2..."

# Check if config files exist
if [ ! -f "config.json" ]; then
    echo "❌ Error: config.json not found!"
    echo "Please ensure config.json exists in the project root."
    exit 1
fi

if [ ! -f "configCommands.json" ]; then
    echo "❌ Error: configCommands.json not found!"
    echo "Please ensure configCommands.json exists in the project root."
    exit 1
fi

if [ ! -f "account.txt" ]; then
    echo "❌ Error: account.txt not found!"
    echo "Please ensure account.txt exists in the project root."
    exit 1
fi

# Create database directory if it doesn't exist
mkdir -p database

echo "✅ All configuration files found"
echo "🚀 Starting bot with NODE_ENV=${NODE_ENV:-production}..."

# Start the bot
exec node index.js
