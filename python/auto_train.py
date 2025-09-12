#!/usr/bin/env python3
"""
自動学習・テスト・ログ保存スクリプト
エポック数、開始jsonl番号、終了jsonl番号を入力して実行
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
    parser = argparse.ArgumentParser(description="自動学習・テスト・ログ保存スクリプト")
    parser.add_argument("--epochs", type=int, required=True, help="エポック数")
    parser.add_argument("--start", type=int, required=True, help="開始jsonl番号 (例: 1)")
    parser.add_argument("--end", type=int, required=True, help="終了jsonl番号 (例: 3)")
    parser.add_argument("--learning_rate", type=float, default=2e-4, help="学習率 (デフォルト: 2e-4)")
    parser.add_argument("--continue_lr", type=float, default=1e-5, help="継続学習の学習率 (デフォルト: 1e-5)")
    
    args = parser.parse_args()
    
    # ログディレクトリを作成
    os.makedirs("logs", exist_ok=True)
    
    # タイムスタンプ
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    
    print(f"=== 自動学習開始 ===")
    print(f"エポック数: {args.epochs}")
    print(f"開始番号: {args.start}")
    print(f"終了番号: {args.end}")
    print(f"学習率: {args.learning_rate}")
    print(f"継続学習率: {args.continue_lr}")
    print(f"タイムスタンプ: {timestamp}")
    print()
    
    # 各バージョンで学習・テストを実行
    for i in range(args.start, args.end + 1):
        jsonl_num = f"{i:03d}"
        print(f"=== バージョン {jsonl_num} の処理開始 ===")
        
        # 学習データファイルの確認
        train_file = f"jsonl/train_{jsonl_num}.jsonl"
        if not os.path.exists(train_file):
            print(f"警告: {train_file} が見つかりません。スキップします。")
            continue
        
        # 学習コマンド
        if i == args.start:
            # 新規学習
            train_cmd = f"""python python/train_llama32_3b_qlora_fixed.py \
                --data {train_file} \
                --out outputs/llama32-3b-typst-qlora-{jsonl_num} \
                --epochs {args.epochs} \
                --batch_size 2 \
                --grad_accum 8 \
                --learning_rate {args.learning_rate} \
                --lora_r 8 \
                --lora_alpha 16 \
                --lora_dropout 0.1"""
            
            train_log = f"logs/{jsonl_num}_training_{timestamp}.log"
            print(f"新規学習: {train_file}")
        else:
            # 継続学習
            prev_num = f"{i-1:03d}"
            checkpoint_dir = f"outputs/llama32-3b-typst-qlora-{prev_num}"
            
            # 最新のチェックポイントを取得
            if os.path.exists(checkpoint_dir):
                checkpoints = [d for d in os.listdir(checkpoint_dir) if d.startswith("checkpoint-")]
                if checkpoints:
                    latest_checkpoint = sorted(checkpoints)[-1]
                    checkpoint_path = f"{checkpoint_dir}/{latest_checkpoint}"
                else:
                    checkpoint_path = checkpoint_dir
            else:
                print(f"エラー: {checkpoint_dir} が見つかりません。")
                continue
            
            train_cmd = f"""python python/train_llama32_3b_qlora_fixed.py \
                --data {train_file} \
                --out outputs/llama32-3b-typst-qlora-{jsonl_num} \
                --resume_from_checkpoint {checkpoint_path} \
                --epochs {args.epochs} \
                --batch_size 2 \
                --grad_accum 8 \
                --learning_rate {args.continue_lr} \
                --lora_r 8 \
                --lora_alpha 16 \
                --lora_dropout 0.1"""
            
            train_log = f"logs/{jsonl_num}_training_{timestamp}.log"
            print(f"継続学習: {train_file} (from {prev_num})")
        
        # 学習実行
        print(f"学習ログ: {train_log}")
        train_result = run_command(train_cmd, train_log)
        
        if train_result != 0:
            print(f"エラー: バージョン {jsonl_num} の学習に失敗しました。")
            continue
        
        # テストコマンド
        test_cmd = f"""python python/inference_llama32_3b.py \
            --input_file sample/sample_small.tex \
            --output_file trained/{jsonl_num}.typ \
            --peft_model_path outputs/llama32-3b-typst-qlora-{jsonl_num} \
            --no-chunking"""
        
        test_log = f"logs/{jsonl_num}_test_{timestamp}.log"
        print(f"テスト実行: trained/{jsonl_num}.typ")
        print(f"テストログ: {test_log}")
        
        test_result = run_command(test_cmd, test_log)
        
        if test_result != 0:
            print(f"エラー: バージョン {jsonl_num} のテストに失敗しました。")
        else:
            print(f"完了: バージョン {jsonl_num} の学習・テストが完了しました。")
        
        print()
    
    print(f"=== 自動学習完了 ===")
    print(f"ログファイル: logs/")
    print(f"テスト結果: trained/")

if __name__ == "__main__":
    main()
