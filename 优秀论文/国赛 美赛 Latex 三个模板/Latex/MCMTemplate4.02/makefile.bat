@echo off
latex mcmpaper
latex mcmpaper
Call clean.bat
dvipdfmx mcmpaper
start mcmpaper.pdf