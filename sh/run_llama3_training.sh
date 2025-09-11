#!/bin/bash

# LLaMA 3専用 QLoRA学習実行スクリプト

set -e

echo "=== LLaMA 3 QLoRA学習セットアップ ==="

# 依存関係のインストール
echo "依存関係をインストール中..."
pip install -r python/requirements.txt

# Hugging Faceログイン（LLaMA 3は要認証）
echo "Hugging Faceにログインしてください（LLaMA 3は要認証）"
echo "huggingface-cli login"
echo "認証後、Enterキーを押してください..."
read

# データの前処理
echo "データを前処理中..."
python python/make_text.py < jsonl/train.jsonl > jsonl/train_processed.jsonl

echo "前処理完了: jsonl/train_processed.jsonl"

# LLaMA 3専用学習実行
echo "LLaMA 3 QLoRA学習を開始します..."
python python/train_llama3_qlora.py \
  --model_id meta-llama/Llama-3-8B-Instruct \
  --data jsonl/train_processed.jsonl \
  --text_field text \
  --out outputs/llama3-typst-qlora \
  --max_len 2048 \
  --batch_size 1 \
  --grad_accum 16 \
  --learning_rate 1e-4 \
  --epochs 3 \
  --lora_r 16 \
  --lora_alpha 32

echo "LLaMA 3 QLoRA学習完了！"

# 推論テスト
echo "推論テストを実行中..."
python python/inference.py \
  --base_model meta-llama/Llama-3-8B-Instruct \
  --peft_model outputs/llama3-typst-qlora \
  --prompt "指示: LaTeX→Typst\n\n入力: \\int_0^1 x dx = \\sum_{i=1}^n x_i \\in \\RR\n\n出力:" \
  --max_new_tokens 100

echo "=== LLaMA 3学習完了 ==="
