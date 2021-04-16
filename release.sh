#!/usr/bin/env bash
timestamp=$(date +%y.%-m.%-d)

echo Tagging version $timestamp
docker tag konrness/konrness.com konrness/konrness.com:$timestamp
docker tag konrness/konrness.com gcr.io/personal-sites-310123/konrness.com:$timestamp
docker tag konrness/konrness.com gcr.io/personal-sites-310123/konrness.com:latest

echo Pushing tag: $timestamp
docker push konrness/konrness.com:$timestamp
docker push gcr.io/personal-sites-310123/konrness.com:$timestamp

echo Pushing tag: latest
docker push konrness/konrness.com:latest
docker push gcr.io/personal-sites-310123/konrness.com:latest

echo Pruning...
docker system prune -f

echo Deploying to Cloud Run
gcloud run deploy konrness-com --image gcr.io/personal-sites-310123/konrness.com:$timestamp --region us-central1 --platform managed