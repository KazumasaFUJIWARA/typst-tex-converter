#!/usr/bin/env python3
"""
継続学習・テスト・ログ保存スクリプト（201回繰り返し）
train_003.jsonlを使用して継続学習を行い、各エポック後にテストを実行
出力ファイル名: 003-<epocnum 0埋め3桁>.typ
"""

import argparse
import subprocess
import os
import sys
from datetime import datetime

def run_command(cmd, log_file=None):
    """コマンドを実行してログに保存"""
    print(f"実行中: {cmd}")
    
    if log_file:
        # ログファイルに保存しながら実行
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
                print(line, end='')
                f.write(line)
                f.flush()
            
            process.wait()
            return process.returncode
    else:
        # ログファイルなしで実行
        return subprocess.call(cmd, shell=True)

def main():
    parser = argparse.ArgumentParser(description="継続学習・テスト・ログ保存スクリプト（201回繰り返し）")
    parser.add_argument("--epochs", type=int, default=5, help="各繰り返しでのエポック数（デフォルト: 5）")
    parser.add_argument("--iterations", type=int, default=201, help="繰り返し回数（デフォルト: 201）")
    parser.add_argument("--learning_rate", type=float, default=1e-4, help="継続学習の学習率（デフォルト: 1e-4）")
    parser.add_argument("--start_from", type=int, default=0, help="開始エポック番号（デフォルト: 0）")
    
    args = parser.parse_args()
    
    # ログディレクトリを作成
    os.makedirs("../logs", exist_ok=True)
    os.makedirs("../trained", exist_ok=True)
    
    # タイムスタンプを生成
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    
    print("=== 継続学習開始 ===")
    print(f"各繰り返しのエポック数: {args.epochs}")
    print(f"繰り返し回数: {args.iterations}")
    print(f"学習率: {args.learning_rate}")
    print(f"開始エポック番号: {args.start_from}")
    print(f"タイムスタンプ: {timestamp}")
    
    # 初期チェックポイント（002-49から開始）
    current_checkpoint = "../outputs/llama32-3b-typst-qlora-002-49"
    train_file = "../jsonl/train_003.jsonl"
    
    print(f"初期チェックポイント: {current_checkpoint}")
    print()
    
    # 各繰り返しで学習・テストを実行
    for i in range(args.start_from, args.start_from + args.iterations):
        epoch_num = f"{i - args.start_from + 1:03d}"
        print(f"=== エポック {epoch_num} の処理開始 ===")
        
        # 学習コマンド（すべて継続学習）
        if i == args.start_from:
            # 最初のエポックは002-99のチェックポイントから継続学習
            train_cmd = f"""python3 train_llama32_3b_qlora_fixed.py \
                --data {train_file} \
                --out ../outputs/llama32-3b-typst-qlora-003-{epoch_num} \
                --peft_model_path {current_checkpoint} \
                --epochs {args.epochs} \
                --batch_size 1 \
                --grad_accum 16 \
                --learning_rate {args.learning_rate} \
                --lora_r 8 \
                --lora_alpha 16 \
                --lora_dropout 0.1"""
            print(f"継続学習（002-49から）: {train_file} (from PEFT model {current_checkpoint})")
        else:
            # 2回目以降は前回のチェックポイントから継続学習
            train_cmd = f"""python3 train_llama32_3b_qlora_fixed.py \
                --data {train_file} \
                --out ../outputs/llama32-3b-typst-qlora-003-{epoch_num} \
                --peft_model_path {current_checkpoint} \
                --epochs {args.epochs} \
                --batch_size 1 \
                --grad_accum 16 \
                --learning_rate {args.learning_rate} \
                --lora_r 8 \
                --lora_alpha 16 \
                --lora_dropout 0.1"""
            print(f"継続学習（前回から）: {train_file} (from PEFT model {current_checkpoint})")
        
        train_log = f"../logs/003-{epoch_num}_training_{timestamp}.log"
        print(f"学習ログ: {train_log}")
        
        train_result = run_command(train_cmd, train_log)
        
        if train_result != 0:
            print(f"エラー: エポック {epoch_num} の学習に失敗しました。")
            print(f"前のチェックポイント ({current_checkpoint}) を使用して続行します。")
            continue
        
        # テストコマンド（5回に1回のみ）
        if i % 5 == 0:
            test_cmd = f"""python3 inference_llama32_3b.py \
                --input_file ../sample/sample_small.tex \
                --output_file ../trained/003-{epoch_num}.typ \
                --peft_model_path ../outputs/llama32-3b-typst-qlora-003-{epoch_num} \
                --no-chunking"""
            
            test_log = f"../logs/003-{epoch_num}_test_{timestamp}.log"
            print(f"テスト実行: ../trained/003-{epoch_num}.typ")
            print(f"テストログ: {test_log}")
            
            test_result = run_command(test_cmd, test_log)
            
            if test_result != 0:
                print(f"エラー: エポック {epoch_num} のテストに失敗しました。")
            else:
                print(f"完了: エポック {epoch_num} の学習・テストが完了しました。")
        else:
            print(f"スキップ: エポック {epoch_num} のテストをスキップしました（5回に1回の実行）")
            test_result = 0
        
        # 次の繰り返し用にチェックポイントを更新（学習が成功した場合のみ）
        if train_result == 0:
            new_checkpoint_dir = f"../outputs/llama32-3b-typst-qlora-003-{epoch_num}"
            if os.path.exists(new_checkpoint_dir):
                current_checkpoint = new_checkpoint_dir
                print(f"チェックポイントを更新: {current_checkpoint}")
            else:
                print(f"警告: 新しいチェックポイントディレクトリが見つかりません: {new_checkpoint_dir}")
        
        print(f"=== エポック {epoch_num} の処理完了 ===")
        print()
    
    print("=== 継続学習完了 ===")
    print(f"最終チェックポイント: {current_checkpoint}")

if __name__ == "__main__":
    main()