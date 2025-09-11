#!/bin/bash

# QLoRA学習済みモデルをGGUF形式に変換してLM Studioで使用可能にするスクリプト

set -e

# 仮想環境の確認
if [ ! -d "venv" ]; then
    echo "仮想環境が見つかりません。先にセットアップを実行してください:"
    echo "  ./setup_venv.sh"
    exit 1
fi

# 仮想環境を有効化
echo "仮想環境を有効化中..."
source venv/bin/activate

# 設定
BASE_MODEL="/mnt/d/lllm/llama32-3b"  # ローカルのLlama 3.2 3B
PEFT_MODEL="outputs/llama32-3b-typst-qlora"
MERGED_MODEL="outputs/merged-llama32-3b-typst"
GGUF_MODEL="outputs/llama32-3b-typst-gguf"
QUANTIZATION="Q5_K_M"  # Q4_K_M (省メモリ), Q5_K_M (バランス), Q6_K (高精度)

echo "=== QLoRA → GGUF 変換 ==="

# 1. マージ済みモデルの作成
echo "1. QLoRAアダプタをベースモデルにマージ中..."
python python/merge_model.py \
  --base_model "$BASE_MODEL" \
  --peft_model "$PEFT_MODEL" \
  --output_dir "$MERGED_MODEL"

# 2. llama.cppの取得（初回のみ）
if [ ! -d "llama.cpp" ]; then
    echo "2. llama.cppをクローン中..."
    git clone https://github.com/ggerganov/llama.cpp.git
    cd llama.cpp
    make
    cd ..
fi

# 3. HuggingFace → GGUF 変換（最新手法）
echo "3. HuggingFaceモデルをGGUFに変換中..."
python llama.cpp/convert-hf-to-gguf.py \
  --outfile "$GGUF_MODEL/merged-model-f16.gguf" \
  --outtype f16 \
  "$MERGED_MODEL"

# 4. 量子化
echo "4. GGUFモデルを量子化中 ($QUANTIZATION)..."
./llama.cpp/llama-quantize \
  "$GGUF_MODEL/merged-model-f16.gguf" \
  "$GGUF_MODEL/merged-model-$QUANTIZATION.gguf" \
  "$QUANTIZATION"

echo "=== 変換完了 ==="
echo "GGUFモデル: $GGUF_MODEL/merged-model-$QUANTIZATION.gguf"
echo ""
echo "LM Studioでの使用方法:"
echo "1. LM Studioを開く"
echo "2. Models → Local file を選択"
echo "3. $GGUF_MODEL/merged-model-$QUANTIZATION.gguf を選択"
echo "4. サーバーを起動して推論開始"
