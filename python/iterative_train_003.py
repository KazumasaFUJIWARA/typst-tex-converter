#!/usr/bin/env python3
"""
継続学習・テスト・ログ保存スクリプト（100回繰り返し）
train_003.jsonlを使用して継続学習を行い、各エポック後にテストを実行
出力ファイル名: 003-<epocnum 0埋め2桁>.typ
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
    parser = argparse.ArgumentParser(description="継続学習・テスト・ログ保存スクリプト（100回繰り返し）")
    parser.add_argument("--epochs", type=int, default=1, help="各繰り返しでのエポック数（デフォルト: 1）")
    parser.add_argument("--iterations", type=int, default=100, help="繰り返し回数（デフォルト: 100）")
    parser.add_argument("--learning_rate", type=float, default=1e-5, help="継続学習の学習率（デフォルト: 1e-5）")
    parser.add_argument("--start_from", type=int, default=0, help="開始エポック番号（デフォルト: 0）")
    
    args = parser.parse_args()
    
    # ログディレクトリを作成
    os.makedirs("logs", exist_ok=True)
    os.makedirs("trained", exist_ok=True)
    
    # タイムスタンプ
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    
    print(f"=== 継続学習開始 ===")
    print(f"各繰り返しのエポック数: {args.epochs}")
    print(f"繰り返し回数: {args.iterations}")
    print(f"学習率: {args.learning_rate}")
    print(f"開始エポック番号: {args.start_from}")
    print(f"タイムスタンプ: {timestamp}")
    print()
    
    # 学習データファイルの確認
    train_file = "jsonl/train_003.jsonl"
    if not os.path.exists(train_file):
        print(f"エラー: {train_file} が見つかりません。")
        return
    
    # 初期チェックポイントの確認（002-20から開始）
    initial_checkpoint = "outputs/llama32-3b-typst-qlora-002-20"
    if not os.path.exists(initial_checkpoint):
        print(f"エラー: 初期チェックポイント {initial_checkpoint} が見つかりません。")
        print("先に002の学習を完了してください。")
        return
    
    # 最新のチェックポイントを取得
    if os.path.exists(initial_checkpoint):
        checkpoints = [d for d in os.listdir(initial_checkpoint) if d.startswith("checkpoint-")]
        if checkpoints:
            latest_checkpoint = sorted(checkpoints)[-1]
            current_checkpoint = f"{initial_checkpoint}/{latest_checkpoint}"
        else:
            current_checkpoint = initial_checkpoint
    else:
        print(f"エラー: {initial_checkpoint} が見つかりません。")
        return
    
    print(f"初期チェックポイント: {current_checkpoint}")
    print()
    
    # 各繰り返しで学習・テストを実行
    for i in range(args.start_from, args.start_from + args.iterations):
        epoch_num = f"{i:02d}"
        print(f"=== エポック {epoch_num} の処理開始 ===")
        
        # 学習コマンド（すべて継続学習）
        if i == args.start_from:
            # 最初のエポックは002-20のチェックポイントから継続学習
            train_cmd = f"""python3 python/train_llama32_3b_qlora_fixed.py \
                --data {train_file} \
                --out outputs/llama32-3b-typst-qlora-003-{epoch_num} \
                --resume_from_checkpoint {current_checkpoint} \
                --epochs {args.epochs} \
                --batch_size 2 \
                --grad_accum 8 \
                --learning_rate {args.learning_rate} \
                --lora_r 8 \
                --lora_alpha 16 \
                --lora_dropout 0.1"""
            print(f"継続学習（002-20から）: {train_file} (from {current_checkpoint})")
        else:
            # 2回目以降は前回のエポックから継続学習
            train_cmd = f"""python3 python/train_llama32_3b_qlora_fixed.py \
                --data {train_file} \
                --out outputs/llama32-3b-typst-qlora-003-{epoch_num} \
                --peft_model_path {current_checkpoint} \
                --epochs {args.epochs} \
                --batch_size 2 \
                --grad_accum 8 \
                --learning_rate {args.learning_rate} \
                --lora_r 8 \
                --lora_alpha 16 \
                --lora_dropout 0.1"""
            print(f"継続学習（前回から）: {train_file} (from PEFT model {current_checkpoint})")
        
        train_log = f"logs/003-{epoch_num}_training_{timestamp}.log"
        print(f"学習ログ: {train_log}")
        
        # 学習実行
        train_result = run_command(train_cmd, train_log)
        
        if train_result != 0:
            print(f"エラー: エポック {epoch_num} の学習に失敗しました。")
            print(f"前のチェックポイント ({current_checkpoint}) を使用して続行します。")
            continue
        
        # テストコマンド
        test_cmd = f"""python3 python/inference_llama32_3b.py \
            --input_file sample/sample_small.tex \
            --output_file trained/003-{epoch_num}.typ \
            --peft_model_path outputs/llama32-3b-typst-qlora-003-{epoch_num} \
            --no-chunking"""
        
        test_log = f"logs/003-{epoch_num}_test_{timestamp}.log"
        print(f"テスト実行: trained/003-{epoch_num}.typ")
        print(f"テストログ: {test_log}")
        
        test_result = run_command(test_cmd, test_log)
        
        if test_result != 0:
            print(f"エラー: エポック {epoch_num} のテストに失敗しました。")
        else:
            print(f"完了: エポック {epoch_num} の学習・テストが完了しました。")
        
        # 次の繰り返し用にチェックポイントを更新（学習が成功した場合のみ）
        if train_result == 0:
            new_checkpoint_dir = f"outputs/llama32-3b-typst-qlora-003-{epoch_num}"
            if os.path.exists(new_checkpoint_dir):
                # チェックポイントディレクトリ内のサブディレクトリを確認
                checkpoints = [d for d in os.listdir(new_checkpoint_dir) if d.startswith("checkpoint-")]
                if checkpoints:
                    latest_checkpoint = sorted(checkpoints)[-1]
                    current_checkpoint = f"{new_checkpoint_dir}/{latest_checkpoint}"
                    print(f"次のチェックポイント: {current_checkpoint}")
                else:
                    # チェックポイントサブディレクトリがない場合は、ディレクトリ自体を使用
                    current_checkpoint = new_checkpoint_dir
                    print(f"次のチェックポイント: {current_checkpoint}")
            else:
                print(f"警告: {new_checkpoint_dir} が見つかりません。前のチェックポイントを使用します。")
        else:
            print(f"学習失敗のため、チェックポイントを更新しません。前のチェックポイント ({current_checkpoint}) を使用します。")
        
        print()
    
    print(f"=== 継続学習完了 ===")
    print(f"ログファイル: logs/")
    print(f"テスト結果: trained/")
    print(f"最終チェックポイント: {current_checkpoint}")

if __name__ == "__main__":
    main()
