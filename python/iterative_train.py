#!/usr/bin/env python3
"""
汎用的な継続学習・テスト・ログ保存スクリプト
任意の学習済みモデルから任意のデータセットで継続学習を実行
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
    parser = argparse.ArgumentParser(description="汎用的な継続学習・テスト・ログ保存スクリプト")
    
    # 学習済みモデルの指定
    parser.add_argument("--base_jsonl", type=str, required=True, 
                       help="学習済みモデルのJSONL番号（例: 002）")
    parser.add_argument("--base_iteration", type=str, default="", 
                       help="学習済みモデルのiteration番号（例: 000、空白の場合は001形式）")
    
    # 学習データの指定
    parser.add_argument("--train_jsonl", type=str, required=True, 
                       help="学習用JSONL番号（例: 003）")
    
    # 学習範囲の指定
    parser.add_argument("--start_iteration", type=int, default=0, 
                       help="学習開始iteration番号（デフォルト: 0）")
    parser.add_argument("--end_iteration", type=int, required=True, 
                       help="学習終了iteration番号（例: 10）")
    
    # 学習パラメータ
    parser.add_argument("--epochs", type=int, default=1, 
                       help="各繰り返しでのエポック数（デフォルト: 1）")
    parser.add_argument("--learning_rate", type=float, default=1e-5, 
                       help="継続学習の学習率（デフォルト: 1e-5）")
    parser.add_argument("--lora_r", type=int, default=16, 
                       help="LoRA rank（デフォルト: 16）")
    parser.add_argument("--lora_alpha", type=int, default=8, 
                       help="LoRA alpha（デフォルト: 8）")
    parser.add_argument("--lora_dropout", type=float, default=0.1, 
                       help="LoRA dropout（デフォルト: 0.1）")
    parser.add_argument("--batch_size", type=int, default=1, 
                       help="バッチサイズ（デフォルト: 1）")
    parser.add_argument("--grad_accum", type=int, default=16, 
                       help="勾配累積ステップ数（デフォルト: 16）")
    
    # テスト設定
    parser.add_argument("--test_interval", type=int, default=5, 
                       help="テスト実行間隔（デフォルト: 5回に1回）")
    parser.add_argument("--test_input", type=str, default="../sample/sample_small.tex", 
                       help="テスト入力ファイル（デフォルト: ../sample/sample_small.tex）")
    
    args = parser.parse_args()
    
    # ログディレクトリを作成
    os.makedirs("../logs", exist_ok=True)
    os.makedirs("../trained", exist_ok=True)
    
    # タイムスタンプを生成
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    
    # 学習済みモデルパス（base_iterationが空白の場合は001形式）
    if args.base_iteration == "":
        base_checkpoint = f"../outputs/llama32-3b-typst-qlora-{args.base_jsonl}"
    else:
        base_checkpoint = f"../outputs/llama32-3b-typst-qlora-{args.base_jsonl}-{args.base_iteration}"
    
    train_file = f"../jsonl/train_{args.train_jsonl}.jsonl"
    
    # 出力シリーズ名（学習用JSONL番号を使用）
    output_series = args.train_jsonl
    
    print("=== 汎用的継続学習開始 ===")
    if args.base_iteration == "":
        print(f"学習済みモデル: {args.base_jsonl}（001形式）")
    else:
        print(f"学習済みモデル: {args.base_jsonl}-{args.base_iteration}")
    print(f"学習データ: train_{args.train_jsonl}.jsonl")
    print(f"学習範囲: {args.start_iteration} → {args.end_iteration}")
    print(f"各繰り返しのエポック数: {args.epochs}")
    print(f"学習率: {args.learning_rate}")
    print(f"LoRA rank: {args.lora_r}")
    print(f"LoRA alpha: {args.lora_alpha}")
    print(f"テスト間隔: {args.test_interval}回に1回")
    print(f"タイムスタンプ: {timestamp}")
    print()
    
    # 初期チェックポイント
    current_checkpoint = base_checkpoint
    
    print(f"初期チェックポイント: {current_checkpoint}")
    print(f"学習ファイル: {train_file}")
    print()
    
    # 各繰り返しで学習・テストを実行
    total_iterations = args.end_iteration - args.start_iteration
    for i in range(args.start_iteration, args.end_iteration):
        iteration_num = f"{i:03d}"
        print(f"=== Iteration {iteration_num} の処理開始 ===")
        
        # 学習コマンド
        train_cmd = f"""python3 train_llama32_3b_qlora_fixed.py \
            --data {train_file} \
            --out ../outputs/llama32-3b-typst-qlora-{output_series}-{iteration_num} \
            --peft_model_path {current_checkpoint} \
            --epochs {args.epochs} \
            --batch_size {args.batch_size} \
            --grad_accum {args.grad_accum} \
            --learning_rate {args.learning_rate} \
            --lora_r {args.lora_r} \
            --lora_alpha {args.lora_alpha} \
            --lora_dropout {args.lora_dropout}"""
        
        print(f"継続学習: {train_file} (from {current_checkpoint})")
        
        # 学習ログファイル
        train_log = f"../logs/{output_series}-{iteration_num}_training_{timestamp}.log"
        print(f"学習ログ: {train_log}")
        
        # 学習実行
        train_result = run_command(train_cmd, train_log)
        
        if train_result != 0:
            print(f"学習エラー: Iteration {iteration_num}")
            print(f"前のチェックポイント ({current_checkpoint}) を使用して続行します。")
            continue
        
        # テスト実行（指定間隔で実行）
        if i % args.test_interval == 0:
            test_cmd = f"""python3 inference_llama32_3b.py \
                --peft_model_path ../outputs/llama32-3b-typst-qlora-{output_series}-{iteration_num} \
                --input_file {args.test_input} \
                --output_file ../trained/{output_series}-{iteration_num}.md"""
            
            print(f"テスト実行: ../outputs/llama32-3b-typst-qlora-{output_series}-{iteration_num}")
            
            # テストログファイル
            test_log = f"../logs/{output_series}-{iteration_num}_test_{timestamp}.log"
            print(f"テストログ: {test_log}")
            
            # テスト実行
            test_result = run_command(test_cmd, test_log)
            
            if test_result != 0:
                print(f"テストエラー: Iteration {iteration_num}")
            else:
                print(f"完了: Iteration {iteration_num} の学習・テストが完了しました。")
        else:
            print(f"スキップ: Iteration {iteration_num} のテストをスキップしました（{args.test_interval}回に1回の実行）")
            test_result = 0
        
        # 次の繰り返し用にチェックポイントを更新（学習が成功した場合のみ）
        if train_result == 0:
            new_checkpoint_dir = f"../outputs/llama32-3b-typst-qlora-{output_series}-{iteration_num}"
            if os.path.exists(new_checkpoint_dir):
                current_checkpoint = new_checkpoint_dir
                print(f"チェックポイントを更新: {current_checkpoint}")
            else:
                print(f"警告: 新しいチェックポイントディレクトリが見つかりません: {new_checkpoint_dir}")
        
        print(f"=== Iteration {iteration_num} の処理完了 ===")
        print("-" * 50)
    
    print("=== 汎用的継続学習完了 ===")
    print(f"最終チェックポイント: {current_checkpoint}")
    print(f"総実行回数: {total_iterations}回")

if __name__ == "__main__":
    main()
