#!/bin/bash

dnf install -y kernel-6.3.0
pesign -s -c 'Sids Secureboot' -i /boot/vmlinuz-6.3.0-0.rc2.89f5349e0673.24.test.fc38.x86_64 -o /boot/vmlinuz-6.3.0-0.rc2.89f5349e0673.24.test.fc38.x86_64.signed

pesign -S -i /boot/vmlinuz-6.3.0-0.rc2.89f5349e0673.24.test.fc38.x86_64.signed
pesign -r --signature-number 0 -i /boot/vmlinuz-6.3.0-0.rc2.89f5349e0673.24.test.fc38.x86_64.signed -o /boot/vmlinuz-6.3.0-0.rc2.89f5349e0673.24.test.fc38.x86_64.2sig
pesign -r --signature-number 0 -i /boot/vmlinuz-6.3.0-0.rc2.89f5349e0673.24.test.fc38.x86_64.2sig -o /boot/vmlinuz-6.3.0-0.rc2.89f5349e0673.24.test.fc38.x86_64.signed --force

mv /boot/vmlinuz-6.3.0-0.rc2.89f5349e0673.24.test.fc38.x86_64{,.bak}
cp /boot/vmlinuz-6.3.0-0.rc2.89f5349e0673.24.test.fc38.x86_64.signed /boot/vmlinuz-6.3.0-0.rc2.89f5349e0673.24.test.fc38.x86_64

