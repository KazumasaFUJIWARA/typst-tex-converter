#!/bin/bash

# Llama 3.2 3B専用 QLoRA学習実行スクリプト

set -e

echo "=== Llama 3.2 3B QLoRA学習セットアップ ==="

# 仮想環境の確認
if [ ! -d "venv" ]; then
    echo "仮想環境が見つかりません。先にセットアップを実行してください:"
    echo "  ./setup_venv.sh"
    exit 1
fi

# 仮想環境を有効化
echo "仮想環境を有効化中..."
source venv/bin/activate

# ローカルモデルを使用するため認証不要
echo "ローカルのLlama 3.2 3Bモデルを使用します"

# 学習データの生成
echo "学習データを生成中..."
python python/generate_training_data.py \
  --input data/teacher/train.jsonl \
  --output_dir data/processed \
  --split_ratio 0.8

echo "学習データ生成完了: data/processed/"

# Llama 3.2 3B専用学習実行
echo "Llama 3.2 3B QLoRA学習を開始します..."
python python/train_llama32_3b_qlora.py \
  --model_id /mnt/d/lllm/llama32-3b \
  --data data/processed/train_processed.jsonl \
  --text_field text \
  --out outputs/llama32-3b-typst-qlora \
  --max_len 1024 \
  --batch_size 2 \
  --grad_accum 8 \
  --learning_rate 2e-4 \
  --epochs 5 \
  --lora_r 8 \
  --lora_alpha 16

echo "Llama 3.2 3B QLoRA学習完了！"

# 推論テスト
echo "推論テストを実行中..."
python python/inference.py \
  --base_model /mnt/d/lllm/llama32-3b \
  --peft_model outputs/llama32-3b-typst-qlora \
  --prompt "指示: LaTeX→Typst\n\n入力: \\int_0^1 x dx = \\sum_{i=1}^n x_i \\in \\RR\n\n出力:" \
  --max_new_tokens 100

echo "=== Llama 3.2 3B学習完了 ==="
