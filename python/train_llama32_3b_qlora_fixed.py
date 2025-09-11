#!/usr/bin/env python3
"""
Llama 3.2 3B Instruct専用 QLoRA学習スクリプト（修正版）
最新のtransformersライブラリに対応
"""

import argparse
import torch
import os
from datasets import load_dataset
from transformers import AutoTokenizer, AutoModelForCausalLM, TrainingArguments, BitsAndBytesConfig
from trl import SFTTrainer
from peft import LoraConfig

def main():
    parser = argparse.ArgumentParser(description="Llama 3.2 3B専用 QLoRA学習スクリプト（修正版）")
    parser.add_argument("--model_id", default="meta-llama/Llama-3.2-3B-Instruct", 
                       help="Llama 3.2 3BモデルのIDまたはパス")
    parser.add_argument("--data", default="jsonl/train.jsonl", 
                       help="学習データファイル")
    parser.add_argument("--text_field", default=None, 
                       help="テキストフィールド名（会話形式の場合は不要）")
    parser.add_argument("--out", default="outputs/llama32-3b-typst-qlora", 
                       help="出力ディレクトリ")
    parser.add_argument("--max_len", type=int, default=1024, 
                       help="最大シーケンス長（3B推奨: 1024）")
    parser.add_argument("--batch_size", type=int, default=2, 
                       help="デバイスあたりのバッチサイズ（3Bは軽量なので2に増加）")
    parser.add_argument("--grad_accum", type=int, default=8, 
                       help="勾配累積ステップ数（3Bは軽量なので削減）")
    parser.add_argument("--learning_rate", type=float, default=2e-4, 
                       help="学習率（3B推奨: 2e-4）")
    parser.add_argument("--epochs", type=int, default=5, 
                       help="エポック数（3Bは軽量なので増加可能）")
    parser.add_argument("--lora_r", type=int, default=8, 
                       help="LoRA rank（3B推奨: 8）")
    parser.add_argument("--lora_alpha", type=int, default=16, 
                       help="LoRA alpha（3B推奨: 16）")
    parser.add_argument("--lora_dropout", type=float, default=0.1, 
                       help="LoRA dropout")
    parser.add_argument("--resume_from_checkpoint", type=str, default=None,
                       help="チェックポイントから学習を再開するパス")
    parser.add_argument("--continue_training", action="store_true",
                       help="既存のPEFTモデルから継続学習")
    
    args = parser.parse_args()
    
    # 出力ディレクトリを作成
    os.makedirs(args.out, exist_ok=True)
    
    print(f"Llama 3.2 3Bモデル: {args.model_id}")
    print(f"データ: {args.data}")
    print(f"出力: {args.out}")
    
    # 継続学習の確認
    if args.continue_training:
        if not os.path.exists(args.out):
            print(f"エラー: 継続学習先のディレクトリ '{args.out}' が見つかりません")
            exit(1)
        print(f"継続学習モード: 既存のPEFTモデル '{args.out}' から継続学習します")
    
    # トークナイザーの読み込み
    print("トークナイザーを読み込み中...")
    tokenizer = AutoTokenizer.from_pretrained(args.model_id, use_fast=False)
    
    # Llama 3.2用のパディングトークン設定
    if tokenizer.pad_token is None:
        tokenizer.pad_token = tokenizer.eos_token
        tokenizer.pad_token_id = tokenizer.eos_token_id
    
    # 4bit量子化設定（最新の方法）
    print("4bit量子化設定を準備中...")
    bnb_config = BitsAndBytesConfig(
        load_in_4bit=True,
        bnb_4bit_use_double_quant=True,
        bnb_4bit_quant_type="nf4",
        bnb_4bit_compute_dtype=torch.bfloat16
    )
    
    # モデルの読み込み（最新の方法）
    print("モデルを読み込み中...")
    model = AutoModelForCausalLM.from_pretrained(
        args.model_id,
        quantization_config=bnb_config,
        device_map="auto",
        dtype=torch.bfloat16,
        trust_remote_code=True
    )
    
    # 継続学習の場合、既存のPEFTモデルを読み込み
    if args.continue_training:
        print("既存のPEFTモデルを読み込み中...")
        from peft import PeftModel
        model = PeftModel.from_pretrained(model, args.out)
    
    # Llama 3.2 3B専用LoRA設定
    lora_config = LoraConfig(
        r=args.lora_r,
        lora_alpha=args.lora_alpha,
        lora_dropout=args.lora_dropout,
        target_modules=[
            "q_proj", "v_proj", "k_proj", "o_proj", 
            "gate_proj", "up_proj", "down_proj"
        ],  # Llama 3.2全層対応
        task_type="CAUSAL_LM",
        bias="none",
        use_rslora=True,  # Llama 3.2推奨
        use_dora=False    # 安定性重視
    )
    
    # データセットの読み込み
    print("データセットを読み込み中...")
    dataset = load_dataset("json", data_files=args.data, split="train")
    print(f"データセットサイズ: {len(dataset)}")
    
    # 学習引数の設定（チェックポイント保存を有効化）
    training_args = TrainingArguments(
        output_dir=args.out,
        per_device_train_batch_size=args.batch_size,
        gradient_accumulation_steps=args.grad_accum,
        learning_rate=args.learning_rate,
        num_train_epochs=args.epochs,
        max_steps=-1,
        save_steps=50,  # 50ステップごとにチェックポイント保存
        save_strategy="steps",
        logging_steps=10,
        logging_dir=f"{args.out}/logs",
        warmup_steps=50,
        fp16=False,
        bf16=True,
        remove_unused_columns=False,
        dataloader_pin_memory=False,
        report_to=None,
        save_total_limit=5,  # 最新5つのチェックポイントのみ保持
        load_best_model_at_end=False,
        metric_for_best_model=None,
        greater_is_better=None,
    )
    
    # SFTTrainerの設定（TrainingArgumentsを追加）
    trainer = SFTTrainer(
        model=model,
        train_dataset=dataset,
        peft_config=lora_config,
        args=training_args,
    )
    
    # 学習開始
    if args.continue_training:
        print("Llama 3.2 3B QLoRA継続学習を開始します...")
    else:
        print("Llama 3.2 3B QLoRA学習を開始します...")
    
    # チェックポイントから再開する場合
    if args.resume_from_checkpoint:
        print(f"チェックポイント '{args.resume_from_checkpoint}' から学習を再開します...")
        trainer.train(resume_from_checkpoint=args.resume_from_checkpoint)
    else:
        trainer.train()
    
    # モデルの保存
    print("モデルを保存中...")
    trainer.save_model(args.out)
    tokenizer.save_pretrained(args.out)
    
    if args.continue_training:
        print(f"Llama 3.2 3B QLoRA継続学習完了！モデルは {args.out} に保存されました。")
    else:
        print(f"Llama 3.2 3B QLoRA学習完了！モデルは {args.out} に保存されました。")

if __name__ == "__main__":
    main()
