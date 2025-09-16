#!/bin/bash

# 001をbaseに002-000から002-010への学習スクリプト
# 試験間隔は2回に1回

echo "=== 001をbaseに002-000から002-010への学習開始 ==="
echo "開始時刻: $(date)"
echo "予定終了時刻: $(date -d '1 hour')"
echo "学習済みモデル: 001（001形式）"
echo "学習データ: train_002.jsonl"
echo "学習範囲: 002-000 → 002-010"
echo "出力形式: Markdown (.md)"
echo "試験間隔: 2回に1回"
echo "学習率: 1e-5（逐次学習用）"
echo "LoRA rank: 8"
echo "LoRA alpha: 8"
echo "================================"

# 学習実行
cd python/
python3 iterative_train.py \
    --base_jsonl 001 \
    --train_jsonl 002 \
    --start_iteration 0 \
    --end_iteration 11 \
    --test_interval 2 \
    --learning_rate 5e-5 \
	 --epochs 5 \
    --lora_r 8 \
    --lora_alpha 8 \
    --lora_dropout 0.1 \
    --batch_size 1 \
    --grad_accum 16 \
	 --warmup_ratio 0.1 \
	 --warmup_steps 50

echo "=== 001をbaseに002-000から002-010への学習完了 ==="
echo "終了時刻: $(date)"
echo "================================"
