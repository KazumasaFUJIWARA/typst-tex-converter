#!/bin/bash

# 002-010をベースに003-000から003-010への学習

echo "=== 002-010をbaseに003-000から003-010への学習開始 ==="
echo "開始時刻: $(date)"
echo "予定終了時刻: $(date -d '1 hour')"
echo "学習済みモデル: 002-010"
echo "学習データ: train_003.jsonl"
echo "学習範囲: 003-000 → 003-010"
echo "出力形式: Markdown (.md)"
echo "試験間隔: 2回に1回"
echo "学習率: 1e-5（逐次学習用）"
echo "LoRA rank: 8"
echo "LoRA alpha: 8"
echo "VRAM: 8GB対応設定"
echo "================================"

# 学習実行
cd python/
python3 iterative_train.py \
    --base_jsonl 002 \
    --base_iteration 010 \
    --train_jsonl 003 \
    --start_iteration 0 \
    --end_iteration 10 \
    --test_interval 2 \
    --epochs 8 \
    --learning_rate 1e-5 \
    --lora_r 8 \
    --lora_alpha 8 \
    --lora_dropout 0.1 \
    --batch_size 1 \
    --grad_accum 16

echo "=== 002-010をbaseに003-000から003-010への学習完了 ==="
echo "終了時刻: $(date)"
echo "================================"
