#!/usr/bin/env bash
set -euo pipefail

APP_NAME="${1:?app name missing}"
REMOTE_APP_DIR="${2:?remote app dir missing}"
ARTIFACT_FILE="${3:?artifact file missing}"
VENV_PATH="$REMOTE_APP_DIR/venv"
RELEASE_PATH="$REMOTE_APP_DIR/releases/$ARTIFACT_FILE"

mkdir -p "$REMOTE_APP_DIR"

if [[ ! -d "$VENV_PATH" ]]; then
    python3 -m venv "$VENV_PATH"
fi

# Install the newly transferred wheel so deployment is repeatable and versioned.
"$VENV_PATH/bin/pip" install --upgrade pip
"$VENV_PATH/bin/pip" install --force-reinstall "$RELEASE_PATH"

# Prefer systemd for service reliability; fallback to nohup for simple labs.
if command -v systemctl >/dev/null 2>&1 && systemctl list-unit-files | grep -q "^${APP_NAME}.service"; then
    sudo systemctl restart "${APP_NAME}.service"
    sudo systemctl is-active --quiet "${APP_NAME}.service"
else
    pkill -f "gunicorn.*src.app:app" || true
    nohup "$VENV_PATH/bin/gunicorn" -w 2 -b 0.0.0.0:8000 src.app:app > "$REMOTE_APP_DIR/app.log" 2>&1 &
fi

# Health-check validation so Jenkins can mark deployment as pass/fail.
curl --fail --silent --show-error "http://localhost:8000/health" >/tmp/${APP_NAME}_health.json
cat /tmp/${APP_NAME}_health.json
