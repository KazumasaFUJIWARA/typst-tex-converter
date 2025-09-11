#!/bin/bash

# データ管理用シェルスクリプト

set -e

# データディレクトリの確認
echo "=== データ管理ディレクトリ確認 ==="
ls -la data/

echo ""
echo "=== 教師データ統計 ==="
echo "学習データ: $(wc -l < data/teacher/train.jsonl) 件"
echo "評価データ: $(wc -l < data/teacher/eval.jsonl) 件"

echo ""
echo "=== 予測結果統計 ==="
if [ -d "data/output/predictions" ]; then
    echo "予測結果ファイル数: $(ls data/output/predictions/*.jsonl 2>/dev/null | wc -l)"
else
    echo "予測結果: 0 件"
fi

echo ""
echo "=== 修正データ統計 ==="
if [ -d "data/correction/manual" ]; then
    echo "手動修正: $(wc -l < data/correction/manual/corrections.jsonl 2>/dev/null || echo 0) 件"
else
    echo "手動修正: 0 件"
fi

if [ -d "data/correction/auto" ]; then
    echo "自動修正: $(wc -l < data/correction/auto/corrections.jsonl 2>/dev/null || echo 0) 件"
else
    echo "自動修正: 0 件"
fi

echo ""
echo "=== データ管理コマンド例 ==="
echo "1. 教師データ追加:"
echo "   python python/data_manager.py --action add_teacher --system '...' --instruction '...' --input '...' --output '...'"
echo ""
echo "2. 予測結果保存:"
echo "   python python/data_manager.py --action save_prediction --input '...' --predicted '...' --ground_truth '...'"
echo ""
echo "3. 修正データ保存:"
echo "   python python/data_manager.py --action save_correction --original '...' --corrected '...' --reason '...'"
echo ""
echo "4. データレポート生成:"
echo "   python python/data_manager.py --action report"
