#!/bin/bash

# Llama 3.2 3B QLoRA学習スクリプト（新しい形式v2対応）
# 使用方法: ./sh/run_llama32_3b_training_v2.sh [オプション]

set -e  # エラー時に停止

# デフォルト値
MODEL_ID="meta-llama/Llama-3.2-3B-Instruct"
DATA_FILE="jsonl/train_v2.jsonl"
OUTPUT_DIR="outputs/llama32-3b-typst-qlora-v2"
MAX_LEN=1024
BATCH_SIZE=2
GRAD_ACCUM=8
LEARNING_RATE="2e-4"
EPOCHS=5
LORA_R=8
LORA_ALPHA=16
CONTINUE_TRAINING=false
RESUME_CHECKPOINT=""

# ヘルプ表示
show_help() {
    echo "使用方法: $0 [オプション]"
    echo ""
    echo "オプション:"
    echo "  -m, --model-id MODEL_ID        モデルID (デフォルト: $MODEL_ID)"
    echo "  -d, --data DATA_FILE           学習データファイル (デフォルト: $DATA_FILE)"
    echo "  -o, --output OUTPUT_DIR        出力ディレクトリ (デフォルト: $OUTPUT_DIR)"
    echo "  -l, --max-len MAX_LEN          最大長 (デフォルト: $MAX_LEN)"
    echo "  -b, --batch-size BATCH_SIZE    バッチサイズ (デフォルト: $BATCH_SIZE)"
    echo "  -g, --grad-accum GRAD_ACCUM    勾配累積 (デフォルト: $GRAD_ACCUM)"
    echo "  -r, --learning-rate LR         学習率 (デフォルト: $LEARNING_RATE)"
    echo "  -e, --epochs EPOCHS            エポック数 (デフォルト: $EPOCHS)"
    echo "  --lora-r RANK                  LoRA rank (デフォルト: $LORA_R)"
    echo "  --lora-alpha ALPHA             LoRA alpha (デフォルト: $LORA_ALPHA)"
    echo "  --continue-training            既存のPEFTモデルから継続学習"
    echo "  --resume-checkpoint PATH       チェックポイントから学習を再開"
    echo "  -h, --help                     このヘルプを表示"
    echo ""
    echo "例:"
    echo "  $0                                    # デフォルト設定で学習"
    echo "  $0 -e 3 -b 1                         # エポック3、バッチサイズ1で学習"
    echo "  $0 -o outputs/my-model               # カスタム出力ディレクトリ"
    echo "  $0 --continue-training               # 既存モデルから継続学習"
    echo "  $0 --resume-checkpoint outputs/llama32-3b-typst-qlora-v2/checkpoint-500  # チェックポイントから再開"
}

# 引数解析
while [[ $# -gt 0 ]]; do
    case $1 in
        -m|--model-id)
            MODEL_ID="$2"
            shift 2
            ;;
        -d|--data)
            DATA_FILE="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        -l|--max-len)
            MAX_LEN="$2"
            shift 2
            ;;
        -b|--batch-size)
            BATCH_SIZE="$2"
            shift 2
            ;;
        -g|--grad-accum)
            GRAD_ACCUM="$2"
            shift 2
            ;;
        -r|--learning-rate)
            LEARNING_RATE="$2"
            shift 2
            ;;
        -e|--epochs)
            EPOCHS="$2"
            shift 2
            ;;
        --lora-r)
            LORA_R="$2"
            shift 2
            ;;
        --lora-alpha)
            LORA_ALPHA="$2"
            shift 2
            ;;
        --continue-training)
            CONTINUE_TRAINING=true
            shift
            ;;
        --resume-checkpoint)
            RESUME_CHECKPOINT="$2"
            shift 2
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

echo "=== Llama 3.2 3B QLoRA学習開始（新しい形式v2） ==="
echo "設定:"
echo "  モデルID: $MODEL_ID"
echo "  学習データ: $DATA_FILE"
echo "  出力ディレクトリ: $OUTPUT_DIR"
echo "  最大長: $MAX_LEN"
echo "  バッチサイズ: $BATCH_SIZE"
echo "  勾配累積: $GRAD_ACCUM"
echo "  学習率: $LEARNING_RATE"
echo "  エポック数: $EPOCHS"
echo "  LoRA rank: $LORA_R"
echo "  LoRA alpha: $LORA_ALPHA"
if [[ "$CONTINUE_TRAINING" == "true" ]]; then
    echo "  継続学習: 有効"
fi
if [[ -n "$RESUME_CHECKPOINT" ]]; then
    echo "  チェックポイント再開: $RESUME_CHECKPOINT"
fi
echo ""

# 仮想環境の確認
if [[ "$VIRTUAL_ENV" == "" ]]; then
    echo "仮想環境が有効化されていません。有効化してください:"
    echo "source venv/bin/activate"
    exit 1
fi

# 必要なファイルの確認
if [[ ! -f "$DATA_FILE" ]]; then
    echo "エラー: 学習データファイル '$DATA_FILE' が見つかりません"
    echo "新しい形式の学習データを生成してください"
    exit 1
fi

if [[ ! -f "python/train_llama32_3b_qlora_fixed.py" ]]; then
    echo "エラー: python/train_llama32_3b_qlora_fixed.py が見つかりません"
    exit 1
fi

# 出力ディレクトリの作成
mkdir -p "$OUTPUT_DIR"

# 学習データの統計表示
echo "学習データの統計:"
echo "サンプル数: $(wc -l < "$DATA_FILE")"
echo "ファイルサイズ: $(du -h "$DATA_FILE" | cut -f1)"
echo ""

# GPU情報の表示
if command -v nvidia-smi &> /dev/null; then
    echo "GPU情報:"
    nvidia-smi --query-gpu=name,memory.total,memory.used --format=csv,noheader,nounits
    echo ""
fi

# 学習実行
echo "学習を開始します..."
TRAINING_ARGS=(
    --model_id "$MODEL_ID"
    --data "$DATA_FILE"
    --out "$OUTPUT_DIR"
    --max_len "$MAX_LEN"
    --batch_size "$BATCH_SIZE"
    --grad_accum "$GRAD_ACCUM"
    --learning_rate "$LEARNING_RATE"
    --epochs "$EPOCHS"
    --lora_r "$LORA_R"
    --lora_alpha "$LORA_ALPHA"
)

if [[ "$CONTINUE_TRAINING" == "true" ]]; then
    TRAINING_ARGS+=(--continue_training)
fi

if [[ -n "$RESUME_CHECKPOINT" ]]; then
    TRAINING_ARGS+=(--resume_from_checkpoint "$RESUME_CHECKPOINT")
fi

python python/train_llama32_3b_qlora_fixed.py "${TRAINING_ARGS[@]}"

echo "=== 学習完了 ==="
echo "出力ディレクトリ: $OUTPUT_DIR"
echo ""

# 学習結果の確認
if [[ -d "$OUTPUT_DIR" ]]; then
    echo "学習結果:"
    echo "  チェックポイント数: $(find "$OUTPUT_DIR" -name "*.safetensors" | wc -l)"
    echo "  最終モデルサイズ: $(du -sh "$OUTPUT_DIR" | cut -f1)"
    echo ""
fi

echo "次のステップ:"
echo "1. 推論テスト: ./sh/run_inference_v2.sh sample/sample.tex traind/01.typ"
echo "2. ベースライン比較: ./sh/run_inference_v2.sh sample/sample.tex traind/01_baseline.typ --baseline"
echo "3. 追加学習: ./sh/run_llama32_3b_training_v2.sh --continue-training"
echo "4. モデルマージ: python python/merge_model.py --base_model $MODEL_ID --peft_model $OUTPUT_DIR --output_dir outputs/merged-llama32-3b-typst-v2"
