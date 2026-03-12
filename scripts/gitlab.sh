#!/usr/bin/env bash

sudo mkdir -p /etc/nixos/gitlab-keys

# Root пароль (30 мин действует)
echo "GitlabRoot2026!" | sudo tee /etc/nixos/gitlab-root-pass

# Секреты (генерируем)
for secret in db secret otp jws; do
  openssl rand -base64 200 | sudo tee /etc/nixos/gitlab-$secret
done

sudo chmod 600 /etc/nixos/gitlab-*
sudo chown root:root /etc/nixos/gitlab-*