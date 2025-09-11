#!/bin/bash

# Python仮想環境セットアップスクリプト

set -e

echo "=== Python仮想環境セットアップ ==="

# Python 3.8以上が必要
python_version=$(python3 --version 2>&1 | cut -d' ' -f2 | cut -d'.' -f1,2)
echo "Python バージョン: $python_version"

# 仮想環境の作成（pipなしで作成）
echo "仮想環境を作成中..."
python3 -m venv --without-pip venv

# 仮想環境の有効化
echo "仮想環境を有効化中..."
source venv/bin/activate

# pipのインストール
echo "pipをインストール中..."
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py
rm get-pip.py

# 依存関係のインストール
echo "依存関係をインストール中..."
python -m pip install -r python/requirements.txt

# 追加の依存関係（QLoRA学習に必要）
echo "追加の依存関係をインストール中..."
python -m pip install flash-attn --no-build-isolation

echo ""
echo "=== セットアップ完了 ==="
echo "仮想環境を有効化するには:"
echo "  source venv/bin/activate"
echo ""
echo "仮想環境を無効化するには:"
echo "  deactivate"
echo ""
echo "学習を開始するには:"
echo "  source venv/bin/activate"
echo "  ./sh/run_llama32_3b_training.sh"
