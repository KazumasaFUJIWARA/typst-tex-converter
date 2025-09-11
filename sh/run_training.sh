#!/bin/bash

# QLoRA学習実行スクリプト

set -e

echo "=== QLoRA学習セットアップ ==="

# 仮想環境の確認
if [ ! -d "venv" ]; then
    echo "仮想環境が見つかりません。先にセットアップを実行してください:"
    echo "  ./setup_venv.sh"
    exit 1
fi

# 仮想環境を有効化
echo "仮想環境を有効化中..."
source venv/bin/activate

# Hugging Faceログイン（必要に応じて）
echo "Hugging Faceにログインしてください（必要に応じて）"
echo "huggingface-cli login"

# 学習データの生成
echo "学習データを生成中..."
python python/generate_training_data.py \
  --input data/teacher/train.jsonl \
  --output_dir data/processed \
  --split_ratio 0.8

echo "学習データ生成完了: data/processed/"

# 学習実行
echo "QLoRA学習を開始します..."
python python/train_qlora.py \
  --model_id meta-llama/Llama-3.2-3B-Instruct \
  --data data/processed/train_processed.jsonl \
  --text_field text \
  --out outputs/typst-tex-qlora \
  --max_len 1024 \
  --batch_size 1 \
  --grad_accum 32 \
  --learning_rate 2e-4 \
  --epochs 3

echo "学習完了！"

# 推論テスト
echo "推論テストを実行中..."
python python/inference.py \
  --base_model Qwen/Qwen2-7B-Instruct \
  --peft_model outputs/typst-tex-qlora \
  --prompt "指示: LaTeX→Typst\n\n入力: \\int_0^1 x dx = \\sum_{i=1}^n x_i \\in \\RR\n\n出力:" \
  --max_new_tokens 100

echo "=== 完了 ==="
