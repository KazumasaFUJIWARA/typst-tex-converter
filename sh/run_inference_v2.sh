#!/bin/bash

# Llama 3.2 3B QLoRA推論スクリプト（新しい形式v2対応）
# 使用方法: ./sh/run_inference_v2.sh <入力ファイル> <出力ファイル> [オプション]

set -e  # エラー時に停止

# 警告を抑制（生成時の無効パラメータ警告のみ）
export TRANSFORMERS_VERBOSITY=warning

# デフォルト値
MODEL_ID="meta-llama/Llama-3.2-3B-Instruct"
PEFT_MODEL_PATH="outputs/llama32-3b-typst-qlora-v2"
MAX_LENGTH=2048
USE_BASELINE=false
NO_CHUNKING=false

# ヘルプ表示
show_help() {
    echo "使用方法: $0 <入力ファイル> <出力ファイル> [オプション]"
    echo ""
    echo "引数:"
    echo "  入力ファイル: 変換するLaTeXファイル"
    echo "  出力ファイル: 出力するTypstファイル"
    echo ""
    echo "オプション:"
    echo "  -m, --model-id MODEL_ID        ベースモデルID (デフォルト: $MODEL_ID)"
    echo "  -p, --peft-model PEFT_PATH     PEFTモデルパス (デフォルト: $PEFT_MODEL_PATH)"
    echo "  -l, --max-length MAX_LENGTH    最大長 (デフォルト: $MAX_LENGTH)"
    echo "  -b, --baseline                 ベースライン（LoRAなし）モデルを使用"
    echo "  --no-chunking                  チャンク分割を無効化（全文を一度に変換）"
    echo "  -h, --help                     このヘルプを表示"
    echo ""
    echo "例:"
    echo "  $0 sample/sample.tex traind/01.typ                    # 学習済みモデルで変換"
    echo "  $0 sample/sample.tex traind/01.typ --baseline         # ベースラインモデルで変換"
    echo "  $0 sample/sample.tex traind/01.typ --no-chunking      # チャンク分割なしで全文変換"
    echo "  $0 sample/sample.tex traind/01.typ --baseline --no-chunking  # ベースライン+全文変換"
    echo "  $0 sample/sample.tex traind/01.typ -p outputs/my-model # カスタムPEFTモデル"
    echo ""
    echo "ベースライン比較:"
    echo "  $0 sample/sample.tex traind/01_finetuned.typ          # 学習済みモデル"
    echo "  $0 sample/sample.tex traind/01_baseline.typ --baseline # ベースラインモデル"
    echo "  $0 sample/sample.tex traind/01_baseline_full.typ --baseline --no-chunking  # ベースライン全文変換"
}

# 引数の確認
if [[ $# -lt 2 ]]; then
    show_help
    exit 1
fi

INPUT_FILE="$1"
OUTPUT_FILE="$2"
shift 2

# オプション解析
while [[ $# -gt 0 ]]; do
    case $1 in
        -m|--model-id)
            MODEL_ID="$2"
            shift 2
            ;;
        -p|--peft-model)
            PEFT_MODEL_PATH="$2"
            shift 2
            ;;
        -l|--max-length)
            MAX_LENGTH="$2"
            shift 2
            ;;
        -b|--baseline)
            USE_BASELINE=true
            shift
            ;;
        --no-chunking)
            NO_CHUNKING=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "不明なオプション: $1"
            show_help
            exit 1
            ;;
    esac
done

echo "=== Llama 3.2 3B QLoRA推論開始（新しい形式v2） ==="

# 設定の表示
echo "設定:"
echo "  ベースモデル: $MODEL_ID"
if [[ "$USE_BASELINE" == "true" ]]; then
    echo "  使用モデル: ベースライン（LoRAなし）"
else
    echo "  PEFTモデル: $PEFT_MODEL_PATH"
fi
echo "  最大長: $MAX_LENGTH"
if [[ "$NO_CHUNKING" == "true" ]]; then
    echo "  チャンク分割: 無効（全文変換）"
else
    echo "  チャンク分割: 有効"
fi
echo ""

# 仮想環境の確認
if [[ "$VIRTUAL_ENV" == "" ]]; then
    echo "仮想環境が有効化されていません。有効化してください:"
    echo "source venv/bin/activate"
    exit 1
fi

# 入力ファイルの確認
if [[ ! -f "$INPUT_FILE" ]]; then
    echo "エラー: 入力ファイル '$INPUT_FILE' が見つかりません"
    exit 1
fi

# ベースライン以外の場合、PEFTモデルの確認
if [[ "$USE_BASELINE" == "false" ]]; then
    if [[ ! -d "$PEFT_MODEL_PATH" ]]; then
        echo "エラー: PEFTモデル '$PEFT_MODEL_PATH' が見つかりません"
        echo "学習を実行してください: ./sh/run_llama32_3b_training_v2.sh"
        echo "またはベースラインモデルを使用してください: --baseline"
        exit 1
    fi
fi

# 推論スクリプトの確認
if [[ ! -f "python/inference_llama32_3b.py" ]]; then
    echo "エラー: python/inference_llama32_3b.py が見つかりません"
    exit 1
fi

# 出力ディレクトリの作成
OUTPUT_DIR=$(dirname "$OUTPUT_FILE")
mkdir -p "$OUTPUT_DIR"

# ファイル情報の表示
echo "ファイル情報:"
echo "  入力ファイル: $INPUT_FILE"
echo "  出力ファイル: $OUTPUT_FILE"
echo "  入力ファイルサイズ: $(du -h "$INPUT_FILE" | cut -f1)"
echo ""

# 推論実行
INFERENCE_ARGS=(
    --model_id "$MODEL_ID"
    --input_file "$INPUT_FILE"
    --output_file "$OUTPUT_FILE"
    --max_length "$MAX_LENGTH"
)

if [[ "$USE_BASELINE" == "true" ]]; then
    echo "ベースラインモデルでLaTeX→Typst変換を開始します..."
    INFERENCE_ARGS+=(--baseline)
else
    echo "学習済みモデルでLaTeX→Typst変換を開始します..."
    INFERENCE_ARGS+=(--peft_model_path "$PEFT_MODEL_PATH")
fi

if [[ "$NO_CHUNKING" == "true" ]]; then
    INFERENCE_ARGS+=(--no-chunking)
fi

python python/inference_llama32_3b.py "${INFERENCE_ARGS[@]}"

echo "=== 変換完了 ==="
echo "出力ファイル: $OUTPUT_FILE"
echo "出力ファイルサイズ: $(du -h "$OUTPUT_FILE" | cut -f1)"

# 結果のプレビュー
echo ""
echo "=== 変換結果のプレビュー（最初の10行） ==="
head -10 "$OUTPUT_FILE"

# ベースライン比較の提案
if [[ "$USE_BASELINE" == "false" ]]; then
    echo ""
    echo "=== ベースライン比較の提案 ==="
    echo "学習済みモデルとベースラインモデルの性能を比較するには:"
    echo "  ./sh/run_inference_v2.sh $INPUT_FILE ${OUTPUT_FILE%.*}_baseline.typ --baseline"
elif [[ "$USE_BASELINE" == "true" ]]; then
    echo ""
    echo "=== 学習済みモデルとの比較 ==="
    echo "学習済みモデルでの変換結果と比較するには:"
    echo "  ./sh/run_inference_v2.sh $INPUT_FILE ${OUTPUT_FILE%.*}_finetuned.typ"
fi
