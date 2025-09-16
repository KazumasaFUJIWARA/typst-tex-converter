#!/usr/bin/env python3
"""
Unicode記号変換専用の継続学習スクリプト
003-050から開始して、train_004.jsonlで10回の学習を実行
"""

import os
import subprocess
import argparse
from datetime import datetime

def run_command(cmd, log_file):
    """コマンドを実行し、ログを保存する"""
    print(f"実行中: {cmd}")
    
    with open(log_file, 'w', encoding='utf-8') as f:
        process = subprocess.Popen(
            cmd, 
            shell=True, 
            stdout=subprocess.PIPE, 
            stderr=subprocess.STDOUT,
            universal_newlines=True,
            bufsize=1
        )
        
        for line in process.stdout:
            print(line.rstrip())
            f.write(line)
            f.flush()
    
    return process.wait()

def main():
    parser = argparse.ArgumentParser(description="Unicode記号変換専用継続学習スクリプト（10回繰り返し）")
    parser.add_argument("--epochs", type=int, default=1, help="各繰り返しでのエポック数（デフォルト: 1）")
    parser.add_argument("--iterations", type=int, default=10, help="繰り返し回数（デフォルト: 10）")
    parser.add_argument("--learning_rate", type=float, default=1e-4, help="継続学習の学習率（デフォルト: 1e-4）")
    parser.add_argument("--start_from", type=int, default=50, help="開始エポック番号（デフォルト: 50）")

    args = parser.parse_args()

    # ログディレクトリを作成
    os.makedirs("logs", exist_ok=True)
    os.makedirs("trained", exist_ok=True)

    # タイムスタンプ
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")

    print("=== Unicode記号変換専用継続学習開始 ===")
    print(f"各繰り返しのエポック数: {args.epochs}")
    print(f"繰り返し回数: {args.iterations}")
    print(f"学習率: {args.learning_rate}")
    print(f"開始エポック番号: {args.start_from}")
    print(f"タイムスタンプ: {timestamp}")

    # 初期チェックポイント（003-050から開始）
    current_checkpoint = "../outputs/llama32-3b-typst-qlora-003-050"
    train_file = "../jsonl/train_004.jsonl"

    print(f"初期チェックポイント: {current_checkpoint}")
    print(f"学習データ: {train_file}")
    print()

    # 各繰り返しで学習・テストを実行
    for i in range(args.start_from, args.start_from + args.iterations):
        epoch_num = f"{i - args.start_from + 1:03d}"  # 004-001から開始
        print(f"=== エポック 004-{epoch_num} の処理開始 ===")

        # 学習コマンド（すべて継続学習）
        train_cmd = f"""python3 train_llama32_3b_qlora_fixed.py \
            --data {train_file} \
            --out ../outputs/llama32-3b-typst-qlora-004-{epoch_num} \
            --peft_model_path {current_checkpoint} \
            --epochs {args.epochs} \
            --batch_size 1 \
            --grad_accum 16 \
            --learning_rate {args.learning_rate} \
            --lora_r 8 \
            --lora_alpha 16 \
            --lora_dropout 0.1"""
        
        print(f"継続学習: {train_file} (from PEFT model {current_checkpoint})")
        
        # 学習ログファイル
        train_log = f"../logs/004-{epoch_num}_training_{timestamp}.log"
        print(f"学習ログ: {train_log}")
        
        # 学習実行
        train_result = run_command(train_cmd, train_log)
        
        if train_result != 0:
            print(f"学習エラー: エポック 004-{epoch_num}")
            break
        
        # チェックポイントを更新
        current_checkpoint = f"../outputs/llama32-3b-typst-qlora-004-{epoch_num}"
        
        # テスト実行（毎回実行）
        test_cmd = f"""python3 inference_llama32_3b.py \
            --peft_model_path {current_checkpoint} \
            --input_file ../sample/sample_small.tex \
            --output_file ../trained/004-{epoch_num}.typ"""
        
        print(f"テスト実行: {current_checkpoint}")
        
        # テストログファイル
        test_log = f"../logs/004-{epoch_num}_test_{timestamp}.log"
        print(f"テストログ: {test_log}")
        
        # テスト実行
        test_result = run_command(test_cmd, test_log)
        
        if test_result != 0:
            print(f"テストエラー: エポック 004-{epoch_num}")
        else:
            print(f"エポック 004-{epoch_num} 完了")
        
        print("-" * 50)

    print("=== Unicode記号変換専用継続学習完了 ===")
    print(f"最終チェックポイント: {current_checkpoint}")

if __name__ == "__main__":
    main()