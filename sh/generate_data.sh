#!/bin/bash

# 学習データ生成スクリプト

set -e

echo "=== 学習データ生成 ==="

# 仮想環境の確認
if [ ! -d "venv" ]; then
    echo "仮想環境が見つかりません。先にセットアップを実行してください:"
    echo "  ./setup_venv.sh"
    exit 1
fi

# 仮想環境を有効化
echo "仮想環境を有効化中..."
source venv/bin/activate

# 元のjsonlデータから学習データを生成
echo "学習データを生成中..."
python python/generate_training_data.py \
  --input data/teacher/train.jsonl \
  --output_dir data/processed \
  --split_ratio 0.8

echo ""
echo "=== 生成されたファイル ==="
echo "学習データ: data/processed/train.jsonl"
echo "評価データ: data/processed/eval.jsonl"
echo "前処理済み学習データ: data/processed/train_processed.jsonl"
echo "前処理済み評価データ: data/processed/eval_processed.jsonl"
echo "統計情報: data/processed/data_statistics.json"

echo ""
echo "=== データ統計 ==="
if [ -f "data/processed/data_statistics.json" ]; then
    python -c "
import json
with open('data/processed/data_statistics.json', 'r', encoding='utf-8') as f:
    stats = json.load(f)
print(f'総サンプル数: {stats[\"total_samples\"]}')
print(f'学習サンプル数: {stats[\"train_samples\"]}')
print(f'評価サンプル数: {stats[\"eval_samples\"]}')
print('\\nカテゴリ別統計:')
for category, count in stats['categories'].items():
    print(f'  {category}: {count} 件')
"
fi

echo ""
echo "学習データ生成完了！"
